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
  ..sendWelcomeEmail = json['send_welcome_email'] as String?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'email': instance.email,
  'first_name': ?instance.firstName,
  'middle_name': ?instance.middleName,
  'last_name': ?instance.lastName,
  'send_welcome_email': ?instance.sendWelcomeEmail,
};
