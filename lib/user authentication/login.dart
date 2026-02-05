import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/working%20with%20bottombar/bottom%20nav%20stylish.dart';
import 'package:solcafe/user%20authentication/sign%20up.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool isobscure = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
        super.dispose();

  }

  Future<void> login() async {
    if (formkey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
       
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Successfully logged in!")));
         Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Bottomnavstylish(  
          
         )),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No user found with this email!")),
          );
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Wrong password!")));
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("An error occured")));
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
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 100, 82, 76),
                   blurRadius: 10,
                    offset: Offset(1, 1),
                  ),
                ],
            
                color: const Color(0xFFF5F2F2),
             
              ),
              child: Form(key: formkey,
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
                    SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        style: TextStyle(
                          
                          
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
                        decoration: InputDecoration(
                     
                           enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
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
                            color: const Color.fromARGB(255, 50, 18, 6),
                          ),
                          hint: Text(
                            "Email",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF321206),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        style: TextStyle(
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
                           enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
    borderSide: BorderSide(color: Color(0xFF321206)), 
  ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color:  Color(0xFF321206),
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
                                  color:Color(0xFF321206),
                            ),
                          ),
                          hint: Text(
                            "Password",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 50, 18, 6),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 350,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.zero,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          
                            login();
                          
                        },
                     style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              const Color.fromARGB(255, 56, 27, 17)),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 50, 18, 6),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Signup()),
                            );
                          },
                          style: ButtonStyle(
                            foregroundColor: WidgetStatePropertyAll(const Color(0xFF251914))
                          ),
                          child: Text(
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
