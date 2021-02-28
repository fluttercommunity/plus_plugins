function toReferenceAPI(plugin) {
  return {
    type: "link",
    label: "Reference API",
    href: `https://pub.dev/documentation/${plugin}_plus/latest/`,
  };
}

module.exports = {
  main: {
    "Getting Started": ["overview", "null_safety"],
    Battery: [
      "battery_plus/overview",
      "battery_plus/usage",
      toReferenceAPI("battery"),
    ],
    Connectivity: [
      "connectivity_plus/overview",
      "connectivity_plus/usage",
      toReferenceAPI("connectivity"),
    ],
    ["Network Info"]: [
      "network_info_plus/overview",
      "network_info_plus/usage",
      toReferenceAPI("network_info"),
    ],
    ["Package Info"]: [
      "package_info_plus/overview",
      "package_info_plus/usage",
      toReferenceAPI("package_info"),
    ],
    ["Device Info"]: [
      "device_info_plus/overview",
      "device_info_plus/usage",
      toReferenceAPI("device_info"),
    ],
    ["Share"]: [
      "share_plus/overview",
      "share_plus/usage",
      toReferenceAPI("share"),
    ],
    ["Sensors"]: [
      "sensors_plus/overview",
      "sensors_plus/usage",
      toReferenceAPI("sensors"),
    ],
    ["Android Alarm Manager"]: [
      "android_alarm_manager_plus/overview",
      "android_alarm_manager_plus/usage",
      toReferenceAPI("android_alarm_manager"),
    ],
    ["Android Intent"]: [
      "android_intent_plus/overview",
      "android_intent_plus/usage",
      toReferenceAPI("android_intent"),
    ],
  },
};
