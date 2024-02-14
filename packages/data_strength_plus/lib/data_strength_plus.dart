import 'data_strength_plus_platform_interface.dart';

class DataStrengthPlus {
  Future<String?> getPlatformVersion() {
    return DataStrengthPlusPlatform.instance.getPlatformVersion();
  }

  Future<int?> getMobileSignalStrength() {
    return DataStrengthPlusPlatform.instance.getMobileSignalStrength();
  }

  Future<int?> getWifiSignalStrength() {
    return DataStrengthPlusPlatform.instance.getWifiSignalStrength();
  }

  Future<int?> getWifiLinkSpeed() {
    return DataStrengthPlusPlatform.instance.getWifiLinkSpeed();
  }

  static range(data) {
    if (data > -50) {
      return 0;
    } else if (data > -70 && data <= -50) {
      return 1;
    } else if (data > -90 && data < -70) {
      return 2;
    } else {
      return 3;
    }
  }

  static rangeName(data) {
    if (data == null) {
      return "Check internet Turn On";
    }
    int rangeValue = range(data);
    switch (rangeValue) {
      case 0:
        return "High";
      case 1:
        return "Good";
      case 2:
        return "Low";
      case 3:
        return "No internet";
      default:
        break;
    }
  }
}
