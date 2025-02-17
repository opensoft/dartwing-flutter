// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..id = json['id'] as String
  ..name = json['name'] as String
  ..email = json['email'] as String
  ..companies = (json['companies'] as List<dynamic>)
      .map((e) => Company.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'companies': instance.companies.map((e) => e.toJson()).toList(),
    };
