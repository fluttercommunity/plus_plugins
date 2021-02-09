function toReferenceAPI(plugin) {
  return {
    type: "link",
    label: "Reference API",
    href: `https://pub.dev/documentation/${plugin}/latest/`,
  };
}

module.exports = {
  main: {
    "Getting Started": ["overview"],
    Battery: ["battery/overview", toReferenceAPI("battery")],
  },
};
