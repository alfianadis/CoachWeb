// To parse this JSON data, do
//
//     final aspekModel = aspekModelFromJson(jsonString);

import 'dart:convert';

List<AspekModel> aspekModelFromJson(String str) =>
    List<AspekModel>.from(json.decode(str).map((x) => AspekModel.fromJson(x)));

String aspekModelToJson(List<AspekModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AspekModel {
  String id;
  String assessmentAspect;
  int percentage;
  int coreFactor;
  int secondaryFactor;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  AspekModel({
    required this.id,
    required this.assessmentAspect,
    required this.percentage,
    required this.coreFactor,
    required this.secondaryFactor,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory AspekModel.fromJson(Map<String, dynamic> json) => AspekModel(
        id: json["_id"],
        assessmentAspect: json["assessment_aspect"],
        percentage: json["percentage"],
        coreFactor: json["core_factor"],
        secondaryFactor: json["secondary_factor"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "assessment_aspect": assessmentAspect,
        "percentage": percentage,
        "core_factor": coreFactor,
        "secondary_factor": secondaryFactor,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "__v": v,
      };
}
