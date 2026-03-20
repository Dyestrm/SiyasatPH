import 'package:flutter/material.dart';
import 'package:siyasat_ph/theme/colors.dart';

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

  void _onScanTapped() {
    final String message = _messageController.text.trim();
    if (message.isEmpty) return;

    // TODO: Integrate your RulesEngine here
    print("Scanning message: $message from: ${_senderController.text}");

    // nav logic (ensure VerdictScreen is imported)
    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerdictScreen(
          message: message,
          sender: _senderController.text.trim(),
        ),
      ),
    );
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SiyasatColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: SiyasatColors.white,
        elevation: 0,
        // teal top border line
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            height: 2,
            color:  SiyasatColors.primaryTeal,
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
                color: SiyasatColors.black,
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
              style: TextStyle(color: SiyasatColors.midGrey,
              fontSize: 14),
            ),
            const SizedBox(height: 10),

            // --- Message Text Area ---
            TextField(
              controller: _messageController,
              style: const TextStyle(color: SiyasatColors.textGrey, fontSize: 12),
              maxLines: null,
              minLines: 5,
              decoration: InputDecoration(
                hintText: 'I-paste ang mensahe rito',
                hintStyle: const TextStyle(color: SiyasatColors.grey, fontSize: 12, fontWeight:FontWeight(600)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: SiyasatColors.midGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: SiyasatColors.primaryTeal, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // --- Sender Number ---
            const Text(
              "Numero nang nagpadala (opsyonal)",
              style: TextStyle(color: SiyasatColors.midGrey, fontSize: 14),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _senderController,
              style: const TextStyle(color: SiyasatColors.textGrey, fontSize: 12),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '09xxxxxxxx',
                hintStyle: const TextStyle(color: SiyasatColors.grey, fontSize: 12, fontWeight:FontWeight(600)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: SiyasatColors.midGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: SiyasatColors.primaryTeal, width: 2),
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
                    backgroundColor: SiyasatColors.primaryTeal,
                    foregroundColor: SiyasatColors.white,
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
                style: TextStyle(fontSize: 12, color: SiyasatColors.midGrey),
              ),
            ),
            ),

            // --- Instruction Card ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: SiyasatColors.inputFieldGray,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: SiyasatColors.inputFieldGray),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'PAANO GAMITIN?',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: SiyasatColors.midGrey,
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
