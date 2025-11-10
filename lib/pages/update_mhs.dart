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
  TextEditingController alamat = TextEditingController(); // 🟩 DITAMBAHKAN: field alamat untuk sinkron API
  bool isLoading = false; // 🟩 DITAMBAHKAN: indikator proses update

  @override
  void initState() {
    super.initState();
    nim.text = widget.mhs.nim;
    nama.text = widget.mhs.nama;
    alamat.text = widget.mhs.alamat ?? ''; // 🟩 DITAMBAHKAN: set nilai awal alamat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Mahasiswa"),
        backgroundColor: const Color(0xFFB87C4C), // 🟩 Konsistensi tema
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          TextFormField(
            controller: nim,
            decoration: const InputDecoration(
              hintText: 'NIM',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: nama,
            decoration: const InputDecoration(
              hintText: 'Nama Lengkap',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: alamat, // 🟩 DITAMBAHKAN
            decoration: const InputDecoration(
              hintText: 'Alamat Mahasiswa',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 30),

          isLoading // 🟩 DITAMBAHKAN: indikator loading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB87C4C),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (nama.text.isEmpty || nim.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('NIM dan Nama tidak boleh kosong!'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }

                    setState(() => isLoading = true); // 🟩 Mulai loading

                    final updatedMhs = MhsModel(
                      nim: nim.text,
                      nama: nama.text,
                      alamat: alamat.text.isEmpty ? '-' : alamat.text, // 🟩 DITAMBAHKAN
                    );

                    final provider =
                        Provider.of<MhsProvider>(context, listen: false);

                    // 🟩 Update data di SQLite
                    await provider.update(updatedMhs);

                    // 🟩 Sinkron ke server (upload data baru)
                    await provider.uploadMahasiswaToApi(updatedMhs);

                    setState(() => isLoading = false); // 🟩 Selesai loading

                    if (!mounted) return;
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data mahasiswa berhasil diperbarui & disinkron!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
        ],
      ),
    );
  }
}
