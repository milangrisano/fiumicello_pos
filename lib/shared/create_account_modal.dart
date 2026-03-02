import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_app/configure/app_colors.dart';
import 'package:responsive_app/content/content_landing.dart';
import 'package:responsive_app/configure/app_text_styles.dart';

// ─────────────────────────────────────────
// Create Account Modal
// ─────────────────────────────────────────
class CreateAccountModal extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback onLoginTap;

  const CreateAccountModal({
    super.key, 
    required this.onSuccess,
    required this.onLoginTap,
  });

  @override
  State<CreateAccountModal> createState() => _CreateAccountModalState();
}

class _CreateAccountModalState extends State<CreateAccountModal> {
  final _formKey  = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  
  bool _obscurePass  = true;
  bool _obscureConfirmPass = true;
  bool _loading  = false;
  String? _error;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_passCtrl.text != _confirmPassCtrl.text) {
      if (mounted) setState(() => _error = LandingStrings.confirmPassError);
      return;
    }

    setState(() { _loading = true; _error = null; });
    
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Suponiendo registro exitoso
    widget.onSuccess();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
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
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderLight, width: 1.5),
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
            child: SingleChildScrollView( // Added scrollview for smaller screens
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
              
                  // ── Fiumicello Logo ──
                  Image.asset(
                    'assets/images/logo_fiumicello.png',
                    width: 260,
                    fit: BoxFit.contain,
                  ),
              
              
                  // ── Title ──
                  Text(
                    LandingStrings.createAccountTitle,
                    style: AppTextStyles.text(
                      fontSize: 22,
                      weight: FontWeight.w600,
                      color: AppColors.primaryTextLight,
                    ),
                  ),
                  const SizedBox(height: 24),
              
                  // ── Name ──
                  TextFormField(
                    controller: _nameCtrl,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    style: GoogleFonts.outfit(fontSize: 14, color: AppColors.primaryTextLight),
                    decoration: _field(LandingStrings.nameHint),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Ingresa tu nombre' : null,
                  ),
                  const SizedBox(height: 12),
              
                  // ── Email ──
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: GoogleFonts.outfit(fontSize: 14, color: AppColors.primaryTextLight),
                    decoration: _field(LandingStrings.emailHint),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return LandingStrings.emailError;
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
                      if (!emailRegex.hasMatch(v.trim())) return LandingStrings.invalidEmailError;
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
              
                  // ── Password ──
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscurePass,
                    textInputAction: TextInputAction.next,
                    style: GoogleFonts.outfit(fontSize: 14, color: AppColors.primaryTextLight),
                    decoration: _field(LandingStrings.passwordHint).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.hintLight,
                          size: 18,
                        ),
                        onPressed: () => setState(() => _obscurePass = !_obscurePass),
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? LandingStrings.passwordError : null,
                  ),
                  const SizedBox(height: 12),
              
                  // ── Confirm Password ──
                  TextFormField(
                    controller: _confirmPassCtrl,
                    obscureText: _obscureConfirmPass,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    style: GoogleFonts.outfit(fontSize: 14, color: AppColors.primaryTextLight),
                    decoration: _field(LandingStrings.confirmPassHint).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.hintLight,
                          size: 18,
                        ),
                        onPressed: () => setState(() => _obscureConfirmPass = !_obscureConfirmPass),
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? LandingStrings.passwordError : null,
                  ),
              
                  // ── Error ──
                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _error!,
                      style: AppTextStyles.text(
                        fontSize: 12, color: Colors.red.shade700,
                      ),
                    ),
                  ],
              
                  const SizedBox(height: 20),
              
                  // ── Registrarse button ──
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonGreenLight,
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
                          : Text(
                              LandingStrings.btnRegister,
                              style: AppTextStyles.text(
                                fontSize: 17,
                                weight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
              
                  const SizedBox(height: 16),
              
                  // ── Already have an account? Login ──
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: widget.onLoginTap,
                      child: RichText(
                        text: TextSpan(
                          text: LandingStrings.haveAccountText1,
                          style: AppTextStyles.text(
                            fontSize: 13,
                            color: AppColors.primaryTextLight,
                          ),
                          children: [
                            TextSpan(
                              text: LandingStrings.haveAccountText2,
                              style: AppTextStyles.text(
                                fontSize: 13,
                                color: AppColors.goldLightDark,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.goldLightDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _field(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.outfit(fontSize: 14, color: AppColors.hintLight),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.goldLightDark, width: 2), // Gold, doubled width
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.goldLightDark, width: 3), // Gold, doubled width
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
