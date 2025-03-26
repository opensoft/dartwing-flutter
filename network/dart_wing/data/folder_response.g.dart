// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FolderResponse _$FolderResponseFromJson(Map<String, dynamic> json) =>
    FolderResponse()
      ..folders = (json['folders'] as List<dynamic>?)
          ?.map((e) => Map<String, String>.from(e as Map))
          .toList()
      ..redirectUrl = json['redirectUrl'] as String?;

Map<String, dynamic> _$FolderResponseToJson(FolderResponse instance) =>
    <String, dynamic>{
      if (instance.folders case final value?) 'folders': value,
      if (instance.redirectUrl case final value?) 'redirectUrl': value,
    };
