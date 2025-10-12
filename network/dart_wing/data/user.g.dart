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
  ..gender = json['gender'] as String?
  ..companies =
      (json['companies'] as List<dynamic>?)
          ?.map((e) => Organization.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [];

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'firstName': ?instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'phoneNumber': ?instance.phoneNumber,
  'dateOfBirth': ?instance.dateOfBirth,
  'address': ?instance.address,
  'city': ?instance.city,
  'state': ?instance.state,
  'postalCode': ?instance.postalCode,
  'country': ?instance.country,
  'gender': ?instance.gender,
  'companies': instance.companies.map((e) => e.toJson()).toList(),
};
