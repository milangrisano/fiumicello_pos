import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_app/page/sales_page.dart';
import 'package:responsive_app/shared/app_colors.dart';
import 'package:responsive_app/shared/app_text_styles.dart';

// ─────────────────────────────────────────
// Mock data
// ─────────────────────────────────────────
class _MenuCategory {
  final String name;
  const _MenuCategory(this.name);
}

class _MenuItem {
  final String name;
  final String description;
  final String price;
  final String category;
  final Color plateColor;

  const _MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.plateColor,
  });
}

const _categories = [
  _MenuCategory('Antipasti'),
  _MenuCategory('Primi'),
  _MenuCategory('Secondi'),
  _MenuCategory('Contorni'),
  _MenuCategory('Dolci'),
];

const _menuItems = [
  // Primi
  _MenuItem(name: 'Tagliatelle al Tartufo Nero', description: 'Creamy tagliatelle with Parmesan and Parmesan', price: '\$28.00', category: 'Primi', plateColor: Color(0xFFF5DEB3)),
  _MenuItem(name: 'Carbonara Autentica', description: 'Rigatoni coated with a silky egg and pecorino sauce with guanciale', price: '\$24.00', category: 'Primi', plateColor: Color(0xFFFFD700)),
  _MenuItem(name: 'Orecchiette con Cime di Rapa', description: 'Ear-shaped pasta with broccoli rabe, garlic, and chili', price: '\$22.00', category: 'Primi', plateColor: Color(0xFF90EE90)),
  _MenuItem(name: 'Gnocchi alla Sorrentina', description: 'Fluffy potato gnocchi in a vibrant tomato and basil sauce with melting mozzarella', price: '\$26.00', category: 'Primi', plateColor: Color(0xFFFF6347)),
  // Secondi
  _MenuItem(name: 'Osso Buco alla Milanese', description: 'Braised veal shank with gremolata over saffron risotto', price: '\$42.00', category: 'Secondi', plateColor: Color(0xFFFFD700)),
  _MenuItem(name: 'Filetto di Manzo al Barolo', description: 'Tender beef fillet with a red wine reduction and roasted vegetables', price: '\$48.00', category: 'Secondi', plateColor: Color(0xFF8B4513)),
  _MenuItem(name: 'Branzino al Forno', description: 'Whole roasted sea bass with lemon, herbs and cherry tomatoes', price: '\$38.00', category: 'Secondi', plateColor: Color(0xFFE0E0E0)),
  _MenuItem(name: 'Cotoletta alla Bolognese', description: 'Breaded veal cutlet topped with prosciutto and Parmesan crostini', price: '\$36.00', category: 'Secondi', plateColor: Color(0xFFF5DEB3)),
  // Antipasti
  _MenuItem(name: 'Bruschetta al Pomodoro', description: 'Toasted bread with fresh tomatoes, basil and extra-virgin olive oil', price: '\$12.00', category: 'Antipasti', plateColor: Color(0xFFFF6347)),
  _MenuItem(name: 'Carpaccio di Manzo', description: 'Paper-thin beef slices with arugula, capers and Parmesan shavings', price: '\$18.00', category: 'Antipasti', plateColor: Color(0xFFFFB6C1)),
  // Contorni
  _MenuItem(name: 'Patate al Forno', description: 'Oven-roasted potatoes with rosemary and garlic', price: '\$9.00', category: 'Contorni', plateColor: Color(0xFFFFD700)),
  _MenuItem(name: 'Verdure Grigliate', description: 'Grilled seasonal vegetables with extra-virgin olive oil', price: '\$11.00', category: 'Contorni', plateColor: Color(0xFF90EE90)),
  // Dolci
  _MenuItem(name: 'Tiramisù Classico', description: 'Classic espresso-soaked ladyfingers with mascarpone cream', price: '\$10.00', category: 'Dolci', plateColor: Color(0xFF8B4513)),
  _MenuItem(name: 'Panna Cotta al Frutti di Bosco', description: 'Silky vanilla panna cotta with mixed berry coulis', price: '\$9.00', category: 'Dolci', plateColor: Color(0xFFFF69B4)),
];

// ─────────────────────────────────────────
// Landing Page
// ─────────────────────────────────────────
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String _selectedCategory = 'Primi';

  List<_MenuItem> get _filtered =>
      _menuItems.where((m) => m.category == _selectedCategory).toList();

  List<String> get _displayCategories =>
      _categories.map((c) => c.name).toList();

  void _openLoginModal() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => _LoginModal(
        onSuccess: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, animation, __) => const SalesPage(),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: Column(
        children: [
          _Header(onAvatarTap: _openLoginModal),
          _CategoryPills(
            categories: _displayCategories,
            selected: _selectedCategory,
            onSelect: (c) => setState(() => _selectedCategory = c),
          ),
          Expanded(
            child: _ProductGrid(
              category: _selectedCategory,
              items: _filtered,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Header
// ─────────────────────────────────────────
class _Header extends StatelessWidget {
  final VoidCallback onAvatarTap;
  const _Header({required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F0E8),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.person, color: Color(0xFFD4AF37), size: 22),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Fiumicello',
                  style: GoogleFonts.greatVibes(
                    fontSize: 38,
                    color: const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 40, height: 1, color: const Color(0xFF888888)),
                    const SizedBox(width: 8),
                    Text('Est. 2024',
                        style: AppTextStyles.text(fontSize: 10, color: const Color(0xFF888888))),
                    const SizedBox(width: 8),
                    Container(width: 40, height: 1, color: const Color(0xFF888888)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.shopping_cart_outlined, color: Color(0xFFD4AF37), size: 22),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Category Pills
// ─────────────────────────────────────────
class _CategoryPills extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelect;

  const _CategoryPills({
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F0E8),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: categories.map((cat) {
          final isSelected = cat == selected;
          return GestureDetector(
            onTap: () => onSelect(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1A1A1A) : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: const Color(0xFF1A1A1A), width: 1),
              ),
              child: Text(
                cat,
                style: AppTextStyles.text(
                  fontSize: 14,
                  color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Product Grid
// ─────────────────────────────────────────
class _ProductGrid extends StatelessWidget {
  final String category;
  final List<_MenuItem> items;
  const _ProductGrid({required this.category, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            category,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.72,
          ),
          itemCount: items.length,
          itemBuilder: (_, i) => _ProductCard(item: items[i]),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// Product Card
// ─────────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final _MenuItem item;
  const _ProductCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: item.plateColor.withValues(alpha: 0.18),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: Icon(Icons.restaurant, size: 56,
                    color: item.plateColor.withValues(alpha: 0.85)),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.outfit(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      item.description,
                      style: AppTextStyles.text(fontSize: 10, color: const Color(0xFF666666)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.price,
                    style: GoogleFonts.outfit(
                        fontSize: 14, fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A1A),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text('Add to Cart',
                          style: AppTextStyles.text(fontSize: 11, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Login Modal  (diseño del mockup)
// ─────────────────────────────────────────
class _LoginModal extends StatefulWidget {
  final VoidCallback onSuccess;
  const _LoginModal({required this.onSuccess});

  @override
  State<_LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<_LoginModal> {
  final _formKey  = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure  = true;
  bool _loading  = false;
  String? _error;

  static const _validEmail = 'admin';
  static const _validPass  = '1234';

  // Palette
  static const _cream     = Color(0xFFF8F5EC);
  static const _darkGreen = Color(0xFF2D5A27);
  static const _dark      = Color(0xFF1A1A1A);
  static const _hint      = Color(0xFFAAAAAA);
  static const _border    = Color(0xFFD4C5A3);

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    await Future.delayed(const Duration(milliseconds: 600));
    if (_emailCtrl.text.trim() == _validEmail && _passCtrl.text == _validPass) {
      widget.onSuccess();
    } else {
      setState(() { _loading = false; _error = 'Email o contraseña incorrectos.'; });
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Container(
        width: 380,
        decoration: BoxDecoration(
          color: _cream,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _border, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.28),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(36, 38, 36, 32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // ── Fiumicello Logo ──
                Image.asset(
                  'assets/images/logo_fiumicello.png',
                  width: 260,
                  fit: BoxFit.contain,
                ),


                // ── Welcome heading ──
                Text(
                  'Bienvenidos',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Email ──
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.outfit(fontSize: 14, color: _dark),
                  decoration: _field('Email'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Ingresa tu email' : null,
                ),
                const SizedBox(height: 12),

                // ── Password ──
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  style: GoogleFonts.outfit(fontSize: 14, color: _dark),
                  decoration: _field('Password').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: _hint,
                        size: 18,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Ingresa tu contraseña' : null,
                ),

                // ── Error ──
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(_error!,
                      style: GoogleFonts.outfit(
                          fontSize: 12, color: Colors.red.shade700)),
                ],

                const SizedBox(height: 20),

                // ── Login button ──
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _darkGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white70))
                        : Text('Login',
                            style: GoogleFonts.outfit(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Create an Account ──
                GestureDetector(
                  onTap: () { /* TODO: registro */ },
                  child: Text(
                    'Create an Account',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: AppColors.goldLight,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.goldLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _field(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.outfit(fontSize: 14, color: _hint),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.goldLight, width: 2), // Gold, doubled width
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.goldLight, width: 3), // Gold, doubled width
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.red.shade400, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.red.shade600, width: 3),
    ),
    errorStyle: GoogleFonts.outfit(fontSize: 11, color: Colors.red),
  );
}
