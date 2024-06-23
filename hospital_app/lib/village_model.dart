import 'package:cloud_firestore/cloud_firestore.dart';

class Village {
  final String name;

  Village({
    required this.name,
  });

  factory Village.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Village(
      name: data['name'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
    };
  }
}
