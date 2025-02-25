import 'package:dart_wing/core/data/application_info.dart';
import 'package:keycloak_wrapper/keycloak_wrapper.dart';

import '../network/dart_wing/data/user.dart';

class Globals {
  static User user = User();
  static ApplicationInfo applicationInfo = ApplicationInfo();
  static bool qaModeEnabled = false;

  static final keycloakWrapper = KeycloakWrapper(
      config: KeycloakConfig(
    bundleIdentifier: 'com.opensoft.ledgerlinc',
    clientId: 'ledgermobile',
    frontendUrl: 'https://keycloak-qa.tech-corps.com/',
    realm: 'master',
  ));
}
