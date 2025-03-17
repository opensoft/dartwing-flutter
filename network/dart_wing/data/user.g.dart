// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..firstName = json['firstName'] as String?
  ..lastName = json['lastName'] as String?
  ..email = json['email'] as String
  ..phoneNumber = json['phoneNumber'] as String?
  ..dateOfBirth = json['dateOfBirth'] as String?
  ..address = json['address'] as String?
  ..city = json['city'] as String?
  ..state = json['state'] as String?
  ..postalCode = json['postalCode'] as String?
  ..country = json['country'] as String?
  ..gender = json['gender'] as String?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      if (instance.firstName case final value?) 'firstName': value,
      'lastName': instance.lastName,
      'email': instance.email,
      if (instance.phoneNumber case final value?) 'phoneNumber': value,
      if (instance.dateOfBirth case final value?) 'dateOfBirth': value,
      if (instance.address case final value?) 'address': value,
      if (instance.city case final value?) 'city': value,
      if (instance.state case final value?) 'state': value,
      if (instance.postalCode case final value?) 'postalCode': value,
      if (instance.country case final value?) 'country': value,
      if (instance.gender case final value?) 'gender': value,
    };
