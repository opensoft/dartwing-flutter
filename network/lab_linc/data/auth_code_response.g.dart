// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_code_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthCodeResponse _$AuthCodeResponseFromJson(Map<String, dynamic> json) =>
    AuthCodeResponse()
      ..code = json['code'] as String
      ..expiresAtUtc = json['expiresAtUtc'] as String
      ..expiresInSeconds = json['expiresInSeconds'] == null
          ? 0
          : _intFromJson(json['expiresInSeconds']);

Map<String, dynamic> _$AuthCodeResponseToJson(AuthCodeResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'expiresAtUtc': instance.expiresAtUtc,
      'expiresInSeconds': _intToJson(instance.expiresInSeconds),
    };
