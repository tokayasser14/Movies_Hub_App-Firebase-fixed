import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/edit-profile/edit_profile_cubit.dart';
import '../cubits/edit-profile/edit_profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String currentPhone;
  final String currentPassword;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentEmail,
    required this.currentPhone,
    required this.currentPassword,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isPasswordVisible = false;

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController phoneController;
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.currentEmail);
    passwordController = TextEditingController(text: widget.currentPassword);
    phoneController = TextEditingController(text: widget.currentPhone);
    usernameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    usernameController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  void saveChanges() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String phone = phoneController.text.trim();
    String username = usernameController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your username')),
      );
      return;
    }

    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your email')));
      return;
    }

    if (!email.contains('@') || !email.endsWith('.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your password')),
      );
      return;
    }

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }

    if (username.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('user name must not exceed 20 characters.'),
        ),
      );
      return;
    }

    if (phone.length != 11 ||
        (!phone.startsWith('011') &&
            !phone.startsWith('012') &&
            !phone.startsWith('015') &&
            !phone.startsWith('010'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please Enter a Valid Phone Number')),
      );
      return;
    }

    await context.read<ProfileCubit>().updateUserData(
      newName: username,
      newEmail: email,
      newPhone: phone,
      newPassword: password,
    );

    Navigator.pop(context);
  }

=======
>>>>>>> 35c5f8aa1ea0eb58d609a468c026a1032e4c2199
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
<<<<<<< HEAD
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. User Name Field
              TextField(
                controller: usernameController,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'User Name',
                  hintStyle: const TextStyle(
                    color: Color(0xFF939392),
                    fontSize: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
=======
      body: BlocListener<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage,
                  style: const TextStyle(color: Colors.black),
>>>>>>> 35c5f8aa1ea0eb58d609a468c026a1032e4c2199
                ),
                backgroundColor: Colors.white,
              ),
<<<<<<< HEAD

              const SizedBox(height: 8),

              // 2. Email Field
              TextField(
                controller: emailController,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'E-mail',
                  hintStyle: const TextStyle(
                    color: Color(0xFF939392),
                    fontSize: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF2D2B2D)),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
=======
            );
          } else if (state is EditProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Profile updated successfully!',
                  style: TextStyle(color: Colors.black),
>>>>>>> 35c5f8aa1ea0eb58d609a468c026a1032e4c2199
                ),
                backgroundColor: Colors.white,
              ),
<<<<<<< HEAD

              const SizedBox(height: 8),

              // 3. Phone Field
              TextField(
                controller: phoneController,
                maxLength: 11,
                style: const TextStyle( fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  hintStyle: const TextStyle(
                    color: Color(0xFF939392),
                    fontSize: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                   borderSide: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
=======
            );
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // username
                TextField(
                  controller: usernameController,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'User Name',
                    hintStyle: const TextStyle(color: Color(0xFF939392), fontSize: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFF2D2B2D)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFFF52B3B)),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF121011),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                ),

                const SizedBox(height: 8),

                // email
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'E-mail',
                    hintStyle: const TextStyle(color: Color(0xFF939392), fontSize: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFF2D2B2D)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFFF52B3B)),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF121011),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                ),

                const SizedBox(height: 8),

                // phone
                TextField(
                  controller: phoneController,
                  maxLength: 11,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    hintStyle: const TextStyle(color: Color(0xFF939392), fontSize: 12),
                    counterStyle: const TextStyle(color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFF2D2B2D)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFFF52B3B)),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF121011),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                ),

                const SizedBox(height: 8),

                // password
                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Color(0xFF939392), fontSize: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFF2D2B2D)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFFF52B3B)),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF121011),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF939392),
                      ),
                    ),
                  ),
>>>>>>> 35c5f8aa1ea0eb58d609a468c026a1032e4c2199
                ),

                const SizedBox(height: 59),

<<<<<<< HEAD
              // 4. Password Field
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                style: const TextStyle( fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(
                    color: Color(0xFF939392),
                    fontSize: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
=======
                // Save Changes button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: BlocBuilder<EditProfileCubit, EditProfileState>(
                    builder: (context, state) {
                      if (state is EditProfileLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Color(0xFFF52B3B)),
                        );
                      }

                      return ElevatedButton(
                        onPressed: () {
                          context.read<EditProfileCubit>().updateUserData(
                                newName: usernameController.text.trim(),
                                newEmail: emailController.text.trim(),
                                newPhone: phoneController.text.trim(),
                                newPassword: passwordController.text.trim(),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF52B3B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
>>>>>>> 35c5f8aa1ea0eb58d609a468c026a1032e4c2199
                    },
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