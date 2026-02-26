import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_app/page/sales_page.dart';
import 'package:responsive_app/shared/app_colors.dart';
import 'package:responsive_app/shared/app_text_styles.dart';

// ─────────────────────────────────────────
// Mock data
// ─────────────────────────────────────────
import 'package:responsive_app/content/content_landing.dart';


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

  List<LandingMenuItem> get _filtered =>
      landingMenuItems.where((m) => m.category == _selectedCategory).toList();

  List<String> get _displayCategories =>
      landingCategories.map((c) => c.name).toList();

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
    return Container(
      color: const Color(0xFFF5F0E8),
      child: Column(
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
  final List<LandingMenuItem> items;
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
  final LandingMenuItem item;
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
                      color: AppColors.goldLightDark,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.goldLightDark,
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
      borderSide: BorderSide(color: AppColors.goldLightDark, width: 2), // Gold, doubled width
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.goldLightDark, width: 3), // Gold, doubled width
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
