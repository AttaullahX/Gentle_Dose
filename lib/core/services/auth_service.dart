import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');
  CollectionReference<Map<String, dynamic>> get _patients =>
      _firestore.collection('patients');
  CollectionReference<Map<String, dynamic>> get _caregivers =>
      _firestore.collection('caregivers');

  Future<UserCredential?> signUpPatient({
    required String name,
    required String email,
    required String password,
    required String age,
    required String gender,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = cred.user!.uid;
      final patientData = {
        'uid': uid,
        'role': 'patient',
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'age': age.trim(),
        'gender': gender,
        'bloodGroup': '',
        'contactNumber': '',
        'caregiverId': null,
        'caregiver': null,
        'caregiverIds': <String>[],
        'profileComplete': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.runTransaction((tx) async {
        tx.set(_users.doc(uid), patientData);
        tx.set(_patients.doc(uid), patientData);
      });

      return cred;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<UserCredential?> signUpCaregiver({
    required String name,
    required String contactNumber,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = cred.user!.uid;
      final caregiverData = {
        'uid': uid,
        'role': 'caregiver',
        'name': name.trim(),
        'contactNumber': contactNumber.trim(),
        'email': email.trim().toLowerCase(),
        'patientIds': <String>[],
        'patients': <Map<String, dynamic>>[],
        'profileComplete': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.runTransaction((tx) async {
        tx.set(_users.doc(uid), caregiverData);
        tx.set(_caregivers.doc(uid), caregiverData);
      });

      await _linkPendingPatientsToCaregiver(uid, caregiverData);
      return cred;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String name,
  }) {
    return signUpPatient(
      name: name,
      email: email,
      password: password,
      age: '',
      gender: '',
    );
  }

  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> getCurrentUserRole() async {
    final uid = currentUser?.uid;
    if (uid == null) return null;
    final doc = await _users.doc(uid).get();
    return doc.data()?['role'] as String?;
  }

  Future<void> savePatientProfile({
    required String name,
    required String age,
    required String gender,
    required String bloodGroup,
    required String contactNumber,
  }) async {
    final uid = currentUser?.uid;
    if (uid == null) return;

    final data = {
      'name': name.trim(),
      'age': age.trim(),
      'gender': gender,
      'bloodGroup': bloodGroup.trim(),
      'contactNumber': contactNumber.trim(),
      'profileComplete': true,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _firestore.runTransaction((tx) async {
      tx.set(_users.doc(uid), data, SetOptions(merge: true));
      tx.set(_patients.doc(uid), data, SetOptions(merge: true));
    });

    await _syncPatientSummaryToCaregiver(uid);
  }

  Future<Map<String, dynamic>?> getPatientProfile() async {
    final uid = currentUser?.uid;
    if (uid == null) return null;

    final patientDoc = await _patients.doc(uid).get();
    if (patientDoc.exists) return patientDoc.data();

    final userDoc = await _users.doc(uid).get();
    return userDoc.data();
  }

  Future<void> saveCaregiver({
    required String name,
    required String relationship,
    required String contactNumber,
    required String reportFrequency,
    String preferredContactMethod = 'SMS',
    String email = '',
  }) async {
    final uid = currentUser?.uid;
    if (uid == null) return;

    try {
      final caregiverInfo = {
        'name': name.trim(),
        'relationship': relationship,
        'contactNumber': contactNumber.trim(),
        'email': email.trim().toLowerCase(),
        'reportFrequency': reportFrequency,
        'preferredContactMethod': preferredContactMethod,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final currentPatientDoc = await _patients.doc(uid).get();
      final previousCaregiverId = currentPatientDoc.data()?['caregiverId'];
      final matchedCaregiverId = await _findCaregiverId(
        email: email,
        contactNumber: contactNumber,
      );
      final patientSummary = await _buildPatientSummary(uid);

      await _firestore.runTransaction((tx) async {
        if (previousCaregiverId is String &&
            previousCaregiverId.isNotEmpty &&
            previousCaregiverId != matchedCaregiverId) {
          tx.update(_caregivers.doc(previousCaregiverId), {
            'patientIds': FieldValue.arrayRemove([uid]),
            'patients': FieldValue.arrayRemove([patientSummary]),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }

        tx.set(_patients.doc(uid), {
          'caregiver': caregiverInfo,
          'caregiverId': matchedCaregiverId,
          'caregiverIds': matchedCaregiverId == null
              ? <String>[]
              : <String>[matchedCaregiverId],
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        tx.set(_users.doc(uid), {
          'caregiver': caregiverInfo,
          'caregiverId': matchedCaregiverId,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        if (matchedCaregiverId != null) {
          tx.set(_caregivers.doc(matchedCaregiverId), {
            'patientIds': FieldValue.arrayUnion([uid]),
            'patients': FieldValue.arrayUnion([patientSummary]),
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      });
    } on FirebaseException catch (e) {
      throw Exception(_handleFirestoreError(e));
    }
  }

  Future<Map<String, dynamic>?> getCaregiver() async {
    final uid = currentUser?.uid;
    if (uid == null) return null;

    final patientDoc = await _patients.doc(uid).get();
    final caregiver = patientDoc.data()?['caregiver'];
    if (caregiver is Map<String, dynamic>) return caregiver;

    final snap = await _users.doc(uid).collection('caregivers').limit(1).get();
    if (snap.docs.isEmpty) return null;
    return snap.docs.first.data();
  }

  Future<Map<String, dynamic>?> getCaregiverProfile() async {
    final uid = currentUser?.uid;
    if (uid == null) return null;

    final caregiverDoc = await _caregivers.doc(uid).get();
    if (caregiverDoc.exists) return caregiverDoc.data();

    final userDoc = await _users.doc(uid).get();
    return userDoc.data();
  }

  Future<void> saveCaregiverProfile({
    required String name,
    required String contactNumber,
  }) async {
    final uid = currentUser?.uid;
    if (uid == null) return;

    final data = {
      'name': name.trim(),
      'contactNumber': contactNumber.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    try {
      await _firestore.runTransaction((tx) async {
        tx.set(_users.doc(uid), data, SetOptions(merge: true));
        tx.set(_caregivers.doc(uid), data, SetOptions(merge: true));
      });
    } on FirebaseException catch (e) {
      throw Exception(_handleFirestoreError(e));
    }
  }

  Future<List<Map<String, dynamic>>> getCaregiverPatients() async {
    final uid = currentUser?.uid;
    if (uid == null) return [];

    final doc = await _caregivers.doc(uid).get();
    final patients = doc.data()?['patients'];
    if (patients is List) {
      return patients
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return [];
  }

  Stream<List<Map<String, dynamic>>> caregiverPatientsStream() {
    final uid = currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _caregivers.doc(uid).snapshots().map((doc) {
      final patients = doc.data()?['patients'];
      if (patients is List) {
        return patients
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }
      return <Map<String, dynamic>>[];
    });
  }

  Stream<List<Map<String, dynamic>>> medicationHistoryStream([
    String? patientId,
  ]) {
    final uid = patientId ?? currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _patients
        .doc(uid)
        .collection('medicationHistory')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList(),
        );
  }

  Future<void> saveMedicationHistory(Map<String, dynamic> medication) async {
    final uid = currentUser?.uid;
    if (uid == null) return;

    final data = {
      ...medication,
      'patientId': uid,
      'status': medication['status'] ?? 'upcoming',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _patients.doc(uid).collection('medicationHistory').add(data);
    await _syncPatientSummaryToCaregiver(uid);
  }

  Future<void> updateMedicationStatus({
    required String medicationId,
    required String status,
  }) async {
    final uid = currentUser?.uid;
    if (uid == null) return;

    await _patients
        .doc(uid)
        .collection('medicationHistory')
        .doc(medicationId)
        .set({
          'status': status,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
    await _syncPatientSummaryToCaregiver(uid);
  }

  Future<String?> _findCaregiverId({
    required String email,
    required String contactNumber,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPhone = contactNumber.trim();

    if (cleanEmail.isNotEmpty) {
      final byEmail = await _caregivers
          .where('email', isEqualTo: cleanEmail)
          .limit(1)
          .get();
      if (byEmail.docs.isNotEmpty) return byEmail.docs.first.id;
    }

    if (cleanPhone.isNotEmpty) {
      final byPhone = await _caregivers
          .where('contactNumber', isEqualTo: cleanPhone)
          .limit(1)
          .get();
      if (byPhone.docs.isNotEmpty) return byPhone.docs.first.id;
    }

    return null;
  }

  Future<Map<String, dynamic>> _buildPatientSummary(String patientId) async {
    final doc = await _patients.doc(patientId).get();
    final data = doc.data() ?? {};
    final history = await _patients
        .doc(patientId)
        .collection('medicationHistory')
        .get();
    final missed = history.docs
        .where((doc) => doc.data()['status'] == 'missed')
        .length;
    final completed = history.docs
        .where((doc) => doc.data()['status'] == 'completed')
        .length;

    return {
      'patientId': patientId,
      'name': data['name'] ?? '',
      'age': data['age'] ?? '',
      'gender': data['gender'] ?? '',
      'contactNumber': data['contactNumber'] ?? '',
      'totalMedications': history.docs.length,
      'completedMedications': completed,
      'missedMedications': missed,
    };
  }

  Future<void> _syncPatientSummaryToCaregiver(String patientId) async {
    final patientDoc = await _patients.doc(patientId).get();
    final caregiverId = patientDoc.data()?['caregiverId'];
    if (caregiverId is! String || caregiverId.isEmpty) return;

    final caregiverRef = _caregivers.doc(caregiverId);
    final caregiverDoc = await caregiverRef.get();
    final currentPatients = caregiverDoc.data()?['patients'];
    final summary = await _buildPatientSummary(patientId);

    final updatedPatients = currentPatients is List
        ? currentPatients
              .whereType<Map>()
              .where((item) => item['patientId'] != patientId)
              .map((item) => Map<String, dynamic>.from(item))
              .toList()
        : <Map<String, dynamic>>[];
    updatedPatients.add(summary);

    await caregiverRef.set({
      'patientIds': FieldValue.arrayUnion([patientId]),
      'patients': updatedPatients,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _linkPendingPatientsToCaregiver(
    String caregiverId,
    Map<String, dynamic> caregiverData,
  ) async {
    final email = caregiverData['email'] as String? ?? '';
    final phone = caregiverData['contactNumber'] as String? ?? '';
    final pending = await _patients.get();

    for (final patient in pending.docs) {
      final caregiver = patient.data()['caregiver'];
      if (caregiver is! Map) continue;
      final caregiverEmail = (caregiver['email'] ?? '')
          .toString()
          .toLowerCase();
      final caregiverPhone = (caregiver['contactNumber'] ?? '').toString();
      if ((email.isNotEmpty && caregiverEmail == email) ||
          (phone.isNotEmpty && caregiverPhone == phone)) {
        await _patients.doc(patient.id).set({
          'caregiverId': caregiverId,
          'caregiverIds': <String>[caregiverId],
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        await _syncPatientSummaryToCaregiver(patient.id);
      }
    }
  }

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'email-already-in-use':
        return 'This email is already in use.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'The email or password is incorrect.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }

  String _handleFirestoreError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Unable to save caregiver details. Please sign in again and try once more.';
      case 'unavailable':
        return 'Firestore is temporarily unavailable. Please try again.';
      case 'not-found':
        return 'The requested record was not found.';
      default:
        return e.message ?? 'A database error occurred.';
    }
  }
}
