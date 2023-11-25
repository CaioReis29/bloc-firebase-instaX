import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:instax/components/strings.dart';
import 'package:instax/components/text_field.dart';
import 'package:user_repository/user_repository.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  bool isSecret = true;

  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
          });
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          return;
        }
      },
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.9,
              child: MyTextField(
                controller: nameController,
                hintText: "Nome",
                isObscure: false,
                keyboardType: TextInputType.name,
                prefixIcon: Icon(
                  CupertinoIcons.person_crop_circle,
                  color: Colors.grey[700],
                  size: 30,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Esse campo precisa ser preenchido";
                  } else if (value.length > 30) {
                    return "Este campo não pode ter mais de 30 caracteres";
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
                controller: emailController,
                hintText: "E-mail",
                isObscure: false,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(
                  CupertinoIcons.mail_solid,
                  color: Colors.grey[700],
                ),
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
                prefixIcon: Icon(
                  CupertinoIcons.lock_fill,
                  color: Colors.grey[700],
                ),
                onChanged: (value) {
                  if (value!.contains(RegExp(r'[A-Z]'))) {
                    setState(() {
                      containsUpperCase = true;
                    });
                  } else {
                    setState(() {
                      containsUpperCase = false;
                    });
                  }
                  if (value.contains(RegExp(r'[a-z]'))) {
                    setState(() {
                      containsLowerCase = true;
                    });
                  } else {
                    setState(() {
                      containsLowerCase = false;
                    });
                  }
                  if (value.contains(RegExp(r'[0-9]'))) {
                    setState(() {
                      containsNumber = true;
                    });
                  } else {
                    setState(() {
                      containsNumber = false;
                    });
                  }
                  if (value.contains(specialCharRegExp)) {
                    setState(() {
                      containsSpecialChar = true;
                    });
                  } else {
                    setState(() {
                      containsSpecialChar = false;
                    });
                  }
                  if (value.length >= 8) {
                    setState(() {
                      contains8Length = true;
                    });
                  } else {
                    setState(() {
                      contains8Length = false;
                    });
                  }
                  return null;
                },
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
                  icon: Icon(
                    isSecret
                        ? CupertinoIcons.eye_slash_fill
                        : CupertinoIcons.eye_fill,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "●  1 Letra maiúscula",
                      style: TextStyle(
                        color: containsUpperCase ? Colors.green : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "●  1 Letra minúscula",
                      style: TextStyle(
                        color: containsLowerCase ? Colors.green : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "●  1 Número",
                      style: TextStyle(
                        color: containsNumber ? Colors.green : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "●  1 Caractere especial",
                      style: TextStyle(
                        color:
                            containsSpecialChar ? Colors.green : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "●  8 Caracteres no mínimo",
                      style: TextStyle(
                        color: contains8Length ? Colors.green : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            !signUpRequired
                ? SizedBox(
                    height: 50,
                    width: MediaQuery.sizeOf(context).width * 0.9,
                    child: TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          MyUser myUser = MyUser.empty;
                          myUser = myUser.copyWith(
                            email: emailController.text,
                            name: nameController.text,
                          );
                          setState(() {
                            context.read<SignUpBloc>().add(
                                  SignUpRequired(
                                    user: myUser,
                                    password: passwordController.text,
                                  ),
                                );
                          });
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
                          "Cadastrar",
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
      ),
    );
  }
}
