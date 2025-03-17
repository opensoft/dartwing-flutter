// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Organization _$OrganizationFromJson(Map<String, dynamic> json) => Organization()
  ..id = json['id'] as String
  ..name = json['name'] as String
  ..type = $enumDecode(_$OrganizationTypeEnumMap, json['type']);

Map<String, dynamic> _$OrganizationToJson(Organization instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$OrganizationTypeEnumMap[instance.type]!,
    };

const _$OrganizationTypeEnumMap = {
  OrganizationType.company: 'company',
  OrganizationType.family: 'family',
  OrganizationType.club: 'club',
  OrganizationType.nonprofit: 'nonprofit',
};
