import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_os/core/theme/app_colors.dart';
import 'package:life_os/core/router/app_router.dart';
import 'package:life_os/core/utils/app_validators.dart';
import 'package:life_os/core/utils/localization_extension.dart';
import 'package:life_os/core/services/auth_service.dart';
import 'package:life_os/core/widgets/entrance_fader.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
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
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _goBackToLogin();
      },
      child: Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isLight ? theme.colorScheme.surface : Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: isLight ? 0.5 : 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18),
          onPressed: _goBackToLogin,
        ),
      ),
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
                    const SizedBox(height: 10),
                    EntranceFader(
                      delay: Duration.zero,
                      child: Text(
                        context.translate('join_system'),
                        style: const TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 24,
                          color: AppColors.cyan,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    EntranceFader(
                      delay: const Duration(milliseconds: 50),
                      child: Text(
                        context.translate('start_story'),
                        style: TextStyle(color: secondaryTextColor, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 48),

                    EntranceFader(
                      delay: const Duration(milliseconds: 100),
                      child: Column(
                        children: [
                          _buildLabel(context.translate('full_name'), isArabic, secondaryTextColor),
                          _buildTextField(
                            theme: theme,
                            textColor: textColor,
                            secondaryTextColor: secondaryTextColor,
                            controller: _nameController,
                            hintText: isArabic ? "عمر فتحي" : "Omar Fathi",
                            errorText: _nameError,
                            onChanged: (_) {
                              if (_nameError != null) setState(() => _nameError = null);
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    EntranceFader(
                      delay: const Duration(milliseconds: 150),
                      child: Column(
                        children: [
                          _buildLabel(context.translate('email'), isArabic, secondaryTextColor),
                          _buildTextField(
                            theme: theme,
                            textColor: textColor,
                            secondaryTextColor: secondaryTextColor,
                            controller: _emailController,
                            hintText: context.translate('register_email_placeholder'),
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
                      delay: const Duration(milliseconds: 200),
                      child: Column(
                        children: [
                          _buildLabel(context.translate('password'), isArabic, secondaryTextColor),
                          _buildTextField(
                            theme: theme,
                            textColor: textColor,
                            secondaryTextColor: secondaryTextColor,
                            controller: _passwordController,
                            hintText: "••••••••",
                            isPassword: true,
                            obscureText: _obscurePassword,
                            onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                            errorText: _passwordError,
                            onChanged: (_) {
                              if (_passwordError != null) setState(() => _passwordError = null);
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    EntranceFader(
                      delay: const Duration(milliseconds: 250),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: AppColors.cyan)
                          : SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _handleRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.cyan,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Text(
                                  context.translate('create_account'),
                                  style: const TextStyle(
                                    color: AppColors.base,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ),
                        
                    const SizedBox(height: 32),
                    EntranceFader(
                      delay: const Duration(milliseconds: 300),
                      child: GestureDetector(
                        onTap: _goBackToLogin,
                        child: Text(
                          context.translate('already_have_account'),
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

  void _goBackToLogin() {
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  void _handleRegister() async {
    final nameErr = AppValidators.validateName(_nameController.text.trim());
    final emailErr = AppValidators.validateEmail(_emailController.text.trim());
    final passErr = AppValidators.validatePassword(_passwordController.text);

    if (nameErr != null || emailErr != null || passErr != null) {
      setState(() {
        _nameError = nameErr;
        _emailError = emailErr;
        _passwordError = passErr;
      });
      return;
    }

    setState(() => _isLoading = true);
    final result = await AuthService().register(
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
}
