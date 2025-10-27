import 'package:flutter/material.dart';
import 'package:myapp/models/mhs_model.dart';
import 'package:myapp/provider/mhs_provider.dart';
import 'package:provider/provider.dart';

class AddMhs extends StatefulWidget {
  const AddMhs({super.key});

  @override
  State<AddMhs> createState() => _AddMhsState();
}

class _AddMhsState extends State<AddMhs> {
  TextEditingController nim = TextEditingController();
  TextEditingController nama = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Mahasiswa")),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          TextFormField(
            controller: nim,
            decoration: InputDecoration(hintText: 'NIM'),
          ),
          SizedBox(height: 15),
          TextFormField(
            controller: nama,
            decoration: InputDecoration(hintText: 'Nama Lengkap'),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              MhsModel mhs = MhsModel(nim: nim.text, nama: nama.text);
              Provider.of<MhsProvider>(context, listen: false).insert(mhs);
              Navigator.pop(context);
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
