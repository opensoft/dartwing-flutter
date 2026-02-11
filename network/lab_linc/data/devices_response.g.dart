// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devices_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevicesResponse _$DevicesResponseFromJson(Map<String, dynamic> json) =>
    DevicesResponse()
      ..items = (json['items'] as List<dynamic>)
          .map((e) => DeviceInfo.fromJson(e as Map<String, dynamic>))
          .toList()
      ..totalCount = json['totalCount'] == null
          ? 0
          : _intFromJson(json['totalCount'])
      ..page = json['page'] == null ? 0 : _intFromJson(json['page'])
      ..pageSize = json['pageSize'] == null
          ? 0
          : _intFromJson(json['pageSize']);

Map<String, dynamic> _$DevicesResponseToJson(DevicesResponse instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'totalCount': _intToJson(instance.totalCount),
      'page': _intToJson(instance.page),
      'pageSize': _intToJson(instance.pageSize),
    };
