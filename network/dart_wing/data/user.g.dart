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

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('firstName', instance.firstName);
  val['lastName'] = instance.lastName;
  val['email'] = instance.email;
  writeNotNull('phoneNumber', instance.phoneNumber);
  writeNotNull('dateOfBirth', instance.dateOfBirth);
  writeNotNull('address', instance.address);
  writeNotNull('city', instance.city);
  writeNotNull('state', instance.state);
  writeNotNull('postalCode', instance.postalCode);
  writeNotNull('country', instance.country);
  writeNotNull('gender', instance.gender);
  return val;
}
