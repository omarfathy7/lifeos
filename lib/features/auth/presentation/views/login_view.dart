import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_os/core/theme/app_colors.dart';
import 'package:life_os/core/router/app_router.dart';
import 'package:life_os/core/utils/app_validators.dart';
import 'package:life_os/core/utils/localization_extension.dart';
import 'package:life_os/core/services/auth_service.dart';
import 'package:life_os/core/widgets/entrance_fader.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isResetLoading = false;
  String? _emailError;
  String? _passwordError;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = context.isArabic;
    final textColor = theme.colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: 0.6);
    final isLight = theme.brightness == Brightness.light;

    return PopScope(
      canPop: false,
      child: Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    EntranceFader(
                      delay: Duration.zero,
                      child: _buildLogo(theme),
                    ),
                    const SizedBox(height: 30),
                    EntranceFader(
                      delay: const Duration(milliseconds: 100),
                      child: Column(
                        children: [
                          Text(
                            context.translate('welcome_back_title'),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              color: textColor,
                            ),
                          ),
                          Text(
                            context.translate('life_waiting'),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    EntranceFader(
                      delay: const Duration(milliseconds: 200),
                      child: Column(
                        children: [
                          _buildLabel(context.translate('email'), isArabic, secondaryTextColor),
                          _buildTextField(
                            theme: theme,
                            textColor: textColor,
                            secondaryTextColor: secondaryTextColor,
                            controller: _emailController,
                            hintText: context.translate('login_email_placeholder'),
                            errorText: _emailError,
                            onChanged: (_) {
                              if (_emailError != null) setState(() => _emailError = null);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    EntranceFader(
                      delay: const Duration(milliseconds: 300),
                      child: Column(
                        children: [
                          _buildLabel(context.translate('password'), isArabic, secondaryTextColor),
                          _buildTextField(
                            theme: theme,
                            textColor: textColor,
                            secondaryTextColor: secondaryTextColor,
                            controller: _passwordController,
                            hintText: '••••••••',
                            isPassword: true,
                            obscureText: _obscurePassword,
                            onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                            errorText: _passwordError,
                            onChanged: (_) {
                              if (_passwordError != null) setState(() => _passwordError = null);
                            },
                          ),
                          Align(
                            alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
                            child: _isResetLoading 
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.cyan)),
                                )
                              : TextButton(
                                  onPressed: _handleForgotPassword,
                                  child: Text(
                                    context.translate('forgot_password'),
                                    style: TextStyle(
                                      color: isLight ? const Color(0xFF00ADB5) : AppColors.cyan, 
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    EntranceFader(
                      delay: const Duration(milliseconds: 400),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: AppColors.cyan)
                          : SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.cyan,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Text(
                                  context.translate('login'),
                                  style: const TextStyle(
                                    color: AppColors.base,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),
                    EntranceFader(
                      delay: const Duration(milliseconds: 500),
                      child: _buildSocialSection(isArabic, secondaryTextColor),
                    ),
                    
                    const SizedBox(height: 32),
                    EntranceFader(
                      delay: const Duration(milliseconds: 600),
                      child: GestureDetector(
                        onTap: () => context.go(AppRoutes.register),
                        child: Text(
                          context.translate('register_prompt'),
                          style: TextStyle(
                            color: isLight ? const Color(0xFF00ADB5) : AppColors.cyan, 
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  void _handleLogin() async {
    final emailErr = AppValidators.validateEmail(_emailController.text.trim());
    final passErr = AppValidators.validatePassword(_passwordController.text);

    if (emailErr != null || passErr != null) {
      setState(() {
        _emailError = emailErr;
        _passwordError = passErr;
      });
      return;
    }

    setState(() => _isLoading = true);
    final result = await AuthService().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (error) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      ),
      (user) => context.go(AppRoutes.dashboard),
    );
  }

  void _handleForgotPassword() async {
    debugPrint("Forgot password clicked");
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.translate('enter_email_first')),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isResetLoading = true);
    try {
      final result = await AuthService().resetPassword(email);
      debugPrint("AuthService.resetPassword result: $result");
      
      if (!mounted) return;
      setState(() => _isResetLoading = false);

      result.fold(
        (error) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        ),
        (_) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.translate('reset_link_sent')),
            backgroundColor: Colors.green,
          ),
        ),
      );
    } catch (e) {
      debugPrint("Caught error in forgot password: $e");
      if (mounted) setState(() => _isResetLoading = false);
    }
  }

  Widget _buildLogo(ThemeData theme) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset('assets/images/helmet_logo.png', fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildLabel(String text, bool isArabic, Color secondaryTextColor) => Align(
    alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
    child: Padding(
      padding: EdgeInsets.only(bottom: 8, right: isArabic ? 9 : 0, left: isArabic ? 0 : 9),
      child: Text(
        text,
        style: TextStyle(color: secondaryTextColor, fontSize: 11),
      ),
    ),
  );

  Widget _buildTextField({
    required ThemeData theme,
    required Color textColor,
    required Color secondaryTextColor,
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    bool? obscureText,
    VoidCallback? onToggleVisibility,
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.brightness == Brightness.light
                  ? theme.colorScheme.onSurface.withValues(alpha: 0.12)
                  : theme.colorScheme.onSurface.withValues(alpha: 0.08),
            ),
            boxShadow: theme.brightness == Brightness.light
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText ?? isPassword,
            onChanged: onChanged,
            validator: (_) => null, // Neutralized validator
            style: TextStyle(color: textColor, fontSize: 13),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: secondaryTextColor),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        (obscureText ?? true) ? Icons.visibility_off : Icons.visibility,
                        color: secondaryTextColor,
                        size: 20,
                      ),
                      onPressed: onToggleVisibility,
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
              errorStyle: const TextStyle(height: 0, fontSize: 0), // Suppress internal error rendering
            ),
          ),
        ),
        SizedBox(
          height: 20, // Dedicated Fixed-Height Slot
          child: Padding(
            padding: const EdgeInsets.only(top: 4, right: 8, left: 8),
            child: Text(
              errorText ?? '',
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialSection(bool isArabic, Color secondaryTextColor) {
    return Column(
      children: [
        Text(
          context.translate('or'),
          style: TextStyle(color: secondaryTextColor, fontSize: 12),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () async {
              setState(() => _isLoading = true);
              final result = await AuthService().signInWithGoogle();
              if (!mounted) return;
              setState(() => _isLoading = false);
              result.fold(
                (error) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error), backgroundColor: Colors.red),
                ),
                (user) => context.go(AppRoutes.dashboard),
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: secondaryTextColor.withValues(alpha: 0.1)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              context.translate('continue_google'),
              style: TextStyle(color: secondaryTextColor),
            ),
          ),
        ),
      ],
    );
  }
}
