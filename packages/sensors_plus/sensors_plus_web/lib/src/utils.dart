import 'dart:html' as html;

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
        // User needs to intract with this
        print(
          'Premission [$premissionName] still has not been granted or denied.',
        );
      } else {
        // If permission is denied, do not do anything
        print('Permission [$premissionName] to use sensor was denied.');
      }
    } catch (e) {
      print(
        'Integration with Permissions API is not enabled; '
        'still trying to start app.',
      );
      initSensor();
    }
  } else {
    print('No Permissions API; still trying to start app.');
    initSensor();
  }
}
