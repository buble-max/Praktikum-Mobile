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
  TextEditingController alamat = TextEditingController(); // 🟩 DITAMBAHKAN: field alamat untuk API (optional)

  bool isLoading = false; // 🟩 DITAMBAHKAN: indikator loading untuk upload proses

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Mahasiswa"),
        backgroundColor: const Color(0xFFB87C4C), // 🟩 DITAMBAHKAN: warna tema konsisten
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
          isLoading // 🟩 DITAMBAHKAN: tampilkan indikator loading saat proses simpan
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
                    if (nim.text.isEmpty || nama.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('NIM dan Nama tidak boleh kosong!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    setState(() => isLoading = true); // 🟩 DITAMBAHKAN

                    // 🟩 DITAMBAHKAN: buat objek mahasiswa lengkap
                    MhsModel mhs = MhsModel(
                      nim: nim.text,
                      nama: nama.text,
                      alamat: alamat.text.isEmpty ? '-' : alamat.text,
                    );

                    final provider = Provider.of<MhsProvider>(context, listen: false);

                    // Simpan ke SQLite
                    await provider.insert(mhs);

                    // Upload ke API juga (sinkron online)
                    await provider.uploadMahasiswaToApi(mhs); // 🟩 DITAMBAHKAN

                    setState(() => isLoading = false); // 🟩 DITAMBAHKAN

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data mahasiswa berhasil disimpan & diupload!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text(
                    'Simpan',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
        ],
      ),
    );
  }
}
