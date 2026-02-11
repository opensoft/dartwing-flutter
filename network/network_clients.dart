import '../core/persistent_storage.dart';
import 'dart_wing/dart_wing_api.dart';
import 'frappe/healthcare_api.dart';
import 'frappe/users_api.dart';
import 'lab_linc/lab_linc_api.dart';
import 'paper_trail.dart';
import 'rest_client.dart';

import '../core/globals.dart';

class NetworkClients {
  static bool qaModeEnabled = false;

  static Future<void> init({
    String? token,
    String? frappeToken,
    String? siteName,
    String? organizationAlias,
  }) async {
    Future<String?> futureCompany = Future.value(organizationAlias);
    if (organizationAlias == null &&
        Globals.applicationInfo.companyAlias.isEmpty) {
      futureCompany = PersistentStorage.getCompany();
    }
    return futureCompany
        .then((companyAlias) {
          if (companyAlias != null) {
            Globals.applicationInfo.companyAlias = companyAlias;
          }
          if (Globals.applicationInfo.companyAlias.isNotEmpty) {
            PersistentStorage.saveCompany(Globals.applicationInfo.companyAlias);
          }

          Future<String?> futureSite = Future.value(siteName);
          if (siteName == null && Globals.applicationInfo.defaultSite.isEmpty) {
            futureSite = PersistentStorage.getSite();
          }
          return futureSite;
        })
        .then((siteName) {
          if (siteName != null) {
            Globals.applicationInfo.defaultSite = siteName;
          }
          if (Globals.applicationInfo.defaultSite.isNotEmpty) {
            PersistentStorage.saveSite(Globals.applicationInfo.defaultSite);
          }

          String appId = [
            Globals.applicationInfo.defaultSite,
            Globals.applicationInfo.deviceId,
            Globals.applicationInfo.userEmail,
          ].where((e) => e.isNotEmpty).join('-').toLowerCase();
          PaperTrailClient.init(
            "${Globals.applicationInfo.appName}${qaModeEnabled ? '-qa' : ''}"
                .toLowerCase(),
            appId,
            Globals.applicationInfo.papertrailSettings.host,
            Globals.applicationInfo.papertrailSettings.port,
          );

          if (token != null) {
            dartWingRestClient.init(
              Globals.applicationInfo.appName,
              token,
              Globals.applicationInfo.userEmail,
            );
            labLincRestClient.init(
              Globals.applicationInfo.appName,
              token,
              Globals.applicationInfo.userEmail,
            );
          }

          if (frappeToken != null) {
            frappeRestClient.init(
              Globals.applicationInfo.appName,
              frappeToken,
              Globals.applicationInfo.userEmail,
            );
          }
          dartWingApi.site = Globals.applicationInfo.defaultSite;
          dartWingApi.company = Globals.applicationInfo.companyAlias;
          labLincApi.site = Globals.applicationInfo.defaultSite;
          labLincApi.company = Globals.applicationInfo.companyAlias;
          healthcareApi.site = Globals.applicationInfo.defaultSite;
          healthcareApi.company = Globals.applicationInfo.companyAlias;
          usersApi.site = Globals.applicationInfo.defaultSite;
          usersApi.company = Globals.applicationInfo.companyAlias;

          if (qaModeEnabled) {
            dartWingApi.init(
              "https://qa.gateway.dartwing.opensoft.one",
              Globals.applicationInfo.defaultSite,
            );
            labLincApi.init(
              "https://lablincdotnet-qa.tech-corps.com",
              Globals.applicationInfo.defaultSite,
            );
            healthcareApi.init(
              "https://qa.frappe.dartwing.opensoft.one",
              Globals.applicationInfo.defaultSite,
            );
            usersApi.init(
              "https://qa.frappe.dartwing.opensoft.one",
              Globals.applicationInfo.defaultSite,
            );
          } else {
            dartWingApi.init(
              'https://gateway.dartwing.opensoft.one',
              Globals.applicationInfo.defaultSite,
            );
            labLincApi.init(
              'https://lablincdotnet.tech-corps.com',
              Globals.applicationInfo.defaultSite,
            );
            healthcareApi.init(
              "https://frappe.dartwing.opensoft.one",
              Globals.applicationInfo.defaultSite,
            );
            usersApi.init(
              "https://frappe.dartwing.opensoft.one",
              Globals.applicationInfo.defaultSite,
            );
          }
        });
  }

  static RestClient dartWingRestClient = RestClient();
  static RestClient labLincRestClient = RestClient();
  static RestClient frappeRestClient = RestClient();

  static DartWingApi dartWingApi = DartWingApi(dartWingRestClient, '', '', '');
  static LabLincApi labLincApi = LabLincApi(labLincRestClient, '', '', '');
  static HealthcareApi healthcareApi = HealthcareApi(
    frappeRestClient,
    '',
    '',
    '',
  );
  static UsersApi usersApi = UsersApi(frappeRestClient, '', '', '');
}
