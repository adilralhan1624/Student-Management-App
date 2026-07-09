# Student Management App

A full-stack student registration and management app — Flutter frontend, PHP REST API backend, MySQL database.

## What it does

- Register students with name, roll number, email, and CGPA (with input validation)
- View all registered students in a styled list
- Data is stored in a MySQL database and served through a PHP API

## Tech stack

- **Frontend:** Flutter (Dart) — `http` package for API calls
- **Backend:** PHP (MySQLi) — simple REST-style endpoints
- **Database:** MySQL

## Setup

**1. Database**
Run the SQL in `SQL Table script.txt` in your MySQL/phpMyAdmin (e.g. via XAMPP) to create the `student_db` database and `students` table.

**2. Backend**
Place `insert_student.php` and `fetch_students.php` in your local server's web root (e.g. `htdocs/student_api/` for XAMPP).

**3. Frontend**
This repo includes the core Flutter source (`lib/main.dart`, `pubspec.yaml`). To run it locally:
1. Create a new Flutter project: `flutter create student_management`
2. Replace the generated `lib/main.dart` and `pubspec.yaml` with the ones from this repo
3. Update the `baseUrl` variable in `main.dart` to match your local server's IP address:
```dart
   final String baseUrl = "http://YOUR_LOCAL_IP/student_api";
```
4. Run:
```bash
   flutter pub get
   flutter run
```

## Notes

Built as a university assignment to practice connecting a Flutter frontend to a PHP/MySQL backend via REST-style API calls. Platform-specific build folders (android, ios, web, etc.) are excluded since Flutter regenerates them automatically with `flutter create .`.
