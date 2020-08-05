import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

import 'package:dio/dio.dart';

class AuthService {
  static String _redirectUrl = 'boardgamescompanion://auth';
  static String _authProfileName = 'B2C_1_sign_up_and_in';

  final FlutterAppAuth _appAuth = FlutterAppAuth();

  final String _clientId = '3e198aad-be85-45d2-b9a8-703852601e0b';
  final String _authorizeUrl =
      'https://boardgamescompanion.b2clogin.com/boardgamescompanion.onmicrosoft.com/$_authProfileName/oauth2/v2.0/authorize';
  final String _tokenUrl =
      'https://boardgamescompanion.b2clogin.com/boardgamescompanion.onmicrosoft.com/$_authProfileName/oauth2/v2.0/token';
  final String _logoutUrl =
      'https://boardgamescompanion.b2clogin.com/boardgamescompanion.onmicrosoft.com/$_authProfileName/oauth2/v2.0/logout?post_logout_redirect_uri=$_redirectUrl';

  final HttpClientAdapter _httpClientAdapter;
  final Dio _dio = Dio();

  AuthService(this._httpClientAdapter) {
    _dio.httpClientAdapter = _httpClientAdapter;
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<void> signIn() async {
    try {
      var authorizationTokenResponse = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          serviceConfiguration:
              AuthorizationServiceConfiguration(_authorizeUrl, _tokenUrl),
          scopes: ['openid', 'offline_access', 'profile'],
        ),
      );

      // TODO Check for Access Token and Refresh Token

      print(authorizationTokenResponse.accessToken);
    } on PlatformException catch (e, stack) {
      print(e.code);
      Crashlytics.instance.recordError(e, stack);
    }
  }

  Future<void> signOut() async {
    try {
      // TODO MK Investigatge how to sign out from different platforms
      // https://docs.microsoft.com/en-us/azure/active-directory-b2c/session-overview
      await _dio.get(_logoutUrl);
    } on Exception catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
    }
  }
}
