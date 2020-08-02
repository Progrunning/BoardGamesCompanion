import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class AuthService {
  final FlutterAppAuth _appAuth = FlutterAppAuth();

  final String _clientId = '3e198aad-be85-45d2-b9a8-703852601e0b';
  final String _authorizeUrl =
      'https://boardgamescompanion.b2clogin.com/boardgamescompanion.onmicrosoft.com/B2C_1_sign_up_and_in/oauth2/v2.0/authorize';
  final String _tokenUrl =
      'https://boardgamescompanion.b2clogin.com/boardgamescompanion.onmicrosoft.com/B2C_1_sign_up_and_in/oauth2/v2.0/token';
  final String _redirectUrl = 'boardgamescompanion://auth';

  Future<void> signIn() async {
    try {
      var authorizationTokenResponse = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId, _redirectUrl,
          serviceConfiguration:
              AuthorizationServiceConfiguration(_authorizeUrl, _tokenUrl),
          scopes: ['openid'],
        ),
      );

      // TODO Check for Access Token and Refresh Token

      print(authorizationTokenResponse.accessToken);
    } on PlatformException catch (e, stack) {
      print(e.code);
      Crashlytics.instance.recordError(e, stack);
    }
  }
}
