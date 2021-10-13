import 'dart:html' as html;
import 'dart:developer' as developer;

/// Receive permission status of the API.
Future<void> checkPremission(
  Function initSensor, {
  String? premissionName,
}) async {
  final _premission = html.window.navigator.permissions;

  // Check if browser supports this API or supports permission manager
  if (_premission != null) {
    try {
      // Request for permission or check premission status
      final premissionStatus = await _premission.query(
        {
          'name': premissionName,
        },
      );
      if (premissionStatus.state == 'granted') {
        initSensor();
      } else if (premissionStatus.state == 'prompt') {
        /// user needs to intract with this
        developer.log(
          'Premission [$premissionName] still has not been granted or denied.',
        );
      } else {
        // If permission is denied, do not do anything
        developer.log('Permission [$premissionName] to use sensor was denied.');
      }
    } catch (e) {
      developer.log(
        'Integration with Permissions API is not enabled, still try to start app.',
      );
      initSensor();
    }
  } else {
    developer.log('No Permissions API, still try to start app.');
    initSensor();
  }
}
