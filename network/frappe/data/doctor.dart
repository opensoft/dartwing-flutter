import 'package:json_annotation/json_annotation.dart';

import '../healthcare_api_helper.dart';

part 'doctor.g.dart';

@JsonSerializable(explicitToJson: true)
class Doctor {
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
  @JsonKey(includeIfNull: false, defaultValue: PatientStatus.active)
  PatientStatus status = PatientStatus.active;

  @JsonKey(includeIfNull: false)
  String? mobile;
  @JsonKey(includeIfNull: false)
  String? phone;
  @JsonKey(includeIfNull: false)
  String? email;
  @JsonKey(includeIfNull: false, name: 'user_id')
  String? userId;
  @JsonKey(includeIfNull: false)
  String? language;

  Doctor();

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorToJson(this);
}
