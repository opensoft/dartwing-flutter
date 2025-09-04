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

Map<String, dynamic> _$FolderResponseToJson(FolderResponse instance) =>
    <String, dynamic>{
      'folders': ?instance.folders?.map((e) => e.toJson()).toList(),
      'redirectUrl': ?instance.redirectUrl,
    };
