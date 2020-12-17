import 'dart:html' as html;

/// Receive premission status of the API
Future<void> checkPremission(
  Function initSensor, {
  String premissionName,
}) async {
  final _premission = html.window.navigator.permissions;

  /// check if browser supports this API or support premission manager
  if (_premission != null) {
    try {
      /// request for permission or check premission status
      final premissionStatus = await _premission.query(
        {
          'name': premissionName,
        },
      );
      if (premissionStatus.state == 'granted') {
        initSensor();
      } else if (premissionStatus.state == 'prompt') {
        /// user needs to intract with this
        print(
          'Premission [$premissionName] still has not been granted or denied.',
        );
      } else {
        /// if permission is denied, do not do anything
        print('Permission [$premissionName] to use sensor was denied.');
      }
    } catch (e) {
      print(
        'Integration with Permissions API is not enabled, still try to start app.',
      );
      initSensor();
    }
  } else {
    print('No Permissions API, still try to start app.');
    initSensor();
  }
}
