// lib/src/features/auth/presentation/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitflow/src/features/auth/data/auth_repository.dart';
import 'package:habitflow/main.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: HabitFlowTheme.darkSurface,
        title: const Text('Authentication Error',
            style: TextStyle(color: HabitFlowTheme.kWhite)),
        content: Text(message,
            style: const TextStyle(color: HabitFlowTheme.kWhite70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK',
                style: TextStyle(color: HabitFlowTheme.primaryColor)),
          ),
        ],
      ),
    );
  }

  Future<void> _submitEmailPassword() async {
    // FIX: Added curly braces
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      if (_isLogin) {
        await authRepo.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        await authRepo.createUserWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      }
    } catch (e) {
      String errorMsg = e.toString();
      if (errorMsg.contains(']')) {
        errorMsg = errorMsg.split('] ').last;
      }
      if (mounted) _showErrorDialog(errorMsg);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
    } catch (e) {
      if (mounted) _showErrorDialog(e.toString().split('] ').last);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithTwitter() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signInWithTwitter();
    } catch (e) {
      if (mounted) _showErrorDialog(e.toString().split('] ').last);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInAnonymously() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signInAnonymously();
    } catch (e) {
      if (mounted) _showErrorDialog(e.toString().split('] ').last);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [HabitFlowTheme.darkBg, HabitFlowTheme.darkSurface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    return Row(
                      children: [
                        Expanded(child: _buildAuthForm()),
                        Expanded(child: _buildIllustration()),
                      ],
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      _buildIllustration(height: 200),
                      _buildAuthForm(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration({double? height}) {
    return SvgPicture.asset(
      'assets/images/login_illustration.svg',
      height: height ?? 400,
    );
  }

  Widget _buildAuthForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Habit Flow',
            style: TextStyle(
              color: HabitFlowTheme.kWhite70,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _isLogin ? 'Login' : 'Sign Up',
            style: const TextStyle(
              color: HabitFlowTheme.kWhite,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    // FIX: Added curly braces
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter email';
                    }
                    if (!val.contains('@') || !val.contains('.')) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline,
                  isObscure: !_isPasswordVisible,
                  onToggleVisibility: () =>
                      setState(() => _isPasswordVisible = !_isPasswordVisible),
                  validator: (val) {
                    // FIX: Added curly braces
                    if (val == null || val.length < 8) {
                      return 'Must be 8+ characters';
                    }
                    return null;
                  },
                ),
                if (!_isLogin) ...[
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    icon: Icons.lock_outline,
                    isObscure: !_isConfirmPasswordVisible,
                    onToggleVisibility: () => setState(() =>
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                    validator: (val) {
                      if (val != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 40),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: HabitFlowTheme.primaryColor))
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitEmailPassword,
                          child: Text(_isLogin ? 'Login' : 'Sign Up'),
                        ),
                      ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildToggleModeButton(),
          const SizedBox(height: 20),
          _buildDivider(),
          const SizedBox(height: 20),
          _buildSocialLogins(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isObscure = false,
    TextInputType? keyboardType,
    VoidCallback? onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(color: HabitFlowTheme.kWhite),
      cursorColor: HabitFlowTheme.primaryColor,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: HabitFlowTheme.kWhite70),
        suffixIcon: onToggleVisibility != null
            ? IconButton(
                icon: Icon(
                  isObscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: HabitFlowTheme.kWhite70,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
      ),
    );
  }

  Widget _buildToggleModeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isLogin ? "Don't have an account?" : "Already have an account?",
          style: const TextStyle(color: HabitFlowTheme.kWhite70),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isLogin = !_isLogin;
              _formKey.currentState?.reset();
            });
          },
          child: Text(
            _isLogin ? 'Sign Up' : 'Login',
            style: const TextStyle(
              color: HabitFlowTheme.kWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
            child: Divider(color: HabitFlowTheme.kWhite70.withAlpha(77))),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('OR', style: TextStyle(color: HabitFlowTheme.kWhite70)),
        ),
        Expanded(
            child: Divider(color: HabitFlowTheme.kWhite70.withAlpha(77))),
      ],
    );
  }

  Widget _buildSocialLogins() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          icon: FontAwesomeIcons.google,
          onPressed: _signInWithGoogle,
        ),
        const SizedBox(width: 20),
        _buildSocialButton(
          icon: FontAwesomeIcons.xTwitter,
          onPressed: _signInWithTwitter,
        ),
        const SizedBox(width: 20),
        _buildSocialButton(
          icon: FontAwesomeIcons.userSecret, // Guest/Anonymous icon
          onPressed: _signInAnonymously,
        ),
      ],
    );
  }

  Widget _buildSocialButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: HabitFlowTheme.kWhite70.withAlpha(77)),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: HabitFlowTheme.kWhite),
        iconSize: 22,
        onPressed: onPressed,
      ),
    );
  }
}