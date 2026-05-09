import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitbot/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:habitbot/features/auth/presentation/bloc/auth_event.dart';
import 'package:habitbot/features/auth/presentation/bloc/auth_state.dart';
import 'package:habitbot/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:habitbot/features/habits/presentation/pages/main_screen.dart';

class SignupPageWeb extends StatefulWidget {
  const SignupPageWeb({super.key});

  @override
  State<SignupPageWeb> createState() => _SignupPageWebState();
}

class _SignupPageWebState extends State<SignupPageWeb> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signup() {
    if (_formKey.currentState!.validate()) {
      if (!_acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please accept the Terms & Conditions', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      context.read<AuthBloc>().add(
        SignupEvent(
          name: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.redAccent),
            );
          } else if (state is Authenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const MainScreen()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return Row(
            children: [
              // Left Side Hero
              Expanded(
                flex: 5,
                child: Container(
                  color: theme.primaryColor.withAlpha(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline, size: 120, color: theme.primaryColor),
                        const SizedBox(height: 32),
                        Text(
                          'Join HabitBot',
                          style: theme.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.primaryColor),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Start your journey to better\nroutines and productivity.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onSurface.withAlpha(150)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Right Side Form
              Expanded(
                flex: 4,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(40.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Create Account',
                              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Join HabitBot and start building better habits today.',
                              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(height: 32),
                            CustomTextField(
                              hintText: 'Full Name',
                              controller: _nameController,
                              prefixIcon: const Icon(Icons.person_outline),
                              validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              hintText: 'Phone Number',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              prefixIcon: const Icon(Icons.phone_outlined),
                              validator: (value) {
                                final input = (value ?? '').trim();
                                if (input.isEmpty) return 'Please enter your phone number';
                                final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
                                if (digits.length < 10) return 'Enter valid phone number';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              hintText: 'Email address',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(Icons.email_outlined),
                              validator: (value) => value == null || value.isEmpty ? 'Please enter your email' : null,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              hintText: 'Password',
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Please enter a password';
                                if (value.length < 6) return 'Password must be at least 6 characters';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              hintText: 'Confirm Password',
                              controller: _confirmPasswordController,
                              obscureText: _obscurePassword,
                              prefixIcon: const Icon(Icons.lock_outline),
                              validator: (value) {
                                if (value != _passwordController.text) return 'Passwords do not match';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Checkbox(
                                  value: _acceptedTerms,
                                  activeColor: theme.primaryColor,
                                  onChanged: (val) => setState(() => _acceptedTerms = val ?? false),
                                ),
                                const Expanded(
                                  child: Text('I agree to the Terms & Conditions and Privacy Policy.', style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: state is AuthLoading ? null : _signup,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                              ),
                              child: state is AuthLoading
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Already have an account?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Sign in', style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
