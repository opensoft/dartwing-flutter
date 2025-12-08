// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationInfo _$ApplicationInfoFromJson(Map<String, dynamic> json) =>
    ApplicationInfo()
      ..initFinished = json['initFinished'] as bool? ?? false
      ..appId = json['appId'] as String? ?? ''
      ..appName = json['appName'] as String? ?? ''
      ..deviceId = json['deviceId'] as String? ?? ''
      ..version = json['version'] as String? ?? ''
      ..defaultSite = json['defaultSite'] as String? ?? ''
      ..companyAlias = json['companyAlias'] as String? ?? ''
      ..username = json['username'] as String? ?? ''
      ..userEmail = json['userEmail'] as String? ?? ''
      ..barcodeScanner = BarcodeScannerSettings.fromJson(
        json['barcodeScanner'] as Map<String, dynamic>,
      )
      ..papertrailSettings = PapertrailSettings.fromJson(
        json['papertrailSettings'] as Map<String, dynamic>,
      );

Map<String, dynamic> _$ApplicationInfoToJson(ApplicationInfo instance) =>
    <String, dynamic>{
      'initFinished': instance.initFinished,
      'appId': instance.appId,
      'appName': instance.appName,
      'deviceId': instance.deviceId,
      'version': instance.version,
      'defaultSite': instance.defaultSite,
      'companyAlias': instance.companyAlias,
      'username': instance.username,
      'userEmail': instance.userEmail,
      'barcodeScanner': instance.barcodeScanner.toJson(),
      'papertrailSettings': instance.papertrailSettings.toJson(),
    };
