import 'package:flutter/material.dart';
import 'package:siyasat_ph/screens/verdict_screen.dart';
import 'package:siyasat_ph/services/analysis_service.dart';
import 'package:siyasat_ph/theme/colors.dart';
import '../models/verdict.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controllers read the text field values when Scan is tapped
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _senderController = TextEditingController();

  @override
  void dispose() {
    //to free memory
    _messageController.dispose();
    _senderController.dispose();
    super.dispose();
  }

  Future<void> _onScanTapped() async {
    final String message = _messageController.text.trim();
    if (message.isEmpty) return;

    final String sender = _senderController.text.trim();

    print("Scanning message: $message from: $sender");

    final verdict = await AnalysisService().analyzeMessage(
      message,
      sender,
      // setup: will be passed later when Family Setup is integrated
    );

    final scanResult = verdict.toScanResult(
      originalMessage: message,
      sender: sender,
    );

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerdictScreen(result: scanResult),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        // teal top border line
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            height: 2,
            color:  AppColors.primaryTeal,
          ),
        ),
        title: Row(
          children: [
          Image.asset(
            'assets/images/siyasat_logo.png',
            height: 32, 
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 7),
            const Text(
              'SiyasatPH',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'May Kahina-hinalang mensahe?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ipaste rito para suriin. Walang kailangang internet para rito.',
              style: TextStyle(color: AppColors.midGrey,
              fontSize: 14),
            ),
            const SizedBox(height: 10),

            // --- Message Text Area ---
            TextField(
              controller: _messageController,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
              maxLines: null,
              minLines: 5,
              decoration: InputDecoration(
                hintText: 'I-paste ang mensahe rito',
                hintStyle: const TextStyle(color: AppColors.grey, fontSize: 12, fontWeight:FontWeight(600)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColors.midGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // --- Sender Number ---
            const Text(
              "Numero nang nagpadala (opsyonal)",
              style: TextStyle(color: AppColors.midGrey, fontSize: 14),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _senderController,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '09xxxxxxxx',
                hintStyle: const TextStyle(color: AppColors.grey, fontSize: 12, fontWeight:FontWeight(600)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.midGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // --- SCAN Button ---
            Center(
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: _onScanTapped,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'SURIIN',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            Padding(padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Center( 
              child: Text( 
                'Ang iyong mensahe ay hindi nai-save o inipadala.',
                style: TextStyle(fontSize: 12, color: AppColors.midGrey),
              ),
            ),
            ),

            // --- Instruction Card ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.inputFieldGray,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.inputFieldGray),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'PAANO GAMITIN?',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.midGrey,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('1. Kopyahin ang kahina-hinalang SMS'),
                  SizedBox(height: 2),
                  Text('2. I-paste sa kahon sa itaas'),
                  SizedBox(height: 2),
                  Text('3. Pindutin at Suriin'),
                  SizedBox(height: 2),
                  Text("4. Tingnan kung ligtas ito o hindi"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
