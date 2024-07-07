// To parse this JSON data, do
//
//     final kriteriaModel = kriteriaModelFromJson(jsonString);

import 'dart:convert';

List<KriteriaModel> kriteriaModelFromJson(String str) =>
    List<KriteriaModel>.from(
        json.decode(str).map((x) => KriteriaModel.fromJson(x)));

String kriteriaModelToJson(List<KriteriaModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KriteriaModel {
  String id;
  String posisi;
  String assessmentAspect;
  String criteria;
  String target;
  String criteriaType;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  KriteriaModel({
    required this.id,
    required this.posisi,
    required this.assessmentAspect,
    required this.criteria,
    required this.target,
    required this.criteriaType,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory KriteriaModel.fromJson(Map<String, dynamic> json) => KriteriaModel(
        id: json["_id"],
        posisi: json["posisi"],
        assessmentAspect: json["assessment_aspect"],
        criteria: json["criteria"],
        target: json["target"],
        criteriaType: json["criteria_type"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "posisi": posisi,
        "assessment_aspect": assessmentAspect,
        "criteria": criteria,
        "target": target,
        "criteria_type": criteriaType,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "__v": v,
      };
}
