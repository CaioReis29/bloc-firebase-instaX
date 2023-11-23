import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instax/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:instax/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:instax/blocs/update_user_info_bloc.dart/update_user_info_bloc.dart';
import 'package:instax/screens/home/post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: (context, state) {
        if (state is UploadPictureSuccess) {
          setState(() {
            context.read<MyUserBloc>().state.user!.picture = state.userImage;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButton: BlocBuilder<MyUserBloc, MyUserState>(
          builder: (context, state) {
            if (state.status == MyUserStatus.success) {
              return FloatingActionButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => PostScreen(
                      myUser: state.user!,
                    ),
                  ),
                ),
                child: const Icon(
                  Icons.add,
                ),
              );
            } else {
              return const FloatingActionButton(
                onPressed: null,
                child: Icon(
                  Icons.clear,
                ),
              );
            }
          },
        ),
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title:
              BlocBuilder<MyUserBloc, MyUserState>(builder: (context, state) {
            if (state.status == MyUserStatus.success) {
              return Row(
                children: [
                  state.user!.picture == "" || state.user!.picture == null
                      ? GestureDetector(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                              maxHeight: 500,
                              maxWidth: 500,
                              imageQuality: 40,
                            );
                            if (image != null) {
                              CroppedFile? croppedFile =
                                  await ImageCropper().cropImage(
                                sourcePath: image.path,
                                aspectRatio: const CropAspectRatio(
                                  ratioX: 1,
                                  ratioY: 1,
                                ),
                                aspectRatioPresets: [
                                  CropAspectRatioPreset.square
                                ],
                                uiSettings: [
                                  AndroidUiSettings(
                                    toolbarTitle: 'Cropper',
                                    toolbarColor:
                                        const Color.fromRGBO(206, 147, 216, 1),
                                    toolbarWidgetColor: Colors.white,
                                    initAspectRatio:
                                        CropAspectRatioPreset.original,
                                    lockAspectRatio: false,
                                  ),
                                  IOSUiSettings(
                                    title: 'Cropper',
                                  ),
                                ],
                              );
                              if (croppedFile != null) {
                                setState(() {
                                  context.read<UpdateUserInfoBloc>().add(
                                        UploadPicture(
                                          croppedFile.path,
                                          context
                                              .read<MyUserBloc>()
                                              .state
                                              .user!
                                              .id,
                                        ),
                                      );
                                });
                              }
                            }
                          },
                          child: Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person)),
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                state.user!.picture!,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Bem-vindo, Caio",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            } else if (state.status == MyUserStatus.loading) {
              return Container();
            } else {
              return Container();
            }
          }),
          actions: [
            IconButton(
              onPressed: () => context.read<SignInBloc>().add(
                    const SignOutRequired(),
                  ),
              icon: Icon(
                Icons.login_outlined,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                // height: 400,
                // color: Colors.blue,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Caio",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("2023-04-12"),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: const Text(
                          "f iuqwefqowebfuqewf87qefuqiewfpebfqubufewfipewuifqiufiewbf7bwefubqwubfuwefiqwebfkuiwefqweofuqeqwiuffieoqwfqhbwefiueewoqin[erj0wunr09u320[rcnu23r9u[439urcn ru43ru29jrcmu934r]]]",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
