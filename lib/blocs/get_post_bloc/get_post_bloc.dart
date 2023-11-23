import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';

part 'get_post_event.dart';
part 'get_post_state.dart';

class GetPostBloc extends Bloc<GetPostEvent, GetPostState> {
  PostRepository postRepository;
  GetPostBloc({required PostRepository myPostRepository})
      : postRepository = myPostRepository,
        super(GetPostInitial()) {
    on<GetPosts>((event, emit) async {
      emit(GetPostLoading());
      try {
        List<Post> posts = await postRepository.getPost();
        emit(GetPostSuccess(posts));
      } catch (e) {
        emit(GetPostFailure());
      }
    });
  }
}
