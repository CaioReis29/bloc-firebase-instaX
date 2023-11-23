import 'package:equatable/equatable.dart';
import 'package:user_repository/src/entities/entities.dart';

// ignore: must_be_immutable
class MyUser extends Equatable {
  final String id;
  final String email;
  final String name;
  String? picture;

  MyUser({
    required this.id,
    required this.email,
    required this.name,
    this.picture,
  });

  // usuário não encontrado

  static final empty = MyUser(
    id: '',
    email: '',
    name: '',
    picture: '',
  );

  // modificar parâmetros de usuário

  MyUser copyWith({
    String? id,
    String? email,
    String? name,
    String? picture,
  }) {
    return MyUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      picture: picture ?? this.picture,
    );
  }

  // getter em caso de usuário estar vazio

  bool get isEmpty => this == MyUser.empty;

  // getter em caso de usuário não estar vazio

  bool get isNotEmpty => this != MyUser.empty;

  MyUserEntity toEntity() {
    return MyUserEntity(
      id: id,
      email: email,
      name: name,
      picture: picture,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      picture: entity.picture,
    );
  }

  @override
  List<Object?> get props => [id, email, name, picture];
}
