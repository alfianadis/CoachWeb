class AssessmentModel {
  String id;
  String posisi;
  String playerName;
  String aspectName;
  List<Aspect> aspect;
  double finalScore; // Properti ini hanya untuk kalkulasi di sisi klien

  AssessmentModel({
    required this.id,
    required this.posisi,
    required this.playerName,
    required this.aspectName,
    required this.aspect,
    this.finalScore = 0.0, // Inisialisasi properti ini
  });

  factory AssessmentModel.fromJson(Map<String, dynamic> json) =>
      AssessmentModel(
        id: json["_id"],
        posisi: json["posisi"],
        playerName: json["player_name"],
        aspectName: json["aspect_name"],
        aspect:
            List<Aspect>.from(json["aspect"].map((x) => Aspect.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "posisi": posisi,
        "player_name": playerName,
        "aspect_name": aspectName,
        "aspect": List<dynamic>.from(aspect.map((x) => x.toJson())),
      };
}

class Aspect {
  Map<String, String> target;
  Criteria criteria;

  Aspect({
    required this.target,
    required this.criteria,
  });

  factory Aspect.fromJson(Map<String, dynamic> json) => Aspect(
        target: Map<String, String>.from(json["target"]),
        criteria: Criteria.fromJson(json["criteria"]),
      );

  Map<String, dynamic> toJson() => {
        "target": target,
        "criteria": criteria.toJson(),
      };

  double calculateSelisih(String key) {
    int criteriaValue = int.parse(criteria.values[key]!);
    int targetValue = int.parse(target[key]!);
    return (criteriaValue - targetValue).toDouble();
  }

  double getBobotNilai(double selisih) {
    switch (selisih) {
      case 0:
        return 5.0;
      case 1:
        return 4.5;
      case -1:
        return 4.0;
      case 2:
        return 3.5;
      case -2:
        return 3.0;
      case 3:
        return 2.5;
      case -3:
        return 2.0;
      case 4:
        return 1.5;
      case -4:
        return 1.0;
      default:
        return 0.0;
    }
  }

  double calculateScore(
      List<String> coreFactors, List<String> secondaryFactors) {
    double coreScore = 0;
    double secondaryScore = 0;

    for (var factor in coreFactors) {
      double selisih = calculateSelisih(factor);
      coreScore += getBobotNilai(selisih);
    }
    coreScore /= coreFactors.length;

    for (var factor in secondaryFactors) {
      double selisih = calculateSelisih(factor);
      secondaryScore += getBobotNilai(selisih);
    }
    secondaryScore /= secondaryFactors.length;

    return (coreScore * 0.6) + (secondaryScore * 0.4);
  }
}

class Criteria {
  Map<String, String> coreFactor;
  Map<String, String> secondaryFactor;

  Criteria({
    required this.coreFactor,
    required this.secondaryFactor,
  });

  factory Criteria.fromJson(Map<String, dynamic> json) => Criteria(
        coreFactor: Map<String, String>.from(json["core_factor"]),
        secondaryFactor: Map<String, String>.from(json["secondary_factor"]),
      );

  Map<String, dynamic> toJson() => {
        "core_factor": coreFactor,
        "secondary_factor": secondaryFactor,
      };

  Map<String, String> get values => {...coreFactor, ...secondaryFactor};
}
