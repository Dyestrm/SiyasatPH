import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../services/family_setup_service.dart';
import '../models/family_setup_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: FamilySetupTestScreen());
  }
}

class FamilySetupTestScreen extends StatefulWidget {
  const FamilySetupTestScreen({super.key});

  @override
  State<FamilySetupTestScreen> createState() => _FamilySetupTestScreenState();
}

class _FamilySetupTestScreenState extends State<FamilySetupTestScreen> {
  final _service = FamilySetupService();

  final _userName = TextEditingController();
  final _notifyName = TextEditingController();
  final _notifyContact = TextEditingController();
  final _elderEmail = TextEditingController();
  final _elderContact = TextEditingController();
  final _elderAddress = TextEditingController();

  String _selectedLanguage = 'fil';
  List<String> _selectedBanks = [];
  List<String> _selectedGovt = [];
  List<String> _selectedTelcos = [];
  String _status = 'No action yet.';
  FamilySetupModel? _loadedSetup;

  final _banks = [
    'BDO',
    'BPI',
    'Metrobank',
    'UnionBank',
    'Landbank',
    'GCash',
    'Maya',
  ];
  final _govts = ['SSS', 'PhilHealth', 'Pag-IBIG', 'GSIS'];
  final _telcos = ['Globe', 'Smart', 'DITO'];

  void _toggleBank(String bank) => setState(
    () => _selectedBanks.contains(bank)
        ? _selectedBanks.remove(bank)
        : _selectedBanks.add(bank),
  );

  void _toggleGovt(String govt) => setState(
    () => _selectedGovt.contains(govt)
        ? _selectedGovt.remove(govt)
        : _selectedGovt.add(govt),
  );

  void _toggleTelco(String telco) => setState(
    () => _selectedTelcos.contains(telco)
        ? _selectedTelcos.remove(telco)
        : _selectedTelcos.add(telco),
  );

  Future<void> _save() async {
    setState(() => _status = 'Saving...');
    try {
      await _service.saveSetup(
        userName: _userName.text,
        selectedBanks: _selectedBanks,
        selectedGovernments: _selectedGovt,
        selectedTelcos: _selectedTelcos,
        language: _selectedLanguage,
        notifyName: _notifyName.text.isEmpty ? null : _notifyName.text,
        notifyContact: _notifyContact.text.isEmpty ? null : _notifyContact.text,
        elderEmail: _elderEmail.text.isEmpty ? null : _elderEmail.text,
        elderContact: _elderContact.text.isEmpty ? null : _elderContact.text,
        elderAddress: _elderAddress.text.isEmpty ? null : _elderAddress.text,
      );
      setState(() => _status = '✅ Saved successfully!');
    } catch (e) {
      setState(() => _status = '❌ Save failed: $e');
    }
  }

  Future<void> _load() async {
    setState(() => _status = 'Loading...');
    final setup = await _service.getSetup();
    setState(() {
      _loadedSetup = setup;
      _status = setup != null
          ? '✅ Loaded: ${setup.userName}'
          : '⚠️ No setup found.';
    });
  }

  Future<void> _deactivate() async {
    setState(() => _status = 'Deactivating...');
    await _service.deactivateSetup();
    setState(() {
      _loadedSetup = null;
      _status = '✅ Setup deactivated.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Family Setup Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STATUS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.grey[200],
              child: Text(_status, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),

            // FORM
            TextField(
              controller: _userName,
              decoration: const InputDecoration(labelText: 'user Name'),
            ),
            TextField(
              controller: _notifyName,
              decoration: const InputDecoration(
                labelText: 'Notify Name (optional)',
              ),
            ),
            TextField(
              controller: _notifyContact,
              decoration: const InputDecoration(
                labelText: 'Notify Contact (optional)',
              ),
            ),
            const Divider(height: 24),
            const Text(
              'Elder Details (for NTC report)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _elderEmail,
              decoration: const InputDecoration(
                labelText: 'Elder Email (optional)',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _elderContact,
              decoration: const InputDecoration(
                labelText: 'Elder Contact (optional)',
              ),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _elderAddress,
              decoration: const InputDecoration(
                labelText: 'Elder Address (optional)',
              ),
            ),
            const SizedBox(height: 12),

            // LANGUAGE
            const Text(
              'Language:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Radio(
                  value: 'fil',
                  groupValue: _selectedLanguage,
                  onChanged: (v) => setState(() => _selectedLanguage = v!),
                ),
                const Text('Filipino'),
                Radio(
                  value: 'en',
                  groupValue: _selectedLanguage,
                  onChanged: (v) => setState(() => _selectedLanguage = v!),
                ),
                const Text('English'),
              ],
            ),
            const SizedBox(height: 12),

            // BANKS
            const Text(
              'Banks / E-Wallets:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: _banks
                  .map(
                    (b) => FilterChip(
                      label: Text(b),
                      selected: _selectedBanks.contains(b),
                      onSelected: (_) => _toggleBank(b),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),

            // GOVERNMENT
            const Text(
              'Government Agencies:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: _govts
                  .map(
                    (g) => FilterChip(
                      label: Text(g),
                      selected: _selectedGovt.contains(g),
                      onSelected: (_) => _toggleGovt(g),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),

            // TELCOS
            const Text(
              'Telcos:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: _telcos
                  .map(
                    (t) => FilterChip(
                      label: Text(t),
                      selected: _selectedTelcos.contains(t),
                      onSelected: (_) => _toggleTelco(t),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),

            // BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _save,
                    child: const Text('Save'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _load,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Load'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _deactivate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Deactivate'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // LOADED DATA
            if (_loadedSetup != null) ...[
              const Text(
                'Loaded Data:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.blue[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('user: ${_loadedSetup!.userName}'),
                    Text('Language: ${_loadedSetup!.language}'),
                    Text('Banks: ${_loadedSetup!.selectedBanks.join(", ")}'),
                    Text(
                      'Govts: ${_loadedSetup!.selectedGovernments.join(", ")}',
                    ),
                    Text('Telcos: ${_loadedSetup!.selectedTelcos.join(", ")}'),
                    Text('Notify Name: ${_loadedSetup!.notifyName ?? "none"}'),
                    Text(
                      'Notify Contact: ${_loadedSetup!.notifyContact ?? "none"}',
                    ),
                    const Divider(),
                    const Text(
                      'Elder Details:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Email: ${_loadedSetup!.elderEmail ?? "none"}'),
                    Text('Contact: ${_loadedSetup!.elderContact ?? "none"}'),
                    Text('Address: ${_loadedSetup!.elderAddress ?? "none"}'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
