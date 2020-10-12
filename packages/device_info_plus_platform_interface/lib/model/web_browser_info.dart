// Copyright 2020 The Flutter Community Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// List of supported browsers
enum BrowserName {
  /// Mozilla Firefox
  firefox,

  /// Samsumg Internet Browser
  samsungInternet,

  /// Opera Web Browser
  opera,

  /// Microsoft Internet Explorer
  msie,

  /// Microsoft Edge
  edge,

  /// Google Chrome
  chrome,

  /// Apple Safari
  safari,

  /// Unknown web browser
  unknown,
}

/// Information derived from `navigator`.
///
/// See: https://developer.mozilla.org/en-US/docs/Web/API/Window/navigator
class WebBrowserInfo {
  /// Web Browser info class.
  WebBrowserInfo({
    this.appCodeName,
    this.appName,
    this.appVersion,
    this.deviceMemory,
    this.language,
    this.languages,
    this.platform,
    this.product,
    this.productSub,
    this.userAgent,
    this.vendor,
    this.vendorSub,
    this.maxTouchPoints,
    this.hardwareConcurrency,
  });

  /// the name of the current browser.
  BrowserName get browserName {
    return _parseUserAgentToBrowserName();
  }

  /// the internal "code" name of the current browser.
  /// Note: Do not rely on this property to return the correct value.
  final String appCodeName;

  /// a DOMString with the official name of the browser.
  /// Note: Do not rely on this property to return the correct value.
  final String appName;

  /// the version of the browser as a DOMString.
  /// Note: Do not rely on this property to return the correct value.
  final String appVersion;

  /// the amount of device memory in gigabytes. This value is an approximation given by rounding to the nearest power of 2 and dividing that number by 1024.
  final int deviceMemory;

  /// a DOMString representing the preferred language of the user, usually the language of the browser UI. The null value is returned when this is unknown.
  final String language;

  /// an array of DOMString representing the languages known to the user, by order of preference.
  final List<dynamic> languages;

  /// the version of the browser as a DOMString.
  /// Note: Do not rely on this property to return the correct value.
  final String platform;

  /// Always returns 'Gecko', on any browser.
  /// Note: Do not rely on this property to return the correct value.
  /// This property is kept only for compatibility purpose.
  final String product;

  /// the build number of the current browser
  /// Note: Do not rely on this property to return the correct value.
  final String productSub;

  /// the build number of the current browser (e.g., "20060909")
  final String userAgent;

  /// the vendor name of the current browser
  final String vendor;

  /// Returns the vendor version number (e.g. "6.1")
  /// Note: Do not rely on this property to return the correct value.
  final String vendorSub;

  /// the number of logical processor cores available.
  final int hardwareConcurrency;

  /// the maximum number of simultaneous touch contact points are supported by the current device.
  final int maxTouchPoints;

  /// Deserializes from the map message received from [Navigator].
  static WebBrowserInfo fromMap(Map<String, dynamic> map) {
    return WebBrowserInfo(
      appCodeName: map['appCodeName'],
      appName: map['appName'],
      appVersion: map['appVersion'],
      deviceMemory: map['deviceMemory'],
      language: map['language'],
      languages: map['languages'],
      platform: map['platform'],
      product: map['product'],
      productSub: map['productSub'],
      userAgent: map['userAgent'],
      vendor: map['vendor'],
      vendorSub: map['vendorSub'],
      hardwareConcurrency: map['hardwareConcurrency'],
      maxTouchPoints: map['maxTouchPoints'],
    );
  }

  BrowserName _parseUserAgentToBrowserName() {
    if (userAgent.contains("Firefox")) {
      return BrowserName.firefox;
      // "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0"
    } else if (userAgent.contains("SamsungBrowser")) {
      return BrowserName.samsungInternet;
      // "Mozilla/5.0 (Linux; Android 9; SAMSUNG SM-G955F Build/PPR1.180610.011) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/9.4 Chrome/67.0.3396.87 Mobile Safari/537.36
    } else if (userAgent.contains("Opera") || userAgent.contains("OPR")) {
      return BrowserName.opera;
      // "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 OPR/57.0.3098.106"
    } else if (userAgent.contains("Trident")) {
      return BrowserName.msie;
      // "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; .NET4.0C; .NET4.0E; Zoom 3.6.0; wbx 1.0.0; rv:11.0) like Gecko"
    } else if (userAgent.contains("Edge")) {
      return BrowserName.edge;
      // "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36 Edge/16.16299"
    } else if (userAgent.contains("Chrome")) {
      return BrowserName.chrome;
      // "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/66.0.3359.181 Chrome/66.0.3359.181 Safari/537.36"
    } else if (userAgent.contains("Safari")) {
      return BrowserName.safari;
      // "Mozilla/5.0 (iPhone; CPU iPhone OS 11_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.0 Mobile/15E148 Safari/604.1 980x1306"
    } else {
      return BrowserName.unknown;
    }
  }
}
