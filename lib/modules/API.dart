import 'dart:convert';
import 'package:http/http.dart';
import 'package:phonebook/structures/PBData.dart';
import 'package:phonebook/structures/PBPartialData.dart';

const _authority = 'jklorenzo-pb-api.herokuapp.com';
const Map<String, String> _headers = {
  "Content-Type": "application/json",
};

class API {
  static Future<void> deleteContact(String id) async {
    final _uri = Uri.https(_authority, '/api/contact/${id}');

    final response = await delete(_uri, headers: _headers);
    if (response.statusCode != 200) throw response.body;
  }

  static Future<PBData> getContact(String id) async {
    final _uri = Uri.https(_authority, '/api/contact/$id');

    final response = await get(_uri, headers: _headers);
    if (response.statusCode != 200) throw response.body;

    final response_body = jsonDecode(response.body);
    return PBData.fromJson(response_body);
  }

  static Future<void> patchContact(PBData data) async {
    final _uri = Uri.https(_authority, '/api/contact/${data.id}');
    final request_body = jsonEncode(data.toJson());

    final response = await patch(_uri, headers: _headers, body: request_body);
    if (response.statusCode != 200) throw response.body;
  }

  static Future<PBData> putContact(PBPartialData data) async {
    final _uri = Uri.https(_authority, '/api/contact');
    final request_body = jsonEncode(data.toJson());

    final response = await put(_uri, headers: _headers, body: request_body);
    if (response.statusCode != 200) throw response.body;

    final response_body = jsonDecode(response.body);
    return PBData.fromJson(response_body);
  }

  // ===========================================================================

  static Future<int> deleteContacts(List<PBPartialData> data) async {
    final _uri = Uri.https(_authority, '/api/contacts');
    final request_body = jsonEncode(data.map((e) => e.toJson()).toList());

    final response = await delete(_uri, headers: _headers, body: request_body);
    if (response.statusCode != 200) throw response.body;

    return int.parse(response.body);
  }

  static Future<List<PBPartialData>> getContacts() async {
    final _uri = Uri.https(_authority, '/api/contacts');

    final response = await get(_uri, headers: _headers);
    if (response.statusCode != 200) throw response.body;

    final response_body = jsonDecode(response.body) as List<dynamic>;
    return response_body.map((data) => PBPartialData.fromJson(data)).toList();
  }
}
