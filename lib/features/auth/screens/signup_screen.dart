// features/auth/screens/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miles_assignment/core/utils/responsive_helper.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/custom_text_field.dart';
import '../providers/auth_providers.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool isLoading = false;
  bool isHovered = false;
  bool _obscurePassword = true;

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => isLoading = true);
    final result = await ref.read(authControllerProvider).signUp(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text.trim(),
    );
    setState(() => isLoading = false);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      Navigator.pop(context);
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
    final isLarge = isTablet(context);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Back Button
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.surface,
                    elevation: 2,
                  ),
                ),
              ),
              // Main Content
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLarge ? 24 : 16,
                    vertical: 24,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isLarge 
                          ? size.width * 0.4 
                          : size.width * 0.9,
                    ),
                    child: MouseRegion(
                      onEnter: (_) => setState(() => isHovered = true),
                      onExit: (_) => setState(() => isHovered = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        transform: Matrix4.identity()
                          ..translate(0.0, isHovered ? -8.0 : 0.0, 0.0),
                        child: Card(
                          elevation: isHovered ? 8 : 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(isLarge ? 32 : 24),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Create Account',
                                    style: theme.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Please fill in the details to continue',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: isLarge ? 32 : 24),
                                  CustomTextField(
                                    controller: _emailCtrl,
                                    label: 'Email',
                                    validator: Validators.validateEmail,
                                    prefixIcon: const Icon(Icons.email_outlined),
                                  ),
                                  SizedBox(height: isLarge ? 16 : 12),
                                  CustomTextField(
                                    controller: _passCtrl,
                                    label: 'Password',
                                    obscure: _obscurePassword,
                                    validator: Validators.validatePassword,
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword 
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(height: isLarge ? 24 : 20),
                                  SizedBox(
                                    height: isLarge ? 48 : 44,
                                    child: isLoading
                                        ? const Center(child: CircularProgressIndicator())
                                        : ElevatedButton(
                                            onPressed: _handleSignup,
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              'Sign Up',
                                              style: TextStyle(
                                                fontSize: isLarge ? 16 : 14,
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
