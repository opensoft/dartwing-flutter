import 'package:get_it/get_it.dart';

import '../app_state.dart';
import '../logging/i_logger.dart';
import '../logging/papertrail_logger.dart';
import '../../gui/screen_registry/default_screen_registry.dart';
import '../../gui/screen_registry/i_screen_registry.dart';
import '../../network/interfaces/i_dart_wing_api.dart';
import '../../network/interfaces/i_healthcare_api.dart';
import '../../network/interfaces/i_users_api.dart';
import '../../network/network_service.dart';

class DartwingServiceLocator {
  static void init() {
    final getIt = GetIt.I;

    if (!getIt.isRegistered<AppState>()) {
      getIt.registerSingleton<AppState>(AppState());
    }

    if (!getIt.isRegistered<ILogger>()) {
      getIt.registerSingleton<ILogger>(PaperTrailLogger());
    }

    // NetworkService requires AppState and ILogger to be registered first
    if (!getIt.isRegistered<NetworkService>()) {
      getIt.registerSingleton<NetworkService>(
        NetworkService(
          appState: getIt<AppState>(),
          logger: getIt<ILogger>(),
        ),
      );
    }

    // Register API interfaces pointing to NetworkService's concrete instances
    if (!getIt.isRegistered<IDartWingApi>()) {
      getIt.registerFactory<IDartWingApi>(
        () => getIt<NetworkService>().dartWingApi,
      );
    }

    if (!getIt.isRegistered<IHealthcareApi>()) {
      getIt.registerFactory<IHealthcareApi>(
        () => getIt<NetworkService>().healthcareApi,
      );
    }

    if (!getIt.isRegistered<IUsersApi>()) {
      getIt.registerFactory<IUsersApi>(
        () => getIt<NetworkService>().usersApi,
      );
    }

    if (!getIt.isRegistered<IScreenRegistry>()) {
      getIt.registerSingleton<IScreenRegistry>(DefaultScreenRegistry());
    }
  }
}
