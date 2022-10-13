import 'dart:developer' as developer;
import 'dart:html' as html;

/// Receive permission status of the API.
Future<void> checkPermission(
  Function initSensor, {
  String? permissionName,
}) async {
  final permission = html.window.navigator.permissions;

  // Check if browser supports this API or supports permission manager
  if (permission != null) {
    try {
      // Request for permission or check permission status
      final permissionStatus = await permission.query(
        {
          'name': permissionName,
        },
      );
      switch (permissionStatus.state) {
        case 'granted':
          initSensor();
          break;
        case 'prompt':
          // user needs to interact with this
          developer.log(
              'Permission [$permissionName] still has not been granted or denied.');
          break;
        default:
          // If permission is denied, do nothing
          developer
              .log('Permission [$permissionName] to use sensor is denied.');
      }
    } catch (e) {
      developer.log(
          'Integration with Permissions API is not enabled, still trying to start app.',
          error: e);
      initSensor();
    }
  } else {
    developer.log('No Permissions API, still try to start app.');
    initSensor();
  }
}
