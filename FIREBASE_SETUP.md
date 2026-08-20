# Firebase setup for Movies Hub

The app code is ready for Firebase Authentication and Cloud Firestore. These
steps must be completed once by a team member who owns the shared Firebase
project, then the generated configuration files should be committed or shared
with the team.

1. Create or open the team Firebase project at https://console.firebase.google.com.
2. In **Authentication > Sign-in method**, enable **Email/Password**.
3. In **Firestore Database**, create a database in production mode.
4. Install the FlutterFire CLI and run this command from the project root:

   ```powershell
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

   Select the team Firebase project and the platforms the team will use. This
   creates `lib/firebase_options.dart` and adds the required native Firebase
   files, such as `android/app/google-services.json`.
5. Update `lib/main.dart` to use the generated options:

   ```dart
   import 'firebase_options.dart';

   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   ```

6. In **Firestore Database > Rules**, publish the following rules. They make
   every user able to read and write only their own profile and favourites:

   ```text
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow create: if request.auth != null && request.auth.uid == userId;
         allow read, update, delete: if request.auth != null && request.auth.uid == userId;

         match /favorites/{movieId} {
           allow read, write: if request.auth != null && request.auth.uid == userId;
         }
       }
     }
   }
   ```

## Stored data

- `users/{uid}`: `name`, `email`, `phone`, and `createdAt`.
- `users/{uid}/favorites/{movieId}`: the movie information needed to restore
  the user's watchlist after signing in again.

Passwords are handled by Firebase Authentication and are never saved in
Firestore.
