// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'papertrail_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PapertrailSettings _$PapertrailSettingsFromJson(Map<String, dynamic> json) =>
    PapertrailSettings()
      ..host = json['host'] as String
      ..port = (json['port'] as num).toInt();

Map<String, dynamic> _$PapertrailSettingsToJson(PapertrailSettings instance) =>
    <String, dynamic>{
      'host': instance.host,
      'port': instance.port,
    };
