import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:phonebook/modules/API.dart';
import 'package:phonebook/structures/AuthData.dart';
import 'package:random_string/random_string.dart';

const JWT_REGISTER = [
  "794b704ce634dd4910966c4b77abc7fa",
  "91a64c9cdf520087dd892949b2cb1abf",
  "884856914cb4a225256b01a406dd9123",
  "1c8c91e32345db91afe5b8ddb0045f66"
];
final sessionId = randomString(10);
String accessToken = '';

class Auth {
  static String getAccessToken() {
    return accessToken;
  }

  static Future<void> register() async {
    // generate register token
    final registerToken = issueJwtHS256(
        JwtClaim(
          issuer: "JKLorenzoPBAPP",
          subject: "register",
          payload: {"id": sessionId},
          maxAge: Duration(seconds: 30),
        ),
        JWT_REGISTER.join());

    // register
    final data = await API.register(
      AuthData(id: sessionId, token: registerToken),
    );

    // check if token is for this session
    if (data.id != sessionId) throw 'SESSION_MISMATCH';

    // decode access token
    final token = verifyJwtHS256Signature(data.token!, JWT_REGISTER.join());

    // check if token has valid headers
    if (token.issuer != 'JKLorenzoPBAPI') throw 'INVALID_HEADER';
    if (token.subject != 'registered') throw 'INVALID_HEADER';

    // check if payload is for this session
    if (token.payload['id'] != sessionId) throw 'SESSION_MISMATCH';

    // get access token
    accessToken = token.payload['token'];
  }
}
