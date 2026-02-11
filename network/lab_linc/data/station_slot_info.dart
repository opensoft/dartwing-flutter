class StationSlotInfo {
  final int slotNumber;
  final String status;
  final String? dishExternalId;
  final String? patientExternalId;
  final String? patientName;
  final int embryosCount;
  final String? embryoStatus;
  final String? positionLabel;
  final String? lastEventAtUtc;
  final bool isOccupied;
  final bool isRecentlyAdded;

  const StationSlotInfo({
    required this.slotNumber,
    required this.status,
    required this.dishExternalId,
    required this.patientExternalId,
    required this.patientName,
    required this.embryosCount,
    required this.embryoStatus,
    required this.positionLabel,
    required this.lastEventAtUtc,
    required this.isOccupied,
    required this.isRecentlyAdded,
  });

  factory StationSlotInfo.empty(int slotNumber) {
    return StationSlotInfo(
      slotNumber: slotNumber,
      status: 'empty',
      dishExternalId: null,
      patientExternalId: null,
      patientName: null,
      embryosCount: 0,
      embryoStatus: null,
      positionLabel: null,
      lastEventAtUtc: null,
      isOccupied: false,
      isRecentlyAdded: false,
    );
  }

  factory StationSlotInfo.fromApiJson(Map<String, dynamic> json) {
    final slotNumber = _firstInt(
      json,
      const [
        'slotNumber',
        'slot',
        'position',
        'index',
        'slotIndex',
        'positionNumber',
        'positionNo',
      ],
    );
    final status = _firstString(
      json,
      const ['status', 'slotStatus', 'state', 'slotState'],
    );
    final dishExternalId = _firstNullableString(
      json,
      const ['dishExternalId', 'dishId', 'dishBarcode', 'dishCode', 'dishNumber'],
    );
    final patientExternalId = _firstNullableString(
      json,
      const ['patientExternalId', 'patientId'],
    );
    final patientName = _firstNullableString(
      json,
      const ['patientName', 'patientDisplayName', 'patient'],
    );
    final embryosCount = _firstInt(
      json,
      const [
        'embryosCount',
        'embryoCount',
        'embryos',
        'occupiedEmbryosCount',
      ],
    );
    final embryoStatus = _firstNullableString(
      json,
      const ['embryoStatus', 'qualityStatus', 'quality', 'stage', 'statusText'],
    );
    final positionLabel = _firstNullableString(
      json,
      const ['positionLabel', 'positionCode', 'positionName'],
    );
    final lastEventAtUtc = _firstNullableString(
      json,
      const ['lastEventAtUtc', 'updatedAtUtc', 'timestamp'],
    );

    final normalizedStatus = status.toLowerCase();
    final hasDish = dishExternalId != null && dishExternalId.isNotEmpty;
    final occupiedFallback =
        hasDish ||
        normalizedStatus.contains('occup') ||
        normalizedStatus.contains('active') ||
        normalizedStatus.contains('load') ||
        normalizedStatus.contains('full');
    final isOccupied = _firstBool(
      json,
      const ['isOccupied', 'occupied', 'hasDish', 'isFilled'],
      defaultValue: occupiedFallback,
    );
    final isRecentlyAdded = _firstBool(
      json,
      const ['isRecentlyAdded', 'recentlyAdded', 'recentAdded', 'isNew'],
      defaultValue:
          normalizedStatus.contains('recent') ||
          normalizedStatus.contains('new'),
    );

    return StationSlotInfo(
      slotNumber: slotNumber,
      status: status,
      dishExternalId: dishExternalId,
      patientExternalId: patientExternalId,
      patientName: patientName,
      embryosCount: embryosCount,
      embryoStatus: embryoStatus,
      positionLabel: positionLabel,
      lastEventAtUtc: lastEventAtUtc,
      isOccupied: isOccupied,
      isRecentlyAdded: isRecentlyAdded,
    );
  }

  static int _firstInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (!json.containsKey(key)) {
        continue;
      }
      final value = json[key];
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.toInt();
      }
      if (value is String) {
        final parsed = int.tryParse(value.trim());
        if (parsed != null) {
          return parsed;
        }
      }
    }
    return 0;
  }

  static String _firstString(Map<String, dynamic> json, List<String> keys) {
    final value = _firstNullableString(json, keys);
    return value ?? '';
  }

  static String? _firstNullableString(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      if (!json.containsKey(key)) {
        continue;
      }
      final value = json[key];
      final parsed = _parseNullableString(value);
      if (parsed != null) {
        return parsed;
      }
    }
    return null;
  }

  static bool _firstBool(
    Map<String, dynamic> json,
    List<String> keys, {
    required bool defaultValue,
  }) {
    for (final key in keys) {
      if (!json.containsKey(key)) {
        continue;
      }
      final value = json[key];
      if (value is bool) {
        return value;
      }
      if (value is num) {
        return value != 0;
      }
      if (value is String) {
        final normalized = value.trim().toLowerCase();
        if (normalized == 'true' ||
            normalized == '1' ||
            normalized == 'yes' ||
            normalized == 'y') {
          return true;
        }
        if (normalized == 'false' ||
            normalized == '0' ||
            normalized == 'no' ||
            normalized == 'n') {
          return false;
        }
      }
    }
    return defaultValue;
  }

  static String? _parseNullableString(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    if (value is num || value is bool) {
      return value.toString();
    }
    if (value is Map) {
      final mapValue = Map<String, dynamic>.from(value);
      final nestedValue = _firstNullableString(
        mapValue,
        const ['name', 'displayName', 'id', 'value'],
      );
      return nestedValue;
    }
    return null;
  }
}
