import 'package:shared_preferences/shared_preferences.dart';

class PersistentStorage {
  static Future<void> saveAppId(String appId) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('app_id', appId);
  }

  static Future<String> getAppId() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('app_id') ?? '';
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
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('access_ums_token', token);
  }

  static Future<String> getAccessUmsToken() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('access_ums_token') ?? '';
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
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('keycloak_client_secret', clientSecret);
  }

  static Future<String> getKeycloakClientSecret() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('keycloak_client_secret') ?? '';
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
}
