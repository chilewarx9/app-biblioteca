// el backup con patas v:
// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AuthRepository({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Future<UserCredential> signIn(String email, String password) async {
    print('Intentando login con email: $email');
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Login exitoso. UID: ${result.user?.uid}');
      return result;
    } catch (e) {
      print('Error en login: $e');
      rethrow;
    }
  }

  Future<UserCredential> register(String email, String password) async {
    print('Intentando registrar email: $email');
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Registro exitoso. UID: ${result.user?.uid}');
      return result;
    } catch (e) {
      print('Error en registro: $e');
      rethrow;
    }
  }

  Future<void> deleteCurrentUser() async {
    print('Intentando eliminar usuario actual');
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-signed-in',
        message: 'No hay usuario autenticado',
      );
    }
    try {
      await user.delete();
      print('Usuario eliminado correctamente');
    } catch (e) {
      print('Error al eliminar usuario: $e');
      rethrow;
    }
  }
}
