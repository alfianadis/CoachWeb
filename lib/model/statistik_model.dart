// To parse this JSON data, do
//
//     final statistikModel = statistikModelFromJson(jsonString);

import 'dart:convert';

StatistikModel statistikModelFromJson(String str) =>
    StatistikModel.fromJson(json.decode(str));

String statistikModelToJson(StatistikModel data) => json.encode(data.toJson());

class StatistikModel {
  String posisi;
  String playerName;
  Attack attack;
  Defence defence;
  Taktikal taktikal;
  Keeper keeper;
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  StatistikModel({
    required this.posisi,
    required this.playerName,
    required this.attack,
    required this.defence,
    required this.taktikal,
    required this.keeper,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory StatistikModel.fromJson(Map<String, dynamic> json) => StatistikModel(
        posisi: json["posisi"],
        playerName: json["player_name"],
        attack: Attack.fromJson(json["attack"]),
        defence: Defence.fromJson(json["defence"]),
        taktikal: Taktikal.fromJson(json["taktikal"]),
        keeper: Keeper.fromJson(json["keeper"]),
        id: json["_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "posisi": posisi,
        "player_name": playerName,
        "attack": attack.toJson(),
        "defence": defence.toJson(),
        "taktikal": taktikal.toJson(),
        "keeper": keeper.toJson(),
        "_id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class Attack {
  int gol;
  int shooting;
  int acceleration;
  int crossing;

  Attack({
    required this.gol,
    required this.shooting,
    required this.acceleration,
    required this.crossing,
  });

  factory Attack.fromJson(Map<String, dynamic> json) => Attack(
        gol: json["Gol"],
        shooting: json["Shooting"],
        acceleration: json["Acceleration"],
        crossing: json["Crossing"],
      );

  Map<String, dynamic> toJson() => {
        "Gol": gol,
        "Shooting": shooting,
        "Acceleration": acceleration,
        "Crossing": crossing,
      };
}

class Defence {
  int ballControl;
  int bodyBalance;
  int endurance;
  int intersep;

  Defence({
    required this.ballControl,
    required this.bodyBalance,
    required this.endurance,
    required this.intersep,
  });

  factory Defence.fromJson(Map<String, dynamic> json) => Defence(
        ballControl: json["Ball_Control"],
        bodyBalance: json["Body_Balance"],
        endurance: json["Endurance"],
        intersep: json["Intersep"],
      );

  Map<String, dynamic> toJson() => {
        "Ball_Control": ballControl,
        "Body_Balance": bodyBalance,
        "Endurance": endurance,
        "Intersep": intersep,
      };
}

class Keeper {
  int save;
  int refleks;
  int jump;
  int throwing;

  Keeper({
    required this.save,
    required this.refleks,
    required this.jump,
    required this.throwing,
  });

  factory Keeper.fromJson(Map<String, dynamic> json) => Keeper(
        save: json["Save"],
        refleks: json["Refleks"],
        jump: json["Jump"],
        throwing: json["Throwing"],
      );

  Map<String, dynamic> toJson() => {
        "Save": save,
        "Refleks": refleks,
        "Jump": jump,
        "Throwing": throwing,
      };
}

class Taktikal {
  int vision;
  int passing;
  int throughPass;

  Taktikal({
    required this.vision,
    required this.passing,
    required this.throughPass,
  });

  factory Taktikal.fromJson(Map<String, dynamic> json) => Taktikal(
        vision: json["Vision"],
        passing: json["Passing"],
        throughPass: json["Through_Pass"],
      );

  Map<String, dynamic> toJson() => {
        "Vision": vision,
        "Passing": passing,
        "Through_Pass": throughPass,
      };
}
