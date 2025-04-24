// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FolderResponse _$FolderResponseFromJson(Map<String, dynamic> json) =>
    FolderResponse()
      ..folders = (json['folders'] as List<dynamic>?)
          ?.map((e) => Folder.fromJson(e as Map<String, dynamic>))
          .toList()
      ..redirectUrl = json['redirectUrl'] as String?;

Map<String, dynamic> _$FolderResponseToJson(FolderResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('folders', instance.folders?.map((e) => e.toJson()).toList());
  writeNotNull('redirectUrl', instance.redirectUrl);
  return val;
}
