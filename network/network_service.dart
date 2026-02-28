import '../core/app_state.dart';
import '../core/logging/i_logger.dart';
import '../core/persistent_storage.dart';
import 'dart_wing/dart_wing_api.dart';
import 'frappe/healthcare_api.dart';
import 'frappe/users_api.dart';
import 'paper_trail.dart';
import 'rest_client.dart';

class NetworkService {
  NetworkService({required this.appState, required this.logger});

  final AppState appState;
  final ILogger logger;

  bool qaModeEnabled = false;

  RestClient dartWingRestClient = RestClient();
  RestClient frappeRestClient = RestClient();

  late DartWingApi dartWingApi = DartWingApi(dartWingRestClient, '', '', '');
  late HealthcareApi healthcareApi = HealthcareApi(
    frappeRestClient,
    '',
    '',
    '',
  );
  late UsersApi usersApi = UsersApi(frappeRestClient, '', '', '');

  Future<void> init({
    String? token,
    String? frappeToken,
    String? siteName,
    String? organizationAlias,
  }) async {
    Future<String?> futureCompany = Future.value(organizationAlias);
    if (organizationAlias == null &&
        appState.applicationInfo.companyAlias.isEmpty) {
      futureCompany = PersistentStorage.getCompany();
    }
    return futureCompany
        .then((companyAlias) {
          if (companyAlias != null) {
            appState.applicationInfo.companyAlias = companyAlias;
          }
          if (appState.applicationInfo.companyAlias.isNotEmpty) {
            PersistentStorage.saveCompany(
              appState.applicationInfo.companyAlias,
            );
          }

          Future<String?> futureSite = Future.value(siteName);
          if (siteName == null &&
              appState.applicationInfo.defaultSite.isEmpty) {
            futureSite = PersistentStorage.getSite();
          }
          return futureSite;
        })
        .then((siteName) {
          if (siteName != null) {
            appState.applicationInfo.defaultSite = siteName;
          }
          if (appState.applicationInfo.defaultSite.isNotEmpty) {
            PersistentStorage.saveSite(appState.applicationInfo.defaultSite);
          }

          String appId = [
            appState.applicationInfo.defaultSite,
            appState.applicationInfo.deviceId,
            appState.applicationInfo.userEmail,
          ].where((e) => e.isNotEmpty).join('-').toLowerCase();
          PaperTrailClient.init(
            "${appState.applicationInfo.appName}${qaModeEnabled ? '-qa' : ''}"
                .toLowerCase(),
            appId,
            appState.applicationInfo.papertrailSettings.host,
            appState.applicationInfo.papertrailSettings.port,
          );

          if (token != null) {
            dartWingRestClient.init(
              appState.applicationInfo.appName,
              token,
              appState.applicationInfo.userEmail,
            );
          }

          if (frappeToken != null) {
            frappeRestClient.init(
              appState.applicationInfo.appName,
              frappeToken,
              appState.applicationInfo.userEmail,
            );
          }
          dartWingApi.site = appState.applicationInfo.defaultSite;
          dartWingApi.company = appState.applicationInfo.companyAlias;
          healthcareApi.site = appState.applicationInfo.defaultSite;
          healthcareApi.company = appState.applicationInfo.companyAlias;
          usersApi.site = appState.applicationInfo.defaultSite;
          usersApi.company = appState.applicationInfo.companyAlias;

          if (qaModeEnabled) {
            dartWingApi.init(
              "https://qa.gateway.dartwing.opensoft.one",
              appState.applicationInfo.defaultSite,
            );
            healthcareApi.init(
              "qa.frappe.dartwing.opensoft.one",
              appState.applicationInfo.defaultSite,
            );
            usersApi.init(
              "qa.frappe.dartwing.opensoft.one",
              appState.applicationInfo.defaultSite,
            );
          } else {
            dartWingApi.init(
              'https://gateway.dartwing.opensoft.one',
              appState.applicationInfo.defaultSite,
            );
            healthcareApi.init(
              "https://frappe.dartwing.opensoft.one",
              appState.applicationInfo.defaultSite,
            );
            usersApi.init(
              "https://frappe.dartwing.opensoft.one",
              appState.applicationInfo.defaultSite,
            );
          }
        });
  }
}
