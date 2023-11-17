import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:instax/components/strings.dart';
import 'package:instax/components/text_field.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isSecret = true;
  String? errorMsg;

  bool signInRequired = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.9,
            child: MyTextField(
              controller: emailController,
              hintText: "E-mail",
              isObscure: false,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(CupertinoIcons.mail_solid),
              errorMessage: errorMsg,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Esse campo precisa ser preenchido";
                } else if (!emailRegExp.hasMatch(value)) {
                  return "E-mail inválido";
                } else {
                  return null;
                }
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.9,
            child: MyTextField(
              controller: passwordController,
              hintText: "Senha",
              isObscure: isSecret,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: const Icon(CupertinoIcons.lock_fill),
              errorMessage: errorMsg,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Esse campo precisa ser preenchido";
                } else if (!passwordRegExp.hasMatch(value)) {
                  return "Senha inválida inválido";
                } else {
                  return null;
                }
              },
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isSecret = !isSecret;
                  });
                },
                icon: Icon(isSecret
                    ? CupertinoIcons.eye_slash_fill
                    : CupertinoIcons.eye_fill),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          !signInRequired
              ? SizedBox(
                  height: 50,
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  child: TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<SignInBloc>().add(
                              SignInRquired(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                      }
                    },
                    style: TextButton.styleFrom(
                      elevation: 6,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                      child: Text(
                        "Entrar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              : const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
