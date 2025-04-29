// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Organization _$OrganizationFromJson(Map<String, dynamic> json) => Organization()
  ..id = json['id'] as String?
  ..name = json['name'] as String?
  ..abbreviation = json['abbreviation'] as String?
  ..currency = json['currency'] as String?
  ..country = json['country'] as String?
  ..domain = json['domain'] as String?
  ..isEnabled = json['isEnabled'] as bool?
  ..companyType =
      $enumDecodeNullable(_$OrganizationTypeEnumMap, json['companyType'])
  ..microsoftSharepointFolderPath =
      json['microsoftSharepointFolderPath'] as String?
  ..invoicesWhitelist = (json['invoicesWhitelist'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      []
  ..permissions =
      (json['permissions'] as List<dynamic>?)?.map((e) => e as String).toList();

Map<String, dynamic> _$OrganizationToJson(Organization instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('abbreviation', instance.abbreviation);
  writeNotNull('currency', instance.currency);
  writeNotNull('country', instance.country);
  writeNotNull('domain', instance.domain);
  writeNotNull('isEnabled', instance.isEnabled);
  writeNotNull('companyType', _$OrganizationTypeEnumMap[instance.companyType]);
  writeNotNull(
      'microsoftSharepointFolderPath', instance.microsoftSharepointFolderPath);
  val['invoicesWhitelist'] = instance.invoicesWhitelist;
  writeNotNull('permissions', instance.permissions);
  return val;
}

const _$OrganizationTypeEnumMap = {
  OrganizationType.company: 'Company',
  OrganizationType.family: 'Family',
  OrganizationType.club: 'Club',
  OrganizationType.nonProfit: 'Non profit',
};
