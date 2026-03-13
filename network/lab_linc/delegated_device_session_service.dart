import 'dart:async';

import 'package:flutter/foundation.dart';

import '../paper_trail.dart';

class DelegatedDeviceSessionService {
  DelegatedDeviceSessionService._();

  static final DelegatedDeviceSessionService instance =
      DelegatedDeviceSessionService._();

  static const Duration _expirySkew = Duration(seconds: 30);

  final StreamController<DelegatedDeviceSessionSnapshot> _snapshotsController =
      StreamController<DelegatedDeviceSessionSnapshot>.broadcast();

  DelegatedDeviceSession? _activeSession;
  Timer? _expiryTimer;

  Stream<DelegatedDeviceSessionSnapshot> get snapshots =>
      _snapshotsController.stream;

  DelegatedDeviceSession? get activeSession {
    _expireIfNeeded();
    return _activeSession;
  }

  bool get hasActiveSession => activeSession != null;

  void activateSession({
    required String sessionId,
    required String delegatedToken,
    String schemaVersion = '',
    String messageType = '',
    String doctorId = '',
    String doctorName = '',
    DateTime? authorizedAtUtc,
    DateTime? expiresAtUtc,
    String deviceUid = '',
  }) {
    final String normalizedSessionId = sessionId.trim();
    final String normalizedDelegatedToken = delegatedToken.trim();
    if (normalizedSessionId.isEmpty || normalizedDelegatedToken.isEmpty) {
      _logWarning(
        'Delegated session activation skipped: missing sessionId or delegatedToken.',
      );
      return;
    }

    final DateTime? normalizedExpiryUtc = expiresAtUtc?.toUtc();
    if (_isExpired(normalizedExpiryUtc)) {
      clearSession(
        reason: 'Received an already expired delegated session.',
        logAsWarning: true,
      );
      return;
    }

    _activeSession = DelegatedDeviceSession(
      schemaVersion: schemaVersion.trim(),
      messageType: messageType.trim(),
      sessionId: normalizedSessionId,
      doctorId: doctorId.trim(),
      doctorName: doctorName.trim(),
      authorizedAtUtc: authorizedAtUtc?.toUtc(),
      expiresAtUtc: normalizedExpiryUtc,
      deviceUid: deviceUid.trim(),
      delegatedToken: normalizedDelegatedToken,
    );
    _scheduleExpiryTimer();
    _emitSnapshot();

    final String identity = _activeSession!.doctorName.isNotEmpty
        ? _activeSession!.doctorName
        : (_activeSession!.doctorId.isNotEmpty
              ? _activeSession!.doctorId
              : 'unknown');
    _logInfo(
      'Delegated session activated: sessionId=${_activeSession!.sessionId}, '
      'doctor=$identity, '
      'expiresAtUtc=${_activeSession!.expiresAtUtc?.toIso8601String() ?? 'n/a'}.',
    );
  }

  void clearSession({String reason = '', bool logAsWarning = false}) {
    final String normalizedReason = reason.trim();
    final bool hadSession = _activeSession != null;

    _expiryTimer?.cancel();
    _expiryTimer = null;
    _activeSession = null;

    if (hadSession) {
      if (normalizedReason.isNotEmpty) {
        if (logAsWarning) {
          _logWarning('Delegated session cleared: $normalizedReason');
        } else {
          _logInfo('Delegated session cleared: $normalizedReason');
        }
      } else {
        _logInfo('Delegated session cleared.');
      }
      _emitSnapshot(reason: normalizedReason);
      return;
    }

    if (normalizedReason.isNotEmpty) {
      _emitSnapshot(reason: normalizedReason);
    }
  }

  Map<String, String> createDelegatedHeaders(Map<String, String> baseHeaders) {
    final DelegatedDeviceSession session = _activeSessionOrThrow();
    return <String, String>{
      ...baseHeaders,
      // Device APIs stay authenticated as the station; the delegated session
      // is carried separately so login-only user tokens are not reused.
      'Device-Session-Id': session.sessionId,
    };
  }

  DelegatedDeviceSession _activeSessionOrThrow() {
    _expireIfNeeded();
    final DelegatedDeviceSession? session = _activeSession;
    if (session == null) {
      throw StateError(
        'Delegated session is not active. Please scan a new QR code.',
      );
    }
    return session;
  }

  void _expireIfNeeded() {
    final DelegatedDeviceSession? session = _activeSession;
    if (session == null) {
      return;
    }

    if (_isExpired(session.expiresAtUtc)) {
      clearSession(reason: 'Delegated session expired.', logAsWarning: true);
    }
  }

  bool _isExpired(DateTime? expiresAtUtc) {
    if (expiresAtUtc == null) {
      return false;
    }
    final DateTime refreshAt = expiresAtUtc.subtract(_expirySkew);
    return DateTime.now().toUtc().isAfter(refreshAt);
  }

  void _scheduleExpiryTimer() {
    _expiryTimer?.cancel();
    _expiryTimer = null;

    final DateTime? expiresAtUtc = _activeSession?.expiresAtUtc;
    if (expiresAtUtc == null) {
      return;
    }

    final DateTime nowUtc = DateTime.now().toUtc();
    Duration delay = expiresAtUtc.difference(nowUtc) - _expirySkew;
    if (delay.isNegative) {
      delay = Duration.zero;
    }

    _expiryTimer = Timer(delay, () {
      clearSession(reason: 'Delegated session expired.', logAsWarning: true);
    });
  }

  void _emitSnapshot({String reason = ''}) {
    _snapshotsController.add(
      DelegatedDeviceSessionSnapshot(
        session: _activeSession,
        reason: reason.trim(),
      ),
    );
  }

  void _logInfo(String message) {
    debugPrint(message);
    PaperTrailClient.sendInfoMessageToPaperTrail(message);
  }

  void _logWarning(String message) {
    debugPrint(message);
    PaperTrailClient.sendWarningMessageToPaperTrail(message);
  }
}

class DelegatedDeviceSessionSnapshot {
  const DelegatedDeviceSessionSnapshot({
    required this.session,
    required this.reason,
  });

  final DelegatedDeviceSession? session;
  final String reason;

  bool get hasActiveSession => session != null;
}

class DelegatedDeviceSession {
  const DelegatedDeviceSession({
    required this.schemaVersion,
    required this.messageType,
    required this.sessionId,
    required this.doctorId,
    required this.doctorName,
    required this.authorizedAtUtc,
    required this.expiresAtUtc,
    required this.deviceUid,
    required this.delegatedToken,
  });

  final String schemaVersion;
  final String messageType;
  final String sessionId;
  final String doctorId;
  final String doctorName;
  final DateTime? authorizedAtUtc;
  final DateTime? expiresAtUtc;
  final String deviceUid;
  final String delegatedToken;
}
