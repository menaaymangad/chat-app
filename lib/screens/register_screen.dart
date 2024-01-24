// ignore_for_file: use_build_context_synchronously, avoid_print, unused_local_variable

import 'package:chatapp/constants/consts.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/widgets/custom_button.dart';
import 'package:chatapp/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants/show_snack_bar.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static String id = 'RegisterScreen';
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? emailAddress;

  String? password;

  String? firstName;

  String? lastName;
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
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
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
                      height: 100,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            function: (data) {
                              firstName = data;
                            },
                            label: 'First Name',
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomTextField(
                            function: (data) {
                              lastName = data;
                            },
                            label: 'Last Name',
                          ),
                        ),
                      ],
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
                            await registerUser();
                            ShowSnackBar(context, 'Success.');
                            Navigator.pushNamed(context, ChatScreen.id,arguments: emailAddress);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              ShowSnackBar(context, 'weak-password');
                            } else if (e.code == 'email-already-in-use') {
                              ShowSnackBar(context,
                                  'The account already exists for that email.');
                            }
                          } catch (e) {
                            print(e);
                          }
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },
                      buttonName: 'Register',
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'You already have an account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Login',
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

  Future<void> registerUser() async {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress!,
      password: password!,
    );
  }
}
