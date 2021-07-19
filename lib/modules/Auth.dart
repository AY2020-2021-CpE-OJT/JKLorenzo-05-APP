import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:phonebook/modules/API.dart';
import 'package:phonebook/structures/AuthData.dart';
import 'package:random_string/random_string.dart';

const JWT_REGISTER =
    "794b704ce634dd4910966c4b77abc7fa91a64c9cdf520087dd892949b2cb1abf884856914cb4a225256b01a406dd91231c8c91e32345db91afe5b8ddb0045f66";
final sessionId = randomString(10);
String accessToken = '';

class Auth {
  static String getAccessToken() {
    return accessToken;
  }

  static Future<void> register() async {
    final requestToken = issueJwtHS256(
        JwtClaim(
          issuer: "JKLorenzoPBAPP",
          subject: "register",
          payload: {"id": sessionId},
          maxAge: Duration(seconds: 30),
        ),
        JWT_REGISTER);

    final data = await API.register(
      AuthData(id: sessionId, token: requestToken),
    );

    if (data.token != null) {
      accessToken = data.token!;
    }
  }
}
