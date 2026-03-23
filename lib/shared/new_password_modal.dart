import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_app/configure/app_colors.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/shared/fiumicello_loading_indicator.dart';
import 'package:responsive_app/provider/auth_provider.dart';

class NewPasswordModal extends StatefulWidget {
  final String email;
  final String code;
  final VoidCallback onSuccess;

  const NewPasswordModal({
    super.key,
    required this.email,
    required this.code,
    required this.onSuccess,
  });

  @override
  State<NewPasswordModal> createState() => _NewPasswordModalState();
}

class _NewPasswordModalState extends State<NewPasswordModal> {
  final _formKey = GlobalKey<FormState>();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  String? _error;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final success = await AuthProvider.instance.resetPassword(
      widget.email,
      widget.code,
      _passCtrl.text,
    );

    if (mounted) {
      if (success) {
        widget.onSuccess();
      } else {
        setState(() {
          _loading = false;
          _error = AuthProvider.instance.error ??
              'Código inválido o expirado. Reinicia el proceso.';
        });
      }
    }
  }

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
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
                    color: AppColors.buttonGreenLight.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_open_rounded,
                    color: AppColors.buttonGreenLight,
                    size: 28,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Nueva contraseña',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.text(
                    fontSize: 20,
                    weight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.primaryTextLight,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Crea una nueva contraseña segura para tu cuenta.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.text(
                    fontSize: 13,
                    color: isDark ? Colors.white60 : AppColors.hintLight,
                  ),
                ),

                const SizedBox(height: 24),

                // ── Password ──
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscurePass,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: isDark
                          ? Colors.white
                          : AppColors.primaryTextLight),
                  decoration: _field('Nueva contraseña', isDark).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePass
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.hintLight,
                        size: 18,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePass = !_obscurePass),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Ingresa una contraseña';
                    }
                    if (v.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // ── Confirm Password ──
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: isDark
                          ? Colors.white
                          : AppColors.primaryTextLight),
                  decoration:
                      _field('Confirmar contraseña', isDark).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.hintLight,
                        size: 18,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Confirma tu contraseña';
                    }
                    if (v != _passCtrl.text) {
                      return 'Las contraseñas no coinciden';
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
                      color: isDark
                          ? AppColors.statusErrorTextDark
                          : AppColors.statusErrorTextLight,
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // ── Reset Button ──
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
                            'Restablecer contraseña',
                            style: AppTextStyles.text(
                              fontSize: 16,
                              weight: FontWeight.w600,
                              color: Colors.white,
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
