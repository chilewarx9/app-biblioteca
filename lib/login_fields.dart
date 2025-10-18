import 'package:app_tareas/controllers/auth_controller.dart';
import 'package:app_tareas/repositories/auth_repository.dart';
import 'package:app_tareas/book_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginFields extends StatefulWidget {
  const LoginFields({super.key});

  @override
  State<LoginFields> createState() => _LoginFieldsState();
}

class _LoginFieldsState extends State<LoginFields> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  String? _error;

  final AuthController _auth = AuthController(AuthRepository());

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) {
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final email = _emailCtrl.text.trim();
      final password = _passCtrl.text.trim();

      final errorMessage = await _auth.login(email, password);

      if (!mounted) {
        return;
      }

      if (errorMessage == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const BookScreen()),
        );
      } else {
        setState(() {
          _error = errorMessage;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Image.network(
                "https://i.ibb.co/gbM1xQbB/logo-inacap.jpg",
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Bienvenido Inacapino",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            TextFormField(
              enabled: !_loading,
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              enableSuggestions: true,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "ejemplo@ejemplo.com",
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final value = v?.trim() ?? '';
                if (value.isEmpty) return "Ingresa tu email";
                final emailOk = RegExp(r'^\S+@\S+\.\S+$').hasMatch(value);
                return emailOk ? null : "Email inválido";
              },
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              enabled: !_loading,
              controller: _passCtrl,
              obscureText: _obscure,
              enableSuggestions: false,
              autocorrect: false,
              autofillHints: const [AutofillHints.password],
              decoration: InputDecoration(
                labelText: "Contraseña",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  tooltip: _obscure ? "Mostrar" : "Ocultar",
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return "Ingrese la contraseña";
                if (v.length < 6) return "Mínimo 6 caracteres";
                return null;
              },
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 8),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text("Ingresar"),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loading ? null : () {},
              child: const Text("¿Olvidaste tu contraseña?"),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            // Registrar usuario
            SizedBox(
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: _loading
                    ? null
                    : () async {
                        final repo = AuthRepository();

                        // capturamos el messenger antes del await para no volver a
                        // usar `context` después del gap asíncrono.
                        final scaffoldMessenger = ScaffoldMessenger.of(context);

                        final result = await showDialog<Map<String, String>?>(
                          context: context,
                          builder: (context) {
                            final eCtrl = TextEditingController();
                            final pCtrl = TextEditingController();
                            return AlertDialog(
                              title: const Text('Registrar usuario'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: eCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                    ),
                                  ),
                                  TextField(
                                    controller: pCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Password',
                                    ),
                                    obscureText: true,
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(null),
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop({
                                    'e': eCtrl.text.trim(),
                                    'p': pCtrl.text.trim(),
                                  }),
                                  child: const Text('Registrar'),
                                ),
                              ],
                            );
                          },
                        );

                        if (result == null) {
                          return;
                        }

                        final email = result['e'] ?? '';
                        final pass = result['p'] ?? '';

                        if (email.isEmpty || pass.isEmpty) {
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              content: Text('Email y password requeridos'),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          _loading = true;
                          _error = null;
                        });

                        try {
                          await repo.register(email, pass);

                          if (!mounted) {
                            return;
                          }

                          // usamos la referencia capturada en lugar de llamar de nuevo a ScaffoldMessenger.of(context)
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              content: Text('Usuario registrado con éxito'),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          if (!mounted) {
                            return;
                          }
                          final msg = e.message ?? 'Error al registrar usuario';
                          setState(() {
                            _error = msg;
                          });
                          scaffoldMessenger.showSnackBar(
                            SnackBar(content: Text(msg)),
                          );
                        } finally {
                          if (mounted) {
                            setState(() => _loading = false);
                          }
                        }
                      },
                child: const Text('Registrar usuario'),
              ),
            ),
            const SizedBox(height: 8),
            // Eliminar cuenta
            SizedBox(
              height: 44,
              child: OutlinedButton(
                onPressed: _loading
                    ? null
                    : () async {
                        setState(() {
                          _loading = true;
                          _error = null;
                        });
                        final repo = AuthRepository();

                        // capturamos scaffoldMessenger antes del await
                        final scaffoldMessenger = ScaffoldMessenger.of(context);

                        try {
                          await repo.deleteCurrentUser();

                          if (!mounted) {
                            return;
                          }

                          scaffoldMessenger.showSnackBar(
                            const SnackBar(content: Text('Usuario eliminado')),
                          );
                        } on FirebaseAuthException catch (e) {
                          if (!mounted) {
                            return;
                          }
                          final msg = e.message ?? 'Error al eliminar usuario';
                          setState(() {
                            _error = msg;
                          });
                          scaffoldMessenger.showSnackBar(
                            SnackBar(content: Text(msg)),
                          );
                        } catch (e) {
                          if (!mounted) {
                            return;
                          }
                          final msg = 'Error inesperado: $e';
                          setState(() {
                            _error = msg;
                          });
                          scaffoldMessenger.showSnackBar(
                            SnackBar(content: Text(msg)),
                          );
                        } finally {
                          if (mounted) {
                            setState(() => _loading = false);
                          }
                        }
                      },
                child: const Text('Eliminar cuenta actual'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
