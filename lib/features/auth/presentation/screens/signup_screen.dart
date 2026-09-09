import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final formkey = GlobalKey<FormState>();

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  bool isobscure = true;
  bool isloading = false;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    phone.dispose();
    super.dispose();
  }

  Future<void> signupnow() async {
    if (formkey.currentState!.validate()) {
      setState(() => isloading = true);
      try {
        final signupUseCase = ref.read(signupUseCaseProvider);
        await signupUseCase(
          name.text.trim(),
          email.text.trim(),
          phone.text.trim(),
          password.text.trim(),
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully")),
        );

        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll("Exception:", ""))),
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    label: const Text("Back"),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: colors.cardBorder,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/cup icon.jpg",
                          height: 110,
                          width: 110,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Welcome! Let's get started",
                          style: GoogleFonts.readexPro(
                            color: colors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: name,
                          style: TextStyle(color: colors.textPrimary),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please provide your name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.edit_outlined, color: colors.accentGold),
                            hintText: "Name",
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: colors.textPrimary),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is necessary";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail_outline, color: colors.accentGold),
                            hintText: "Email",
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: phone,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(color: colors.textPrimary),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please give your phone number";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.call_outlined, color: colors.accentGold),
                            hintText: "Phone",
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: password,
                          obscureText: isobscure,
                          style: TextStyle(color: colors.textPrimary),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is necessary";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
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
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isloading ? null : signupnow,
                            child: isloading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text("Sign up"),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(color: colors.textSecondary),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "Login",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
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
}
