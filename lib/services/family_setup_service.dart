import 'package:siyasat_ph/models/family_setup_model.dart';
import 'package:siyasat_ph/utils/device_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FamilySetupService {
  final _db = FirebaseFirestore.instance;
  final _collection = 'FamilySetup';
  final _localKey = 'family_setup';

  // Local Storage ──────────────────────────────────────────

  Future<void> _saveLocally(FamilySetupModel setup) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localKey, jsonEncode(setup.toMap()));
  }

  Future<FamilySetupModel?> _loadLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_localKey);
    if (raw == null) return null;
    return FamilySetupModel.fromMap(jsonDecode(raw));
  }

  Future<void> _deleteLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localKey);
  }

  // Public Methods ─────────────────────────────────────────

  Future<void> saveSetup({
    required String configName,
    required List<String> selectedBanks,
    required List<String> selectedGovernments,
    required String language,
    String? notifyName,
    String? notifyContact,
  }) async {
    final deviceId = await getOrCreateDeviceId();

    final setup = FamilySetupModel(
      deviceId: deviceId,
      configName: configName,
      selectedBanks: selectedBanks,
      selectedGovernments: selectedGovernments,
      language: language,
      notifyName: notifyName,
      notifyContact: notifyContact,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // save locally first (works offline)
    await _saveLocally(setup);

    // sync to Firestore (for notifications)
    try {
      final query = await _db
          .collection(_collection)
          .where('device_id', isEqualTo: deviceId)
          .get();

      if (query.docs.isEmpty) {
        // first time - create
        await _db.collection(_collection).add(setup.toFirestoreMap());
      } else {
        // already exists - update
        await query.docs.first.reference.update({
          'config_name': configName,
          'selected_banks': selectedBanks,
          'selected_governments': selectedGovernments,
          'language': language,
          'notify_name': notifyName,
          'notify_contact': notifyContact,
          'updated_at': DateTime.now(),
        });
      }
    } catch (e) {
      // no internet - local save already done
      print('Firestore sync failed, saved locally only: $e');
    }
  }

  Future<FamilySetupModel?> getSetup() async {
    // local first (works offline)
    final local = await _loadLocally();
    if (local != null) return local;

    // fallback to Firestore if no local data
    try {
      final deviceId = await getOrCreateDeviceId();
      final query = await _db
          .collection(_collection)
          .where('device_id', isEqualTo: deviceId)
          .where('is_active', isEqualTo: true)
          .get();

      if (query.docs.isEmpty) return null;

      final setup = FamilySetupModel.fromFirestore(query.docs.first.data());
      await _saveLocally(setup); // cache locally for next time
      return setup;
    } catch (e) {
      return null;
    }
  }

  Future<bool> hasSetup() async {
    final setup = await getSetup();
    return setup != null;
  }

  Future<void> deactivateSetup() async {
    // clear local first
    await _deleteLocally();

    // soft delete in Firestore
    try {
      final deviceId = await getOrCreateDeviceId();
      final query = await _db
          .collection(_collection)
          .where('device_id', isEqualTo: deviceId)
          .get();

      for (var doc in query.docs) {
        await doc.reference.update({'is_active': false});
      }
    } catch (e) {
      print('Firestore deactivate failed: $e');
    }
  }
}
