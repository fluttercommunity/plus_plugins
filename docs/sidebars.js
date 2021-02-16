function toReferenceAPI(plugin) {
  return {
    type: "link",
    label: "Reference API",
    href: `https://pub.dev/documentation/${plugin}_plus/latest/`,
  };
}

module.exports = {
  main: {
    "Getting Started": ["overview", "migration_guide"],
    Battery: ["battery/overview","battery/usage", toReferenceAPI("battery")],
    Connectivity: ["connectivity/overview", "connectivity/usage", toReferenceAPI("connectivity")]
  },
};
