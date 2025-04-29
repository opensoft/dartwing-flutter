import '../core/data/application_info.dart';
import 'dart_wing/dart_wing_api.dart';
import 'paper_trail.dart';
import 'rest_client.dart';

import '../core/globals.dart';
import '../core/persistent_storage.dart';

class NetworkClients {
  static bool qaModeEnabled = false;

  static Future<void> init({String? token, String? organization}) async {
    if (organization != null) {
      Globals.applicationInfo.defaultLocation = organization;
    }

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

    if (qaModeEnabled) {
      dartWingApi.init("https://dartwing-dotnet-gatekeeper-qa.tech-corps.com",
          Globals.applicationInfo.defaultLocation);
    } else {
      dartWingApi.init('https://dartwing.tech-corps.com',
          Globals.applicationInfo.defaultLocation);
    }
  }

  static updateOrganization(String organization) {
    dartWingApi.location = Globals.applicationInfo.defaultLocation;
  }

  static RestClient dartWingRestClient = RestClient();

  static DartWingApi dartWingApi = DartWingApi(dartWingRestClient, '', '');
}
