// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient()
  ..firstName = json['firstName'] as String?
  ..middleName = json['middleName'] as String?
  ..lastName = json['lastName'] as String?
  ..sex = json['sex'] as String?
  ..dateOfBirth = json['dateOfBirth'] as String?
  ..image = json['image'] as String?
  ..status = $enumDecode(_$PatientStatusEnumMap, json['status'])
  ..identificationNumber = json['identificationNumber'] as String?
  ..inpatientRecord = json['inpatientRecord'] as String?
  ..inpatientStatus =
      $enumDecode(_$InpatientStatusEnumMap, json['inpatientStatus'])
  ..reportPreference =
      $enumDecode(_$PatientReportPreferenceEnumMap, json['reportPreference'])
  ..mobile = json['mobile'] as String?
  ..phone = json['phone'] as String?
  ..email = json['email'] as String?
  ..userId = json['userId'] as String?
  ..customer = json['customer'] as String?
  ..customerGroup = json['customerGroup'] as String?
  ..territory = json['territory'] as String?
  ..defaultCurrency = json['defaultCurrency'] as String?
  ..defaultPriceList = json['defaultPriceList'] as String?
  ..language = json['language'] as String?
  ..patientDetails = json['patientDetails'] as String?
  ..bloodGroup = $enumDecode(_$BloodGroupEnumMap, json['bloodGroup']);

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
      if (instance.firstName case final value?) 'firstName': value,
      if (instance.middleName case final value?) 'middleName': value,
      if (instance.lastName case final value?) 'lastName': value,
      if (instance.sex case final value?) 'sex': value,
      if (instance.dateOfBirth case final value?) 'dateOfBirth': value,
      if (instance.image case final value?) 'image': value,
      'status': _$PatientStatusEnumMap[instance.status]!,
      if (instance.identificationNumber case final value?)
        'identificationNumber': value,
      if (instance.inpatientRecord case final value?) 'inpatientRecord': value,
      'inpatientStatus': _$InpatientStatusEnumMap[instance.inpatientStatus]!,
      'reportPreference':
          _$PatientReportPreferenceEnumMap[instance.reportPreference]!,
      if (instance.mobile case final value?) 'mobile': value,
      if (instance.phone case final value?) 'phone': value,
      if (instance.email case final value?) 'email': value,
      if (instance.userId case final value?) 'userId': value,
      if (instance.customer case final value?) 'customer': value,
      if (instance.customerGroup case final value?) 'customerGroup': value,
      if (instance.territory case final value?) 'territory': value,
      if (instance.defaultCurrency case final value?) 'defaultCurrency': value,
      if (instance.defaultPriceList case final value?)
        'defaultPriceList': value,
      if (instance.language case final value?) 'language': value,
      if (instance.patientDetails case final value?) 'patientDetails': value,
      'bloodGroup': _$BloodGroupEnumMap[instance.bloodGroup]!,
    };

const _$PatientStatusEnumMap = {
  PatientStatus.active: 'Active',
  PatientStatus.disabled: 'Disabled',
};

const _$InpatientStatusEnumMap = {
  InpatientStatus.none: 'None',
  InpatientStatus.admissionScheduled: 'AdmissionScheduled',
  InpatientStatus.admitted: 'Admitted',
  InpatientStatus.dischargeScheduled: 'DischargeScheduled',
};

const _$PatientReportPreferenceEnumMap = {
  PatientReportPreference.none: 'None',
  PatientReportPreference.email: 'Email',
  PatientReportPreference.print: 'Print',
};

const _$BloodGroupEnumMap = {
  BloodGroup.none: 'None',
  BloodGroup.aPositive: 'APositive',
  BloodGroup.aNegative: 'ANegative',
  BloodGroup.abPositive: 'ABPositive',
  BloodGroup.abNegative: 'ABNegative',
  BloodGroup.bPositive: 'BPositive',
  BloodGroup.bNegative: 'BNegative',
  BloodGroup.oPositive: 'OPositive',
  BloodGroup.oNegative: 'ONegative',
};
