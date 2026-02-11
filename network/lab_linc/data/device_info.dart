import 'package:json_annotation/json_annotation.dart';

part 'device_info.g.dart';

@JsonSerializable(explicitToJson: true)
class DeviceInfo {
  String deviceUid = '';
  String name = '';

  @JsonKey(defaultValue: 0, fromJson: _intFromJson, toJson: _intToJson)
  int slotCount = 0;

  @JsonKey(defaultValue: 0, fromJson: _intFromJson, toJson: _intToJson)
  int occupiedSlotCount = 0;

  String? keycloakClientId;
  String? companyId;
  String? companyName;
  String? laboratoryId;
  String? laboratoryName;
  String? labShortCode;
  String onlineStatus = '';
  String? lastSeenAtUtc;
  String createdAtUtc = '';

  DeviceInfo();

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);
}

int _intFromJson(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}

dynamic _intToJson(int value) => value;
