import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/dope%20introduction/dope%20main.dart';
import 'package:solcafe/user%20authentication/login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    phone.dispose();
    super.dispose();
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Dopemain()),
                    );
                  },
                  label: Text("Back",style: TextStyle(color: Colors.white),),
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 100, 82, 76),
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
                          "welcome !Let's get started",
                          style: GoogleFonts.lato(
                            color: const Color.fromARGB(255, 50, 18, 6),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 18),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: TextFormField(
                            style: TextStyle(
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
                            decoration: InputDecoration(
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
                                color: const Color(0xFF321206),
                              ),
                              hint: Text(
                                "Name",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 50, 18, 6),
                                  fontWeight: FontWeight.bold,
                                ),
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
                            style: TextStyle(
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
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail_outline,
                                color: const Color.fromARGB(255, 50, 18, 6),
                              ),
                              hint: Text(
                                "Email",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 50, 18, 6),
                                  fontWeight: FontWeight.bold,
                                ),
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
                            style: TextStyle(
                              color: Color(0xFF321206), 
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "please give your phone number ";
                              }
                              return null;
                            },
                            controller: phone,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.call_outlined,
                                color: const Color.fromARGB(255, 50, 18, 6),
                              ),
                              hint: Text(
                                "Phone",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 50, 18, 6),
                                  fontWeight: FontWeight.bold,
                                ),
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
                            style: TextStyle(
                              color: Color(0xFF321206), 
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "password is necessary";
                              }
                              return null;
                            },
                            controller: password,
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.visibility_outlined,
                                size: 20,
                                color: const Color.fromARGB(255, 50, 18, 6),
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: const Color.fromARGB(255, 50, 18, 6),
                              ),
                              hint: Text(
                                "Password",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 50, 18, 6),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                borderSide: BorderSide(
                                  color: Color(0xFF321206),
                                ), 
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
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
                            onPressed: () async {
                              try {
                               
                                signupnow();
                              } catch (e) {
                                print('Error: $e');
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                const Color.fromARGB(255, 56, 27, 17),
                              ),
                            ),
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 239, 237, 235),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 50, 18, 6),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                foregroundColor: WidgetStatePropertyAll(
                                  const Color(0xFF251914),
                                ),
                              ),
                              child: Text(
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

  Future<void> signupnow() async {
    if (formkey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: email.text,
              password: password.text,
            );
        final user1 = userCredential.user;
        if (user1 != null) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user1.uid)
              .set({
                "username": name.text,
                "email": email.text,
                "phone": phone.text,
                "uid": user1.uid,
              });
          await userCredential.user!.updateDisplayName(name.text);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Account created successfully")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message ?? "Sign up failed")));
      } catch (e) {
        print("Error:$e");
      }
    }
  }
}
