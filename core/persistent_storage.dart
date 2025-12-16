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

  static Future<bool> isComplaintNotificationEnabled() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool('complaint_notification') ?? false;
  }

  static Future<void> setComplaintNotificationEnabled(bool enabled) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool('complaint_notification', enabled);
  }
}
