import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_app/configure/app_colors.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/shared/fiumicello_loading_indicator.dart';
import 'package:responsive_app/provider/auth_provider.dart';

class EmailVerificationModal extends StatefulWidget {
  final String email;
  final VoidCallback onSuccess;

  /// 'register' (default) runs the full verify-code endpoint which marks
  /// the email as verified in the DB.
  /// 'reset' skips the endpoint and passes the code to [onCodeVerified]
  /// so the reset-password endpoint can validate it atomically.
  final String mode;

  /// Only used when [mode] == 'reset'. Receives the raw code entered by the
  /// user so the caller can open the NewPasswordModal with it.
  final void Function(String code)? onCodeVerified;

  const EmailVerificationModal({
    super.key,
    required this.email,
    required this.onSuccess,
    this.mode = 'register',
    this.onCodeVerified,
  });

  @override
  State<EmailVerificationModal> createState() => _EmailVerificationModalState();
}

class _EmailVerificationModalState extends State<EmailVerificationModal> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();

  bool _loading = false;
  String? _error;

  Timer? _countdownTimer;
  int _secondsRemaining = 60; // 1 minute

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Assuming the code is sent automatically when opening this modal from registration
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 60;
      _error = null;
    });

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _resendCode() async {
    if (_secondsRemaining > 0) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    // En modo 'reset' reenviamos el código de recuperación de contraseña.
    // En modo 'register' reenviamos el código de verificación de email.
    final success = widget.mode == 'reset'
        ? await AuthProvider.instance.sendPasswordResetCode(widget.email)
        : await AuthProvider.instance.sendVerificationCode(widget.email);

    if (mounted) {
      setState(() {
        _loading = false;
        if (success) {
          _startTimer();
          // Optional: Show a subtle toast/snackbar for "Code resent"
        } else {
          _error = AuthProvider.instance.error ?? 'Error al reenviar el código';
        }
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    if (widget.mode == 'reset') {
      // In reset mode we don't call verify-code (which marks isEmailVerified).
      // The code will be validated atomically inside reset-password.
      if (mounted) {
        widget.onCodeVerified?.call(_codeCtrl.text.trim());
      }
      return;
    }

    final success = await AuthProvider.instance.verifyEmailCode(
      widget.email,
      _codeCtrl.text.trim(),
    );

    if (mounted) {
      if (success) {
        widget.onSuccess();
      } else {
        setState(() {
          _loading = false;
          _error = AuthProvider.instance.error ?? 'Código inválido o expirado';
        });
      }
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _codeCtrl.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_secondsRemaining / 60).floor().toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                // ── Fiumicello Logo ──
                Image.asset(
                  isDark
                      ? 'assets/images/logo_gold.png'
                      : 'assets/images/logo_fiumicello.png',
                  width: 260,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 24),

                // ── Title ──
                Text(
                  widget.mode == 'reset'
                      ? 'Verificar identidad'
                      : 'Verificar Correo',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.text(
                    fontSize: 22,
                    weight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.primaryTextLight,
                  ),
                ),

                const SizedBox(height: 12),

                // ── Instruction Text ──
                Text(
                  widget.mode == 'reset'
                      ? 'Enviamos un código de recuperación de 6 dígitos a:\n${widget.email}'
                      : 'Hemos enviado un código de 6 dígitos al correo:\n${widget.email}',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.text(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : AppColors.primaryTextLight,
                  ),
                ),

                const SizedBox(height: 24),

                // ── Code Input ──
                TextFormField(
                  controller: _codeCtrl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  onFieldSubmitted: (_) => _submit(),
                  style: GoogleFonts.outfit(
                      fontSize: 24,
                      letterSpacing: 8,
                      fontWeight: FontWeight.bold,
                      color:
                          isDark ? Colors.white : AppColors.primaryTextLight),
                  decoration: InputDecoration(
                    hintText: '000000',
                    hintStyle: GoogleFonts.outfit(
                        fontSize: 24,
                        letterSpacing: 8,
                        color:
                            isDark ? AppColors.hintDark : AppColors.hintLight),
                    filled: true,
                    fillColor: isDark ? AppColors.backgroundDark : Colors.white,
                    counterText: '', // Ocultar contador de maxLength
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: AppColors.goldLightDark, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: AppColors.goldLightDark, width: 3),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: isDark
                              ? AppColors.statusErrorBorderDark
                              : AppColors.statusErrorBorderLight,
                          width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: isDark
                              ? AppColors.statusErrorBorderDark
                              : AppColors.statusErrorBorderLight,
                          width: 3),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().length != 6) {
                      return 'Ingresa los 6 dígitos requeridos';
                    }
                    return null;
                  },
                ),

                // ── Error ──
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.text(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.statusErrorTextDark
                          : AppColors.statusErrorTextLight,
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // ── Verify button ──
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
                            widget.mode == 'reset' ? 'Continuar' : 'Verificar',
                            style: AppTextStyles.text(
                              fontSize: 17,
                              weight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Resend Code Section ──
                if (_secondsRemaining > 0)
                  Text(
                    'Reenviar código en $_formattedTime min.',
                    style: AppTextStyles.text(
                      fontSize: 13,
                      color: isDark ? Colors.white54 : AppColors.hintLight,
                    ),
                  )
                else
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _loading ? null : _resendCode,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          'Reenviar Código',
                          style: AppTextStyles.text(
                            fontSize: 14,
                            color: AppColors.goldLightDark,
                            weight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.goldLightDark,
                          ),
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
}
