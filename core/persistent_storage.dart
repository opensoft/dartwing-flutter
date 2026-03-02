import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistentStorage {
  static const String _installationIdKey = 'client_info_installation_id';
  static const String _lastSelectedCameraDeviceIdKey =
      'last_selected_camera_device_id';
  static const String _accessUmsTokenKey = 'access_ums_token';
  static const String _keycloakClientSecretKey = 'keycloak_client_secret';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> saveAppId(String appId) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('app_id', appId);
  }

  static Future<String> getAppId() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('app_id') ?? '';
  }

  static Future<void> saveInstallationId(String installationId) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString(_installationIdKey, installationId);
  }

  static Future<String> getInstallationId() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString(_installationIdKey) ?? '';
  }

  static Future<void> init() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool('init', true);
  }

  static Future<void> deInit() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool('init', false);
  }

  static Future<bool> isInitialed() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool('init') ?? false;
  }

  static Future<void> saveCompany(String company) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('Company', company);
  }

  static Future<String> getCompany() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('Company') ?? '';
  }

  static Future<void> saveSite(String site) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('Site', site);
  }

  static Future<String> getSite() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('Site') ?? '';
  }

  static Future<void> saveAccessUmsToken(String token) async {
    await _saveSensitiveString(
      key: _accessUmsTokenKey,
      value: token,
      legacyPrefsKey: _accessUmsTokenKey,
    );
  }

  static Future<String> getAccessUmsToken() async {
    return _readSensitiveString(
      key: _accessUmsTokenKey,
      legacyPrefsKey: _accessUmsTokenKey,
    );
  }

  static Future<void> saveAccessUmsTokenExpiryEpochMs(int epochMs) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setInt('access_ums_token_expiry_epoch_ms', epochMs);
  }

  static Future<int> getAccessUmsTokenExpiryEpochMs() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getInt('access_ums_token_expiry_epoch_ms') ?? 0;
  }

  static Future<void> saveKeycloakClientId(String clientId) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('keycloak_client_id', clientId);
  }

  static Future<String> getKeycloakClientId() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('keycloak_client_id') ?? '';
  }

  static Future<void> saveKeycloakClientSecret(String clientSecret) async {
    await _saveSensitiveString(
      key: _keycloakClientSecretKey,
      value: clientSecret,
      legacyPrefsKey: _keycloakClientSecretKey,
    );
  }

  static Future<String> getKeycloakClientSecret() async {
    return _readSensitiveString(
      key: _keycloakClientSecretKey,
      legacyPrefsKey: _keycloakClientSecretKey,
    );
  }

  static Future<bool> isComplaintNotificationEnabled() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool('complaint_notification') ?? false;
  }

  static Future<void> setComplaintNotificationEnabled(bool enabled) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool('complaint_notification', enabled);
  }

  static Future<void> saveLastSuccessfulSerialPort(String port) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('last_successful_serial_port', port);
  }

  static Future<String> getLastSuccessfulSerialPort() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('last_successful_serial_port') ?? '';
  }

  static Future<void> saveLastSelectedCameraDeviceId(String deviceId) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString(_lastSelectedCameraDeviceIdKey, deviceId);
  }

  static Future<String> getLastSelectedCameraDeviceId() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString(_lastSelectedCameraDeviceIdKey) ?? '';
  }

  static Future<void> _saveSensitiveString({
    required String key,
    required String value,
    required String legacyPrefsKey,
  }) async {
    final SharedPreferences myPrefs = await SharedPreferences.getInstance();
    final String normalized = value.trim();
    try {
      if (normalized.isEmpty) {
        await _secureStorage.delete(key: key);
      } else {
        await _secureStorage.write(key: key, value: normalized);
      }
      await myPrefs.remove(legacyPrefsKey);
    } catch (error, stackTrace) {
      debugPrint('Secure storage write failed for $key: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (normalized.isEmpty) {
        await myPrefs.remove(legacyPrefsKey);
      } else {
        await myPrefs.setString(legacyPrefsKey, normalized);
      }
    }
  }

  static Future<String> _readSensitiveString({
    required String key,
    required String legacyPrefsKey,
  }) async {
    final SharedPreferences myPrefs = await SharedPreferences.getInstance();
    try {
      final String? secureValue = await _secureStorage.read(key: key);
      if (secureValue != null && secureValue.isNotEmpty) {
        return secureValue;
      }
    } catch (error, stackTrace) {
      debugPrint('Secure storage read failed for $key: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    final String legacyValue = myPrefs.getString(legacyPrefsKey) ?? '';
    if (legacyValue.isNotEmpty) {
      unawaited(
        _saveSensitiveString(
          key: key,
          value: legacyValue,
          legacyPrefsKey: legacyPrefsKey,
        ),
      );
    }
    return legacyValue;
  }
}
