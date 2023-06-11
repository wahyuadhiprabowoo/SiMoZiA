// To parse this JSON data, do
//
//     final puskesmas = puskesmasFromJson(jsonString);

import 'dart:convert';

// sudah tidak perlu di decode
Puskesmas puskesmasFromJson(String str) => Puskesmas.fromJson(json.decode(str));

String puskesmasToJson(Puskesmas data) => json.encode(data.toJson());

class Puskesmas {
  int id;
  String namaPuskesmas;
  String alamat;
  String telepon;
  String smsWa;
  DateTime? createdAt;
  DateTime? updatedAt;

  Puskesmas({
    required this.id,
    required this.namaPuskesmas,
    required this.alamat,
    required this.telepon,
    required this.smsWa,
    this.createdAt,
    this.updatedAt,
  });

  factory Puskesmas.fromJson(Map<String, dynamic> json) => Puskesmas(
        id: json["id"],
        namaPuskesmas: json["nama_puskesmas"],
        alamat: json["alamat"],
        telepon: json["telepon"],
        smsWa: json["sms_wa"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_puskesmas": namaPuskesmas,
        "alamat": alamat,
        "telepon": telepon,
        "sms_wa": smsWa,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  static List<Puskesmas> fromJsonList(List list) {
    if (list.length == 0) return List<Puskesmas>.empty();
    return list.map((item) => Puskesmas.fromJson(item)).toList();
  }
}
