import 'dart:convert';

class MhsModel {
  String nim;
  String nama;
  String? alamat; // 🟩 DIGANTI: Diizinkan untuk null (nullable)

  MhsModel({
    required this.nim,
    required this.nama,
    this.alamat, // 🟩 DIGANTI: Menjadi parameter opsional
  });

  factory MhsModel.fromRawJson(String str) => MhsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory MhsModel.fromJson(Map<String, dynamic> json) => MhsModel(
        nim: json["nim"],
        nama: json["nama"],
        alamat: json["alamat"], // 🟩 CUKUP SEPERTI INI: Akan menjadi null jika tidak ada
      );

  Map<String, dynamic> toMap() => {
        "nim": nim,
        "nama": nama,
        "alamat": alamat, // 🟩 CUKUP SEPERTI INI: Akan mengirim null jika nilainya null
      };
}
