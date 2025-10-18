/*
Script para eliminar usuarios de Firebase Auth por email.

Instrucciones:
1) Descarga el JSON de la cuenta de servicio desde Firebase Console (Project Settings -> Service accounts -> Generate new private key).
2) Guarda el JSON en una ubicación segura. No subirlo al repo.
3) Edita `users_to_delete.txt` con un email por línea (ej: ismael@gmail.com).
4) En PowerShell, desde la carpeta `app_tareas/scripts`:
   $env:GOOGLE_APPLICATION_CREDENTIALS = 'C:\ruta\a\serviceAccountKey.json'
   npm init -y
   npm install firebase-admin
   node delete_users.js

El script usa la variable de entorno GOOGLE_APPLICATION_CREDENTIALS para localizar la credencial.
*/

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

const usersFile = path.join(__dirname, 'users_to_delete.txt');

if (!process.env.GOOGLE_APPLICATION_CREDENTIALS) {
  console.error('ERROR: Set GOOGLE_APPLICATION_CREDENTIALS env var to the service account JSON path.');
  console.error('Example (PowerShell): $env:GOOGLE_APPLICATION_CREDENTIALS = "C:\\\\path\\\\to\\\\serviceAccountKey.json"');
  process.exit(1);
}

admin.initializeApp();

async function main() {
  if (!fs.existsSync(usersFile)) {
    console.error('users_to_delete.txt not found. Create it with one email per line.');
    process.exit(1);
  }
  const data = fs.readFileSync(usersFile, 'utf8')
    .split(/\r?\n/)
    .map(s => s.trim())
    .filter(Boolean);

  if (data.length === 0) {
    console.log('No emails found in users_to_delete.txt');
    return;
  }

  for (const email of data) {
    try {
      const userRecord = await admin.auth().getUserByEmail(email);
      await admin.auth().deleteUser(userRecord.uid);
      console.log(`Deleted user: ${email}`);
    } catch (err) {
      console.error(`Failed to delete ${email}:`, err.message || err);
    }
  }
}

main().catch(err => {
  console.error('Fatal error:', err);
  process.exit(1);
});
