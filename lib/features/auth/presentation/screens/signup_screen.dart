import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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

        // Correct navigation flow: pop back to root (AuthWrapper) which will show the home screen
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
    return Scaffold(
      backgroundColor: const Color(0xFF3E2820),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Fix nested navigation stack growth by popping instead of pushing Dopemain
                    Navigator.pop(context);
                  },
                  label: const Text("Back", style: TextStyle(color: Colors.white)),
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 100, 82, 76),
                        blurRadius: 10,
                        offset: Offset(1, 1),
                      ),
                    ],
                    color: const Color.fromARGB(255, 245, 242, 242),
                    borderRadius: BorderRadius.circular(20),
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
                          "welcome! Let's get started",
                          style: GoogleFonts.lato(
                            color: const Color.fromARGB(255, 50, 18, 6),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: TextFormField(
                            style: const TextStyle(
                              color: Color(0xFF321206),
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please provide your name";
                              }
                              return null;
                            },
                            controller: name,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                borderSide: BorderSide(
                                  color: Color(0xFF321206),
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.edit_outlined,
                                color: Color(0xFF321206),
                              ),
                              hintText: "Name",
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 50, 18, 6),
                                fontWeight: FontWeight.bold,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: TextFormField(
                            style: const TextStyle(
                              color: Color(0xFF321206),
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is necessary";
                              }
                              return null;
                            },
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail_outline,
                                color: Color.fromARGB(255, 50, 18, 6),
                              ),
                              hintText: "Email",
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 50, 18, 6),
                                fontWeight: FontWeight.bold,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(
                                  color: Color(0xFF321206),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: TextFormField(
                            style: const TextStyle(
                              color: Color(0xFF321206),
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "please give your phone number";
                              }
                              return null;
                            },
                            controller: phone,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.call_outlined,
                                color: Color.fromARGB(255, 50, 18, 6),
                              ),
                              hintText: "Phone",
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 50, 18, 6),
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(
                                  color: Color(0xFF321206),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: TextFormField(
                            style: const TextStyle(
                              color: Color(0xFF321206),
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "password is necessary";
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                            obscureText: isobscure,
                            controller: password,
                            decoration: InputDecoration(
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
                                  size: 20,
                                  color: const Color.fromARGB(255, 50, 18, 6),
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Color.fromARGB(255, 50, 18, 6),
                              ),
                              hintText: "Password",
                              hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 50, 18, 6),
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                borderSide: BorderSide(
                                  color: Color(0xFF321206),
                                ),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 350,
                          padding: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: isloading ? null : signupnow,
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
                                    "Sign up",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 239, 237, 235),
                                    ),
                                  ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: Color.fromARGB(255, 50, 18, 6),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Simple pop back to Login
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF251914),
                              ),
                              child: const Text(
                                "Login",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
