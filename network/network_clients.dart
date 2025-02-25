import 'package:dart_wing/core/data/application_info.dart';
import 'package:dart_wing/network/dart_wing/dart_wing_api.dart';
import 'package:dart_wing/network/paper_trail.dart';
import 'package:dart_wing/network/rest_client.dart';

import '../core/globals.dart';
import '../core/persistent_storage.dart';

class NetworkClients {
  static bool qaModeEnabled = false;

  static Future<void> init({String? token, String? organization}) async {
    String appId = [
      Globals.applicationInfo.defaultLocation,
      Globals.applicationInfo.deviceId,
      Globals.applicationInfo.userEmail
    ].where((e) => e.isNotEmpty).join('-').toLowerCase();
    PaperTrailClient.init(
        "${Globals.applicationInfo.appName}${qaModeEnabled ? '-qa' : ''}"
            .toLowerCase(),
        appId,
        Globals.applicationInfo.papertrailSettings.host,
        Globals.applicationInfo.papertrailSettings.port);

    if (token != null) {
      dartWingRestClient.init(Globals.applicationInfo.appName, token,
          Globals.applicationInfo.userEmail);
    }
    dartWingApi.location = Globals.applicationInfo.defaultLocation;
  }

  static updateOrganization(String organization) {
    dartWingApi.location = Globals.applicationInfo.defaultLocation;
  }

  static RestClient dartWingRestClient = RestClient();

  static DartWingApi dartWingApi =
      DartWingApi(dartWingRestClient, 'https://api-dev.ledgerlinc.com', "");
}
