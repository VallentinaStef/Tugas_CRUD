import 'dart:convert';

class Barang {
  final int? id;
  final String nama;
  final int harga;
  final int stok;

  const Barang({
    this.id,
    required this.nama,
    required this.harga,
    required this.stok,
  });

  Barang copyWith({int? id, String? nama, int? harga, int? stok}) {
    return Barang(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      harga: harga ?? this.harga,
      stok: stok ?? this.stok,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nama': nama,
      'harga': harga,
      'stok': stok,
    };
  }

  factory Barang.fromMap(Map<String, dynamic> map) {
    return Barang(
      id: map['id'] as int?,
      nama: map['nama'] as String,
      harga: map['harga'] as int,
      stok: map['stok'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Barang.fromJson(String source) =>
      Barang.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Barang(id: $id, nama: $nama, harga: $harga, stok: $stok)';
  }

  @override
  bool operator ==(covariant Barang other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nama == nama &&
        other.harga == harga &&
        other.stok == stok;
  }

  @override
  int get hashCode => id.hashCode ^ nama.hashCode ^ harga.hashCode ^ stok.hashCode;
}
