// eslint-disable-next-line @typescript-eslint/no-var-requires
const path = require('path');

module.exports = {
  title: 'Flutter Community Plus Plugins',
  tagline: 'The official Flutter Community Plus plugins for Flutter',
  url: 'https://plus.fluttercommunity.dev',
  baseUrl: '/',
  favicon: '/favicon/favicon.ico',
  organizationName: 'fluttercommunity',
  projectName: 'fluttercommunityplus',
  themeConfig: {
    announcementBar: {
      id: 'wip-nullsafety',
      content:
        '📣 <a rel="noopener" href="/docs/null_safety"><b>Null-safety versions</b></a> are now available. This Plus documentation hub is currently a work in progress',
      backgroundColor: '#13B9FD',
      textColor: '#fff',
    },
    prism: {
      additionalLanguages: [
        'dart',
        'bash',
        'java',
        'kotlin',
        'objectivec',
        'swift',
        'groovy',
        'ruby',
        'json',
        'yaml',
      ],
    },
    navbar: {
      title: 'Plus Plugins',
      logo: {
        alt: 'FlutterFire Logo',
        src: '/img/fc_logo.png',
      },
      items: [
        {
          to: 'docs/overview',
          activeBasePath: 'docs',
          label: 'Docs',
          position: 'right',
        },
        {
          href: 'https://twitter.com/FlutterComm',
          label: 'Twitter',
          position: 'right',
        },
        {
          href: 'https://github.com/fluttercommunity',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      copyright: `<div style="margin-top: 3rem"><small>Developed and maintained by Flutter Community</small></div>`,
    },
    gtag: {
      trackingID: 'G-0G7Q1JL01Z',
      anonymizeIP: true,
    },
  },
  plugins: [
    require.resolve('docusaurus-plugin-sass'),
    // require.resolve('@docusaurus/plugin-ideal-image'),
    path.resolve(__dirname, './docusaurus-plugins/favicon-tags'),
    path.resolve(__dirname, './docusaurus-plugins/source-versions'),
  ],
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: {
          path: '../docs',
          sidebarPath: require.resolve('../docs/sidebars.js'),
          editUrl: 'https://github.com/fluttercommunity/plus/edit/master/docs/',
        },
        theme: {
          customCss: require.resolve('./src/styles.scss'),
        },
      },
    ],
  ],
};
