import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instax/blocs/create_post_bloc/create_post_bloc.dart';
import 'package:instax/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:instax/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:instax/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:instax/blocs/update_user_info_bloc.dart/update_user_info_bloc.dart';
import 'package:instax/screens/home/post_screen.dart';
import 'package:intl/intl.dart';
import 'package:post_repository/post_repository.dart';

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
                    builder: (context) => BlocProvider<CreatePostBloc>(
                      create: (context) => CreatePostBloc(
                        myPostRepository: FirebasePostRepository(),
                      ),
                      child: PostScreen(
                        myUser: state.user!,
                      ),
                    ),
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
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
                            child: const Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                          ),
                        )
                      : GestureDetector(
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
                              setState(() {
                                context.read<UpdateUserInfoBloc>().add(
                                      UploadPicture(
                                        croppedFile!.path,
                                        context
                                            .read<MyUserBloc>()
                                            .state
                                            .user!
                                            .id,
                                      ),
                                    );
                              });
                            }
                          },
                          child: Container(
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
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Olá, ${state.user!.name}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
              onPressed: () {
                context.read<SignInBloc>().add(
                      const SignOutRequired(),
                    );
              },
              icon: Icon(
                Icons.login_outlined,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: () async => context.read<GetPostBloc>().add(GetPosts()),
          child: BlocBuilder<GetPostBloc, GetPostState>(
            builder: (context, state) {
              if (state is GetPostSuccess) {
                return ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    List<Post> sortedPosts = List.from(state.posts);
                    sortedPosts
                        .sort((a, b) => b.createdAt.compareTo(a.createdAt));
                    final user = sortedPosts[index].myUser;
                    final post = sortedPosts[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: (user.picture != null ||
                                          user.picture != "")
                                      ? Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                user.picture!,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 70,
                                          height: 70,
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('dd/MM/yyy hh:mm').format(
                                        post.createdAt,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                post.post,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 80),
                              child: Divider(
                                color: Colors.grey,
                                height: 0.5,
                                thickness: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is GetPostLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return const Center(
                  child: Text("Erro ao carregar seu feed"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
