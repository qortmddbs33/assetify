import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

// g.dart 파일 생성 : dart run build_runner build

@JsonSerializable()
class Pong {
  String message;

  Pong({
    required this.message,
  });

  factory Pong.fromJson(Map<String, dynamic> json) =>
      _$PongFromJson(json);

  Map<String, dynamic> toJson() => _$PongToJson(this);
}