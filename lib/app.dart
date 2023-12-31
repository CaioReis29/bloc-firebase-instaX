import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/app_view.dart';
import 'package:instax/blocs/auth_bloc/authentication_bloc.dart';
import 'package:instax/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MyUserBloc(
            myUserRepository: context.read<AuthenticationBloc>().userRepository,
          )..add(
              GetMyUser(
                myUserId: context.read<AuthenticationBloc>().state.user!.uid,
              ),
            ),
        ),
        RepositoryProvider<AuthenticationBloc>(
          create: (c) => AuthenticationBloc(myUserRepository: userRepository),
        ),
      ],
      child: const AppView(),
    );
  }
}
