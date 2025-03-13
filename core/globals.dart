import 'package:keycloak_wrapper/keycloak_wrapper.dart';

import 'data/application_info.dart';

import '../network/dart_wing/data/user.dart';

class Globals {
  static User user = User();
  static ApplicationInfo applicationInfo = ApplicationInfo();
  static bool qaModeEnabled = false;

  static final keycloakWrapper = KeycloakWrapper(
      config: KeycloakConfig(
    bundleIdentifier: 'com.opensoft.dartwing',
    clientId: 'dartwingmobile',
    frontendUrl: 'https://qa.keycloak.tech-corps.com/',
    realm: 'DartWing',
  ));
}
