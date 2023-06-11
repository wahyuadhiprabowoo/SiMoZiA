class Posyandu {
  int id;
  String namaPosyandu;
  String alamat;
  String kelurahan;
  String kecamatan;
  int puskesmasId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Posyandu({
    required this.id,
    required this.namaPosyandu,
    required this.alamat,
    required this.kelurahan,
    required this.kecamatan,
    required this.puskesmasId,
    this.createdAt,
    this.updatedAt,
  });

  factory Posyandu.fromJson(Map<String, dynamic> json) => Posyandu(
        id: json["id"],
        namaPosyandu: json["nama_posyandu"],
        alamat: json["alamat"],
        kelurahan: json["kelurahan"],
        kecamatan: json["kecamatan"],
        puskesmasId: json["puskesmas_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_posyandu": namaPosyandu,
        "alamat": alamat,
        "kelurahan": kelurahan,
        "kecamatan": kecamatan,
        "puskesmas_id": puskesmasId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
