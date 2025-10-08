// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient()
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
  ..identificationNumber = json['identification_number'] as String?
  ..inpatientRecord = json['inpatient_record'] as String?
  ..mobile = json['mobile'] as String?
  ..phone = json['phone'] as String?
  ..email = json['email'] as String?
  ..userId = json['user_id'] as String?
  ..customer = json['customer'] as String?
  ..customerGroup = json['customerGroup'] as String?
  ..territory = json['territory'] as String?
  ..defaultCurrency = json['default_currency'] as String?
  ..defaultPriceList = json['default_price_lisat'] as String?
  ..language = json['language'] as String?
  ..patientDetails = json['patient_details'] as String?
  ..bloodGroup =
      $enumDecodeNullable(_$BloodGroupEnumMap, json['blood_group']) ??
      BloodGroup.none;

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
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
  'identification_number': ?instance.identificationNumber,
  'inpatient_record': ?instance.inpatientRecord,
  'mobile': ?instance.mobile,
  'phone': ?instance.phone,
  'email': ?instance.email,
  'user_id': ?instance.userId,
  'customer': ?instance.customer,
  'customerGroup': ?instance.customerGroup,
  'territory': ?instance.territory,
  'default_currency': ?instance.defaultCurrency,
  'default_price_lisat': ?instance.defaultPriceList,
  'language': ?instance.language,
  'patient_details': ?instance.patientDetails,
  'blood_group': _$BloodGroupEnumMap[instance.bloodGroup]!,
};

const _$PatientStatusEnumMap = {
  PatientStatus.active: 'Active',
  PatientStatus.disabled: 'Disabled',
};

const _$BloodGroupEnumMap = {
  BloodGroup.none: '',
  BloodGroup.aPositive: 'A Positive',
  BloodGroup.aNegative: 'A Negative',
  BloodGroup.abPositive: 'AB Positive',
  BloodGroup.abNegative: 'AB Negative',
  BloodGroup.bPositive: 'B Positive',
  BloodGroup.bNegative: 'B Negative',
  BloodGroup.oPositive: 'O Positive',
  BloodGroup.oNegative: 'O Negative',
};
