import 'package:json_annotation/json_annotation.dart';

import '../dart_wing_api_helper.dart';

part 'site_status_reply.g.dart';

@JsonSerializable(explicitToJson: true)
class SiteStatusReply {
  SiteStatus status = SiteStatus.none;
  @JsonKey(defaultValue: '', name: 'companyAlias')
  String alias = '';

  SiteStatusReply();

  factory SiteStatusReply.fromJson(Map<String, dynamic> json) =>
      _$SiteStatusReplyFromJson(json);

  Map<String, dynamic> toJson() => _$SiteStatusReplyToJson(this);
}
