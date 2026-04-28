import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> saveSetting(String key, dynamic value) async {
    await db.collection('settings').doc(key).set({'value': value, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getSetting(String key) {
    return db.collection('settings').doc(key).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> reportsStream() {
    return db.collection('reports').orderBy('date', descending: true).snapshots();
  }

  Future<void> saveReport(Map<String, dynamic> data) async {
    data['date'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();
    await db.collection('reports').add(data);
  }

  Future<void> saveDraft(Map<String, dynamic> data) async {
    data['draft'] = true;
    await saveReport(data);
  }

  Future<void> saveDocument(Map<String, dynamic> data) async {
    data['date'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();
    await db.collection('documents').add(data);
  }

  Future<String> uploadFile({required File file, required String folder, required String fileName}) async {
    final ref = storage.ref().child('$folder/${DateTime.now().millisecondsSinceEpoch}_$fileName');
    final task = await ref.putFile(file);
    return task.ref.getDownloadURL();
  }

  Future<void> seedInitialData() async {
    await db.collection('settings').doc('appName').set({'value': 'ALMCO Work Tracker'}, SetOptions(merge: true));
    await db.collection('config').doc('activities').set({
      'items': {
        'Waterproof': ['Primer', 'First Coat', 'Second Coat'],
        'Painting': ['Primer', 'First Coat Stucco', 'Second Coat Stucco', 'First Coat Paint', 'Final Paint'],
      }
    }, SetOptions(merge: true));
    await db.collection('config').doc('sites').set({
      'items': [
        {'name': 'Adek', 'locations': ['School 1 / Zone 1','School 1 / Zone 2','School 1 / Zone 3','School 1 / Zone 4','School 1 / Service Block','School 2 / Zone 1','School 2 / Zone 2','School 2 / Zone 3','School 2 / Zone 4','School 2 / Service Block']},
        {'name': 'Grove', 'locations': ['Zone 10','Zone 11']},
        {'name': 'Lagoon Villa', 'locations': ['Cluster / Block / Villa']},
        {'name': 'Khalifa University', 'locations': ['Zone 1','Zone 2','Zone 3','Zone 4','Zone 5']},
        {'name': 'Museum Guggenheim', 'locations': ['General']},
      ]
    }, SetOptions(merge: true));
  }
}
