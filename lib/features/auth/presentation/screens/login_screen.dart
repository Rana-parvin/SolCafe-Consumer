import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:solcafe/features/auth/presentation/screens/signup_screen.dart';

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
        
        // Correct the duplicate navigation overlay bug by popping auth screens back to root.
        // AuthWrapper is the root of the app and will automatically render the main layout on auth update.
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
    return Scaffold(
      backgroundColor: const Color(0xFF3E2820),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 100, 82, 76),
                    blurRadius: 10,
                    offset: Offset(1, 1),
                  ),
                ],
                color: const Color(0xFFF5F2F2),
              ),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/cup icon.jpg",
                      height: 135,
                      width: 135,
                    ),
                    Text(
                      "access your account",
                      style: GoogleFonts.lato(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 50, 18, 6),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        style: const TextStyle(
                          color: Color(0xFF321206),
                          fontWeight: FontWeight.bold,
                        ),
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            borderSide: BorderSide(color: Color(0xFF321206)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.mail_outline,
                            color: Color.fromARGB(255, 50, 18, 6),
                          ),
                          hintText: "Email",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF321206),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        style: const TextStyle(
                          color: Color(0xFF321206),
                          fontWeight: FontWeight.bold,
                        ),
                        obscureText: isobscure,
                        controller: password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            borderSide: BorderSide(color: Color(0xFF321206)),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xFF321206),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isobscure = !isobscure;
                              });
                            },
                            icon: Icon(
                              isobscure
                                  ? Icons.visibility_off
                                  : Icons.visibility_outlined,
                              color: const Color(0xFF321206),
                            ),
                          ),
                          hintText: "Password",
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 50, 18, 6),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 350,
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: isloading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 56, 27, 17),
                        ),
                        child: isloading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 50, 18, 6),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const SignupScreen()),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF251914),
                          ),
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
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
