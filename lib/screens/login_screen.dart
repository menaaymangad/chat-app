// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:chatapp/constants/consts.dart';
import 'package:chatapp/constants/show_snack_bar.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/custom_text_field.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'LoginScreen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? emailAddress;

  String? password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: KPrimaryColor,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Chat App',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomTextField(
                      function: (data) {
                        emailAddress = data;
                      },
                      label: 'Email',
                      hint: 'Enter your email address',
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomTextField(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      obsecure: !_passwordVisible,
                      function: (data) {
                        password = data;
                      },
                      label: 'Password',
                      hint: 'Enter your password',
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomButton(
                      function: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await loginUser();
                            ShowSnackBar(context, 'login success.');
                            Navigator.pushNamed(context, ChatScreen.id,
                                arguments: emailAddress);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              ShowSnackBar(
                                  context, 'No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              ShowSnackBar(context,
                                  'Wrong password provided for that user.');
                            }
                          }
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },
                      buttonName: 'Login',
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'don\'t have an account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              'RegisterScreen',
                            );
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress!, password: password!);
  }
}
