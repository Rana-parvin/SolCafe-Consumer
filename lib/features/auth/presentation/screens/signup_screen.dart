import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/presentation/widgets/auth_logo.dart';
import 'package:solcafe/core/presentation/widgets/responsive_layout.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:solcafe/features/auth/presentation/screens/login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreen(initialIsSignUp: true);
  }
}

class SignupCard extends ConsumerStatefulWidget {
  final VoidCallback onToggleMode;

  const SignupCard({
    super.key,
    required this.onToggleMode,
  });

  @override
  ConsumerState<SignupCard> createState() => _SignupCardState();
}

class _SignupCardState extends ConsumerState<SignupCard> {
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

    return ConstrainedCenterContainer(
      maxWidth: 440,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: colors.cardBorder.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.all(SolCafeBreakpoints.isCompact(context) ? 20 : 28),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              const AuthLogo(),
              Text(
                "Welcome! Let's get started",
                textAlign: TextAlign.center,
                style: GoogleFonts.readexPro(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 28),
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
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: colors.textSecondary),
                  ),
                  TextButton(
                    onPressed: widget.onToggleMode,
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
    );
  }
}
