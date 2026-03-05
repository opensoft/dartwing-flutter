import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../core/custom_exceptions.dart';
import '../base_api.dart';
import '../rest_client.dart';
import 'data/auth_code_response.dart';
import 'data/command_ack_request.dart';
import 'data/command_status_response.dart';
import 'data/device_info.dart';
import 'data/device_slots_response.dart';
import 'data/mqtt_config_response.dart';
import 'data/station_slot_info.dart';
import 'data/slot_event_request.dart';
import 'delegated_device_session_service.dart';

class LabLincApi extends BaseNetworkApi {
  LabLincApi(super.restClient, super.host, super.site, super.company);

  Future<void> sendHeartbeat() async {
    return await RestClient.post(
      Uri.parse('$host/api/v1/device/heartbeat'),
      headers: createBearerAuthNetworkHeaders(),
      silentMode: true,
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot send heartbeat');
      }
    });
  }

  Future<CommandStatusResponse> sendCommandAck(
    CommandAckRequest commandAckRequest,
  ) async {
    return _withDelegatedHeaders<CommandStatusResponse>(
      operationName: 'device command ack',
      operation: (Map<String, String> delegatedHeaders) async {
        final response = await RestClient.post(
          Uri.parse('$host/api/v1/device/command-acks'),
          headers: delegatedHeaders,
          body: jsonEncode(commandAckRequest.toJson()),
        );
        if (response.statusCode ~/ 100 != 2) {
          errorHandler(response, 'Cannot send command ack');
        }
        return CommandStatusResponse.fromJson(json.decode(response.body));
      },
    );
  }

  Future<void> sendSlotEvent(SlotEventRequest slotEventRequest) async {
    return _withDelegatedHeaders<void>(
      operationName: 'device slot event',
      operation: (Map<String, String> delegatedHeaders) async {
        final response = await RestClient.post(
          Uri.parse('$host/api/v1/device/slot-events'),
          headers: delegatedHeaders,
          body: jsonEncode(slotEventRequest.toJson()),
        );
        if (response.statusCode ~/ 100 != 2) {
          errorHandler(response, 'Cannot send slot event');
        }
      },
    );
  }

  Future<String> startCaptureSession({
    required int slotNumber,
    required int wellPosition,
    required num magnification,
    DateTime? capturedAtUtc,
  }) async {
    return _withDelegatedHeaders<String>(
      operationName: 'start capture session',
      operation: (Map<String, String> delegatedHeaders) async {
        final double normalizedMagnification = magnification.toDouble();
        final response = await RestClient.post(
          Uri.parse('$host/api/v1/device/capture-sessions'),
          headers: delegatedHeaders,
          body: jsonEncode(<String, dynamic>{
            'slotNumber': slotNumber,
            'wellPosition': wellPosition,
            'magnification': normalizedMagnification,
            'capturedAtUtc': capturedAtUtc?.toUtc().toIso8601String(),
          }),
        );

        if (response.statusCode ~/ 100 != 2) {
          errorHandler(response, 'Cannot start capture session');
        }

        final String captureSessionId = _extractCaptureSessionIdFromResponse(
          response,
        );
        if (captureSessionId.isEmpty) {
          throw const FormatException(
            'Cannot start capture session: missing captureSessionId in response',
          );
        }
        return captureSessionId;
      },
    );
  }

  Future<void> uploadCaptureSessionImage({
    required String captureSessionId,
    required int slotNumber,
    required int wellPosition,
    required int focalPlaneIndex,
    required int zHeightMicrometers,
    required DateTime capturedAtUtc,
    required int imageWidthPx,
    required int imageHeightPx,
    required List<int> imageBytes,
    required String filename,
    bool preferZipUpload = true,
  }) async {
    return _withDelegatedHeaders<void>(
      operationName: 'upload capture session image',
      operation: (Map<String, String> delegatedHeaders) async {
        final encodedCaptureSessionId = Uri.encodeComponent(captureSessionId);
        final uri = Uri.parse(
          '$host/api/v1/device/capture-sessions/$encodedCaptureSessionId/images',
        );

        final Map<String, String> fields = <String, String>{
          'SlotNumber': slotNumber.toString(),
          'WellPosition': wellPosition.toString(),
          'FocalPlaneIndex': focalPlaneIndex.toString(),
          'ZHeightMicrometers': zHeightMicrometers.toString(),
          'CapturedAtUtc': capturedAtUtc.toUtc().toIso8601String(),
          'ImageWidthPx': imageWidthPx.toString(),
          'ImageHeightPx': imageHeightPx.toString(),
        };

        final _CaptureImageUploadPayload preferredPayload = preferZipUpload
            ? _buildZipCaptureImageUploadPayload(
                filename: filename,
                imageBytes: imageBytes,
              )
            : _buildRawCaptureImageUploadPayload(
                filename: filename,
                imageBytes: imageBytes,
              );

        http.Response response = await _sendCaptureSessionImageMultipart(
          uri: uri,
          fields: fields,
          payload: preferredPayload,
          headers: _multipartHeaders(delegatedHeaders),
        );

        if (response.statusCode ~/ 100 != 2 && preferredPayload.isZipArchive) {
          final _CaptureImageUploadPayload rawPayload =
              _buildRawCaptureImageUploadPayload(
                filename: filename,
                imageBytes: imageBytes,
              );
          response = await _sendCaptureSessionImageMultipart(
            uri: uri,
            fields: fields,
            payload: rawPayload,
            headers: _multipartHeaders(delegatedHeaders),
          );
        }

        if (response.statusCode ~/ 100 != 2) {
          errorHandler(
            response,
            'Cannot send capture image for slot $slotNumber and well $wellPosition',
          );
        }
      },
    );
  }

  Future<void> uploadCaptureSessionImageViaPresignedUrl({
    required String captureSessionId,
    required int focalPlaneIndex,
    required double zHeightMicrometers,
    required String contentType,
    required List<int> imageBytes,
    int? imageWidthPx,
    int? imageHeightPx,
    String? eventId,
  }) async {
    return _withDelegatedHeaders<void>(
      operationName: 'presigned capture image upload',
      operation: (Map<String, String> delegatedHeaders) async {
        final String uploadUrl = await _presignSingleCaptureSessionUploadUrl(
          captureSessionId: captureSessionId,
          focalPlaneIndex: focalPlaneIndex,
          zHeightMicrometers: zHeightMicrometers,
          contentType: contentType,
          fileSizeBytes: imageBytes.length,
          imageWidthPx: imageWidthPx,
          imageHeightPx: imageHeightPx,
          eventId: eventId,
          headers: delegatedHeaders,
        );

        http.Response uploadResponse =
            await _uploadCaptureImageBytesToBlobStorage(
              uploadUrl: uploadUrl,
              contentType: contentType,
              imageBytes: imageBytes,
            );

        if (uploadResponse.statusCode == 403) {
          // Presigned URLs expire quickly; retry once with a fresh URL.
          final String freshUploadUrl =
              await _presignSingleCaptureSessionUploadUrl(
                captureSessionId: captureSessionId,
                focalPlaneIndex: focalPlaneIndex,
                zHeightMicrometers: zHeightMicrometers,
                contentType: contentType,
                fileSizeBytes: imageBytes.length,
                imageWidthPx: imageWidthPx,
                imageHeightPx: imageHeightPx,
                eventId: eventId,
                headers: delegatedHeaders,
              );
          uploadResponse = await _uploadCaptureImageBytesToBlobStorage(
            uploadUrl: freshUploadUrl,
            contentType: contentType,
            imageBytes: imageBytes,
          );
        }

        if (uploadResponse.statusCode ~/ 100 != 2) {
          throw FetchDataException(
            'Cannot upload capture image bytes via presigned URL: '
            '${uploadResponse.statusCode} ${uploadResponse.reasonPhrase}',
          );
        }
      },
    );
  }

  Future<String> _presignSingleCaptureSessionUploadUrl({
    required String captureSessionId,
    required int focalPlaneIndex,
    required double zHeightMicrometers,
    required String contentType,
    required int fileSizeBytes,
    int? imageWidthPx,
    int? imageHeightPx,
    String? eventId,
    required Map<String, String> headers,
  }) async {
    final String encodedCaptureSessionId = Uri.encodeComponent(
      captureSessionId,
    );
    final Uri uri = Uri.parse(
      '$host/api/v1/device/capture-sessions/'
      '$encodedCaptureSessionId/presign-upload',
    );

    final Map<String, dynamic> imagePayload = <String, dynamic>{
      'focalPlaneIndex': focalPlaneIndex,
      'zHeightMicrometers': zHeightMicrometers,
      'contentType': contentType,
      'fileSizeBytes': fileSizeBytes,
      if (eventId != null && eventId.trim().isNotEmpty)
        'eventId': eventId.trim(),
    };
    if (imageWidthPx != null) {
      imagePayload['imageWidthPx'] = imageWidthPx;
    }
    if (imageHeightPx != null) {
      imagePayload['imageHeightPx'] = imageHeightPx;
    }

    final http.Response response = await RestClient.post(
      uri,
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'images': <Map<String, dynamic>>[imagePayload],
      }),
    );

    if (response.statusCode ~/ 100 != 2) {
      errorHandler(
        response,
        'Cannot presign upload URL for capture session $captureSessionId',
      );
    }

    final String body = response.body.trim();
    if (body.isEmpty) {
      throw const FormatException(
        'Cannot presign upload URL: empty response body',
      );
    }

    final dynamic decoded = json.decode(body);
    if (decoded is! Map) {
      throw const FormatException(
        'Cannot presign upload URL: expected JSON object response',
      );
    }

    final Map<String, dynamic> decodedMap = Map<String, dynamic>.from(decoded);
    final dynamic imagesField = decodedMap['images'];
    if (imagesField is! List || imagesField.isEmpty) {
      throw const FormatException(
        'Cannot presign upload URL: missing images in response',
      );
    }

    final dynamic first = imagesField.first;
    if (first is! Map) {
      throw const FormatException(
        'Cannot presign upload URL: invalid image response item',
      );
    }
    final Map<String, dynamic> firstImage = Map<String, dynamic>.from(first);
    final String uploadUrl = _firstNonEmptyString(<dynamic>[
      firstImage['uploadUrl'],
    ]);
    if (uploadUrl.isEmpty) {
      throw const FormatException(
        'Cannot presign upload URL: missing uploadUrl in response item',
      );
    }
    return uploadUrl;
  }

  Future<http.Response> _uploadCaptureImageBytesToBlobStorage({
    required String uploadUrl,
    required String contentType,
    required List<int> imageBytes,
  }) {
    return RestClient.put(
      Uri.parse(uploadUrl),
      headers: <String, String>{
        'Content-Type': contentType,
        'Content-Length': imageBytes.length.toString(),
        'x-ms-blob-type': 'BlockBlob',
      },
      body: imageBytes,
      silentMode: true,
    );
  }

  Future<http.Response> _sendCaptureSessionImageMultipart({
    required Uri uri,
    required Map<String, String> fields,
    required _CaptureImageUploadPayload payload,
    required Map<String, String> headers,
  }) {
    return RestClient.multipartFileRequest(
      uri,
      fields,
      <String, List<int>>{'image': payload.bytes},
      payload.filename,
      headers: headers,
      fileContentType: payload.contentType,
    );
  }

  _CaptureImageUploadPayload _buildZipCaptureImageUploadPayload({
    required String filename,
    required List<int> imageBytes,
  }) {
    final Archive archive = Archive();
    archive.addFile(ArchiveFile(filename, imageBytes.length, imageBytes));
    final List<int> zipBytes = ZipEncoder().encode(
      archive,
      level: DeflateLevel.bestCompression,
    );
    if (zipBytes.isEmpty) {
      return _buildRawCaptureImageUploadPayload(
        filename: filename,
        imageBytes: imageBytes,
      );
    }
    return _CaptureImageUploadPayload(
      bytes: zipBytes,
      filename: '$filename.zip',
      contentType: MediaType('application', 'zip'),
      isZipArchive: true,
    );
  }

  _CaptureImageUploadPayload _buildRawCaptureImageUploadPayload({
    required String filename,
    required List<int> imageBytes,
  }) {
    final String lowerFilename = filename.toLowerCase();
    final MediaType contentType;
    if (lowerFilename.endsWith('.png')) {
      contentType = MediaType('image', 'png');
    } else if (lowerFilename.endsWith('.jpg') ||
        lowerFilename.endsWith('.jpeg')) {
      contentType = MediaType('image', 'jpeg');
    } else {
      contentType = MediaType('application', 'octet-stream');
    }
    return _CaptureImageUploadPayload(
      bytes: imageBytes,
      filename: filename,
      contentType: contentType,
      isZipArchive: false,
    );
  }

  Future<void> closeCaptureSession(String captureSessionId) async {
    return _withDelegatedHeaders<void>(
      operationName: 'close capture session',
      operation: (Map<String, String> delegatedHeaders) async {
        final encodedCaptureSessionId = Uri.encodeComponent(captureSessionId);
        final response = await RestClient.post(
          Uri.parse(
            '$host/api/v1/device/capture-sessions/$encodedCaptureSessionId/close',
          ),
          headers: <String, String>{
            ..._multipartHeaders(delegatedHeaders),
            'Content-Type': 'text/plain;charset=UTF-8',
          },
          body: '',
        );

        if (response.statusCode ~/ 100 != 2) {
          errorHandler(response, 'Cannot close capture session $captureSessionId');
        }
      },
    );
  }

  Future<void> endDeviceSession() async {
    await _withDelegatedHeaders<void>(
      operationName: 'end device session',
      operation: (Map<String, String> delegatedHeaders) async {
        final response = await RestClient.post(
          Uri.parse('$host/api/v1/device/session/end'),
          headers: <String, String>{
            ..._multipartHeaders(delegatedHeaders),
            'Content-Type': 'text/plain;charset=UTF-8',
          },
          body: '',
        );

        if (response.statusCode ~/ 100 != 2) {
          errorHandler(response, 'Cannot end delegated device session');
        }
      },
    );
    DelegatedDeviceSessionService.instance.clearSession(
      reason: 'Delegated session ended by device request.',
    );
  }

  Future<AuthCodeResponse> fetchAuthCode() async {
    final headers = <String, String>{
      ...createBearerAuthNetworkHeaders(),
      'Content-Type': 'text/plain;charset=UTF-8',
    };

    final response = await _firstSuccessfulPost(
      _deviceInfoPaths(suffix: 'auth-code'),
      headers: headers,
      body: '',
    );

    if (response.statusCode ~/ 100 != 2) {
      errorHandler(response, 'Cannot fetch auth code');
    }
    return AuthCodeResponse.fromJson(json.decode(response.body));
  }

  Future<MqttConfigResponse> fetchMqttConfig() async {
    final response = await _firstSuccessfulGet(
      _deviceInfoPaths(suffix: 'mqtt-config'),
      headers: createBearerAuthNetworkHeaders(),
    );

    if (response.statusCode ~/ 100 != 2) {
      errorHandler(response, 'Cannot fetch mqtt config');
    }
    return MqttConfigResponse.fromJson(json.decode(response.body));
  }

  Future<List<DeviceInfo>> fetchDevices({int? page, int? pageSize}) async {
    final queryParameters = <String, String>{};
    if (page != null) {
      queryParameters['page'] = page.toString();
    }
    if (pageSize != null) {
      queryParameters['pageSize'] = pageSize.toString();
    }

    final uri = Uri.parse('$host/api/v1/stations').replace(
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );

    return await RestClient.get(
      uri,
      headers: createBearerAuthNetworkHeaders(),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot fetch devices');
      }

      final decoded = json.decode(response.body);
      if (decoded is! List) {
        throw const FormatException(
          'Cannot fetch devices: expected response body to be a JSON list',
        );
      }

      return decoded
          .whereType<Map>()
          .map(
            (item) => _deviceInfoFromApiJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    });
  }

  Future<DeviceInfo?> authorizeStationByQrCode(
    String qrCode, {
    String temporaryUserToken = '',
  }) async {
    final trimmedQrCode = qrCode.trim();
    if (trimmedQrCode.isEmpty) {
      return null;
    }

    final String normalizedTemporaryUserToken = temporaryUserToken.trim();
    final Map<String, String> headers = normalizedTemporaryUserToken.isEmpty
        ? createBearerAuthNetworkHeaders()
        : <String, String>{
            'Accept': '*/*',
            'Authorization': 'Bearer $normalizedTemporaryUserToken',
            'Content-Type': 'application/json',
          };

    final response = await RestClient.post(
      Uri.parse('$host/api/v1/stations/authorize'),
      headers: headers,
      body: jsonEncode({'qrCode': trimmedQrCode}),
    );

    if (response.statusCode ~/ 100 != 2) {
      errorHandler(response, 'Cannot authorize station by qr code');
    }

    if (response.body.trim().isEmpty) {
      return null;
    }

    final decoded = json.decode(response.body);
    return _extractAuthorizedDevice(decoded);
  }

  Future<DeviceSlotsResponse> fetchDeviceSlots() async {
    final response = await RestClient.get(
      Uri.parse('$host/api/v1/device/slots'),
      headers: createBearerAuthNetworkHeaders(),
    );
    if (response.statusCode ~/ 100 != 2) {
      errorHandler(response, 'Cannot fetch device slots');
    }
    return _parseDeviceSlotsResponse(response.body);
  }

  Future<DeviceSlotsResponse> fetchStationSlots(String deviceUid) async {
    final String trimmedDeviceUid = deviceUid.trim();
    if (trimmedDeviceUid.isEmpty) {
      throw const FormatException(
        'Cannot fetch station slots: empty deviceUid',
      );
    }

    final String encodedDeviceUid = Uri.encodeComponent(trimmedDeviceUid);
    final response = await RestClient.get(
      Uri.parse('$host/api/v1/stations/$encodedDeviceUid/slots'),
      headers: createBearerAuthNetworkHeaders(),
    );
    if (response.statusCode ~/ 100 != 2) {
      errorHandler(
        response,
        'Cannot fetch slots for station $trimmedDeviceUid',
      );
    }
    return _parseDeviceSlotsResponse(response.body);
  }

  Future<CommandStatusResponse> rotateStationToSlot(
    String deviceUid,
    int slotNumber,
  ) async {
    final encodedDeviceUid = Uri.encodeComponent(deviceUid);
    final uri = Uri.parse(
      '$host/api/v1/stations/$encodedDeviceUid/commands/rotate',
    );
    final payload = {
      'commandId': null,
      'toAngle': null,
      'byDegrees': null,
      'bySlots': slotNumber,
    };

    final response = await RestClient.post(
      uri,
      headers: createBearerAuthNetworkHeaders(),
      body: jsonEncode(payload),
    );
    if (response.statusCode ~/ 100 == 2) {
      return _parseCommandStatusResponse(response.body);
    }

    errorHandler(
      response,
      'Cannot rotate station $deviceUid to slot $slotNumber',
    );
    return CommandStatusResponse();
  }

  Future<void> saveDishToSlot(
    String deviceUid,
    int slotNumber,
    String dishBarcode,
  ) async {
    final encodedDeviceUid = Uri.encodeComponent(deviceUid);
    final encodedSlotNumber = Uri.encodeComponent(slotNumber.toString());
    final uri = Uri.parse(
      '$host/api/v1/stations/$encodedDeviceUid/slots/$encodedSlotNumber/dish',
    );
    final payloadVariants = _dishPayloadVariants(dishBarcode);

    var response = await RestClient.put(
      uri,
      headers: createBearerAuthNetworkHeaders(),
      body: jsonEncode(payloadVariants.first),
    );
    if (response.statusCode ~/ 100 == 2) {
      return;
    }

    for (final payload in payloadVariants.skip(1)) {
      if (response.statusCode != 400 && response.statusCode != 422) {
        break;
      }

      response = await RestClient.put(
        uri,
        headers: createBearerAuthNetworkHeaders(),
        body: jsonEncode(payload),
      );
      if (response.statusCode ~/ 100 == 2) {
        return;
      }
    }

    errorHandler(
      response,
      'Cannot save dish $dishBarcode to slot $slotNumber for device $deviceUid',
    );
  }

  Future<StationSlotInfo> removeDishFromSlot(
    String deviceUid,
    int slotNumber,
  ) async {
    final encodedDeviceUid = Uri.encodeComponent(deviceUid);
    final encodedSlotNumber = Uri.encodeComponent(slotNumber.toString());
    final uri = Uri.parse(
      '$host/api/v1/stations/$encodedDeviceUid/slots/$encodedSlotNumber/dish',
    );

    final response = await RestClient.delete(
      uri,
      headers: {
        ...createBearerAuthNetworkHeaders(),
        'Content-Type': 'text/plain;charset=UTF-8',
      },
      body: '',
    );

    if (response.statusCode ~/ 100 != 2) {
      errorHandler(
        response,
        'Cannot remove dish from slot $slotNumber for device $deviceUid',
      );
    }

    if (response.body.trim().isEmpty) {
      return StationSlotInfo.empty(slotNumber);
    }

    final decoded = json.decode(response.body);
    if (decoded is Map) {
      return StationSlotInfo.fromApiJson(Map<String, dynamic>.from(decoded));
    }

    if (decoded is List && decoded.isNotEmpty && decoded.first is Map) {
      return StationSlotInfo.fromApiJson(
        Map<String, dynamic>.from(decoded.first as Map),
      );
    }

    return StationSlotInfo.empty(slotNumber);
  }

  List<Map<String, dynamic>> _extractStationSlotItems(dynamic decoded) {
    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    if (decoded is Map) {
      final decodedMap = Map<String, dynamic>.from(decoded);
      final nestedLists = <dynamic>[
        decodedMap['slots'],
        decodedMap['slotStates'],
        decodedMap['currentSlots'],
        decodedMap['items'],
        decodedMap['data'],
        decodedMap['positions'],
      ];
      for (final listValue in nestedLists) {
        if (listValue is List) {
          return listValue
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        }
      }

      if (decodedMap.containsKey('slotNumber')) {
        return [decodedMap];
      }
    }

    return const [];
  }

  DeviceInfo _deviceInfoFromApiJson(Map<String, dynamic> json) {
    final device = DeviceInfo();
    device.deviceUid = _firstNonEmptyString([
      json['deviceUid'],
      json['stationUid'],
      json['uid'],
      json['stationId'],
      json['id'],
    ]);
    device.name = _firstNonEmptyString([
      json['name'],
      json['deviceName'],
      json['stationName'],
      json['displayName'],
      json['label'],
    ]);
    device.onlineStatus = _stringValue(json['onlineStatus']);
    device.lastSeenAtUtc = _nullableFirstNonEmptyString([
      json['lastSeenAtUtc'],
      json['lastSeenAt'],
    ]);
    device.labShortCode = _nullableFirstNonEmptyString([
      json['labShortCode'],
      json['shortCode'],
    ]);
    device.laboratoryName = _nullableFirstNonEmptyString([
      json['labName'],
      json['laboratoryName'],
    ]);
    device.slotCount = _intValue(json['slotCount']);
    device.occupiedSlotCount = _intValue(json['occupiedSlotCount']);
    return device;
  }

  DeviceInfo? _extractAuthorizedDevice(dynamic decodedJson) {
    final deviceJson = _findDeviceMapInJson(decodedJson);
    if (deviceJson == null) {
      return null;
    }

    final device = _deviceInfoFromApiJson(deviceJson);
    if (device.deviceUid.trim().isEmpty && device.name.trim().isEmpty) {
      return null;
    }
    return device;
  }

  Map<String, dynamic>? _findDeviceMapInJson(dynamic value) {
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      if (_looksLikeDeviceMap(map)) {
        return map;
      }

      const preferredKeys = <String>[
        'station',
        'device',
        'data',
        'result',
        'payload',
        'item',
      ];
      for (final key in preferredKeys) {
        if (!map.containsKey(key)) {
          continue;
        }
        final nested = _findDeviceMapInJson(map[key]);
        if (nested != null) {
          return nested;
        }
      }

      for (final nestedValue in map.values) {
        final nested = _findDeviceMapInJson(nestedValue);
        if (nested != null) {
          return nested;
        }
      }
      return null;
    }

    if (value is List) {
      for (final item in value) {
        final nested = _findDeviceMapInJson(item);
        if (nested != null) {
          return nested;
        }
      }
    }

    return null;
  }

  bool _looksLikeDeviceMap(Map<String, dynamic> map) {
    const identityKeys = <String>{
      'deviceUid',
      'stationUid',
      'uid',
      'stationId',
      'id',
      'name',
      'deviceName',
      'stationName',
      'displayName',
      'label',
    };
    for (final key in identityKeys) {
      final value = map[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  String _stringValue(dynamic value) => value is String ? value : '';

  String _firstNonEmptyString(List<dynamic> values) {
    for (final value in values) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty) {
        return text;
      }
    }
    return '';
  }

  String? _nullableFirstNonEmptyString(List<dynamic> values) {
    final value = _firstNonEmptyString(values);
    return value.isEmpty ? null : value;
  }

  int _intValue(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  DeviceSlotsResponse _parseDeviceSlotsResponse(String responseBody) {
    final dynamic decoded = json.decode(responseBody);
    final List<Map<String, dynamic>> slotItems = _extractStationSlotItems(
      decoded,
    );
    final List<StationSlotInfo> slots = slotItems
        .map(StationSlotInfo.fromApiJson)
        .toList();

    int slotCount = slots.length;
    int? currentFocusedSlotNumber;
    double? currentAngleDegrees;

    if (decoded is Map) {
      final Map<String, dynamic> decodedMap = Map<String, dynamic>.from(
        decoded,
      );
      final int parsedSlotCount = _intValue(decodedMap['slotCount']);
      if (parsedSlotCount > 0) {
        slotCount = parsedSlotCount;
      }
      currentFocusedSlotNumber = _nullableIntValue(
        decodedMap['currentFocusedSlotNumber'],
      );
      currentAngleDegrees = _nullableDoubleValue(
        decodedMap['currentAngleDegrees'],
      );
    }

    return DeviceSlotsResponse(
      slotCount: slotCount,
      currentFocusedSlotNumber: currentFocusedSlotNumber,
      currentAngleDegrees: currentAngleDegrees,
      slots: slots,
    );
  }

  int? _nullableIntValue(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value.trim());
    }
    return null;
  }

  double? _nullableDoubleValue(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value.trim());
    }
    return null;
  }

  String _extractCaptureSessionIdFromResponse(http.Response response) {
    final String body = response.body.trim();
    if (body.isNotEmpty) {
      final dynamic decoded = json.decode(body);
      final String captureSessionId = _findCaptureSessionIdInJson(decoded);
      if (captureSessionId.isNotEmpty) {
        return captureSessionId;
      }
    }

    final String? locationHeader =
        response.headers['location'] ?? response.headers['Location'];
    if (locationHeader != null && locationHeader.trim().isNotEmpty) {
      final Uri? locationUri = Uri.tryParse(locationHeader.trim());
      if (locationUri != null && locationUri.pathSegments.isNotEmpty) {
        final String id = locationUri.pathSegments.last.trim();
        if (id.isNotEmpty) {
          return id;
        }
      }
    }
    return '';
  }

  String _findCaptureSessionIdInJson(dynamic decoded) {
    if (decoded is Map) {
      final Map<String, dynamic> decodedMap = Map<String, dynamic>.from(
        decoded,
      );
      final String directMatch = _firstNonEmptyString([
        decodedMap['captureSessionId'],
        decodedMap['sessionId'],
        decodedMap['id'],
      ]);
      if (directMatch.isNotEmpty) {
        return directMatch;
      }

      const preferredKeys = <String>[
        'captureSession',
        'session',
        'data',
        'result',
        'payload',
        'item',
      ];
      for (final key in preferredKeys) {
        if (!decodedMap.containsKey(key)) {
          continue;
        }
        final String nestedId = _findCaptureSessionIdInJson(decodedMap[key]);
        if (nestedId.isNotEmpty) {
          return nestedId;
        }
      }

      for (final nestedValue in decodedMap.values) {
        final String nestedId = _findCaptureSessionIdInJson(nestedValue);
        if (nestedId.isNotEmpty) {
          return nestedId;
        }
      }
      return '';
    }

    if (decoded is List) {
      for (final item in decoded) {
        final String nestedId = _findCaptureSessionIdInJson(item);
        if (nestedId.isNotEmpty) {
          return nestedId;
        }
      }
    }

    return '';
  }

  Future<T> _withDelegatedHeaders<T>({
    required String operationName,
    required Future<T> Function(Map<String, String> delegatedHeaders)
    operation,
  }) async {
    final Map<String, String> delegatedHeaders;
    try {
      delegatedHeaders = _delegatedSessionHeaders();
    } on StateError catch (error) {
      throw FetchDataException('Cannot $operationName: $error');
    }

    try {
      return await operation(delegatedHeaders);
    } on UnauthorisedException {
      DelegatedDeviceSessionService.instance.clearSession(
        reason:
            'Delegated session rejected by server while calling $operationName.',
        logAsWarning: true,
      );
      throw FetchDataException(
        'Cannot $operationName: delegated session is no longer authorized. '
        'Please scan QR code again.',
      );
    }
  }

  Map<String, String> _delegatedSessionHeaders() {
    final Map<String, String> headers = Map<String, String>.from(
      createBearerAuthNetworkHeaders(),
    );
    return DelegatedDeviceSessionService.instance.createDelegatedHeaders(
      headers,
    );
  }

  Map<String, String> _multipartHeaders(Map<String, String> headers) {
    final Map<String, String> multipartHeaders = Map<String, String>.from(
      headers,
    );
    multipartHeaders.remove('Content-Type');
    return multipartHeaders;
  }

  List<Map<String, dynamic>> _dishPayloadVariants(String dishBarcode) {
    return [
      {'dishExternalId': dishBarcode},
      {'dishBarcode': dishBarcode},
      {'dishId': dishBarcode},
      {'externalDishId': dishBarcode},
      {'barcode': dishBarcode},
      {'id': dishBarcode},
    ];
  }

  CommandStatusResponse _parseCommandStatusResponse(String responseBody) {
    if (responseBody.trim().isEmpty) {
      return CommandStatusResponse();
    }

    final decoded = json.decode(responseBody);
    if (decoded is Map) {
      return CommandStatusResponse.fromJson(Map<String, dynamic>.from(decoded));
    }

    if (decoded is List && decoded.isNotEmpty && decoded.first is Map) {
      return CommandStatusResponse.fromJson(
        Map<String, dynamic>.from(decoded.first as Map),
      );
    }

    return CommandStatusResponse();
  }

  List<Uri> _deviceInfoPaths({required String suffix}) {
    final paths = <Uri>[Uri.parse('$host/api/v1/device/$suffix')];
    return paths;
  }

  Future<http.Response> _firstSuccessfulGet(
    List<Uri> candidateUris, {
    Map<String, String>? headers,
  }) async {
    late http.Response lastResponse;
    for (final uri in candidateUris) {
      final response = await RestClient.get(uri, headers: headers);
      if (response.statusCode ~/ 100 == 2) {
        return response;
      }
      if (response.statusCode != 404) {
        return response;
      }
      lastResponse = response;
    }
    return lastResponse;
  }

  Future<http.Response> _firstSuccessfulPost(
    List<Uri> candidateUris, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    late http.Response lastResponse;
    for (final uri in candidateUris) {
      final response = await RestClient.post(uri, headers: headers, body: body);
      if (response.statusCode ~/ 100 == 2) {
        return response;
      }
      if (response.statusCode != 404) {
        return response;
      }
      lastResponse = response;
    }
    return lastResponse;
  }
}

class _CaptureImageUploadPayload {
  const _CaptureImageUploadPayload({
    required this.bytes,
    required this.filename,
    required this.contentType,
    required this.isZipArchive,
  });

  final List<int> bytes;
  final String filename;
  final MediaType contentType;
  final bool isZipArchive;
}
