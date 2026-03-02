import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_app/configure/app_colors.dart';
import 'package:responsive_app/content/content_landing.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/shared/create_account_modal.dart';

class LoginModal extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback? onCreateAccountTap;
  const LoginModal({super.key, required this.onSuccess, this.onCreateAccountTap});

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final _formKey  = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure  = true;
  bool _loading  = false;
  String? _error;

  static const _validEmail = 'admin@admin.com';
  static const _validPass  = '1234';

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    await Future.delayed(const Duration(milliseconds: 600));
    if (_emailCtrl.text.trim() == _validEmail && _passCtrl.text == _validPass) {
      widget.onSuccess();
    } else {
      if (mounted) {
        setState(() { _loading = false; _error = LandingStrings.loginError; });
      }
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Container(
        width: 380,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
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
                  LandingStrings.welcome,
                  style: AppTextStyles.text(
                    fontSize: 22,
                    weight: FontWeight.w600,
                    color: isDark ? AppColors.goldLightDark : AppColors.primaryTextLight,
                  ),
                ),
                const SizedBox(height: 24),

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
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  style: GoogleFonts.outfit(fontSize: 14, color: AppColors.primaryTextLight),
                  decoration: _field(LandingStrings.passwordHint).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.hintLight,
                        size: 18,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
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

                // ── Login button ──
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
                            LandingStrings.btnLogin,
                            style: AppTextStyles.text(
                              fontSize: 17,
                              weight: FontWeight.w600,
                              color: isDark ? AppColors.goldHighlightDark : Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Create an Account ──
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: widget.onCreateAccountTap ?? () {
                      // Usar el contexto de overlay para evitar usar un contexto desmontado tras el pop
                      final BuildContext rootContext = Navigator.of(context).overlay!.context;
                      Navigator.of(context).pop();
                      
                      showDialog(
                        context: rootContext,
                        barrierColor: Colors.black54,
                        builder: (_) => CreateAccountModal(
                          onSuccess: widget.onSuccess,
                          onLoginTap: () {
                             Navigator.of(rootContext).pop();
                             showDialog(
                               context: rootContext,
                               barrierColor: Colors.black54,
                               builder: (_) => LoginModal(onSuccess: widget.onSuccess),
                             );
                          },
                        ),
                      );
                    },
                    child: Text(
                      LandingStrings.btnCreateAccount,
                      style: AppTextStyles.text(
                        fontSize: 13,
                        color: AppColors.goldLightDark,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.goldLightDark,
                      ),
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
