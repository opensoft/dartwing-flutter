import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

import 'barcode_scanner_settings.dart';
import 'papertrail_settings.dart';
part 'application_info.g.dart';

@JsonSerializable(explicitToJson: true)
class ApplicationInfo {
  @JsonKey(defaultValue: false)
  bool initFinished = false;
  @JsonKey(defaultValue: '')
  String appId = '';
  @JsonKey(defaultValue: '')
  String appName = '';
  @JsonKey(defaultValue: '')
  String deviceId = '';
  @JsonKey(defaultValue: '')
  String version = '';
  @JsonKey(defaultValue: '')
  String defaultSite = '';
  @JsonKey(defaultValue: '')
  String companyAlias = '';
  @JsonKey(defaultValue: '')
  String username = '';
  @JsonKey(defaultValue: '')
  String userEmail = '';
  @JsonKey(defaultValue: [], includeFromJson: false, includeToJson: false)
  List<Locale> localeList = [const Locale('en'), const Locale('de')];

  BarcodeScannerSettings barcodeScanner = BarcodeScannerSettings();
  PapertrailSettings papertrailSettings = PapertrailSettings();

  ApplicationInfo();

  factory ApplicationInfo.fromJson(Map<String, dynamic> json) =>
      _$ApplicationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationInfoToJson(this);
}
