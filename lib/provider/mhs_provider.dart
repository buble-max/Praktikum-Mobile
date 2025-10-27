import 'package:flutter/material.dart';
import 'package:myapp/db/my_db.dart';
import 'package:myapp/models/mhs_model.dart';

class MhsProvider with ChangeNotifier {
  List<MhsModel> mahasiswa = [];
  MyDb db = MyDb();

  MhsProvider() {
    getMahasiswa();
  }

  getMahasiswa() async {
    mahasiswa = await db.getMahasiswa();
    notifyListeners();
  }

  insert(MhsModel mhs) async {
    await db.insertMhs(mhs);
    getMahasiswa();
  }

  update(MhsModel mhs) async {
    await db.updateMhs(mhs);
    getMahasiswa();
  }

  delete(MhsModel mhs) async {
    await db.deleteMhs(mhs);
    getMahasiswa();
  }
}
