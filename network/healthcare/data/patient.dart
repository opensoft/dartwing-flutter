import 'package:json_annotation/json_annotation.dart';

import '../healthcare_api_helper.dart';

part 'patient.g.dart';

@JsonSerializable(explicitToJson: true)
class Patient {
  @JsonKey(includeIfNull: false)
  String? firstName;
  @JsonKey(includeIfNull: false)
  String? middleName;
  @JsonKey(includeIfNull: false)
  String? lastName;
  @JsonKey(includeIfNull: false)
  String? sex;
  @JsonKey(includeIfNull: false)
  String? dateOfBirth;
  @JsonKey(includeIfNull: false)
  String? image;
  @JsonKey(includeIfNull: false)
  PatientStatus status = PatientStatus.disabled;
  @JsonKey(includeIfNull: false)
  String? identificationNumber;
  @JsonKey(includeIfNull: false)
  String? inpatientRecord;
  InpatientStatus inpatientStatus = InpatientStatus.none;
  PatientReportPreference reportPreference = PatientReportPreference.none;
  @JsonKey(includeIfNull: false)
  String? mobile;
  @JsonKey(includeIfNull: false)
  String? phone;
  @JsonKey(includeIfNull: false)
  String? email;
  @JsonKey(includeIfNull: false)
  String? userId;
  @JsonKey(includeIfNull: false)
  String? customer;
  @JsonKey(includeIfNull: false)
  String? customerGroup;
  @JsonKey(includeIfNull: false)
  String? territory;
  @JsonKey(includeIfNull: false)
  String? defaultCurrency;
  @JsonKey(includeIfNull: false)
  String? defaultPriceList;
  @JsonKey(includeIfNull: false)
  String? language;
  @JsonKey(includeIfNull: false)
  String? patientDetails;
  BloodGroup bloodGroup = BloodGroup.none;

  Patient();

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);
  Map<String, dynamic> toJson() => _$PatientToJson(this);
}
