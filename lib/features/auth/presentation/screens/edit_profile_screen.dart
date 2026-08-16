import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solcafe/core/utils/string_utils.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? profileImage;
  final ImagePicker picker = ImagePicker();

  final formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    loadimage();

    // Fetch initial user data after layout build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authStateChangesProvider).value;
      if (user != null) {
        setState(() {
          nameController.text = StringUtils.capitalizeFullName(user.displayName) ?? '';
          emailController.text = user.email;
          phoneController.text = user.phoneNumber;
        });
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> pickimage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = pickedFile.name;
      final File newImage = await File(pickedFile.path).copy('${directory.path}/$fileName');

      setState(() {
        profileImage = newImage;
      });
      final pref = await SharedPreferences.getInstance();
      await pref.setString('profile_image_path', newImage.path);
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

  Future<void> modifydetails() async {
    if (formkey.currentState!.validate()) {
      setState(() => isloading = true);
      try {
        final updateProfileUseCase = ref.read(updateProfileUseCaseProvider);
        await updateProfileUseCase(
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
          email: emailController.text.trim(),
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Your details modified successfully")),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating profile: $e")),
        );
      } finally {
        if (mounted) setState(() => isloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Edit profile")),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: pickimage,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: theme.secondary,
                        backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
                        child: profileImage == null
                            ? const Icon(Icons.person_outline, size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      nameController.text.isNotEmpty ? nameController.text : "Update Profile",
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        letterSpacing: 1.5,
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
                  CustomField(
                    controller: nameController,
                    padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
                    borderradius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    hinttext: "Name",
                    prefixicon: Icon(
                      Icons.person_outline_outlined,
                      color: theme.primary,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                  ),
                  CustomField(
                    controller: phoneController,
                    keyboardtype: TextInputType.phone,
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    borderradius: BorderRadius.zero,
                    hinttext: "Phone number",
                    prefixicon: Icon(
                      Icons.call_outlined,
                      color: theme.primary,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Phone number is required";
                      }
                      return null;
                    },
                  ),
                  CustomField(
                    controller: emailController,
                    keyboardtype: TextInputType.emailAddress,
                    padding: const EdgeInsets.only(bottom: 20, left: 25, right: 25),
                    borderradius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    hinttext: "Email address",
                    prefixicon: Icon(
                      Icons.email_outlined,
                      color: theme.primary,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: theme.secondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        onPressed: isloading ? null : modifydetails,
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(theme.secondary),
                          elevation: const WidgetStatePropertyAll(0),
                        ),
                        child: isloading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text("Save Details"),
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
}

class CustomField extends StatelessWidget {
  final TextEditingController controller;
  final String hinttext;
  final Widget prefixicon;
  final TextInputType? keyboardtype;
  final BorderRadius borderradius;
  final EdgeInsets padding;
  final String? Function(String?) validator;

  const CustomField({
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
    final theme = Theme.of(context).colorScheme;

    return Padding(
      padding: padding,
      child: TextFormField(
        style: TextStyle(color: theme.primary),
        controller: controller,
        validator: validator,
        keyboardType: keyboardtype,
        decoration: InputDecoration(
          filled: true,
          fillColor: theme.tertiary,
          hintText: hinttext,
          hintStyle: TextStyle(color: theme.primary),
          prefixIcon: prefixicon,
          border: OutlineInputBorder(
            borderRadius: borderradius,
            borderSide: BorderSide(color: theme.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderradius,
            borderSide: BorderSide(color: theme.secondary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderradius,
            borderSide: BorderSide(color: theme.secondary),
          ),
        ),
      ),
    );
  }
}
