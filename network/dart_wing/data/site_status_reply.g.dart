// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_status_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SiteStatusReply _$SiteStatusReplyFromJson(Map<String, dynamic> json) =>
    SiteStatusReply()
      ..status = $enumDecode(_$SiteStatusEnumMap, json['status'])
      ..alias = json['companyAlias'] as String? ?? '';

Map<String, dynamic> _$SiteStatusReplyToJson(SiteStatusReply instance) =>
    <String, dynamic>{
      'status': _$SiteStatusEnumMap[instance.status]!,
      'companyAlias': instance.alias,
    };

const _$SiteStatusEnumMap = {
  SiteStatus.none: 'None',
  SiteStatus.inProgress: 'InProgress',
  SiteStatus.finished: 'Finished',
  SiteStatus.failed: 'Failed',
};
