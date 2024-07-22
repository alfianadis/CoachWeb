// To parse this JSON data, do
//
//     final playerModel = playerModelFromJson(jsonString);

import 'dart:convert';

List<PlayerModel> playerModelFromJson(String str) => List<PlayerModel>.from(
    json.decode(str).map((x) => PlayerModel.fromJson(x)));

String playerModelToJson(List<PlayerModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlayerModel {
  String id;
  String name;
  String position;
  int jerseyNumber;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  PlayerModel({
    required this.id,
    required this.name,
    required this.position,
    required this.jerseyNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) => PlayerModel(
        id: json["_id"],
        name: json["name"],
        position: json["position"],
        jerseyNumber: json["jersey_number"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "position": position,
        "jersey_number": jerseyNumber,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "__v": v,
      };
}
