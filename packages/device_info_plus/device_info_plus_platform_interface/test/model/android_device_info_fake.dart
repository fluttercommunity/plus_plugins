const fakeAndroidBuildVersion = <String, dynamic>{
  'sdkInt': 16,
  'baseOS': 'baseOS',
  'previewSdkInt': 30,
  'release': 'release',
  'codename': 'codename',
  'incremental': 'incremental',
  'securityPatch': 'securityPatch',
};

const fakeDisplayMetrics = <String, dynamic>{
  'widthPx': 1080.0,
  'heightPx': 2220.0,
  'xDpi': 530.0859,
  'yDpi': 529.4639,
};

const fakeSupportedAbis = <String>['arm64-v8a', 'x86', 'x86_64'];
const fakeSupported32BitAbis = <String?>['x86 (IA-32)', 'MMX'];
const fakeSupported64BitAbis = <String?>['x86-64', 'MMX', 'SSSE3'];
const fakeSystemFeatures = ['FEATURE_AUDIO_PRO', 'FEATURE_AUDIO_OUTPUT'];

const fakeAndroidDeviceInfo = <String, dynamic>{
  'id': 'id',
  'host': 'host',
  'tags': 'tags',
  'type': 'type',
  'model': 'model',
  'board': 'board',
  'brand': 'Google',
  'device': 'device',
  'product': 'product',
  'display': 'display',
  'hardware': 'hardware',
  'isPhysicalDevice': true,
  'bootloader': 'bootloader',
  'fingerprint': 'fingerprint',
  'manufacturer': 'manufacturer',
  'supportedAbis': fakeSupportedAbis,
  'systemFeatures': fakeSystemFeatures,
  'version': fakeAndroidBuildVersion,
  'supported64BitAbis': fakeSupported64BitAbis,
  'supported32BitAbis': fakeSupported32BitAbis,
  'displayMetrics': fakeDisplayMetrics,
};
