import 'dart:convert';

import 'package:http/http.dart' as http;

import '../base_api.dart';
import '../rest_client.dart';
import 'data/auth_code_response.dart';
import 'data/command_ack_request.dart';
import 'data/command_status_response.dart';
import 'data/device_info.dart';
import 'data/mqtt_config_response.dart';
import 'data/station_slot_info.dart';
import 'data/slot_event_request.dart';

class LabLincApi extends BaseNetworkApi {
  LabLincApi(super.restClient, super.host, super.site, super.company);

  Future<void> sendHeartbeat() async {
    return await RestClient.post(
      Uri.parse('$host/api/v1/devices/heartbeat'),
      headers: createBearerAuthNetworkHeaders(),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot send heartbeat');
      }
    });
  }

  Future<CommandStatusResponse> sendCommandAck(
    CommandAckRequest commandAckRequest,
  ) async {
    return await RestClient.post(
      Uri.parse('$host/api/v1/devices/command-acks'),
      headers: createBearerAuthNetworkHeaders(),
      body: jsonEncode(commandAckRequest.toJson()),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot send command ack');
      }
      return CommandStatusResponse.fromJson(json.decode(response.body));
    });
  }

  Future<void> sendSlotEvent(SlotEventRequest slotEventRequest) async {
    return await RestClient.post(
      Uri.parse('$host/api/v1/devices/slot-events'),
      headers: createBearerAuthNetworkHeaders(),
      body: jsonEncode(slotEventRequest.toJson()),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot send slot event');
      }
    });
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
            (item) =>
                _deviceInfoFromApiJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    });
  }

  Future<List<StationSlotInfo>> fetchStationSlots([String? deviceUid]) async {
    final response = await _firstSuccessfulGet(
      _stationInfoPaths(suffix: 'slots', deviceUid: deviceUid),
      headers: createBearerAuthNetworkHeaders(),
    );

    if (response.statusCode ~/ 100 != 2) {
      errorHandler(response, 'Cannot fetch slots');
    }

    final decoded = json.decode(response.body);
    final slotItems = _extractStationSlotItems(decoded);

    return slotItems.map(StationSlotInfo.fromApiJson).toList();
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
    device.deviceUid = _stringValue(json['deviceUid']);
    device.name = _stringValue(json['name']);
    device.onlineStatus = _stringValue(json['onlineStatus']);
    device.lastSeenAtUtc = _nullableStringValue(json['lastSeenAtUtc']);
    device.labShortCode = _nullableStringValue(json['labShortCode']);
    device.laboratoryName = _nullableStringValue(json['labName']);
    device.slotCount = _intValue(json['slotCount']);
    device.occupiedSlotCount = _intValue(json['occupiedSlotCount']);
    return device;
  }

  String _stringValue(dynamic value) => value is String ? value : '';

  String? _nullableStringValue(dynamic value) => value is String ? value : null;

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

  List<Uri> _stationInfoPaths({required String suffix, String? deviceUid}) {
    final paths = <Uri>[Uri.parse('$host/api/v1/stations/$suffix')];

    final trimmedDeviceUid = deviceUid?.trim() ?? '';
    if (trimmedDeviceUid.isNotEmpty) {
      final encodedDeviceUid = Uri.encodeComponent(trimmedDeviceUid);
      paths.add(Uri.parse('$host/api/v1/stations/$encodedDeviceUid/$suffix'));
    }
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
