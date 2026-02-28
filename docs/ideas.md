design for Dartwing, we are moving from a standard monolith to a sophisticated Modular White-Labeling architecture. By treating your framework as a suite of local packages, you create a "plug-and-play" system where the main application is merely a consumer of your logic and UI.To achieve the "skinning" and "overriding" capabilities you're looking for, we need to implement a Dependency Injection (DI) and Interface-based design.1. The "Skinning" Strategy: Theme-Driven UIInstead of hardcoding colors or shapes, the dartwing_ui package should rely on a Design System interface.Custom Theme Extensions: Use Flutter's ThemeExtension to add properties that ThemeData doesn't cover (like specific gradients for your workflows or custom shadow depths).The Component Factory: If App A needs a rounded button and App B needs a sharp-edged one, your UI package shouldn't have if/else statements. Instead, it should look for a DartwingStyle configuration passed at the root.2. Overriding Screens with an Abstract RouterTo "override" a screen, the framework cannot hard-import specific classes. You must use a Registry Pattern:Define the Interface: In dartwing_core, define an abstract class for a feature (e.g., abstract class AuthScreenProvider).Default Implementation: Create DefaultAuthScreen in your framework.The Registry: The main app "registers" which widget to show for that route.App A: Uses the default.App B: Registers CustomAuthScreen(), and the framework automatically navigates to your new version instead of the internal one.3. The Package HierarchyThis structure ensures your business logic (the "Engine") remains pure and reusable across different apps or even non-Flutter Dart projects.PackageResponsibilityDependenciesdartwing_coreData models, Repositories, API clients, Business Logic.dart:core, dio, isardartwing_uiDesign system, atomic widgets (buttons, inputs), Base Layouts.flutter, dartwing_coredartwing_featuresFull workflows (e.g., Onboarding, Payment Flow).dartwing_ui, dartwing_coreMain AppThe "Glue." Sets the Theme and provides the specific UI overrides.All of the above4. Technical Implementation of the "Core Library"Since we discussed dartwing_core as a library, here is how you ensure it stays "headless":Dart// dartwing_core/lib/src/auth_service.dart
abstract class AuthService {
Future<bool> login(String user, String pass);
}

// Inside your UI package, you depend on the interface, not the implementation:
class LoginButton extends StatelessWidget {
final AuthService auth; // Injected via GetIt or Provider
...
}

To override screens in a framework like Dartwing, you move away from hard-coded navigation (e.g., MaterialPageRoute(builder: (\_) => MyScreen())) and move toward a Registry Pattern powered by Dependency Injection (DI).

The goal is for the framework to say, "I need to show the Login Screen now," while the specific App determines which Login Screen is actually rendered.

1. The Registry Interface
   In your dartwing_core or a dedicated dartwing_router package, you define an abstract "Map" of your UI.

Dart
// dartwing_core: Screen Definitions
abstract class DartwingScreenRegistry {
Widget getLoginScreen();
Widget getDashboardScreen();
Widget getProfileScreen();
} 2. The Default Framework Implementation
Inside your framework, you provide a "Standard" version of these screens. This allows a new app to work out of the box without you having to define every screen manually.

Dart
// dartwing_ui: Default Implementation
class DefaultScreenRegistry implements DartwingScreenRegistry {
@override
Widget getLoginScreen() => const BaseLoginWidget(); // Your framework's default UI

@override
Widget getDashboardScreen() => const BaseDashboardWidget();

@override
Widget getProfileScreen() => const BaseProfileWidget();
} 3. The Dependency Injection Setup
Using a service locator like GetIt, you register the registry at the start of the app.

In the Framework (The "Glue" code):
Dart
final getIt = GetIt.instance;

void setupDartwing(DartwingScreenRegistry overrides) {
// We register the provided registry (could be default or custom)
getIt.registerSingleton<DartwingScreenRegistry>(overrides);
} 4. How the App Overrides a Screen
When you build "App B" (which needs a custom branded login), you simply extend the registry and swap out only what you need.

Dart
// App B: The Custom App
class AppBScreenRegistry extends DefaultScreenRegistry {
@override
Widget getLoginScreen() {
return const FancyBrandedLogin(); // Your custom screen for App B
}
// getDashboardScreen and others are inherited from Default
} 5. Navigating via DI
Now, when your framework's business logic triggers a navigation event, it doesn't call a class name. It asks the DI container for the registered widget.

Dart
// Inside dartwing_features or your Router
void \_onLogout() {
final registry = GetIt.I<DartwingScreenRegistry>();

Navigator.of(context).pushReplacement(
MaterialPageRoute(builder: (\_) => registry.getLoginScreen()),
);
}
Why this works for Dartwing:
Decoupling: Your feature logic (the "Workflow") doesn't care if the screen is a simple form or a 3D-animated experience. It just knows it's calling getLoginScreen().

Tree Shaking: If App A doesn't use the DefaultLoginScreen, and you've set up your project correctly with conditional imports or separate packages, the unused default UI code won't be compiled into the final binary.

A/B Testing: You can swap the entire ScreenRegistry at runtime to test different UI flows without changing a single line of business logic.

Dealing with Parameters
If your screens require data (like a UserID), update your registry methods to accept them:
Widget getProfileScreen(String userId);


To move Keycloak into the framework while allowing for app-level configuration and total overrides, you should implement an **Interface-Driven Auth Layer** combined with a **Configuration Registry**.

This setup ensures that the framework handles the "heavy lifting" (token management, redirect logic, and backend handshakes) while the App simply provides the "parameters" or a completely different provider if needed.

---

Gemini said
The current Dartwing architecture uses a Service Locator pattern (static singletons like Globals and NetworkClients) rather than true Dependency Injection (DI). While this is simple to start with, it creates "hidden dependencies" that make it difficult to override screens or unit test logic without spinning up the entire framework.

Below is a top-level plan to evolve Dartwing from a Shared Library to a Modular Framework using DI and interface-driven design.

1. Move from Static Singletons to DI (GetIt)
Currently, NetworkClients and Globals are hard-coded singletons. If you want to change how DartWingApi works for a specific app, you can't easily swap it.

Improvement: Replace static access with a service locator like GetIt.

Why: This allows the "App" layer to register a custom version of an API client or Service before the framework starts.

Action: Instead of NetworkClients.dartWingApi, you will call getIt<DartWingApi>().

2. Implement the "Registry Pattern" for Screen Overrides
The flutter/ library currently owns specific routes like scannerPage and organizationsListPage. You cannot easily change the UI of these pages without modifying the library itself.

Improvement: Create an abstract ScreenRegistry interface in the library.

The Plan:

In Library: Define abstract class DartwingUI { Widget scannerScreen(); }.

In Library: Provide DefaultDartwingUI (the current implementation).

In App: If you want a custom scanner, create AppCustomUI that extends the default and overrides scannerScreen().

At Startup: Register your UI implementation: getIt.registerSingleton<DartwingUI>(AppCustomUI()).

3. Extract "App-Owned" Auth into a Library Interface
Your documentation notes that Auth stays in the app because OAuth2/Keycloak is app-specific. However, the library needs the user and tokens to function.

Improvement: Define an IAuthService interface in the library.

Benefit: The library can then define "protected" routes that automatically check IAuthService.isLoggedIn() without needing to know how Keycloak works. The App provides the actual implementation of the login logic.

4. Hierarchy & Modularization Plan
To make the framework truly robust, reorganize the flutter/ directory into sub-packages or clear layers:

Layer	Responsibility	Improvement
Core	Models, Exceptions, Persistent Storage.	Make Globals a non-static class managed by DI.
Domain	Abstract Interfaces (API definitions, Auth interfaces).	This becomes the "Contract" that the App must fulfill.
Data	RestClient, DartWingApi.	Use DI to inject the RestClient into the APIs for easier mocking/testing.
UI/Features	BaseScaffold, ScannerPage, Org Management.	Rely on ThemeExtensions for skinning and the Registry for overrides.
5. Summary of Best Practices for Dartwing
Stop using static: Move all global state into a container that can be initialized and cleared.

Code to Interfaces: The library should depend on BaseApi, not the concrete DartWingApi, so you can swap backends easily.

Thematic Skinning: Instead of hardcoded colors in base_colors.dart, use Theme.of(context).extension<DartwingTheme>() so the App can change the look without touching library code.

we also want to move the keycloak integration into the framework - so make plan to implment this

## 1. Define the Abstract Auth Contract

In the `flutter/core` package, define an interface that all authentication services must follow. This allows the rest of the framework to remain "provider-agnostic".

```dart
// flutter/lib/core/auth/auth_service.dart
abstract class IAuthService {
  Future<void> login();
  Future<void> logout();
  Future<String?> getAccessToken();
  bool get isAuthenticated;
}

```

## 2. Framework-Level Keycloak Implementation

Create the default Keycloak implementation within the framework. It should accept a configuration object so it doesn't have hard-coded URLs.

```dart
// flutter/lib/core/auth/keycloak_auth_service.dart
class KeycloakAuthService implements IAuthService {
  final AuthConfig config; // Passed from the App
  final FlutterAppAuth _appAuth = FlutterAppAuth();

  KeycloakAuthService(this.config);

  @override
  Future<void> login() async {
    // Uses config.discoveryUrl, config.clientId, etc.
    final result = await _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        config.clientId,
        config.redirectUrl,
        discoveryUrl: config.discoveryUrl,
        scopes: ['openid', 'profile', 'email'],
      ),
    );
    // Handle token storage in PersistentStorage (framework library)
  }
  // ... other overrides
}

```

## 3. Configuration Management

Instead of a raw text file, use a typed **Configuration Class** in the framework. This allows the App to pass its unique parameters into the framework during initialization.

```dart
// flutter/lib/core/config/dartwing_config.dart
class AuthConfig {
  final String clientId;
  final String discoveryUrl;
  final String redirectUrl;

  AuthConfig({
    required this.clientId,
    required this.discoveryUrl,
    required this.redirectUrl,
  });
}

```

## 4. The "Pluggable" Setup in the App

The App’s `main.dart` is where you decide which service to use. By default, you tell the framework to use Keycloak with specific parameters. If a different app wants to use Auth0, it simply registers an `Auth0Service` instead.

### For a standard Keycloak App:

```dart
// app/lib/main.dart
void main() {
  final myConfig = AuthConfig(
    clientId: 'dartwing-mobile-app',
    discoveryUrl: 'https://auth.example.com/realms/myrealm/.well-known/openid-configuration',
    redirectUrl: 'com.dartwing.app:/oauthredirect',
  );

  // Register the implementation in the Service Locator (GetIt)
  getIt.registerLazySingleton<IAuthService>(() => KeycloakAuthService(myConfig));
  
  runApp(MyApp());
}

```

### To override with a different service (e.g., Azure AD):

```dart
// app_b/lib/main.dart
getIt.registerLazySingleton<IAuthService>(() => AzureAuthService(azureConfig));

```

---

## 5. Summary of the Benefits

* **Encapsulation**: The framework logic for handling expired tokens, injecting Bearer headers, and PaperTrail logging of auth failures is written once in `KeycloakAuthService`.
* **Zero-Knowledge App**: The App doesn't need to import `flutter_appauth` or handle deep-link redirects; it just calls `getIt<IAuthService>().login()`.
* **Configuration Flexibility**: Since the `AuthConfig` is passed at runtime, you can easily load different domains for `QA`, `Production`, or `Local` environments without changing framework code.

**Would you like me to show how to integrate this new `IAuthService` into your existing `NetworkClients` so it automatically attaches tokens to every request?**