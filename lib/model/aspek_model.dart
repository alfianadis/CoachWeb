// To parse this JSON data, do
//
//     final aspekModel = aspekModelFromJson(jsonString);

import 'dart:convert';

AspekModel aspekModelFromJson(String str) =>
    AspekModel.fromJson(json.decode(str));

String aspekModelToJson(AspekModel data) => json.encode(data.toJson());

class AspekModel {
  String assessmentAspect;
  int coreFactor;
  int secondaryFactor;
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  AspekModel({
    required this.assessmentAspect,
    required this.coreFactor,
    required this.secondaryFactor,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory AspekModel.fromJson(Map<String, dynamic> json) => AspekModel(
        assessmentAspect: json["assessment_aspect"],
        coreFactor: json["core_factor"],
        secondaryFactor: json["secondary_factor"],
        id: json["_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "assessment_aspect": assessmentAspect,
        "core_factor": coreFactor,
        "secondary_factor": secondaryFactor,
        "_id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "__v": v,
      };
}
