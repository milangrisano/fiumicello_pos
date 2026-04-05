import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_app/content/content_landing.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/shared/create_account_modal.dart';

import 'package:responsive_app/provider/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/router/app_router.dart';
import 'package:responsive_app/shared/forgot_password_modal.dart';
import 'package:responsive_app/shared/email_verification_modal.dart';
import 'package:responsive_app/shared/new_password_modal.dart';

class LandingPage extends StatefulWidget {
  final String? category;
  const LandingPage({super.key, this.category});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    final success = await AuthProvider.instance.login(
      _emailCtrl.text.trim(),
      _passCtrl.text,
    );

    if (mounted) {
      if (success) {
        final user = AuthProvider.instance.currentUser;
        final isGuest = user?.isGuestUser ?? false;
        context.go(isGuest ? '/guest' : '/sales');
      } else {
        setState(() {
          _loading = false;
          _error = AuthProvider.instance.error ?? LandingStrings.loginError;
        });
      }
    }
  }

  void _openForgotPassword(BuildContext rootContext) {
    showDialog(
      context: rootContext,
      barrierColor: Colors.black54,
      builder: (_) => ForgotPasswordModal(
        onCodeSent: (email) {
          Navigator.of(rootContext).pop();
          showDialog(
            context: rootContext,
            barrierColor: Colors.black54,
            builder: (_) => EmailVerificationModal(
              email: email,
              mode: 'reset',
              onSuccess: () {}, // Not used in reset mode
              onCodeVerified: (code) {
                Navigator.of(rootContext).pop();
                showDialog(
                  context: rootContext,
                  barrierColor: Colors.black54,
                  builder: (_) => NewPasswordModal(
                    email: email,
                    code: code,
                    onSuccess: () {
                      Navigator.of(rootContext).pop();
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
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

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 380,
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
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
                        color: isDark
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Email ──
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface),
                      decoration: _field(context, LandingStrings.emailHint),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return LandingStrings.emailError;
                        }
                        final emailRegex =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
                        if (!emailRegex.hasMatch(v.trim())) {
                          return LandingStrings.invalidEmailError;
                        }
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
                      style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface),
                      decoration:
                          _field(context, LandingStrings.passwordHint).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Theme.of(context).hintColor,
                            size: 18,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? LandingStrings.passwordError
                          : null,
                    ),

                    // ── Error ──
                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _error!,
                        style: AppTextStyles.text(
                          fontSize: 12,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],

                    // ── Forgot Password link ──
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            final BuildContext? rootContext =
                                rootNavigatorKey.currentState?.overlay?.context;
                            if (rootContext != null) {
                              _openForgotPassword(rootContext);
                            }
                          },
                          child: Text(
                            '¿Olvidaste tu contraseña?',
                            style: AppTextStyles.text(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.secondary,
                              decoration: TextDecoration.underline,
                              decorationColor: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Login button ──
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white70))
                            : Text(
                                LandingStrings.btnLogin,
                                style: AppTextStyles.text(
                                  fontSize: 17,
                                  weight: FontWeight.w600,
                                  color: isDark
                                      ? Theme.of(context).colorScheme.tertiary
                                      : Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Create an Account ──
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          // Usamos el overlay del router general para mostrar el modal de registro
                          final BuildContext? rootContext =
                              rootNavigatorKey.currentState?.overlay?.context;
                          if (rootContext == null) return;

                          showDialog(
                            context: rootContext,
                            barrierColor: Colors.black54,
                            builder: (_) => CreateAccountModal(
                              onSuccess: () {
                                final user = AuthProvider.instance.currentUser;
                                final isGuest = user?.isGuestUser ?? false;
                                context.go(isGuest ? '/guest' : '/sales');
                              },
                              onLoginTap: () {
                                Navigator.of(rootContext).pop();
                              },
                            ),
                          );
                        },
                        child: Text(
                          LandingStrings.btnCreateAccount,
                          style: AppTextStyles.text(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.secondary,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                Theme.of(context).colorScheme.secondary,
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
      ),
    );
  }

  InputDecoration _field(BuildContext context, String hint) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(
            fontSize: 14, color: Theme.of(context).hintColor),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary, width: 3),
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
