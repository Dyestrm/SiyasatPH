// lib/models/family_setup_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FamilySetupModel {
  final String deviceId;
  final String configName;
  final List<String> selectedBanks;
  final List<String> selectedGovernments;
  final String language;
  final String? notifyName;
  final String? notifyContact;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  FamilySetupModel({
    required this.deviceId,
    required this.configName,
    required this.selectedBanks,
    required this.selectedGovernments,
    required this.language,
    this.notifyName,
    this.notifyContact,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  // For local storage (shared_preferences) - uses ISO string for DateTime
  Map<String, dynamic> toMap() => {
    'device_id': deviceId,
    'config_name': configName,
    'selected_banks': selectedBanks,
    'selected_governments': selectedGovernments,
    'language': language,
    'notify_name': notifyName,
    'notify_contact': notifyContact,
    'is_active': isActive,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  // For Firestore - uses Timestamp instead of ISO string
  Map<String, dynamic> toFirestoreMap() => {
    'device_id': deviceId,
    'config_name': configName,
    'selected_banks': selectedBanks,
    'selected_governments': selectedGovernments,
    'language': language,
    'notify_name': notifyName,
    'notify_contact': notifyContact,
    'is_active': isActive,
    'created_at': Timestamp.fromDate(createdAt),
    'updated_at': Timestamp.fromDate(updatedAt),
  };

  // From local storage (shared_preferences)
  factory FamilySetupModel.fromMap(Map<String, dynamic> map) =>
      FamilySetupModel(
        deviceId: map['device_id'],
        configName: map['config_name'],
        selectedBanks: List<String>.from(map['selected_banks']),
        selectedGovernments: List<String>.from(map['selected_governments']),
        language: map['language'],
        notifyName: map['notify_name'],
        notifyContact: map['notify_contact'],
        isActive: map['is_active'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']),
      );

  // From Firestore
  factory FamilySetupModel.fromFirestore(Map<String, dynamic> map) =>
      FamilySetupModel(
        deviceId: map['device_id'],
        configName: map['config_name'],
        selectedBanks: List<String>.from(map['selected_banks']),
        selectedGovernments: List<String>.from(map['selected_governments']),
        language: map['language'],
        notifyName: map['notify_name'],
        notifyContact: map['notify_contact'],
        isActive: map['is_active'],
        createdAt: (map['created_at'] as Timestamp).toDate(),
        updatedAt: (map['updated_at'] as Timestamp).toDate(),
      );
}
