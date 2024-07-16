import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;
  Future<void> logEvent(String name, Map<String, Object>? parameters) async {
    await _firebaseAnalytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  FirebaseAnalyticsObserver getAnalyticObserver() =>
      FirebaseAnalyticsObserver(analytics: _firebaseAnalytics);
  Future<void> logAndOpen() => _firebaseAnalytics.logAppOpen();
}
