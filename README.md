# MAD Project 2 (MedihBook)

This Flutter app already has Firebase dependencies and app initialization configured. This guide explains how to **set up Firebase**, then use **Firebase Authentication** and **Cloud Firestore** (only) for this project.

## 1) Prerequisites

- Flutter SDK installed
- A Firebase project (in [Firebase Console](https://console.firebase.google.com/))
- FlutterFire CLI installed:

```bash
dart pub global activate flutterfire_cli
```

Make sure your `$PATH` includes pub global binaries so `flutterfire` is available.

---

## 2) Firebase setup for this app

From this project root:

```bash
flutterfire configure
```

What this does:
- Links this Flutter app to your Firebase project
- Enables selected platforms
- Generates/updates `firebase_options.dart`

> This repository already initializes Firebase in `main.dart` using `DefaultFirebaseOptions.currentPlatform`.

---

## 3) Enable Authentication (Email/Password)

In Firebase Console:
1. Go to **Build → Authentication → Sign-in method**.
2. Enable **Email/Password** provider.

### Use in Flutter

Import:

```dart
import 'package:firebase_auth/firebase_auth.dart';
```

#### Register user

```dart
final credential = await FirebaseAuth.instance
    .createUserWithEmailAndPassword(
  email: email,
  password: password,
);

final uid = credential.user!.uid;
```

#### Login user

```dart
final credential = await FirebaseAuth.instance
    .signInWithEmailAndPassword(
  email: email,
  password: password,
);

final uid = credential.user!.uid;
```

#### Reset password email

```dart
await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
```

#### Logout

```dart
await FirebaseAuth.instance.signOut();
```

---

## 4) Enable Firestore

In Firebase Console:
1. Go to **Build → Firestore Database**.
2. Create database.
3. Start in test mode for development (then secure with rules below).
4. Pick region close to your users.

### Use in Flutter

Import:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
```

Use a shared instance:

```dart
final db = FirebaseFirestore.instance;
```

---

## 5) Suggested data model (Auth + Firestore only)

### `users/{uid}`
Store profile and role:

```json
{
  "role": "patient",
  "name": "Test Patient",
  "email": "test@example.com",
  "phone": "91511886",
  "dob": "19-02-2007",
  "emergencyContact": "",
  "allergies": ["Peanuts"],
  "surgeries": ["Sinus surgery"],
  "conditions": []
}
```

For doctors, set `role: "doctor"` and include `doctorId` if needed.

### `appointments/{appointmentId}`

```json
{
  "doctorId": "D001",
  "patientUid": "auth-uid",
  "patientName": "Test Patient",
  "dateTime": "Firestore Timestamp",
  "status": "booked"
}
```

### `doctorSlots/{doctorId}/dates/{yyyy-MM-dd}`

```json
{
  "slots": ["09:00", "09:30", "10:00"]
}
```

---

## 6) Common Firestore operations for this app

### Create or update profile

```dart
await FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .set({
  'name': name,
  'email': email,
  'phone': phone,
  'role': 'patient',
}, SetOptions(merge: true));
```

### Read profile

```dart
final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
final data = doc.data();
```

### Create appointment

```dart
await FirebaseFirestore.instance.collection('appointments').add({
  'doctorId': doctorId,
  'patientUid': uid,
  'patientName': patientName,
  'dateTime': Timestamp.fromDate(selectedDateTime),
  'status': 'booked',
});
```

### Query patient appointments

```dart
final snapshot = await FirebaseFirestore.instance
    .collection('appointments')
    .where('patientUid', isEqualTo: uid)
    .orderBy('dateTime')
    .get();
```

### Query doctor appointments for a day

Use day range filtering:

```dart
final start = DateTime(day.year, day.month, day.day);
final end = start.add(const Duration(days: 1));

final snapshot = await FirebaseFirestore.instance
    .collection('appointments')
    .where('doctorId', isEqualTo: doctorId)
    .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
    .where('dateTime', isLessThan: Timestamp.fromDate(end))
    .get();
```

---

## 7) Route by user role after login

After Auth login:
1. Read `users/{uid}`.
2. Check `role`.
3. Navigate:
   - `role == patient` → Patient dashboard
   - `role == doctor` → Doctor dashboard

This replaces local in-memory role checks.

---

## 8) Minimal Firestore security rules (starter)

Use this as a baseline and tighten as needed:

```txt
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    match /appointments/{appointmentId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null
                    && request.resource.data.patientUid == request.auth.uid;
      allow update, delete: if request.auth != null;
    }

    match /doctorSlots/{doctorId}/dates/{dateId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

> For production, enforce stricter role-based writes (doctor-only slot updates, ownership checks, immutable fields, etc.).

---

## 9) Recommended migration path from local services

Current app still contains local in-memory services (`UserDataService`, `AppointmentsDataService`, `SlotsDataService`).

Migrate in this order:
1. **Authentication pages**: register/login/reset to Firebase Auth.
2. **User profile pages**: read/write `users/{uid}` documents.
3. **Appointments + Slots pages**: move to Firestore collections.
4. Remove local services after full cutover.

---

## 10) Useful commands

```bash
flutter pub get
flutter run
```

If you update Firebase project/platform settings later:

```bash
flutterfire configure
```

