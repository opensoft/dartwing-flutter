import 'package:json_annotation/json_annotation.dart';

part 'barcode_scanner_settings.g.dart';

@JsonSerializable(explicitToJson: true)
class BarcodeScannerSettings {
  String prefix = '=::=';
  String postfix = ':==:';

  BarcodeScannerSettings();

  factory BarcodeScannerSettings.fromJson(Map<String, dynamic> json) =>
      _$BarcodeScannerSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$BarcodeScannerSettingsToJson(this);
}
