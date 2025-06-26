import '../core/persistent_storage.dart';
import 'dart_wing/dart_wing_api.dart';
import 'healthcare/healthcare_api.dart';
import 'paper_trail.dart';
import 'rest_client.dart';

import '../core/globals.dart';

class NetworkClients {
  static bool qaModeEnabled = false;

  static Future<void> init(
      {String? token, String? siteName, String? organizationName}) async {
    Future<String?> futureCompany = Future.value(organizationName);
    if (organizationName == null && Globals.applicationInfo.company.isEmpty) {
      futureCompany = PersistentStorage.getCompany();
    }
    return futureCompany.then((company) {
      if (company != null) {
        Globals.applicationInfo.company = company;
      }
      if (Globals.applicationInfo.company.isNotEmpty) {
        PersistentStorage.saveCompany(Globals.applicationInfo.company);
      }

      Future<String?> futureSite = Future.value(siteName);
      if (siteName == null && Globals.applicationInfo.defaultSite.isEmpty) {
        futureSite = PersistentStorage.getSite();
      }
      return futureSite;
    }).then((siteName) {
      if (siteName != null) {
        Globals.applicationInfo.defaultSite = siteName;
      }
      if (Globals.applicationInfo.defaultSite.isNotEmpty) {
        PersistentStorage.saveSite(Globals.applicationInfo.defaultSite);
      }

      String appId = [
        Globals.applicationInfo.defaultSite,
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
      dartWingApi.site = Globals.applicationInfo.defaultSite;
      dartWingApi.company = Globals.applicationInfo.company;
      healthcareApi.site = Globals.applicationInfo.defaultSite;
      healthcareApi.company = Globals.applicationInfo.company;

      if (qaModeEnabled) {
        dartWingApi.init("https://dartwing-dotnet-gatekeeper-qa.tech-corps.com",
            Globals.applicationInfo.defaultSite);
        healthcareApi.init(
            "https://dartwing-dotnet-gatekeeper-qa.tech-corps.com",
            Globals.applicationInfo.defaultSite);
      } else {
        dartWingApi.init('https://dartwing-gatekeeper.opensoft.one',
            Globals.applicationInfo.defaultSite);
        healthcareApi.init('https://dartwing-gatekeeper.opensoft.one',
            Globals.applicationInfo.defaultSite);
      }
    });
  }

  static RestClient dartWingRestClient = RestClient();

  static DartWingApi dartWingApi = DartWingApi(dartWingRestClient, '', '', '');
  static HealthcareApi healthcareApi =
      HealthcareApi(dartWingRestClient, '', '', '');
}
