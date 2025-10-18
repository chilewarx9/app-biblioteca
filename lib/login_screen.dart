import 'package:app_tareas/login_fields.dart'; // Importa un archivo donde están los campos del formulario de login
import 'package:flutter/material.dart'; // Importa el paquete de Flutter para construir la interfaz

class LoginScreen extends StatelessWidget { // Crea una pantalla de login que no cambia (StatelessWidget)
  const LoginScreen({super.key}); // Constructor que permite pasar una clave única al widget

  @override
  Widget build(BuildContext context) {
    // Construye la estructura visual de la pantalla
    return Scaffold(
      appBar: AppBar(title: const Text("Login")), // Barra superior con el título "Login"
      body: SafeArea( // Asegura que el contenido no se meta debajo de cosas como la barra de estado
        child: Center( // Centra el contenido en la pantalla
          child: SingleChildScrollView( // Permite hacer scroll si el contenido es más grande que la pantalla
            padding: const EdgeInsets.all(16), // Agrega espacio alrededor del contenido
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420), // Limita el ancho del contenido
              child: LoginFields(), // Muestra los campos de texto y botones definidos en otro archivo
            ),
          ),
        ),
      ),
    );
  }
}
