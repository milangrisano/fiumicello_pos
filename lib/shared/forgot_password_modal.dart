import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_app/configure/app_colors.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/shared/fiumicello_loading_indicator.dart';
import 'package:responsive_app/provider/auth_provider.dart';

class ForgotPasswordModal extends StatefulWidget {
  final void Function(String email) onCodeSent;

  const ForgotPasswordModal({super.key, required this.onCodeSent});

  @override
  State<ForgotPasswordModal> createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    // Always succeeds from user's perspective (silent for non-existent emails)
    await AuthProvider.instance.sendPasswordResetCode(_emailCtrl.text.trim());

    if (mounted) {
      // Even if email doesn't exist we proceed silently for security
      widget.onCodeSent(_emailCtrl.text.trim());
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
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
          border: Border.all(
              color: isDark ? const Color(0xFF444444) : AppColors.borderLight,
              width: 1.5),
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
                // ── Logo ──
                Image.asset(
                  isDark
                      ? 'assets/images/logo_gold.png'
                      : 'assets/images/logo_fiumicello.png',
                  width: 260,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 24),

                // ── Icon ──
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.goldLightDark.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    color: AppColors.goldLightDark,
                    size: 28,
                  ),
                ),

                const SizedBox(height: 16),

                // ── Title ──
                Text(
                  '¿Olvidaste tu contraseña?',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.text(
                    fontSize: 20,
                    weight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.primaryTextLight,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Ingresa tu correo y te enviaremos un código para restablecerla.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.text(
                    fontSize: 13,
                    color: isDark ? Colors.white60 : AppColors.hintLight,
                  ),
                ),

                const SizedBox(height: 24),

                // ── Email ──
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: isDark
                          ? Colors.white
                          : AppColors.primaryTextLight),
                  decoration: _field('Tu correo electrónico', isDark),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Ingresa tu correo electrónico';
                    }
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
                    if (!emailRegex.hasMatch(v.trim())) {
                      return 'Ingresa un correo válido';
                    }
                    return null;
                  },
                ),

                // ── Error ──
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.text(
                      fontSize: 12,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // ── Send Button ──
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
                            width: 32,
                            height: 32,
                            child: FiumicelloLoadingIndicator(size: 26))
                        : Text(
                            'Enviar código',
                            style: AppTextStyles.text(
                              fontSize: 17,
                              weight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Back ──
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      'Volver al inicio de sesión',
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

  InputDecoration _field(String hint, bool isDark) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(
            fontSize: 14,
            color: isDark ? AppColors.hintDark : AppColors.hintLight),
        filled: true,
        fillColor: isDark ? AppColors.backgroundDark : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: AppColors.goldLightDark, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: AppColors.goldLightDark, width: 3),
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
