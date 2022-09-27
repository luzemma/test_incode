

import 'package:json_annotation/json_annotation.dart';

part 'dto_incode_data.g.dart';

@JsonSerializable()
class DtoIncodeData {
  final String customerId;
  final String token;

  DtoIncodeData({
    required this.customerId,
    required this.token
  });

  factory DtoIncodeData.fromJson(Map<String, dynamic> json) => _$DtoIncodeDataFromJson(json);

  Map<String, dynamic> toJson() => _$DtoIncodeDataToJson(this);

}

