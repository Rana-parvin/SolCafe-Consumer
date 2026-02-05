import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  File? profileImage;
  final ImagePicker picker = ImagePicker();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  var username = FirebaseAuth.instance.currentUser?.displayName;

  var emailid = FirebaseAuth.instance.currentUser?.email;
  var phonenumber = FirebaseAuth.instance.currentUser?.phoneNumber;

  String? capitalizeFullName(String? name) {
    if (name == null || name.trim().isEmpty) return name;

    return name
        .trim()
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1).toLowerCase()
              : '',
        )
        .join(' ');
  }

  @override
  void initState() {
    super.initState();
    loadimage();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch user document from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data()!;

          setState(() {
            name.text = capitalizeFullName(username).toString();
            email.text = data['email'] ?? '';
            phone.text = data['phone'].toString(); 
          });
        }
      }
    });
  }

  Future<void> pickimage() async {
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final name = PickedFile.name;
      final File newimage = await File(
        PickedFile.path,
      ).copy('${directory.path}/$name');

      setState(() {
        profileImage = newimage;
      });
      final pref = await SharedPreferences.getInstance();
      await pref.setString('profile_image_path', newimage.path);
    }
  }

  Future<void> loadimage() async {
    final prefs = await SharedPreferences.getInstance();
    final imgpath = prefs.getString('profile_image_path');
    if (imgpath != null && File(imgpath).existsSync()) {
      setState(() {
        profileImage = File(imgpath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(title: Text("Edit profile")),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: () {
                        pickimage();
                      },
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondary,
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : null,
                        child: profileImage == null
                            ? Icon(Icons.person_outline, size: 50)
                            : null,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      capitalizeFullName(username) ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 25,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Form(
              key: formkey,
              child: Column(
                children: [
                  customfields(
                    controller: name,
                    padding: EdgeInsets.only(top: 20, left: 25, right: 25),
                    borderradius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    hinttext: "Name",
                    prefixicon: Icon(
                      Icons.person_outline_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name is required! Please enter your nickname or something";
                      }
                      return null;
                    },
                  ),
                  customfields(
                    controller: phone,
                    keyboardtype: TextInputType.numberWithOptions(),
                    padding: EdgeInsets.only(left: 25, right: 25),
                    borderradius: BorderRadius.zero,
                    hinttext: "Phone number",
                    prefixicon: Icon(
                      Icons.call_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Phone number is required!";
                      }
                      return null;
                    },
                  ),
                  customfields(
                    controller: email,
                    keyboardtype: TextInputType.emailAddress,
                    padding: EdgeInsets.only(bottom: 20, left: 25, right: 25),
                    borderradius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    hinttext: "Email address",
                    prefixicon: Icon(
                      Icons.email_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required! Please enter";
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            await modifydetails();
                            await loadimage();
                            setState(() {
                              
                            });
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.secondary,
                          ),
                          elevation: WidgetStatePropertyAll(0),
                        ),
                        child: Text("Edit"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> modifydetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user logged in");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("No user logged in")));
    }
    try {
      final docref = FirebaseFirestore.instance
          .collection("users")
          .doc(user?.uid);
      await docref.update({
        'name': name.text,
        'email': email.text,
        'phone': phone.text,
      });
      print("Details modified successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Your details modified successfully")),
      );
    } catch (e) {
      print("error updating profile!Try again later");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error updating profile. $e")));
    }
  }
}

class customfields extends StatelessWidget {
  final TextEditingController controller;
  final String hinttext;
  final Widget prefixicon;
  final TextInputType? keyboardtype;
  final BorderRadius borderradius;
  final EdgeInsets padding;
  final String? Function(String?) validator;

  const customfields({
    super.key,
    required this.controller,
    required this.padding,
    required this.borderradius,
    required this.hinttext,
    this.keyboardtype,
    required this.prefixicon,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        controller: controller,
        validator: validator,
        keyboardType: keyboardtype,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.tertiary,
          hintText: hinttext,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          prefixIcon: prefixicon,
          border: OutlineInputBorder(
            borderRadius: borderradius,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: borderradius,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          enabled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: borderradius,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
