Eliminar usuarios de prueba (Firebase Auth)

1) Generar una clave de servicio en Firebase Console:
   - Project settings -> Service accounts -> Generate new private key
   - Guarda el JSON en una ruta local segura, por ejemplo: C:\path\to\serviceAccountKey.json

2) En PowerShell (desde la carpeta app_tareas/scripts):

   # Establece la variable de entorno apuntando al JSON (temporal para la sesión)
   $env:GOOGLE_APPLICATION_CREDENTIALS = 'C:\path\to\serviceAccountKey.json'

   # Inicializa npm e instala dependencias (si no lo hiciste antes)
   npm init -y
   npm install firebase-admin

   # Edita users_to_delete.txt y añade los emails a eliminar (uno por línea)
   node delete_users.js

3) El script intentará borrar cada email listado y te mostrará éxitos/errores en la consola.

Precaución: este script borra usuarios de tu proyecto Firebase. No lo ejecutes en proyectos de producción sin verificar los emails.
