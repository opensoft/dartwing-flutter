import 'package:json_annotation/json_annotation.dart';

enum Roles { patient, doctor, nurse }

enum PatientStatus {
  @JsonValue("Active")
  active,
  @JsonValue("Disabled")
  disabled,
}

enum InpatientStatus {
  @JsonValue("None")
  none,
  @JsonValue("AdmissionScheduled")
  admissionScheduled,
  @JsonValue("Admitted")
  admitted,
  @JsonValue("DischargeScheduled")
  dischargeScheduled,
}

enum PatientReportPreference {
  @JsonValue("None")
  none,
  @JsonValue("Email")
  email,
  @JsonValue("Print")
  print,
}

enum BloodGroup {
  @JsonValue("")
  none,
  @JsonValue("A Positive")
  aPositive,
  @JsonValue("A Negative")
  aNegative,
  @JsonValue("AB Positive")
  abPositive,
  @JsonValue("AB Negative")
  abNegative,
  @JsonValue("B Positive")
  bPositive,
  @JsonValue("B Negative")
  bNegative,
  @JsonValue("O Positive")
  oPositive,
  @JsonValue("O Negative")
  oNegative,
}
