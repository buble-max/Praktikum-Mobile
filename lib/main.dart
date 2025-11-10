import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myapp/pages/login_page.dart';
import 'package:myapp/provider/mhs_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:firebase_core/firebase_core.dart';

// 🔴 DIHAPUS: import yang tidak diperlukan
// import 'dart:convert';
// import 'package:myapp/models/post_model.dart';
// import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 🟩 Inisialisasi SQLite agar bisa berjalan di Windows/Linux
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 🔴 DIHAPUS: variabel dan logika tidak digunakan
  // String link = 'https://jsonplaceholder.typicode.com/posts';
  // bool loading = false;
  // List<PostModel> posts = [];

  @override
  Widget build(BuildContext context) {
    return MultiProvider( // 🟩 DIGANTI: agar nanti mudah menambah provider lain
      providers: [
        ChangeNotifierProvider(create: (_) => MhsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aplikasi Mahasiswa',
        theme: ThemeData(
          primaryColor: const Color(0xFFA8BBA3),
          scaffoldBackgroundColor: const Color(0xFFF7F4EA),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFEBD9D1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB87C4C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        home: const LoginPage(), // 🟩 tetap: halaman awal login
      ),
    );
  }
}
