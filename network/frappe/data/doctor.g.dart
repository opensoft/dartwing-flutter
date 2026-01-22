// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Doctor _$DoctorFromJson(Map<String, dynamic> json) => Doctor()
  ..id = json['name'] as String? ?? ''
  ..owner = json['owner'] as String?
  ..creation = json['creation'] as String?
  ..firstName = json['first_name'] as String?
  ..middleName = json['middle_name'] as String?
  ..lastName = json['last_name'] as String?
  ..patientName = json['patient_name'] as String?
  ..sex = json['sex'] as String?
  ..image = json['image'] as String?
  ..status =
      $enumDecodeNullable(_$PatientStatusEnumMap, json['status']) ??
      PatientStatus.active
  ..mobile = json['mobile'] as String?
  ..phone = json['phone'] as String?
  ..email = json['email'] as String?
  ..userId = json['user_id'] as String?
  ..language = json['language'] as String?;

Map<String, dynamic> _$DoctorToJson(Doctor instance) => <String, dynamic>{
  'name': instance.id,
  'owner': ?instance.owner,
  'creation': ?instance.creation,
  'first_name': ?instance.firstName,
  'middle_name': ?instance.middleName,
  'last_name': ?instance.lastName,
  'patient_name': ?instance.patientName,
  'sex': ?instance.sex,
  'image': ?instance.image,
  'status': _$PatientStatusEnumMap[instance.status]!,
  'mobile': ?instance.mobile,
  'phone': ?instance.phone,
  'email': ?instance.email,
  'user_id': ?instance.userId,
  'language': ?instance.language,
};

const _$PatientStatusEnumMap = {
  PatientStatus.active: 'Active',
  PatientStatus.disabled: 'Disabled',
};
