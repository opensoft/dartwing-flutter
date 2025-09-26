import 'package:json_annotation/json_annotation.dart';

import '../healthcare_api_helper.dart';

part 'patient.g.dart';

@JsonSerializable(explicitToJson: true)
class Patient {
  @JsonKey(name: 'name', defaultValue: '')
  String id = '';
  @JsonKey(includeIfNull: false)
  String? owner;
  @JsonKey(includeIfNull: false)
  String? creation;
  @JsonKey(includeIfNull: false, name: 'first_name')
  String? firstName;
  @JsonKey(includeIfNull: false, name: 'middle_name')
  String? middleName;
  @JsonKey(includeIfNull: false, name: 'last_name')
  String? lastName;
  @JsonKey(includeIfNull: false, name: 'patient_name')
  String? patientName;
  @JsonKey(includeIfNull: false)
  String? sex;
  @JsonKey(includeIfNull: false)
  String? image;
  @JsonKey(includeIfNull: false, defaultValue: PatientStatus.disabled)
  PatientStatus status = PatientStatus.disabled;
  @JsonKey(includeIfNull: false, name: 'identification_number')
  String? identificationNumber;
  @JsonKey(includeIfNull: false, name: 'inpatient_record')
  String? inpatientRecord = '';
  /*
  @JsonKey(
    includeIfNull: false,
    name: 'inpatient_status',
    defaultValue: InpatientStatus.none,
  )
  InpatientStatus inpatientStatus = InpatientStatus.none;
  @JsonKey(
    includeIfNull: false,
    name: 'report_preference',
    defaultValue: PatientReportPreference.none,
  )
  PatientReportPreference reportPreference = PatientReportPreference.none;

   */
  @JsonKey(includeIfNull: false)
  String? mobile;
  @JsonKey(includeIfNull: false)
  String? phone;
  @JsonKey(includeIfNull: false)
  String? email;
  @JsonKey(includeIfNull: false, name: 'user_id')
  String? userId;
  @JsonKey(includeIfNull: false)
  String? customer;
  @JsonKey(includeIfNull: false)
  String? customerGroup;
  @JsonKey(includeIfNull: false)
  String? territory;
  @JsonKey(includeIfNull: false, name: 'default_currency')
  String? defaultCurrency;
  @JsonKey(includeIfNull: false, name: 'default_price_lisat')
  String? defaultPriceList;
  @JsonKey(includeIfNull: false)
  String? language;
  @JsonKey(includeIfNull: false, name: 'patient_details')
  String? patientDetails;
  @JsonKey(
    includeIfNull: false,
    name: 'blood_group',
    defaultValue: BloodGroup.none,
  )
  BloodGroup bloodGroup = BloodGroup.none;

  Patient();

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);
  Map<String, dynamic> toJson() => _$PatientToJson(this);
}
