// To parse this JSON data, do
//
//     final emosionalModel = emosionalModelFromJson(jsonString);

import 'dart:convert';

List<EmosionalModel> emosionalModelFromJson(String str) =>
    List<EmosionalModel>.from(
        json.decode(str).map((x) => EmosionalModel.fromJson(x)));

String emosionalModelToJson(List<EmosionalModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmosionalModel {
  String id;
  String position;
  String name;
  String assessmentWeek;
  String disciplineScore;
  String motivationScore;
  String leadershipScore;
  String teamworkScore;
  String emotionalControlScore;
  String developmentScore;
  int v;

  EmosionalModel({
    required this.id,
    required this.position,
    required this.name,
    required this.assessmentWeek,
    required this.disciplineScore,
    required this.motivationScore,
    required this.leadershipScore,
    required this.teamworkScore,
    required this.emotionalControlScore,
    required this.developmentScore,
    required this.v,
  });

  factory EmosionalModel.fromJson(Map<String, dynamic> json) => EmosionalModel(
        id: json["_id"],
        position: json["position"],
        name: json["name"],
        assessmentWeek: json["assessmentWeek"],
        disciplineScore: json["disciplineScore"],
        motivationScore: json["motivationScore"],
        leadershipScore: json["leadershipScore"],
        teamworkScore: json["teamworkScore"],
        emotionalControlScore: json["emotionalControlScore"],
        developmentScore: json["developmentScore"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "position": position,
        "name": name,
        "assessmentWeek": assessmentWeek,
        "disciplineScore": disciplineScore,
        "motivationScore": motivationScore,
        "leadershipScore": leadershipScore,
        "teamworkScore": teamworkScore,
        "emotionalControlScore": emotionalControlScore,
        "developmentScore": developmentScore,
        "__v": v,
      };
}
