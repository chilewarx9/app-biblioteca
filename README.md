# 📚 App Biblioteca Digital - INACAP

Aplicación móvil desarrollada en Flutter con Firebase para la gestión de biblioteca personal.

## 👥 Equipo de Desarrollo
- Kevin Bustos
- Ismael Valdivia
- Javier Muñoz

## 🚀 Funcionalidades Implementadas

### Autenticación (RF1-RF6)
- ✅ Registro de usuarios con email/contraseña (Firebase Auth)
- ✅ Login con validaciones de formato
- ✅ Validación: email debe contener "@"
- ✅ Validación: contraseña mínimo 6 caracteres
- ✅ Mensajes de error específicos
- ✅ Navegación automática post-login

### Gestión de Libros (RF7-RF15)
- ✅ Listado de 5 libros precargados automáticamente
- ✅ Estados derivados: Almacenado, Prestado, Vencido
- ✅ Búsqueda en tiempo real por título y notas
- ✅ Filtros rápidos por estado (Chips)
- ✅ Marcar libro como completado (checkbox)
- ✅ Crear nuevos libros con validaciones
- ✅ Eliminar libros con confirmación (swipe)
- ✅ Ordenamiento por fecha de creación
- ✅ Datos persistentes en la nube (Firestore)

## 🛠️ Tecnologías Utilizadas

- **Flutter** 3.x
- **Firebase Authentication** - Gestión de usuarios
- **Cloud Firestore** - Base de datos en tiempo real
- **Dart** 3.x

## 📦 Dependencias Principales
```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.8.1
  firebase_auth: ^5.3.3
  cloud_firestore: ^5.5.2
```

## 🔧 Instalación y Ejecución

### Prerrequisitos
- Flutter SDK instalado
- Android Studio con emulador configurado

### Pasos para ejecutar

1. **Clonar el repositorio:**
```bash
git clone https://github.com/chilewarx9/app-biblioteca.git
cd app_tareas
```

2. **Instalar dependencias:**
```bash
flutter pub get
```

3. **Iniciar emulador Android:**
```bash
flutter emulators --launch Medium_Phone_API_36.0 *debe estar iniciado el emulador en android studio*
```

4. **Ejecutar la aplicación:**
```bash
flutter run
```

## 👤 Usuarios de Prueba

Para facilitar la evaluación, puedes usar estos usuarios o crear nuevos:

- **Email:** `1@gmail.com`
- **Password:** `racergsi12`

O registrar nuevos usuarios desde la app.

## 🔥 Configuración de Firebase

Este proyecto usa Firebase Authentication y Cloud Firestore.
La configuración ya está incluida en el repositorio para facilitar la evaluación.

### Reglas de Seguridad (Firestore)
Los usuarios solo pueden acceder a sus propios libros (filtrado por `userId`).

## 📱 Video demostrativo breve:

https://youtu.be/yADp8YtPAbQ

## 🎓 Contexto Académico

**Asignatura:** Aplicaciones Móviles para IoT  
**Institución:** INACAP  
**Período:** Primavera 2025  
**Evaluación:** Sumativa Grupal - Unidad "Fundamentos de Flutter"

### Requisitos Cumplidos

#### Login (RF1-RF6)
- [x] Autenticación real con Firebase
- [x] Validación de formato de correo
- [x] Validación de contraseña (min 6 caracteres)
- [x] Mensajes de error personalizados
- [x] Botón de ingreso con validaciones
- [x] Navegación a pantalla principal

#### Vista Principal (RF7-RF15)
- [x] Listado con título, nota y fecha
- [x] Estados derivados con estilos diferenciados
- [x] Barra de búsqueda funcional
- [x] Filtros rápidos (chips)
- [x] Toggle para marcar completado
- [x] Creación de libros con validaciones
- [x] Eliminación con confirmación
- [x] Orden por fecha
- [x] Restricción: no editar (solo crear/eliminar)
- [x] Estilo corporativo (rojo INACAP)

## 📂 Estructura del Proyecto
```
lib/
├── main.dart                    # Punto de entrada, inicialización Firebase
├── firebase_options.dart        # Configuración Firebase (auto-generado)
├── models/
│   └── book.dart               # Modelo de datos Book
├── repositories/
│   ├── auth_repository.dart           # Lógica de autenticación
│   └── firestore_book_repository.dart # Lógica de Firestore
├── controllers/
│   ├── auth_controller.dart     # Controlador de autenticación
│   └── book_controller.dart     # Controlador de libros
├── login_screen.dart            # Pantalla de login
├── login_fields.dart            # Formulario de login
└── book_screen.dart             # Pantalla principal de libros
```

## 🔒 Seguridad

- Autenticación obligatoria para acceder a datos
- Reglas de Firestore: usuarios solo ven sus propios libros
- Contraseñas manejadas por Firebase Auth (encriptadas)

## ⚠️ Nota Importante

Este es un proyecto académico con repositorio privado. Las configuraciones (repo publico por ahora para ser evaluado)
de Firebase están incluidas solo para fines educativos y de evaluación.

## 📄 Licencia

Proyecto desarrollado con fines académicos - INACAP 2025
