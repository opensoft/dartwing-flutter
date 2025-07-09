// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address()
  ..street = json['street'] as String? ?? ''
  ..city = json['city'] as String? ?? ''
  ..state = json['state'] as String? ?? ''
  ..postalCode = json['postalCode'] as String? ?? ''
  ..country = json['country'] as String? ?? '';

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'street': instance.street,
  'city': instance.city,
  'state': instance.state,
  'postalCode': instance.postalCode,
  'country': instance.country,
};
