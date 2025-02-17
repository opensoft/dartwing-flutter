import 'package:shared_preferences/shared_preferences.dart';

class PersistentStorage {
  static saveUvFilesPath(String filePath, double width, double height) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('substrate_${width}x$height', filePath);
  }

  static Future<String> getUvFilesPath(double width, double height) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('substrate_${width}x$height') ?? "";
  }

  static saveCuttingMachineName(String cuttingMachineName) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('cutting_machine_name', cuttingMachineName);
  }

  static Future<String> getCuttingMachineName() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('cutting_machine_name') ?? "";
  }

  static saveAppId(String appId) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('app_id', appId);
  }

  static Future<String> getAppId() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('app_id') ?? '';
  }

  static savePrinterName(String printerName) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('printer_name', printerName);
  }

  static Future<String> getPrinterName() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('printer_name') ?? '';
  }

  static savePressName(String pressName) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('press_name', pressName);
  }

  static Future<String> getPressName() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('press_name') ?? '';
  }

  static init() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool('init', true);
  }

  static deInit() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool('init', false);
  }

  static Future<bool> isInitialed() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool('init') ?? false;
  }

  static saveLocation(String location) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('Location', location);
  }

  static Future<String> getLocation() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('Location') ?? '';
  }

  static saveAccessUmsToken(String token) async {
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

  static setComplaintNotificationEnabled(bool enabled) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool('complaint_notification', enabled);
  }
}
