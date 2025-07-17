// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Organization _$OrganizationFromJson(Map<String, dynamic> json) => Organization()
  ..id = json['id'] as String?
  ..name = json['name'] as String?
  ..site = json['site'] as String?
  ..alias = json['alias'] as String
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

Map<String, dynamic> _$OrganizationToJson(Organization instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.site case final value?) 'site': value,
      'alias': instance.alias,
      if (instance.abbreviation case final value?) 'abbreviation': value,
      if (instance.currency case final value?) 'currency': value,
      if (instance.country case final value?) 'country': value,
      if (instance.domain case final value?) 'domain': value,
      if (instance.isEnabled case final value?) 'isEnabled': value,
      if (_$OrganizationTypeEnumMap[instance.companyType] case final value?)
        'companyType': value,
      if (instance.microsoftSharepointFolderPath case final value?)
        'microsoftSharepointFolderPath': value,
      'invoicesWhitelist': instance.invoicesWhitelist,
      if (instance.permissions case final value?) 'permissions': value,
    };

const _$OrganizationTypeEnumMap = {
  OrganizationType.company: 'Company',
  OrganizationType.family: 'Family',
  OrganizationType.club: 'Club',
  OrganizationType.nonProfit: 'Non profit',
};
