import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

void debug(String msg) {
  if (kDebugMode) {
    print("DEBUG: $msg");
  }
}

CollectionReference getStudentCollection() {
  return FirebaseFirestore.instance.collection("mhs");
}

Future<List<Map<String, dynamic>>> fetchStudents() async {
  try {
    QuerySnapshot snapshot = await getStudentCollection().get();
    return snapshot.docs.map((element) {
      var data = element.data() as Map<String, dynamic>;
      data["id"] = element.id;
      return data;
    }).toList();
  } catch (e) {
    debug("Error fetching students: $e");
    return [];
  }
}

Future<void> addStudent(String nim, String name) async {
  try {
    await getStudentCollection().add({"nim": nim, "nama": name});
    debug("Student added successfully");
  } catch (e) {
    debug("Error adding student: $e");
  }
}

Future<void> updateStudent(String? productId, String nim, String name) async {
  try {
    await getStudentCollection()
        .doc(productId)
        .update({"nim": nim, "nama": name});
    debug("Student updated successfully");
  } catch (e) {
    debug("Error updating student: $e");
  }
}

Future<void> deleteStudent(String productId) async {
  try {
    await getStudentCollection().doc(productId).delete();
    debug("Student deleted successfully");
  } catch (e) {
    debug("Error deleting student: $e");
  }
}
