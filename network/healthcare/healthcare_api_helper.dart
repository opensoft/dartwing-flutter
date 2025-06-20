import 'package:json_annotation/json_annotation.dart';

enum PatientStatus {
  @JsonValue("Active")
  active,
  @JsonValue("Disabled")
  disabled
}

enum InpatientStatus {
  @JsonValue("None")
  none,
  @JsonValue("AdmissionScheduled")
  admissionScheduled,
  @JsonValue("Admitted")
  admitted,
  @JsonValue("DischargeScheduled")
  dischargeScheduled
}

enum PatientReportPreference {
  @JsonValue("None")
  none,
  @JsonValue("Email")
  email,
  @JsonValue("Print")
  print
}

enum BloodGroup {
  @JsonValue("None")
  none,
  @JsonValue("APositive")
  aPositive,
  @JsonValue("ANegative")
  aNegative,
  @JsonValue("ABPositive")
  abPositive,
  @JsonValue("ABNegative")
  abNegative,
  @JsonValue("BPositive")
  bPositive,
  @JsonValue("BNegative")
  bNegative,
  @JsonValue("OPositive")
  oPositive,
  @JsonValue("ONegative")
  oNegative
}
