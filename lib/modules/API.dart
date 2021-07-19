import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:phonebook/modules/Auth.dart';
import 'package:phonebook/structures/AuthData.dart';
import 'package:phonebook/structures/PBData.dart';
import 'package:phonebook/structures/PBPartialData.dart';

const _authority = 'jklorenzo-pb-api.herokuapp.com';

class API {
  static Future<AuthData> register(AuthData data) async {
    final uri = Uri.https(_authority, '/auth/register');
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: 'Bearer ${data.token}'
    };
    final requestBody = jsonEncode(data.toJson());

    final response = await post(uri, headers: headers, body: requestBody);

    switch (response.statusCode) {
      case 200:
        return AuthData.fromJson(jsonDecode(response.body));
      default:
        throw response.body;
    }
  }

  // ===========================================================================

  static Future<void> deleteContact(String id) async {
    final uri = Uri.https(_authority, '/api/contact/$id');
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: 'Bearer ${Auth.getAccessToken()}'
    };

    final response = await delete(uri, headers: headers);

    switch (response.statusCode) {
      case 200:
        return;
      case 401:
      case 403:
        await Auth.register();
        return await deleteContact(id);
      default:
        throw response.body;
    }
  }

  static Future<PBData> getContact(String id) async {
    final uri = Uri.https(_authority, '/api/contact/$id');
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: 'Bearer ${Auth.getAccessToken()}'
    };

    final response = await get(uri, headers: headers);

    switch (response.statusCode) {
      case 200:
        return PBData.fromJson(jsonDecode(response.body));
      case 401:
      case 403:
        await Auth.register();
        return await getContact(id);
      default:
        throw response.body;
    }
  }

  static Future<void> patchContact(String id, PBPartialData data) async {
    final uri = Uri.https(_authority, '/api/contact/$id');
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: 'Bearer ${Auth.getAccessToken()}'
    };
    final requestBody = jsonEncode(data.toJson());

    final response = await patch(uri, headers: headers, body: requestBody);

    switch (response.statusCode) {
      case 200:
        return;
      case 401:
      case 403:
        await Auth.register();
        return await patchContact(id, data);
      default:
        throw response.body;
    }
  }

  static Future<PBData> putContact(PBPartialData data) async {
    final uri = Uri.https(_authority, '/api/contact');
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: 'Bearer ${Auth.getAccessToken()}'
    };
    final requestBody = jsonEncode(data.toJson());

    final response = await put(uri, headers: headers, body: requestBody);

    switch (response.statusCode) {
      case 200:
        return PBData.fromJson(jsonDecode(response.body));
      case 401:
      case 403:
        await Auth.register();
        return await putContact(data);
      default:
        throw response.body;
    }
  }

  // ===========================================================================

  static Future<int> deleteContacts(List<PBPartialData> data) async {
    final uri = Uri.https(_authority, '/api/contacts');
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: 'Bearer ${Auth.getAccessToken()}'
    };
    final requestBody = jsonEncode(data.map((e) => e.toJson()).toList());

    final response = await delete(uri, headers: headers, body: requestBody);

    switch (response.statusCode) {
      case 200:
        return int.parse(response.body);
      case 401:
      case 403:
        await Auth.register();
        return await deleteContacts(data);
      default:
        throw response.body;
    }
  }

  static Future<List<PBPartialData>> getContacts() async {
    final uri = Uri.https(_authority, '/api/contacts');
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: 'Bearer ${Auth.getAccessToken()}'
    };

    final response = await get(uri, headers: headers);

    switch (response.statusCode) {
      case 200:
        final responseBody = jsonDecode(response.body) as List<dynamic>;
        return responseBody
            .map((data) => PBPartialData.fromJson(data))
            .toList();
      case 401:
      case 403:
        await Auth.register();
        return await getContacts();
      default:
        throw response.body;
    }
  }
}
