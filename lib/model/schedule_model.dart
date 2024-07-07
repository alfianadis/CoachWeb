class ScheduleModel {
  final String id;
  final String activityName;
  final DateTime activityTime;
  final String activityLocation;

  ScheduleModel({
    required this.id,
    required this.activityName,
    required this.activityTime,
    required this.activityLocation,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['_id'],
      activityName: json['activity_name'],
      activityTime: DateTime.parse(json['activity_time']),
      activityLocation: json['activity_location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity_name': activityName,
      'activity_time': activityTime.toIso8601String(),
      'activity_location': activityLocation,
    };
  }
}
