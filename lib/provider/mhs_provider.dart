import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/db/my_db.dart';
import 'package:myapp/models/mhs_model.dart';

class MhsProvider extends ChangeNotifier {
  List<MhsModel> mahasiswa = [];
  bool isLoading = true;
  final MyDb db = MyDb();

  MhsProvider() {
    _refreshMahasiswa();
  }

  Future<void> _refreshMahasiswa() async {
    mahasiswa = await db.getMahasiswa();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMahasiswaFromApi() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.npoint.io/901f2956c40c94382103'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        for (var item in data.take(10)) {
          final mhs = MhsModel.fromJson(item);
          await db.insertMhs(mhs);
        }

        await _refreshMahasiswa();
      } else {
        throw Exception('Gagal mengambil data dari API');
      }
    } catch (e) {
      debugPrint('Error fetchMahasiswaFromApi: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🟩 FUNGSI-FUNGSI INI DIPINDAHKAN KE LUAR BLOK fetchMahasiswaFromApi

  Future<void> insert(MhsModel mhs) async {
    await db.insertMhs(mhs);
    await _refreshMahasiswa();
  }

  Future<void> update(MhsModel mhs) async {
    await db.updateMhs(mhs);
    await _refreshMahasiswa();
  }

  Future<void> delete(MhsModel mhs) async {
    await db.deleteMhs(mhs);
    await _refreshMahasiswa();
  }

  Future<void> uploadMahasiswaToApi(MhsModel mhs) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.npoint.io/901f2956c40c94382103'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(mhs.toMap()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint('Data berhasil di-upload ke server');
      } else {
        throw Exception(
            'Gagal meng-upload data. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error uploadMahasiswaToApi: $e');
    }
  }
}
