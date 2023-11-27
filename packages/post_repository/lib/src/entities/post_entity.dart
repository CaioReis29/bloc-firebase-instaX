import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

// ignore: must_be_immutable
class PostEntity extends Equatable {
  String postId;
  String post;
  String picturePost;
  DateTime createdAt;
  MyUser myUser;

  PostEntity({
    required this.postId,
    required this.post,
    required this.picturePost,
    required this.createdAt,
    required this.myUser,
  });

  Map<String, Object?> toDocument() {
    return {
      "postId": postId,
      "post": post,
      "picturePost": picturePost,
      "createdAt": createdAt,
      "myUser": myUser.toEntity().toDocument(),
    };
  }

  static PostEntity fromDocument(Map<String, dynamic> doc) {
    return PostEntity(
      postId: doc["postId"] as String,
      post: doc["post"] as String,
      picturePost: doc["picturePost"] as String,
      createdAt: (doc["createdAt"] as Timestamp).toDate(),
      myUser: MyUser.fromEntity(
        MyUserEntity.fromDocument(doc["myUser"]),
      ),
    );
  }

  @override
  List<Object?> get props => [postId, post, picturePost, createdAt, myUser];

  @override
  String toString() {
    return '''PostEntity: {
      postId: $postId,
      post: $post,
      picturePost: $picturePost,
      createdAt: $createdAt,
      myUser: $myUser,
    }
    ''';
  }
}
