import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @singleton
  FirebaseAnalytics get firebaseAnalytics => FirebaseAnalytics.instance;

  @injectable
  HiveInterface get hive => Hive;

  @singleton
  FirebaseAnalyticsObserver get firebaseAnalyticsObserver =>
      FirebaseAnalyticsObserver(analytics: firebaseAnalytics);
}
