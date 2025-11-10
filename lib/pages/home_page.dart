import 'package:flutter/material.dart';
import 'package:myapp/models/mhs_model.dart';
import 'package:myapp/pages/add_mhs.dart';
import 'package:myapp/pages/login_page.dart';
import 'package:myapp/pages/update_mhs.dart';
import 'package:myapp/provider/mhs_provider.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.username});
  final String title;
  final String username;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MhsProvider>(context); // 🟩 DITAMBAHKAN: untuk akses provider langsung

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 3,
        shadowColor: Colors.black.withAlpha(77), // (sudah ada)
        actions: [ // 🟩 DITAMBAHKAN: tombol sinkronisasi API
          IconButton(
            icon: const Icon(Icons.cloud_download, color: Colors.white),
            tooltip: 'Sinkronisasi dari API',
            onPressed: () async {
              await provider.fetchMahasiswaFromApi(); // 🟩 Panggil fungsi fetch dari API di provider
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data berhasil disinkronisasi dari API!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFEBD9D1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFFA8BBA3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.flutter_dash, size: 64, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    "Welcome, ${widget.username}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),

      body: provider.isLoading // 🟩 DITAMBAHKAN: tampilkan indikator loading saat fetch API
          ? const Center(child: CircularProgressIndicator())
          : Consumer<MhsProvider>(
              builder: (context, provider, child) {
                if (provider.mahasiswa.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada data mahasiswa.\nTekan tombol + untuk menambah atau sinkronisasi dari API.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: provider.mahasiswa.length,
                  itemBuilder: (context, index) {
                    final MhsModel mhs = provider.mahasiswa[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.school, color: Colors.blueAccent),
                        title: Text(
                          mhs.nama,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'NIM: ${mhs.nim}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateMhs(mhs: mhs),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red[700]),
                          onPressed: () {
                            // Show a confirmation dialog before deleting
                            showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: const Text('Konfirmasi Hapus'),
                                  content: Text('Apakah Anda yakin ingin menghapus data ${mhs.nama}?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Batal'),
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Hapus', style: TextStyle(color: Colors.red[700])),
                                      onPressed: () {
                                        provider.delete(mhs);
                                        Navigator.of(ctx).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Data ${mhs.nama} berhasil dihapus.'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMhs()),
          );
        },
        backgroundColor: const Color(0xFFB87C4C), // Matching login button color
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
