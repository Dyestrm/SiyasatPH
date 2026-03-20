import 'package:cloud_firestore/cloud_firestore.dart';

class FamilySetupModel {
  final String deviceId;
  final String configName;
  final List<String> selectedBanks;
  final List<String> selectedGovernments;
  final List<String> selectedTelcos;
  final String language;
  final String? notifyName;
  final String? notifyContact;
  final String? elderEmail;
  final String? elderContact;
  final String? elderAddress;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  FamilySetupModel({
    required this.deviceId,
    required this.configName,
    required this.selectedBanks,
    required this.selectedGovernments,
    required this.selectedTelcos,
    required this.language,
    this.notifyName,
    this.notifyContact,
    this.elderEmail,
    this.elderContact,
    this.elderAddress,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    'device_id': deviceId,
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
    'is_active': isActive,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  Map<String, dynamic> toFirestoreMap() => {
    'device_id': deviceId,
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
    'is_active': isActive,
    'created_at': Timestamp.fromDate(createdAt),
    'updated_at': Timestamp.fromDate(updatedAt),
  };

  factory FamilySetupModel.fromMap(Map<String, dynamic> map) =>
      FamilySetupModel(
        deviceId: map['device_id'],
        configName: map['config_name'],
        selectedBanks: List<String>.from(map['selected_banks']),
        selectedGovernments: List<String>.from(map['selected_governments']),
        selectedTelcos: List<String>.from(map['selected_telcos'] ?? []),
        language: map['language'],
        notifyName: map['notify_name'],
        notifyContact: map['notify_contact'],
        elderEmail: map['elder_email'],
        elderContact: map['elder_contact'],
        elderAddress: map['elder_address'],
        isActive: map['is_active'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']),
      );

  factory FamilySetupModel.fromFirestore(Map<String, dynamic> map) =>
      FamilySetupModel(
        deviceId: map['device_id'],
        configName: map['config_name'],
        selectedBanks: List<String>.from(map['selected_banks']),
        selectedGovernments: List<String>.from(map['selected_governments']),
        selectedTelcos: List<String>.from(map['selected_telcos'] ?? []),
        language: map['language'],
        notifyName: map['notify_name'],
        notifyContact: map['notify_contact'],
        elderEmail: map['elder_email'],
        elderContact: map['elder_contact'],
        elderAddress: map['elder_address'],
        isActive: map['is_active'],
        createdAt: (map['created_at'] as Timestamp).toDate(),
        updatedAt: (map['updated_at'] as Timestamp).toDate(),
      );
}
