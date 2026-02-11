// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => DeviceInfo()
  ..deviceUid = json['deviceUid'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..slotCount = json['slotCount'] == null ? 0 : _intFromJson(json['slotCount'])
  ..occupiedSlotCount =
      json['occupiedSlotCount'] == null
          ? 0
          : _intFromJson(json['occupiedSlotCount'])
  ..keycloakClientId = json['keycloakClientId'] as String?
  ..companyId = json['companyId'] as String?
  ..companyName = json['companyName'] as String?
  ..laboratoryId = json['laboratoryId'] as String?
  ..laboratoryName = (json['labName'] ?? json['laboratoryName']) as String?
  ..labShortCode = json['labShortCode'] as String?
  ..onlineStatus = json['onlineStatus'] as String? ?? ''
  ..lastSeenAtUtc = json['lastSeenAtUtc'] as String?
  ..createdAtUtc = json['createdAtUtc'] as String? ?? '';

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{
      'deviceUid': instance.deviceUid,
      'name': instance.name,
      'slotCount': _intToJson(instance.slotCount),
      'occupiedSlotCount': _intToJson(instance.occupiedSlotCount),
      'keycloakClientId': instance.keycloakClientId,
      'companyId': instance.companyId,
      'companyName': instance.companyName,
      'laboratoryId': instance.laboratoryId,
      'labName': instance.laboratoryName,
      'labShortCode': instance.labShortCode,
      'onlineStatus': instance.onlineStatus,
      'lastSeenAtUtc': instance.lastSeenAtUtc,
      'createdAtUtc': instance.createdAtUtc,
    };
