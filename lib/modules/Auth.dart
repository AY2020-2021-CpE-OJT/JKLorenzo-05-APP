import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:phonebook/modules/API.dart';
import 'package:phonebook/structures/AuthData.dart';
import 'package:random_string/random_string.dart';

const JWT_REGISTER =
    "794b704ce634dd4910966c4b77abc7fa91a64c9cdf520087dd892949b2cb1abf884856914cb4a225256b01a406dd91231c8c91e32345db91afe5b8ddb0045f66";
final session_id = randomString(10);
String access_token = '';

class Auth {
  static String getAccessToken() {
    return access_token;
  }

  static Future<void> register() async {
    final request_token = issueJwtHS256(
        JwtClaim(
          issuer: "JKLorenzoPBAPP",
          subject: "register",
          payload: {"id": session_id},
          maxAge: Duration(seconds: 30),
        ),
        JWT_REGISTER);

    final data = await API.register(
      AuthData(id: session_id, token: request_token),
    );

    if (data.token != null) {
      access_token = data.token!;
    }
  }
}
