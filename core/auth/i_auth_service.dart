import 'dart:async';

abstract class IAuthService {
  bool get isInitialized;
  String? get accessToken;
  DateTime? get accessTokenExpiration;
  Stream<bool> get authenticationStream;
  Future<bool> get isLoggedIn;
  Map<String, dynamic>? get idClaims;

  set onError(
    void Function(String message, Object error, StackTrace stackTrace)?
        handler,
  );

  Future<void> initialize();
  Future<bool> login();
  Future<bool> logout();
  Future<void> refreshTokens();
  Future<Map<String, dynamic>?> getUserInfo({bool retryOnUnauthorized = true});
}
