import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:solcafe/features/auth/presentation/screens/signup_screen.dart';

import 'package:solcafe/core/presentation/widgets/responsive_layout.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool isobscure = true;
  bool isloading = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (formkey.currentState!.validate()) {
      setState(() => isloading = true);
      try {
        final loginUseCase = ref.read(loginUseCaseProvider);
        await loginUseCase(email.text.trim(), password.text.trim());
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully logged in!")),
        );
        
        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: ${e.toString().replaceAll("Exception:", "")}")),
        );
      } finally {
        if (mounted) setState(() => isloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.solcafeColors;

    return Scaffold(
      backgroundColor: colors.surfacePrimary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedCenterContainer(
              maxWidth: 480,
              child: Container(

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colors.cardBorder,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                color: colors.cardBackground,
              ),
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/cup icon.jpg",
                      height: 120,
                      width: 120,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Access your account",
                      style: GoogleFonts.readexPro(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: colors.textPrimary),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail_outline, color: colors.accentGold),
                        hintText: "Email",
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: password,
                      obscureText: isobscure,
                      style: TextStyle(color: colors.textPrimary),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline, color: colors.accentGold),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isobscure = !isobscure;
                            });
                          },
                          icon: Icon(
                            isobscure ? Icons.visibility_off : Icons.visibility_outlined,
                            color: colors.textSecondary,
                          ),
                        ),
                        hintText: "Password",
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isloading ? null : login,
                        child: isloading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Login"),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: colors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const SignupScreen()),
                            );
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
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
    );
  }
}
