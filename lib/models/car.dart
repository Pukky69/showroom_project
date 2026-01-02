class Car {
  String? id;
  String merk;
  String model;
  int tahun;
  double harga;
  String warna;
  String deskripsi;

  Car({
    this.id,
    required this.merk,
    required this.model,
    required this.tahun,
    required this.harga,
    required this.warna,
    required this.deskripsi,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      merk: json['merk'],
      model: json['model'],
      tahun: json['tahun'] is int
          ? json['tahun']
          : int.parse(json['tahun'].toString()),
      harga: json['harga'] is double
          ? json['harga']
          : double.parse(json['harga'].toString()),
      warna: json['warna'],
      deskripsi: json['deskripsi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merk': merk,
      'model': model,
      'tahun': tahun,
      'harga': harga,
      'warna': warna,
      'deskripsi': deskripsi,
    };
  }
}
