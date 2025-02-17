// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_scanner_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarcodeScannerSettings _$BarcodeScannerSettingsFromJson(
        Map<String, dynamic> json) =>
    BarcodeScannerSettings()
      ..prefix = json['prefix'] as String
      ..postfix = json['postfix'] as String;

Map<String, dynamic> _$BarcodeScannerSettingsToJson(
        BarcodeScannerSettings instance) =>
    <String, dynamic>{
      'prefix': instance.prefix,
      'postfix': instance.postfix,
    };
