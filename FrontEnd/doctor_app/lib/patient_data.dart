enum Gender { male, female }

enum Priority { low, severe, critical }

class PatientData {
  String? patientName;
  String? villageName;
  String? doctorName;
  DateTime? timestamp;
  int? age;
  Gender? gender;
  Priority? priority;
  Map<String, dynamic>? dentalData;
  String? medicalData;

  void addInfo(PatientInfo info) {
    patientName = info.patientName;
    villageName = info.villageName;
    doctorName = info.doctorName;
    timestamp = info.timestamp;
    age = info.age;
    gender = info.gender;
    priority = info.priority;
  }

  Map<String, dynamic> toJson() {
    return {
      'patientName': patientName,
      'villageName': villageName,
      'doctorName': doctorName,
      'timestamp':
          timestamp?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'age': age,
      'gender': gender.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'dentalData': dentalData,
      'medicalData': medicalData,
    };
  }
}

class PatientInfo {
  late String patientName;
  late String villageName;
  late String doctorName;
  late DateTime timestamp;
  late int age;
  late Gender gender;
  late Priority priority;

  PatientInfo(
      {required this.patientName,
      required this.villageName,
      required this.doctorName,
      required this.timestamp,
      required this.age,
      required this.gender,
      required this.priority});
}
