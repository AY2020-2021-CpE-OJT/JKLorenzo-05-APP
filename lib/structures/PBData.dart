class PBData {
  String id;
  String first_name;
  String last_name;
  List<String> phone_numbers;

  PBData(this.id, this.first_name, this.last_name, this.phone_numbers);

  factory PBData.fromJson(Map<String, dynamic> json) {
    final raw_phone_numbers = json['phone_numbers'] as List<dynamic>;
    return PBData(
      json['id'] as String,
      json['first_name'] as String,
      json['last_name'] as String,
      raw_phone_numbers.map((value) => value.toString()).toList(),
    );
  }

  toJson() {
    return {
      "id": this.id,
      "first_name": this.first_name,
      "last_name": this.last_name,
      "phone_numbers": this.phone_numbers
    };
  }
}
