enum Gender { male, female }

enum Priority { low, severe, critical }

class PatientData {
  String? name;
  String? villageName;
  String? doctor;
  DateTime? last_checked;
  int? age;
  Gender? gender;
  Priority? priority;
  Map<String, dynamic>? dental;
  String? medical;

  void addInfo(PatientInfo info) {
    name = info.patientName;
    villageName = info.villageName;
    doctor = info.doctorName;
    last_checked = info.timestamp;
    age = info.age;
    gender = info.gender;
    priority = info.priority;
  }

  Map<String, dynamic> toJson() {
    return {
      'patientName': name,
      'villageName': villageName,
      'doctorName': doctor,
      'timestamp':
          last_checked?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'age': age,
      'gender': gender.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'dentalData': dental,
      'medicalData': medical,
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
