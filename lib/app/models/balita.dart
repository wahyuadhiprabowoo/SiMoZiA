class Balita {
  final int id;
  final String namaIbu;
  final String namaAnak;
  final String alamat;
  final String jenisKelamin;
  final int umur;
  final int beratBadan;
  final int panjangBadan;
  final int detakJantung;
  final int zscoreBeratBadan;
  final int zscorePanjangBadan;
  final String klasifikasiBeratBadan;
  final String klasifikasiPanjangBadan;
  final String klasifikasiDetakJantung;
  final int posyanduId;
  final int puskesmasId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Balita({
    required this.id,
    required this.namaIbu,
    required this.namaAnak,
    required this.alamat,
    required this.jenisKelamin,
    required this.umur,
    required this.beratBadan,
    required this.panjangBadan,
    required this.detakJantung,
    required this.zscoreBeratBadan,
    required this.zscorePanjangBadan,
    required this.klasifikasiBeratBadan,
    required this.klasifikasiPanjangBadan,
    required this.klasifikasiDetakJantung,
    required this.posyanduId,
    required this.puskesmasId,
    this.createdAt,
    this.updatedAt,
  });

  factory Balita.fromJson(Map<String, dynamic> json) => Balita(
        id: json["id"],
        namaIbu: json["nama_ibu"],
        namaAnak: json["nama_anak"],
        alamat: json["alamat"],
        jenisKelamin: json["jenis_kelamin"],
        umur: json["umur"],
        beratBadan: json["berat_badan"],
        panjangBadan: json["panjang_badan"],
        detakJantung: json["detak_jantung"],
        zscoreBeratBadan: json["zscore_berat_badan"],
        zscorePanjangBadan: json["zscore_panjang_badan"],
        klasifikasiBeratBadan: json["klasifikasi_berat_badan"],
        klasifikasiPanjangBadan: json["klasifikasi_panjang_badan"],
        klasifikasiDetakJantung: json["klasifikasi_detak_jantung"],
        posyanduId: json["posyandu_id"],
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
        "nama_ibu": namaIbu,
        "nama_anak": namaAnak,
        "alamat": alamat,
        "jenis_kelamin": jenisKelamin,
        "umur": umur,
        "berat_badan": beratBadan,
        "panjang_badan": panjangBadan,
        "detak_jantung": detakJantung,
        "zscore_berat_badan": zscoreBeratBadan,
        "zscore_panjang_badan": zscorePanjangBadan,
        "klasifikasi_berat_badan": klasifikasiBeratBadan,
        "klasifikasi_panjang_badan": klasifikasiPanjangBadan,
        "klasifikasi_detak_jantung": klasifikasiDetakJantung,
        "posyandu_id": posyanduId,
        "puskesmas_id": puskesmasId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
