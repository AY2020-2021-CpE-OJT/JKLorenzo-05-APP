// ignore_for_file: non_constant_identifier_names

class PBPartialData {
  String? id;
  String? first_name;
  String? last_name;
  List<String>? phone_numbers;

  PBPartialData({this.id, this.first_name, this.last_name, this.phone_numbers});

  factory PBPartialData.fromJson(Map<String, dynamic> json) {
    final pnums = json['phone_numbers'] as List<dynamic>?;
    return PBPartialData(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      phone_numbers: pnums?.map((value) => value.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final thisData = <String, dynamic>{};
    if (this.id != null) thisData['id'] = this.id;
    if (this.first_name != null) thisData['first_name'] = this.first_name;
    if (this.last_name != null) thisData['last_name'] = this.last_name;
    if (this.phone_numbers != null)
      thisData['phone_numbers'] = this.phone_numbers;
    return thisData;
  }
}
