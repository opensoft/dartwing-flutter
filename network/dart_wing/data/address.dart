import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable(explicitToJson: true)
class Address {
  @JsonKey(defaultValue: '')
  String name = '';
  @JsonKey(defaultValue: '')
  String street = '';
  @JsonKey(defaultValue: '')
  String city = '';
  @JsonKey(defaultValue: '')
  String state = '';
  @JsonKey(defaultValue: '')
  String postalCode = '';
  @JsonKey(defaultValue: '')
  String country = '';

  Address();

  bool isExist() {
    return street.isNotEmpty &&
        city.isNotEmpty &&
        state.isNotEmpty &&
        postalCode.isNotEmpty &&
        country.isNotEmpty;
  }

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
