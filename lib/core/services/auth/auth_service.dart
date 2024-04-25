import 'dart:io';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_firebase_service.dart';

abstract class AuthService {
  ChatUser? get currentUser;

  Stream<ChatUser?> get userChanges;

  Future<void> signup(
    String nome,
    String email,
    String password,
    File? image,
  );

  Future<void> login(
    String email,
    String password,
  );

  Future<void> logout();

  // Um construtor factory é um tipo especial de construtor
  // que não necessariamente cria uma nova instância da classe
  // em que está definido. Em vez disso, pode retornar uma instância
  // de uma subclasse, outra classe ou até mesmo uma instância já existente.
  factory AuthService() {
    // return AuthMockService();
    return AuthFirebaseService();
  }
}
