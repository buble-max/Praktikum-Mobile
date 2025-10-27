import 'package:flutter/material.dart';
import 'package:myapp/models/mhs_model.dart';
import 'package:myapp/provider/mhs_provider.dart';
import 'package:provider/provider.dart';

class UpdateMhs extends StatefulWidget {
  final MhsModel mhs;
  const UpdateMhs({super.key, required this.mhs});

  @override
  State<UpdateMhs> createState() => _UpdateMhsState();
}

class _UpdateMhsState extends State<UpdateMhs> {
  TextEditingController nim = TextEditingController();
  TextEditingController nama = TextEditingController();

  @override
  void initState() {
    nim.text = widget.mhs.nim;
    nama.text = widget.mhs.nama;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Mahasiswa")),
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
              MhsModel mhs = MhsModel(
                id: widget.mhs.id,
                nim: nim.text,
                nama: nama.text,
              );
              Provider.of<MhsProvider>(context, listen: false).update(mhs);
              Navigator.pop(context);
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}
