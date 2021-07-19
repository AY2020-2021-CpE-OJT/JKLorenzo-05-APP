// ignore_for_file: non_constant_identifier_names

class PBData {
  String id;
  String first_name;
  String last_name;
  List<String> phone_numbers;

  PBData(this.id, this.first_name, this.last_name, this.phone_numbers);

  factory PBData.fromJson(Map<String, dynamic> json) {
    final pnums = json['phone_numbers'] as List<dynamic>;
    return PBData(
      json['id'] as String,
      json['first_name'] as String,
      json['last_name'] as String,
      pnums.map((value) => value.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "first_name": this.first_name,
      "last_name": this.last_name,
      "phone_numbers": this.phone_numbers
    };
  }
}
