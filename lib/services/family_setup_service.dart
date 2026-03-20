import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import '../models/family_setup_model.dart';
import '../utils/device_utils.dart';

class FamilySetupService {
  final _db = FirebaseFirestore.instance;
  final _collection = 'FamilySetup';
  final _localKey = 'family_setup';

  // ── LOCAL ───────────────────────────────────────────────────

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

  // ── PUBLIC ──────────────────────────────────────────────────

  Future<void> saveSetup({
    required String configName,
    required List<String> selectedBanks,
    required List<String> selectedGovernments,
    required List<String> selectedTelcos,
    required String language,
    String? notifyName,
    String? notifyContact,
    String? elderEmail,
    String? elderContact,
    String? elderAddress,
  }) async {
    final deviceId = await getOrCreateDeviceId();

    final setup = FamilySetupModel(
      deviceId: deviceId,
      configName: configName,
      selectedBanks: selectedBanks,
      selectedGovernments: selectedGovernments,
      selectedTelcos: selectedTelcos,
      language: language,
      notifyName: notifyName,
      notifyContact: notifyContact,
      elderEmail: elderEmail,
      elderContact: elderContact,
      elderAddress: elderAddress,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _saveLocally(setup);

    try {
      final query = await _db
          .collection(_collection)
          .where('device_id', isEqualTo: deviceId)
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 5));

      if (query.docs.isEmpty) {
        await _db
            .collection(_collection)
            .add(setup.toFirestoreMap())
            .timeout(const Duration(seconds: 5));
      } else {
        await query.docs.first.reference
            .update({
              'config_name': configName,
              'selected_banks': selectedBanks,
              'selected_governments': selectedGovernments,
              'selected_telcos': selectedTelcos,
              'language': language,
              'notify_name': notifyName,
              'notify_contact': notifyContact,
              'elder_email': elderEmail,
              'elder_contact': elderContact,
              'elder_address': elderAddress,
              'updated_at': DateTime.now(),
            })
            .timeout(const Duration(seconds: 5));
      }
    } on TimeoutException catch (_) {
      print('Firestore timed out, saved locally only.');
    } catch (e) {
      print('Firestore sync failed, saved locally only: $e');
    }
  }

  Future<FamilySetupModel?> getSetup() async {
    final local = await _loadLocally();
    if (local != null) return local;

    try {
      final deviceId = await getOrCreateDeviceId();
      final query = await _db
          .collection(_collection)
          .where('device_id', isEqualTo: deviceId)
          .where('is_active', isEqualTo: true)
          .get();

      if (query.docs.isEmpty) return null;

      final setup = FamilySetupModel.fromFirestore(query.docs.first.data());
      await _saveLocally(setup);
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
    await _deleteLocally();

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
