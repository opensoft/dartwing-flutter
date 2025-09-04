import 'package:json_annotation/json_annotation.dart';

import '../healthcare_api_helper.dart';

part 'patient.g.dart';

@JsonSerializable(explicitToJson: true)
class Patient {
  @JsonKey(name: 'name', defaultValue: '')
  String id = '';
  @JsonKey(includeIfNull: false, defaultValue: '')
  String owner = '';
  @JsonKey(includeIfNull: false, defaultValue: '')
  String creation = '';
  @JsonKey(includeIfNull: false, name: 'first_name', defaultValue: '')
  String firstName = '';
  @JsonKey(includeIfNull: false, name: 'middle_name', defaultValue: '')
  String middleName = '';
  @JsonKey(includeIfNull: false, name: 'last_name', defaultValue: '')
  String lastName = '';
  @JsonKey(includeIfNull: false, name: 'patient_name', defaultValue: '')
  String patientName = '';
  @JsonKey(includeIfNull: false, defaultValue: '')
  String sex = '';
  @JsonKey(includeIfNull: false, defaultValue: '')
  String image = '';
  @JsonKey(includeIfNull: false, defaultValue: PatientStatus.disabled)
  PatientStatus status = PatientStatus.disabled;
  @JsonKey(
    includeIfNull: false,
    name: 'identification_number',
    defaultValue: '',
  )
  String identificationNumber = '';
  @JsonKey(includeIfNull: false, name: 'inpatient_record', defaultValue: '')
  String inpatientRecord = '';
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
  @JsonKey(includeIfNull: false, defaultValue: '')
  String mobile = '';
  @JsonKey(includeIfNull: false, defaultValue: '')
  String phone = '';
  @JsonKey(includeIfNull: false, defaultValue: '')
  String email = '';
  @JsonKey(includeIfNull: false, name: 'user_id', defaultValue: '')
  String userId = '';
  @JsonKey(includeIfNull: false, defaultValue: '')
  String customer = '';
  @JsonKey(includeIfNull: false, defaultValue: '')
  String customerGroup = '';
  @JsonKey(includeIfNull: false, defaultValue: '')
  String territory = '';
  @JsonKey(includeIfNull: false, name: 'default_currency', defaultValue: '')
  String defaultCurrency = '';
  @JsonKey(includeIfNull: false, name: 'default_price_list', defaultValue: '')
  String defaultPriceList = '';
  @JsonKey(includeIfNull: false, defaultValue: '')
  String language = '';
  @JsonKey(includeIfNull: false, name: 'patient_details', defaultValue: '')
  String patientDetails = '';
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
