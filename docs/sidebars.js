function toReferenceAPI(plugin) {
  return {
    type: "link",
    label: "Reference API",
    href: `https://pub.dev/documentation/${plugin}_plus/latest/`,
  };
}

module.exports = {
  main: {
    "Getting Started": ["overview"],
    ["Android Alarm Manager"]: [
      "android_alarm_manager_plus/overview",
      "android_alarm_manager_plus/usage",
      toReferenceAPI("android_alarm_manager"),
    ],
    ["Android Intent Plus"]: [
      "android_intent_plus/overview",
      "android_intent_plus/usage",
      toReferenceAPI("android_intent"),
    ],
    ["Battery Plus"]: [
      "battery_plus/overview",
      "battery_plus/usage",
      toReferenceAPI("battery"),
    ],
    ["Connectivity Plus"]: [
      "connectivity_plus/overview",
      "connectivity_plus/usage",
      toReferenceAPI("connectivity"),
    ],
    ["Device Info Plus"]: [
      "device_info_plus/overview",
      "device_info_plus/usage",
      toReferenceAPI("device_info"),
    ],
    ["Network Info Plus"]: [
      "network_info_plus/overview",
      "network_info_plus/usage",
      toReferenceAPI("network_info"),
    ],
    ["Package Info Plus"]: [
      "package_info_plus/overview",
      "package_info_plus/usage",
      toReferenceAPI("package_info"),
    ],
    ["Share Plus"]: [
      "share_plus/overview",
      "share_plus/usage",
      toReferenceAPI("share"),
    ],
    ["Sensors Plus"]: [
      "sensors_plus/overview",
      "sensors_plus/usage",
      toReferenceAPI("sensors"),
    ],
  },
};
