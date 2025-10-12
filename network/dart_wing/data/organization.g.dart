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
  ..companyType = $enumDecodeNullable(
    _$OrganizationTypeEnumMap,
    json['companyType'],
  )
  ..microsoftSharepointFolderPath =
      json['microsoftSharepointFolderPath'] as String?
  ..invoicesWhitelist =
      (json['invoicesWhitelist'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      []
  ..permissions = (json['permissions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList();

Map<String, dynamic> _$OrganizationToJson(Organization instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'name': ?instance.name,
      'site': ?instance.site,
      'alias': instance.alias,
      'abbreviation': ?instance.abbreviation,
      'currency': ?instance.currency,
      'country': ?instance.country,
      'domain': ?instance.domain,
      'isEnabled': ?instance.isEnabled,
      'companyType': ?_$OrganizationTypeEnumMap[instance.companyType],
      'microsoftSharepointFolderPath': ?instance.microsoftSharepointFolderPath,
      'invoicesWhitelist': instance.invoicesWhitelist,
      'permissions': ?instance.permissions,
    };

const _$OrganizationTypeEnumMap = {
  OrganizationType.company: 'Company',
  OrganizationType.family: 'Family',
  OrganizationType.club: 'Club',
  OrganizationType.nonProfit: 'Non profit',
};
