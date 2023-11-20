import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/blocs/auth_bloc/authentication_bloc.dart';
import 'package:instax/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:instax/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:instax/blocs/update_user_info_bloc.dart/update_user_info_bloc.dart';
import 'package:instax/screens/home/home_screen.dart';
import 'package:instax/screens/auth/welcome_screen.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "InstaX",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          background: Colors.white,
          onBackground: Colors.white,
          primary: Color.fromRGBO(206, 147, 216, 1),
          secondary: Colors.black,
          onSecondary: Color.fromRGBO(244, 143, 177, 1),
          tertiary: Color.fromRGBO(255, 204, 128, 1),
          error: Colors.red,
          outline: Color(0xFF424242),
        ),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticaded) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SignInBloc(
                    myUserRepository:
                        context.read<AuthenticationBloc>().userRepository,
                  ),
                ),
                BlocProvider(
                  create: (context) => UpdateUserInfoBloc(
                    myUserRepository:
                        context.read<AuthenticationBloc>().userRepository,
                  ),
                ),
                BlocProvider(
                  create: (context) => MyUserBloc(
                    myUserRepository:
                        context.read<AuthenticationBloc>().userRepository,
                  )..add(
                      GetMyUser(
                        myUserId:
                            context.read<AuthenticationBloc>().state.user!.uid,
                      ),
                    ),
                ),
              ],
              child: const HomeScreen(),
            );
          } else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
