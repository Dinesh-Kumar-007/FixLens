import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() => runApp(const FixLensApp());

const Color ink = Color(0xFF122033);
const Color muted = Color(0xFF728096);
const Color blue = Color(0xFF356DF3);
const Color mint = Color(0xFF42D6B0);
const Color canvas = Color(0xFFF4F7FB);

class FixLensApp extends StatelessWidget {
  const FixLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixLens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: canvas,
        colorScheme: ColorScheme.fromSeed(seedColor: blue),
        fontFamily: 'Arial',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5F7FB),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE6EBF2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: blue, width: 1.5),
          ),
        ),
      ),
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false;
  bool _hidePassword = true;
  bool _accepted = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) return;
    if (!_accepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the demo sign-in notice to continue.')),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => FixLensShell(
          displayName: _register && _name.text.trim().isNotEmpty
              ? _name.text.trim()
              : (_email.text.trim().split('@').first),
          email: _email.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 850;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (wide)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(44),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF101D33), Color(0xFF1A3C64), Color(0xFF245D79)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BrandLogo(light: true),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .08),
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(color: Colors.white.withValues(alpha: .12)),
                        ),
                        child: const Icon(Icons.home_repair_service_rounded, color: mint, size: 76),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Your home.\nBack in good shape.',
                        style: TextStyle(color: Colors.white, fontSize: 42, height: 1.12, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Understand the problem, explore repair options, and keep every fix organised in one place.',
                        style: TextStyle(color: Colors.white.withValues(alpha: .75), fontSize: 16, height: 1.6),
                      ),
                      const SizedBox(height: 30),
                      const Row(
                        children: [
                          _FeatureChip(icon: Icons.center_focus_strong_rounded, label: 'Smart diagnosis'),
                          SizedBox(width: 10),
                          _FeatureChip(icon: Icons.verified_user_outlined, label: 'Trusted repairs'),
                        ],
                      ),
                      const Spacer(),
                      Text('FIXLENS  •  SEE IT. UNDERSTAND IT. FIX IT.', style: TextStyle(color: Colors.white.withValues(alpha: .5), letterSpacing: 1.2, fontSize: 10, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: wide ? 58 : 26, vertical: 30),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!wide) const BrandLogo(),
                          if (!wide) const SizedBox(height: 42),
                          Text(_register ? 'Create your account' : 'Welcome back',
                              style: const TextStyle(fontSize: 31, fontWeight: FontWeight.w800, color: ink, letterSpacing: -.8)),
                          const SizedBox(height: 10),
                          Text(
                            _register ? 'Start taking better care of your home.' : 'Sign in to continue your home-care journey.',
                            style: const TextStyle(color: muted, fontSize: 14, height: 1.5),
                          ),
                          const SizedBox(height: 30),
                          if (_register) ...[
                            const _FieldLabel('Full name'),
                            TextFormField(
                              controller: _name,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(hintText: 'e.g. Dinesh Kumar', prefixIcon: Icon(Icons.person_outline_rounded)),
                              validator: (v) => (v == null || v.trim().length < 2) ? 'Enter your name' : null,
                            ),
                            const SizedBox(height: 17),
                          ],
                          const _FieldLabel('Email address'),
                          TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(hintText: 'you@example.com', prefixIcon: Icon(Icons.mail_outline_rounded)),
                            validator: (v) {
                              final value = v?.trim() ?? '';
                              return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value) ? null : 'Enter a valid email address';
                            },
                          ),
                          const SizedBox(height: 17),
                          const _FieldLabel('Password'),
                          TextFormField(
                            controller: _password,
                            obscureText: _hidePassword,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => _hidePassword = !_hidePassword),
                                icon: Icon(_hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                              ),
                            ),
                            validator: (v) => (v == null || v.length < 6) ? 'Use at least 6 characters' : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Checkbox(
                                value: _accepted,
                                onChanged: (v) => setState(() => _accepted = v ?? false),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              ),
                              const Expanded(
                                child: Text('I understand this is a demo sign-in until a backend is connected.',
                                    style: TextStyle(fontSize: 11, color: muted, height: 1.4)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: FilledButton(
                              onPressed: _continue,
                              style: FilledButton.styleFrom(
                                backgroundColor: blue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_register ? 'Create account' : 'Sign in', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                  const SizedBox(width: 9),
                                  const Icon(Icons.arrow_forward_rounded, size: 19),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(_register ? 'Already have an account? ' : 'New to FixLens? ', style: const TextStyle(color: muted)),
                                TextButton(
                                  onPressed: () => setState(() => _register = !_register),
                                  child: Text(_register ? 'Sign in' : 'Create account', style: const TextStyle(fontWeight: FontWeight.w800)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Center(child: Text('Your home-care companion', style: TextStyle(color: Color(0xFFA0AABB), fontSize: 12))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FixLensShell extends StatefulWidget {
  final String displayName;
  final String email;
  const FixLensShell({super.key, required this.displayName, required this.email});

  @override
  State<FixLensShell> createState() => _FixLensShellState();
}

class _FixLensShellState extends State<FixLensShell> {
  int _selected = 0;
  final List<RepairRecord> _repairs = [
    RepairRecord('Kitchen sink leakage', 'Plumbing', 'Technician assigned', const Color(0xFFFFA33B), Icons.water_drop_rounded),
    RepairRecord('Bedroom light fitting', 'Electrical', 'Completed', const Color(0xFF27B99A), Icons.bolt_rounded),
  ];

  void _addRepair(RepairRecord record) {
    setState(() {
      _repairs.insert(0, record);
      _selected = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(
        name: widget.displayName,
        repairs: _repairs,
        onDiagnose: () => setState(() => _selected = 1),
        onRepairs: () => setState(() => _selected = 2),
      ),
      DiagnosisPage(onCreateRepair: _addRepair),
      RepairsPage(repairs: _repairs),
      ProfilePage(name: widget.displayName, email: widget.email),
    ];
    return Scaffold(
      body: Row(
        children: [
          if (MediaQuery.sizeOf(context).width >= 760)
            _SideNavigation(selected: _selected, onSelect: (i) => setState(() => _selected = i)),
          Expanded(child: SafeArea(child: pages[_selected])),
        ],
      ),
      bottomNavigationBar: MediaQuery.sizeOf(context).width < 760
          ? NavigationBar(
              selectedIndex: _selected,
              onDestinationSelected: (i) => setState(() => _selected = i),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.center_focus_strong_rounded), label: 'Diagnose'),
                NavigationDestination(icon: Icon(Icons.handyman_outlined), label: 'Repairs'),
                NavigationDestination(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
              ],
            )
          : null,
    );
  }
}

class _SideNavigation extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _SideNavigation({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 244,
      padding: const EdgeInsets.fromLTRB(18, 26, 14, 20),
      decoration: const BoxDecoration(color: Colors.white, border: Border(right: BorderSide(color: Color(0xFFE8EDF4)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(left: 8, bottom: 42), child: BrandLogo()),
          const Padding(padding: EdgeInsets.only(left: 10, bottom: 12), child: Text('WORKSPACE', style: TextStyle(color: Color(0xFFA0AABB), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5))),
          _NavItem(icon: Icons.grid_view_rounded, label: 'Overview', active: selected == 0, onTap: () => onSelect(0)),
          _NavItem(icon: Icons.center_focus_strong_rounded, label: 'Smart diagnosis', active: selected == 1, onTap: () => onSelect(1)),
          _NavItem(icon: Icons.handyman_outlined, label: 'My repairs', active: selected == 2, onTap: () => onSelect(2)),
          _NavItem(icon: Icons.person_outline_rounded, label: 'My profile', active: selected == 3, onTap: () => onSelect(3)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF1F6FF), borderRadius: BorderRadius.circular(18)),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.tips_and_updates_outlined, color: blue, size: 25),
              SizedBox(height: 10),
              Text('Home-care tip', style: TextStyle(color: ink, fontWeight: FontWeight.w800)),
              SizedBox(height: 5),
              Text('A small check today can prevent a costly repair tomorrow.', style: TextStyle(color: muted, fontSize: 12, height: 1.5)),
            ]),
          ),
          const SizedBox(height: 18),
          const Text('FIXLENS  •  v1.0', style: TextStyle(color: Color(0xFFA0AABB), fontSize: 10, letterSpacing: 1)),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final String name;
  final List<RepairRecord> repairs;
  final VoidCallback onDiagnose;
  final VoidCallback onRepairs;
  const DashboardPage({super.key, required this.name, required this.repairs, required this.onDiagnose, required this.onRepairs});

  @override
  Widget build(BuildContext context) {
    final firstName = name.trim().isEmpty ? 'there' : name.trim().split(RegExp(r'\s+')).first;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 25, 28, 36),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(child: BrandLogo()),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE8EDF4))),
                    child: const Icon(Icons.notifications_none_rounded, color: ink),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(backgroundColor: const Color(0xFFDDE8FF), child: Text(firstName.isNotEmpty ? firstName[0].toUpperCase() : 'F', style: const TextStyle(color: blue, fontWeight: FontWeight.w800))),
                ],
              ),
              const SizedBox(height: 34),
              Text('Good ${_greeting()}, $firstName 👋', style: const TextStyle(color: muted, fontSize: 14)),
              const SizedBox(height: 8),
              const Text('Let’s make home feel right.', style: TextStyle(fontSize: 30, color: ink, fontWeight: FontWeight.w800, letterSpacing: -.8)),
              const SizedBox(height: 10),
              const Text('Spot a problem, understand your options, and get it sorted.', style: TextStyle(color: muted, height: 1.5)),
              const SizedBox(height: 26),
              _HeroBanner(onDiagnose: onDiagnose),
              const SizedBox(height: 24),
              LayoutBuilder(builder: (context, constraints) {
                final columns = constraints.maxWidth > 850 ? 4 : (constraints.maxWidth > 520 ? 2 : 1);
                final stats = [
                  const _StatData('Total repairs', '02', Icons.home_repair_service_outlined, Color(0xFFEAF0FF), blue),
                  _StatData('In progress', repairs.where((r) => r.status != 'Completed').length.toString().padLeft(2, '0'), Icons.pending_actions_rounded, Color(0xFFFFF3E5), Color(0xFFEA942E)),
                  _StatData('Completed', repairs.where((r) => r.status == 'Completed').length.toString().padLeft(2, '0'), Icons.check_circle_outline_rounded, Color(0xFFE3FAF3), Color(0xFF1FA989)),
                  const _StatData('Saved this year', '₹2.4k', Icons.savings_outlined, Color(0xFFF0E9FF), Color(0xFF8660DB)),
                ];
                return Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: stats.map((s) => SizedBox(
                    width: (constraints.maxWidth - (14 * (columns - 1))) / columns,
                    child: _StatCard(data: s),
                  )).toList(),
                );
              }),
              const SizedBox(height: 32),
              Row(
                children: [
                  const Expanded(child: Text('Recent repairs', style: TextStyle(color: ink, fontSize: 20, fontWeight: FontWeight.w800))),
                  TextButton(onPressed: onRepairs, child: const Text('View all  →')),
                ],
              ),
              const SizedBox(height: 12),
              ...repairs.take(3).map((r) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _RepairTile(record: r))),
              const SizedBox(height: 12),
              const Text('Your home, made simpler', style: TextStyle(color: ink, fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              const Wrap(spacing: 12, runSpacing: 12, children: [
                _MiniFeature(icon: Icons.photo_camera_outlined, title: 'Show the issue', subtitle: 'Start with a photo'),
                _MiniFeature(icon: Icons.lightbulb_outline_rounded, title: 'Understand it', subtitle: 'Explore next steps'),
                _MiniFeature(icon: Icons.event_available_outlined, title: 'Plan a repair', subtitle: 'Keep jobs organised'),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'morning';
    if (h < 17) return 'afternoon';
    return 'evening';
  }
}

class _HeroBanner extends StatelessWidget {
  final VoidCallback onDiagnose;
  const _HeroBanner({required this.onDiagnose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(colors: [Color(0xFF1B3151), Color(0xFF285C83)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: const Color(0xFF214D76).withValues(alpha: .16), blurRadius: 25, offset: const Offset(0, 12))],
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final compact = constraints.maxWidth < 530;
        return Flex(
          direction: compact ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: compact ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: compact ? 0 : 3,
              fit: FlexFit.loose,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7), decoration: BoxDecoration(color: mint.withValues(alpha: .15), borderRadius: BorderRadius.circular(30)), child: const Text('✦  YOUR SMART HOME ASSISTANT', style: TextStyle(color: mint, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1))),
                  const SizedBox(height: 17),
                  const Text('Something not right\nat home?', style: TextStyle(color: Colors.white, fontSize: 27, height: 1.15, fontWeight: FontWeight.w800, letterSpacing: -.5)),
                  const SizedBox(height: 12),
                  Text('Take a photo and get started with a clearer repair plan.', style: TextStyle(color: Colors.white.withValues(alpha: .76), fontSize: 13, height: 1.5)),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: onDiagnose,
                    icon: const Icon(Icons.center_focus_strong_rounded, size: 18),
                    label: const Text('Diagnose a problem'),
                    style: FilledButton.styleFrom(backgroundColor: mint, foregroundColor: const Color(0xFF0B2935), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15)),
                  ),
                ],
              ),
            ),
            if (!compact) const SizedBox(width: 20),
            if (compact) const SizedBox(height: 22),
            Container(
              width: compact ? 100 : 160,
              height: compact ? 100 : 160,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .08), shape: BoxShape.circle, border: Border.all(color: Colors.white.withValues(alpha: .12))),
              child: const Icon(Icons.home_work_outlined, color: mint, size: 75),
            ),
          ],
        );
      }),
    );
  }
}

class DiagnosisPage extends StatefulWidget {
  final ValueChanged<RepairRecord> onCreateRepair;
  const DiagnosisPage({super.key, required this.onCreateRepair});

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  Uint8List? _imageBytes;
  String? _imageName;
  String _category = 'Plumbing';
  final _description = TextEditingController();
  bool _showResult = false;

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFiles = await FilePicker.pickFiles(type: FileType.image);
      if (pickedFiles.isEmpty) return;

      final file = pickedFiles.first;
      final fileBytes = await file.readAsBytes();
      if (fileBytes.isEmpty) {
        if (mounted) _message('Could not read this image. Please choose another file.');
        return;
      }

      setState(() {
        _imageBytes = fileBytes;
        _imageName = file.name;
        _showResult = false;
      });
    } catch (_) {
      if (mounted) _message('Image selection failed. Please try again.');
    }
  }

  void _message(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  void _analyse() {
    if (_imageBytes == null && _description.text.trim().isEmpty) {
      _message('Add a photo or describe the problem first.');
      return;
    }
    setState(() => _showResult = true);
  }

  void _createRepair() {
    widget.onCreateRepair(RepairRecord(
      _description.text.trim().isEmpty ? 'New $_category issue' : _description.text.trim(),
      _category,
      'Ready to book',
      blue,
      _category == 'Electrical' ? Icons.bolt_rounded : _category == 'Plumbing' ? Icons.water_drop_rounded : Icons.home_repair_service_rounded,
    ));
    _message('Demo repair added to My Repairs.');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 26, 28, 36),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _PageHeading(eyebrow: 'FIXLENS INTELLIGENCE', title: 'Smart diagnosis', subtitle: 'Describe what is happening and add a photo to organise the next steps.'),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('01  •  Add a photo', style: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 7),
                    const Text('Choose a clear picture of the area or item that needs attention.', style: TextStyle(color: muted, height: 1.5)),
                    const SizedBox(height: 18),
                    if (_imageBytes == null)
                      InkWell(
                        onTap: _pickImage,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
                          decoration: BoxDecoration(color: const Color(0xFFF7F9FD), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFCBD7EA), style: BorderStyle.solid)),
                          child: const Column(children: [
                            CircleAvatar(radius: 29, backgroundColor: Color(0xFFE7EEFF), child: Icon(Icons.add_a_photo_outlined, color: blue, size: 26)),
                            SizedBox(height: 13),
                            Text('Click to upload an image', style: TextStyle(color: ink, fontWeight: FontWeight.w800)),
                            SizedBox(height: 5),
                            Text('JPG, PNG or another supported image format', style: TextStyle(color: muted, fontSize: 12)),
                          ]),
                        ),
                      )
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              constraints: const BoxConstraints(maxHeight: 340),
                              color: const Color(0xFFF0F3F8),
                              child: Image.memory(_imageBytes!, fit: BoxFit.contain),
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: IconButton.filledTonal(
                                tooltip: 'Remove image',
                                onPressed: () => setState(() { _imageBytes = null; _imageName = null; _showResult = false; }),
                                icon: const Icon(Icons.close_rounded),
                              ),
                            ),
                            Positioned(
                              left: 12,
                              bottom: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(color: Colors.black.withValues(alpha: .65), borderRadius: BorderRadius.circular(10)),
                                child: Text(_imageName ?? 'Selected image', style: const TextStyle(color: Colors.white, fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 26),
                    const Text('02  •  Tell us about it', style: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 16),
                    const _FieldLabel('Problem category'),
                    DropdownButtonFormField<String>(
                      initialValue: _category,
                      decoration: const InputDecoration(prefixIcon: Icon(Icons.category_outlined)),
                      items: const ['Plumbing', 'Electrical', 'Appliance', 'Walls & paint', 'Doors & windows', 'Other']
                          .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                      onChanged: (v) => setState(() => _category = v ?? 'Other'),
                    ),
                    const SizedBox(height: 16),
                    const _FieldLabel('What have you noticed?'),
                    TextFormField(
                      controller: _description,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(hintText: 'For example: water is dripping under the kitchen sink…', alignLabelWithHint: true),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: _analyse,
                        icon: const Icon(Icons.auto_awesome_rounded),
                        label: const Text('Review problem', style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ],
                ),
              ),
              if (_showResult) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: const Color(0xFFEAF9F5), borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFFC9EEE4))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(children: [Icon(Icons.check_circle_rounded, color: Color(0xFF149B7D)), SizedBox(width: 10), Text('Problem details ready', style: TextStyle(color: ink, fontSize: 18, fontWeight: FontWeight.w800))]),
                      const SizedBox(height: 10),
                      const Text('This is a demo review, not an AI diagnosis. Use these details to organise a repair or share them with a qualified technician.', style: TextStyle(color: muted, height: 1.55)),
                      const SizedBox(height: 14),
                      Text('Category: $_category', style: const TextStyle(color: ink, fontWeight: FontWeight.w700)),
                      if (_description.text.trim().isNotEmpty) Text('Description: ${_description.text.trim()}', style: const TextStyle(color: ink, height: 1.5)),
                      const SizedBox(height: 16),
                      FilledButton.icon(onPressed: _createRepair, icon: const Icon(Icons.add_task_rounded), label: const Text('Add to My Repairs')),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class RepairsPage extends StatelessWidget {
  final List<RepairRecord> repairs;
  const RepairsPage({super.key, required this.repairs});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 26, 28, 36),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _PageHeading(eyebrow: 'YOUR HOME, IN GOOD HANDS', title: 'My repairs', subtitle: 'Keep an eye on repair requests and their current status.'),
              const SizedBox(height: 25),
              Row(children: [
                Expanded(child: _StatCard(data: _StatData('All requests', repairs.length.toString().padLeft(2, '0'), Icons.receipt_long_outlined, const Color(0xFFEAF0FF), blue))),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(data: _StatData('Completed', repairs.where((r) => r.status == 'Completed').length.toString().padLeft(2, '0'), Icons.check_circle_outline, const Color(0xFFE3FAF3), const Color(0xFF1FA989)))),
              ]),
              const SizedBox(height: 24),
              if (repairs.isEmpty)
                const _EmptyState(icon: Icons.handyman_outlined, title: 'No repairs yet', subtitle: 'Use Smart diagnosis to add your first repair request.')
              else
                ...repairs.map((r) => Padding(padding: const EdgeInsets.only(bottom: 13), child: _RepairTile(record: r))),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE6EBF2))),
                child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.info_outline_rounded, color: blue),
                  SizedBox(width: 12),
                  Expanded(child: Text('Demo data is kept only in the current app session. Connect your Java Servlet and Oracle backend to save repair requests permanently.', style: TextStyle(color: muted, height: 1.5))),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String name;
  final String email;
  const ProfilePage({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 26, 28, 36),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _PageHeading(eyebrow: 'YOUR SPACE', title: 'My profile', subtitle: 'Your FixLens account details and preferences.'),
              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(colors: [Color(0xFF1A2D49), Color(0xFF2E5D80)]),
                ),
                child: Column(children: [
                  CircleAvatar(radius: 42, backgroundColor: mint, child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'F', style: const TextStyle(color: ink, fontSize: 30, fontWeight: FontWeight.w800))),
                  const SizedBox(height: 15),
                  Text(name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(email, style: TextStyle(color: Colors.white.withValues(alpha: 0.72))),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(color: mint.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(30)),
                    child: const Text('FIXLENS MEMBER', style: TextStyle(color: mint, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.w800)),
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              _ProfileOption(icon: Icons.person_outline_rounded, title: 'Personal information', subtitle: 'Name and email used for this demo'),
              _ProfileOption(icon: Icons.notifications_none_rounded, title: 'Notifications', subtitle: 'Repair status and appointment updates'),
              _ProfileOption(icon: Icons.shield_outlined, title: 'Privacy and security', subtitle: 'Account security settings'),
              _ProfileOption(icon: Icons.help_outline_rounded, title: 'Help and support', subtitle: 'Get help using FixLens'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const AuthPage()), (route) => false),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Sign out'),
                  style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFD34B55), padding: const EdgeInsets.symmetric(vertical: 16), side: const BorderSide(color: Color(0xFFF0D6D9)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RepairRecord {
  final String title;
  final String category;
  final String status;
  final Color color;
  final IconData icon;
  RepairRecord(this.title, this.category, this.status, this.color, this.icon);
}

class BrandLogo extends StatelessWidget {
  final bool light;
  const BrandLogo({super.key, this.light = false});

  @override
  Widget build(BuildContext context) {
    final fg = light ? Colors.white : ink;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(color: light ? Colors.white.withValues(alpha: .12) : blue, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.center_focus_strong_rounded, color: mint, size: 23),
      ),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('FixLens', style: TextStyle(color: fg, fontWeight: FontWeight.w900, fontSize: 21, letterSpacing: -.7)),
        Text('HOME CARE, MADE CLEAR', style: TextStyle(color: light ? Colors.white.withValues(alpha: .55) : muted, fontSize: 8, letterSpacing: 1.25, fontWeight: FontWeight.w800)),
      ]),
    ]);
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: .08), borderRadius: BorderRadius.circular(12)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: mint, size: 15),
      const SizedBox(width: 7),
      Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
    ]),
  );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(color: ink, fontSize: 12, fontWeight: FontWeight.w800)),
  );
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
        decoration: BoxDecoration(color: active ? const Color(0xFFEAF0FF) : Colors.transparent, borderRadius: BorderRadius.circular(13)),
        child: Row(children: [
          Icon(icon, size: 20, color: active ? blue : muted),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: active ? blue : muted, fontWeight: active ? FontWeight.w800 : FontWeight.w600, fontSize: 13)),
        ]),
      ),
    ),
  );
}

class _PageHeading extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  const _PageHeading({required this.eyebrow, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(eyebrow, style: const TextStyle(color: blue, fontSize: 10, letterSpacing: 1.6, fontWeight: FontWeight.w900)),
      const SizedBox(height: 8),
      Text(title, style: const TextStyle(color: ink, fontSize: 30, letterSpacing: -.7, fontWeight: FontWeight.w900)),
      const SizedBox(height: 8),
      Text(subtitle, style: const TextStyle(color: muted, height: 1.55)),
    ],
  );
}

class _StatData {
  final String title;
  final String value;
  final IconData icon;
  final Color background;
  final Color foreground;
  const _StatData(this.title, this.value, this.icon, this.background, this.foreground);
}

class _StatCard extends StatelessWidget {
  final _StatData data;
  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: _cardDecoration(),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 39, height: 39, decoration: BoxDecoration(color: data.background, borderRadius: BorderRadius.circular(12)), child: Icon(data.icon, color: data.foreground, size: 21)),
      const SizedBox(height: 17),
      Text(data.value, style: const TextStyle(color: ink, fontSize: 25, fontWeight: FontWeight.w900, letterSpacing: -.5)),
      const SizedBox(height: 5),
      Text(data.title, style: const TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w600)),
    ]),
  );
}

class _MiniFeature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _MiniFeature({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) => Container(
    width: 220,
    padding: const EdgeInsets.all(17),
    decoration: _cardDecoration(),
    child: Row(children: [
      Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFEAF0FF), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: blue)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 12)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: muted, fontSize: 11)),
      ])),
    ]),
  );
}

class _RepairTile extends StatelessWidget {
  final RepairRecord record;
  const _RepairTile({required this.record});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: _cardDecoration(),
    child: Row(children: [
      Container(width: 48, height: 48, decoration: BoxDecoration(color: record.color.withValues(alpha: .12), borderRadius: BorderRadius.circular(15)), child: Icon(record.icon, color: record.color)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(record.title, style: const TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 14)),
        const SizedBox(height: 5),
        Text(record.category, style: const TextStyle(color: muted, fontSize: 12)),
      ])),
      const SizedBox(width: 8),
      Flexible(child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(color: record.color.withValues(alpha: .12), borderRadius: BorderRadius.circular(30)),
        child: Text(record.status, textAlign: TextAlign.center, style: TextStyle(color: record.color, fontSize: 10, fontWeight: FontWeight.w800)),
      )),
    ]),
  );
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _ProfileOption({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(17),
    decoration: _cardDecoration(),
    child: Row(children: [
      Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFF0F4FA), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: blue)),
      const SizedBox(width: 13),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 13)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: muted, fontSize: 11)),
      ])),
      const Icon(Icons.chevron_right_rounded, color: muted),
    ]),
  );
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _EmptyState({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(34),
    decoration: _cardDecoration(),
    child: Column(children: [
      Icon(icon, size: 42, color: blue),
      const SizedBox(height: 12),
      Text(title, style: const TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w800)),
      const SizedBox(height: 7),
      Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: muted, height: 1.5)),
    ]),
  );
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(20),
  border: Border.all(color: const Color(0xFFE8EDF4)),
  boxShadow: [BoxShadow(color: const Color(0xFF1D3655).withValues(alpha: .025), blurRadius: 16, offset: const Offset(0, 5))],
);
