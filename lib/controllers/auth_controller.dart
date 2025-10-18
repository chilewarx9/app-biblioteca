import 'package:app_tareas/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  AuthController(this._repo);
  final AuthRepository _repo;

  // Login existente (ya lo tienes)
  Future<String?> login(String email, String password) async {
    try {
      await _repo.signIn(email, password);
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapErrorCode(e.code);
    }
  }

  // NUEVO: Registro de usuario
  Future<String?> register(String email, String password) async {
    try {
      await _repo.register(email, password);
      return null; // Éxito
    } on FirebaseAuthException catch (e) {
      return _mapErrorCode(e.code);
    }
  }

  // NUEVO: Eliminar cuenta actual
  Future<void> deleteCurrentUser() async {
    await _repo.deleteCurrentUser();
  }

  // NUEVO: Cerrar sesión
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // NUEVO: Verificar si está logueado
  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

  // Mapeo de errores (ampliado)
  String _mapErrorCode(String code) {
    switch (code) {
      case 'wrong-password':
        return 'Usuario o contraseña incorrecta';
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'invalid-email':
        return 'Email inválido';
      case 'user-disabled':
        return 'Usuario no habilitado';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      case 'operation-not-allowed':
        return 'El método de autenticación no está habilitado en Firebase';
      case 'email-already-in-use':
        return 'Este correo ya está registrado';
      case 'weak-password':
        return 'La contraseña es muy débil (mínimo 6 caracteres)';
      case 'invalid-credential':
        return 'Credenciales inválidas';
      case 'user-not-signed-in':
        return 'No hay usuario autenticado';
      case 'requires-recent-login':
        return 'Por seguridad, inicia sesión nuevamente';
      default:
        return 'No se puede completar la operación ($code)';
    }
  }
}
