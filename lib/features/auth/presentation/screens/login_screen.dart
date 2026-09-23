import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/presentation/widgets/auth_logo.dart';
import 'package:solcafe/core/presentation/widgets/responsive_layout.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:solcafe/features/auth/presentation/screens/signup_screen.dart';
import 'package:solcafe/features/auth/presentation/widgets/auth_background.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final bool initialIsSignUp;
  const LoginScreen({super.key, this.initialIsSignUp = false});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late bool isSignUp;

  @override
  void initState() {
    super.initState();
    isSignUp = widget.initialIsSignUp;
  }

  void toggleAuthMode() {
    setState(() {
      isSignUp = !isSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.solcafeColors;

    return Scaffold(
      backgroundColor: colors.surfacePrimary,
      body: Stack(
        children: [
          const AuthBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: SolCafeBreakpoints.getResponsivePadding(context),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.03),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: isSignUp
                      ? SignupCard(
                          key: const ValueKey('signup_card'),
                          onToggleMode: toggleAuthMode,
                        )
                      : LoginCard(
                          key: const ValueKey('login_card'),
                          onToggleMode: toggleAuthMode,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginCard extends ConsumerStatefulWidget {
  final VoidCallback onToggleMode;

  const LoginCard({
    super.key,
    required this.onToggleMode,
  });

  @override
  ConsumerState<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends ConsumerState<LoginCard> {
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

    return ConstrainedCenterContainer(
      maxWidth: 440,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colors.cardBorder.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
          color: colors.cardBackground,
        ),
        padding: EdgeInsets.all(SolCafeBreakpoints.isCompact(context) ? 20 : 28),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              const AuthLogo(),
              Text(
                "Access your account",
                textAlign: TextAlign.center,
                style: GoogleFonts.readexPro(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 28),
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
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: colors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onToggleMode,
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
    );
  }
}
