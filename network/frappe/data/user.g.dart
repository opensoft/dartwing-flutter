// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..email = json['email'] as String?
  ..firstName = json['first_name'] as String?
  ..middleName = json['middle_name'] as String?
  ..lastName = json['last_name'] as String?
  ..fullName = json['full_name'] as String?
  ..language = json['language'] as String?
  ..sendWelcomeEmail = (json['send_welcome_email'] as num?)?.toInt()
  ..roles = (json['roles'] as List<dynamic>)
      .map((e) => Role.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'email': instance.email,
  'first_name': ?instance.firstName,
  'middle_name': ?instance.middleName,
  'last_name': ?instance.lastName,
  'full_name': ?instance.fullName,
  'language': instance.language,
  'send_welcome_email': ?instance.sendWelcomeEmail,
  'roles': instance.roles.map((e) => e.toJson()).toList(),
};
