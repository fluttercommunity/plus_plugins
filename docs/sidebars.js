function toReferenceAPI(plugin) {
  return {
    type: "link",
    label: "Reference API",
    href: `https://pub.dev/documentation/${plugin}_plus/latest/`,
  };
}

module.exports = {
    main: [
        'overview',
        {
            type: 'category',
            label: 'Android Alarm Manager Plus',
            items: [
                "android_alarm_manager_plus/overview",
                "android_alarm_manager_plus/usage",
                toReferenceAPI("android_alarm_manager"),
            ],
        },
        {
            type: 'category',
            label: 'Battery Plus',
            items: [
                "battery_plus/overview",
                "battery_plus/usage",
                toReferenceAPI("battery"),
            ],
        },
        {
            type: 'category',
            label: 'Connectivity Plus',
            items: [
                "connectivity_plus/overview",
                "connectivity_plus/usage",
                toReferenceAPI("connectivity"),
            ],
        },
        {
            type: 'category',
            label: 'Device Info Plus',
            items: [
                "device_info_plus/overview",
                "device_info_plus/usage",
                toReferenceAPI("device_info"),
            ],
        },
        {
            type: 'category',
            label: 'Network Plus',
            items: [
                "network_info_plus/overview",
                "network_info_plus/usage",
                toReferenceAPI("network_info"),
            ],
        },
        {
            type: 'category',
            label: 'Package Info Plus',
            items: [
                "package_info_plus/overview",
                "package_info_plus/usage",
                toReferenceAPI("package_info"),
            ],
        },
        {
            type: 'category',
            label: 'Sensors Plus',
            items: [
                "sensors_plus/overview",
                "sensors_plus/usage",
                toReferenceAPI("sensors"),
            ],
        },
        {
            type: 'category',
            label: 'Share Plus',
            items: [
                "share_plus/overview",
                "share_plus/usage",
                toReferenceAPI("share"),
            ],
        },
    ],
};
