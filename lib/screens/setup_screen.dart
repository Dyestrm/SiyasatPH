import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/bottom_nav.dart';

//data model
class UserProfile {
  final String name;
  final String contactNumber;
  final List<String> banks;

  const UserProfile({
    required this.name,
    required this.contactNumber,
    required this.banks,
  });
}

class FamilyMember {
  final String name;
  final String contactNumber;
  final List<String> banks;

  const FamilyMember({
    required this.name,
    required this.contactNumber,
    required this.banks,
  });
}

//add bank modal
Future<void> _showAddBankDialog(
  BuildContext context,
  List<String> banks,
  VoidCallback onUpdate,
) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    constraints: BoxConstraints(
      minHeight: MediaQuery.of(context).size.height * 0.5,//height of modal
    ),
    builder: (_) => _AddBankSheet(banks: banks, onUpdate: onUpdate),
  );
}

class _AddBankSheet extends StatefulWidget {
  final List<String> banks;
  final VoidCallback onUpdate;

  const _AddBankSheet({required this.banks, required this.onUpdate});

  @override
  State<_AddBankSheet> createState() => _AddBankSheetState();
}

class _AddBankSheetState extends State<_AddBankSheet> {
  final _presets = ['BDO', 'Unionbank','GCash', 
  'PhilHealth', 'BPI', 'Metrobank', 'Maya', 'Landbank', 'PNB', 'SSS', 'GSIS', 'Pag-IBIG'];

  @override
  void dispose() {
    super.dispose();
  }

  void _addBank(String bank) {
    if (!widget.banks.contains(bank)) {
      setState(() => widget.banks.add(bank));
      widget.onUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCCCCCC),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Add Bank/Benefits',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 16),

          //preset chips
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 6, 
            children: _presets.map((bank) {
              final isAdded = widget.banks.contains(bank);
              return GestureDetector(
                onTap: isAdded ? null : () => _addBank(bank),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isAdded ? AppColors.primaryTeal : AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isAdded ? AppColors.primaryTeal : const Color(0xFFDDDDDD),
                    ),
                  ),
                  child: Text(
                    bank,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isAdded ? AppColors.white : AppColors.textColorGray,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

//setup screen
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

// navbar index 2 = setup
class _SetupScreenState extends State<SetupScreen> {
  int _currentIndex = 2;

  UserProfile _profile = const UserProfile(
    name: 'Mary Dawn Alido',
    contactNumber: '+63 123 456 7890',
    banks: ['BDO', 'GCash', 'PhilHealth'],
  );

  List<FamilyMember> _familyMembers = [
      const FamilyMember(
      name: 'Lola Giya',
      contactNumber: '+63 123 456 7890',
      banks: ['BDO', 'GCash', 'PhilHealth'],
    ),
  ];

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  // header
  AppBar _buildAppBar() => AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 56,
        titleSpacing: 30,
        title: const Text(
          'Set-up',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            fontSize: 16,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.primaryTeal),
        ),
      );

  void _openEditProfile() async {
    final updated = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(profile: _profile),
      ),
    );
    if (updated != null) setState(() => _profile = updated);
  }

  void _openAddFamilyMember() async {
    final result = await Navigator.push<FamilyMember>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddFamilyMemberScreen(),
      ),
    );
    if (result != null) setState(() => _familyMembers.add(result));
  }

  void _openEditFamilyMember(int index) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (_) => EditFamilyMemberScreen(member: _familyMembers[index]),
      ),
    );
    if (result == null) return;
    if (result == 'deleted') {
      setState(() => _familyMembers.removeAt(index));
    } else if (result is FamilyMember) {
      setState(() => _familyMembers[index] = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgOffWhite,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //my profile section
              const Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _ProfileCard(
                initials: _initials(_profile.name),
                name: _profile.name,
                contactNumber: _profile.contactNumber,
                onEdit: _openEditProfile,
              ),
              const SizedBox(height: 15),

              //family member section
              const Text(
                'Family Member',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              ..._familyMembers.asMap().entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ProfileCard(
                      initials: _initials(entry.value.name),
                      name: entry.value.name,
                      contactNumber: entry.value.contactNumber,
                      onEdit: () => _openEditFamilyMember(entry.key),
                    ),
                  )),
              const SizedBox(height: 10),

              //add fam member button
              GestureDetector(
                onTap: _openAddFamilyMember,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primaryTeal,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 18, color: AppColors.primaryTeal),
                      SizedBox(width: 6),
                      Text(
                        'Add Family Member',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              //info banner - under add family member section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.lightOrange,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.darkOrange),
                ),
                child: const Text(
                  'Para baguhin ang iyong mga bangko o language, i-tap ang Edit sa iyong profile.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkOrange,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

//profile card widget
class _ProfileCard extends StatelessWidget {
  final String initials;
  final String name;
  final String contactNumber;
  final VoidCallback onEdit;

  const _ProfileCard({
    required this.initials,
    required this.name,
    required this.contactNumber,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF878787)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // initials avatar
          Container(
            width: 40,
            height: 35,
            decoration: BoxDecoration(
              color: AppColors.midTeal,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.darkTeal,
              ),
            ),
          ),
          const SizedBox(width: 18),

          //name and number
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  contactNumber,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textColorGray,
                  ),
                ),
              ],
            ),
          ),

          //edit button
          OutlinedButton(
            onPressed: onEdit,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              side: const BorderSide(color: AppColors.darkOrange),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.darkOrange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//edit profile screen
class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late List<String> _banks;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _contactController = TextEditingController(text: widget.profile.contactNumber);
    _banks = List.from(widget.profile.banks);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  //appbar for edit profile screen
  AppBar _buildAppBar(BuildContext ctx) => AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 60,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () => Navigator.pop(ctx),
            child: const Row(
              children: [
                Icon(Icons.arrow_back, size: 18, color: AppColors.primaryTeal),
                SizedBox(width: 4),
                Text(
                  'Bumalik',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        title: const Text(
          'Edit My Profile',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.black,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.primaryTeal),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal Info',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textColorGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              _InputField(controller: _nameController),

              const SizedBox(height: 16),
              Text(
                'Contact Number',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textColorGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              _InputField(
                controller: _contactController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              const Text(
                'My Banks / Benefits',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textColorGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              _BankChips(
                banks: _banks,
                onAdd: () => _showAddBankDialog(
                  context,
                  _banks,
                  () => setState(() {}),
                ),
                onRemove: (bank) => setState(() => _banks.remove(bank)),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(
                    context,
                    UserProfile(
                      name: _nameController.text,
                      contactNumber: _contactController.text,
                      banks: _banks,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'I-save ang mga pagbabago',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.bgOffWhite,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    side: const BorderSide(color: AppColors.textGrey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Kanselahin',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

//edit family member screen

class EditFamilyMemberScreen extends StatefulWidget {
  final FamilyMember member;

  const EditFamilyMemberScreen({super.key, required this.member});

  @override
  State<EditFamilyMemberScreen> createState() => _EditFamilyMemberScreenState();
}

class _EditFamilyMemberScreenState extends State<EditFamilyMemberScreen> {
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late List<String> _banks;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member.name);
    _contactController = TextEditingController(text: widget.member.contactNumber);
    _banks = List.from(widget.member.banks);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  //appbar for edit family member screen
  AppBar _buildAppBar(BuildContext ctx) => AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 60,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () => Navigator.pop(ctx),
            child: const Row(
              children: [
                Icon(Icons.arrow_back, size: 18, color: AppColors.primaryTeal),
                SizedBox(width: 4),
                Text(
                  'Bumalik',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        title: const Text(
          'Edit Family Member',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.black,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.primaryTeal),
        ),
      );

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal Info',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              _InputField(controller: _nameController),

              const SizedBox(height: 16),
              Text(
                'Contact Number',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textColorGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              _InputField(
                controller: _contactController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              const Text(
                'My Banks / Benefits',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textColorGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              _BankChips(
                banks: _banks,
                onAdd: () => _showAddBankDialog(
                  context,
                  _banks,
                  () => setState(() {}),
                ),
                onRemove: (bank) => setState(() => _banks.remove(bank)),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(
                    context,
                    UserProfile(
                      name: _nameController.text,
                      contactNumber: _contactController.text,
                      banks: _banks,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'I-save ang mga pagbabago',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.bgOffWhite,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    side: const BorderSide(color: AppColors.textGrey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Kanselahin',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, 'deleted'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    side: const BorderSide(color: AppColors.textDarkRed),
                    backgroundColor: AppColors.paleBlush,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Alisin ang family member',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDarkRed,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// add familt member screen

class AddFamilyMemberScreen extends StatefulWidget {
  const AddFamilyMemberScreen({super.key});

  @override
  State<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final List<String> _banks = [];

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

    AppBar _buildAppBar(BuildContext ctx) => AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 60,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () => Navigator.pop(ctx),
            child: const Row(
              children: [
                Icon(Icons.arrow_back, size: 18, color: AppColors.primaryTeal),
                SizedBox(width: 4),
                Text(
                  'Bumalik',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        title: const Text(
          'Add Family Member',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.black,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.primaryTeal),
        ),
      );

// appbar for add family member screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Family Member Info',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textColorGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              _InputField(controller: _nameController),

              const SizedBox(height: 16),
              Text(
                'Contact Number',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textColorGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              _InputField(
                controller: _contactController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              const Text(
                "Family Member's Banks",
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textColorGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              _BankChips(
                banks: _banks,
                onAdd: () => _showAddBankDialog(
                  context,
                  _banks,
                  () => setState(() {}),
                ),
                onRemove: (bank) => setState(() => _banks.remove(bank)),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.trim().isEmpty) return;
                    Navigator.pop(
                      context,
                      FamilyMember(
                        name: _nameController.text.trim(),
                        contactNumber: _contactController.text.trim(),
                        banks: _banks,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'I-save ang mga pagbabago',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    side: const BorderSide(color: AppColors.textGrey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Kanselahin',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// widgets for edit profile and add family member screens

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _InputField({
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 15,
        color: AppColors.black,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: AppColors.bgOffWhite,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryTeal, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
        ),
      ),
    );
  }
}

// bank chips widget used in edit profile and add family member screens
class _BankChips extends StatelessWidget {
  final List<String> banks;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  const _BankChips({
    required this.banks,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...banks.map((bank) => GestureDetector(
              onLongPress: () => onRemove(bank),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      bank,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => onRemove(bank),
                      child: const Icon(Icons.close, size: 14, color: AppColors.white),
                    ),
                  ],
                ),
              ),
            )),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.bgOffWhite,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: const Text(
              '+ Add',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}