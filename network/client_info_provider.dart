import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../core/persistent_storage.dart';

class ClientInfoProvider {
  ClientInfoProvider._();

  static final ClientInfoProvider instance = ClientInfoProvider._();

  static const String _defaultAppName = 'Dartwing.Device';
  static const int _maxHeaderLength = 500;
  static const Map<String, int> _fieldMaxLengths = <String, int>{
    'name': 100,
    'ver': 50,
    'os': 50,
    'osver': 50,
    'model': 100,
    'inst': 128,
    'sdk': 50,
  };

  String _cachedHeaderValue = '';

  String get headerValue => _cachedHeaderValue;

  Future<void> init({String appName = _defaultAppName}) async {
    if (_cachedHeaderValue.isNotEmpty) {
      return;
    }

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String normalizedName = _normalizeValue(appName);
    final String normalizedVersion = _normalizeValue(
      _buildAppVersion(packageInfo),
    );
    if (normalizedName.isEmpty || normalizedVersion.isEmpty) {
      return;
    }

    final _DeviceMetadata deviceMetadata = await _readDeviceMetadata();
    final String installationId = await _readOrCreateInstallationId();
    final String sdkVersion = _readSdkVersion();

    final List<String> orderedPairs = <String>[
      _toPair('name', normalizedName),
      _toPair('ver', normalizedVersion),
      _toPair('os', deviceMetadata.platform),
      _toPair('osver', deviceMetadata.osVersion),
      _toPair('model', deviceMetadata.model),
      _toPair('inst', installationId),
      _toPair('sdk', sdkVersion),
    ].where((String pair) => pair.isNotEmpty).toList();

    _cachedHeaderValue = _capToMaxHeaderLength(orderedPairs);
  }

  String _buildAppVersion(PackageInfo packageInfo) {
    final String version = packageInfo.version.trim();
    if (version.isEmpty) {
      return '';
    }

    final String buildNumber = packageInfo.buildNumber.trim();
    if (buildNumber.isEmpty || buildNumber == '0') {
      return version;
    }

    return '$version+$buildNumber';
  }

  Future<_DeviceMetadata> _readDeviceMetadata() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final String platform = _normalizeValue(Platform.operatingSystem);

    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
        return _DeviceMetadata(
          platform: platform,
          osVersion: _normalizeValue(info.version.release),
          model: _normalizeValue(info.model),
        );
      }

      if (Platform.isIOS) {
        final IosDeviceInfo info = await deviceInfoPlugin.iosInfo;
        final String model = info.utsname.machine.isNotEmpty
            ? info.utsname.machine
            : info.model;
        return _DeviceMetadata(
          platform: platform,
          osVersion: _normalizeValue(info.systemVersion),
          model: _normalizeValue(model),
        );
      }

      if (Platform.isMacOS) {
        final MacOsDeviceInfo info = await deviceInfoPlugin.macOsInfo;
        return _DeviceMetadata(
          platform: platform,
          osVersion: _normalizeValue(info.osRelease),
          model: _normalizeValue(info.model),
        );
      }

      if (Platform.isWindows) {
        final WindowsDeviceInfo info = await deviceInfoPlugin.windowsInfo;
        return _DeviceMetadata(
          platform: platform,
          osVersion: _normalizeValue(
            _pickStringFromMap(info.data, <String>[
              'displayVersion',
              'releaseId',
              'buildNumber',
            ]),
          ),
          model: _normalizeValue(
            _pickStringFromMap(info.data, <String>[
              'productName',
              'computerName',
            ]),
          ),
        );
      }

      if (Platform.isLinux) {
        final LinuxDeviceInfo info = await deviceInfoPlugin.linuxInfo;
        return _DeviceMetadata(
          platform: platform,
          osVersion: _normalizeValue(info.version),
          model: _normalizeValue(info.prettyName),
        );
      }
    } catch (_) {
      // Best effort: fall back to platform-only metadata.
    }

    return _DeviceMetadata(
      platform: platform,
      osVersion: _normalizeValue(Platform.operatingSystemVersion),
      model: '',
    );
  }

  Future<String> _readOrCreateInstallationId() async {
    String installationId = (await PersistentStorage.getInstallationId())
        .trim();
    if (installationId.isNotEmpty) {
      return installationId;
    }

    installationId = const Uuid().v4();
    await PersistentStorage.saveInstallationId(installationId);
    return installationId;
  }

  String _readSdkVersion() {
    final RegExpMatch? match = RegExp(
      r'^\s*(\d+\.\d+\.\d+)',
    ).firstMatch(Platform.version);
    if (match == null) {
      return '';
    }
    return 'dart/${match.group(1)}';
  }

  String _toPair(String key, String value) {
    final String normalizedValue = _normalizeValue(value);
    if (normalizedValue.isEmpty) {
      return '';
    }

    final int maxLength = _fieldMaxLengths[key] ?? normalizedValue.length;
    final String boundedValue = normalizedValue.length > maxLength
        ? normalizedValue.substring(0, maxLength)
        : normalizedValue;
    return '$key=$boundedValue';
  }

  String _capToMaxHeaderLength(List<String> orderedPairs) {
    if (orderedPairs.isEmpty) {
      return '';
    }

    final StringBuffer buffer = StringBuffer();
    for (final String pair in orderedPairs) {
      final String candidate = buffer.isEmpty
          ? pair
          : '${buffer.toString()}; $pair';
      if (candidate.length > _maxHeaderLength) {
        break;
      }
      buffer
        ..clear()
        ..write(candidate);
    }
    return buffer.toString();
  }

  String _normalizeValue(String? value) {
    if (value == null) {
      return '';
    }
    return value
        .replaceAll(RegExp(r'[\r\n\t]+'), ' ')
        .replaceAll(';', '')
        .replaceAll('=', '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _pickStringFromMap(Map<String, dynamic> data, List<String> keys) {
    for (final String key in keys) {
      final dynamic value = data[key];
      if (value == null) {
        continue;
      }
      final String candidate = value.toString().trim();
      if (candidate.isNotEmpty) {
        return candidate;
      }
    }
    return '';
  }
}

class _DeviceMetadata {
  const _DeviceMetadata({
    required this.platform,
    required this.osVersion,
    required this.model,
  });

  final String platform;
  final String osVersion;
  final String model;
}
