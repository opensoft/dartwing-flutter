// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Organization _$OrganizationFromJson(Map<String, dynamic> json) => Organization()
  ..name = json['name'] as String
  ..abbreviation = json['abbreviation'] as String?
  ..currency = json['currency'] as String?
  ..country = json['country'] as String?
  ..domain = json['domain'] as String?
  ..isEnabled = json['isEnabled'] as bool?
  ..companyType =
      $enumDecodeNullable(_$OrganizationTypeEnumMap, json['companyType']);

Map<String, dynamic> _$OrganizationToJson(Organization instance) =>
    <String, dynamic>{
      'name': instance.name,
      if (instance.abbreviation case final value?) 'abbreviation': value,
      if (instance.currency case final value?) 'currency': value,
      if (instance.country case final value?) 'country': value,
      if (instance.domain case final value?) 'domain': value,
      if (instance.isEnabled case final value?) 'isEnabled': value,
      if (_$OrganizationTypeEnumMap[instance.companyType] case final value?)
        'companyType': value,
    };

const _$OrganizationTypeEnumMap = {
  OrganizationType.company: 'Company',
  OrganizationType.family: 'Family',
  OrganizationType.club: 'Club',
  OrganizationType.nonProfit: 'Non profit',
};
