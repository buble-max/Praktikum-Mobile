class MhsModel {
  int? id;
  String nama, nim;

  MhsModel({this.id, required this.nim, required this.nama});

  factory MhsModel.fromMap(map) =>
      MhsModel(id: map['id'], nim: map['nim'], nama: map['nama']);

  Map<String, dynamic> toMap() => {'nim': nim, 'nama': nama};
}
