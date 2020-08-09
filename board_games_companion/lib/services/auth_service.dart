import 'dart:convert';

import 'package:board_games_companion/services/secure_storage_service.dart';
import 'package:board_games_companion/utilities/custom_http_client_adapter.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

import 'package:dio/dio.dart';

class AuthService {
  static int _numberOfJwtTokenSegments = 3;
  static int _jwtPayloadSegmenetNumber = 1;
  static String _objectIdJwtClaimName = 'oid';
  static String _refreshTokenSecureStorageKey = 'refrehsToken';
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

  final Dio _dio = Dio();

  final SecureStorageService _secureStorageService;

  AuthService(this._secureStorageService) {
    _dio.httpClientAdapter = CustomHttpClientAdapter();
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
          promptValues: ['login'],
          scopes: ['openid', 'offline_access', 'profile', 'email'],
        ),
      );

      var userId = _extractUserId(authorizationTokenResponse.idToken);
      if(userId.isEmpty) {
        // TOOD MK Handle errors
      }

      Crashlytics.instance.setUserIdentifier(userId);

      if (authorizationTokenResponse.refreshToken.isNotEmpty) {
        await _secureStorageService.setSecurly(_refreshTokenSecureStorageKey,
            authorizationTokenResponse.refreshToken);
      }
    } on PlatformException catch (e, stack) {
      print(e.code);
      Crashlytics.instance.recordError(e, stack);
    }
  }

  Future<void> signOut() async {
    await _secureStorageService.removeKey(_refreshTokenSecureStorageKey);
  }

  String _extractUserId(String jwtToken) {
    if (jwtToken.isEmpty) {
      return null;
    }

    var jwtTokenSplit = jwtToken.split('.');
    if (jwtTokenSplit.length != _numberOfJwtTokenSegments) {
      return null;
    }

    var payloadBase64Encoded = jwtTokenSplit[_jwtPayloadSegmenetNumber];
    if (payloadBase64Encoded.isEmpty) {
      return null;
    }

    try {
      var payloadBase64EncodedNormalised = base64.normalize(payloadBase64Encoded);
      var payloadBase64Decoded = base64Decode(payloadBase64EncodedNormalised);
      var payloadUtf8 = utf8.decode(payloadBase64Decoded);
      var payloadJsonMap = json.decode(payloadUtf8);

      return payloadJsonMap[_objectIdJwtClaimName];
    } on Exception catch (ex, stack) {
      Crashlytics.instance.recordError(ex, stack);
    }

    return null;
  }
}
