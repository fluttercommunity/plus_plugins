import React, { useState } from 'react';
import cx from 'classnames';
import Layout from '@theme/Layout';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import useBaseUrl from '@docusaurus/useBaseUrl';

import styles from './styles.module.scss';
import { Triangle } from '../components/Triangle';

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import plugins from '../../plugins';

interface Plugin {
  name: string;
  pub: string;
  support: {
    web?: boolean;
    android?: boolean;
    ios?: boolean;
    macos?: boolean;
    linux?: boolean;
    windows?: boolean;
  };
  maintainer: {
    web?: string;
    android?: string;
    ios?: string;
    macos?: string;
    linux?: string;
    windows?: string;
  };
}

function Home() {
  const context = useDocusaurusContext();
  const { siteConfig } = context;

  const toggleTooltip = (e: any) => {
    e.preventDefault();
    e.stopPropagation();
    const node = e.currentTarget;
    const tooltipElement = node.dataset.tip;
    if (tooltipElement) {
      node.appendChild(tooltipElement);
    }
  };

  return (
    <Layout title={siteConfig.title} description={siteConfig.tagline}>
      <section className={cx(styles.hero, 'bg-flutter-blue-primary-dark dark-bg-flutter-blue-primary-dark')}>
        {/** Left **/}
        <Triangle
          zIndex={1}
          light="flutter-blue-primary"
          dark="flutter-blue-primary"
          style={{
            left: -150,
          }}
        />
        <Triangle
          light="flutter-blue-primary-light"
          dark="flutter-blue-primary-light"
          style={{
            left: 0,
          }}
          rotate={-90}
        />

        {/** Right **/}
        <Triangle
          zIndex={1}
          light="flutter-blue-primary"
          dark="flutter-blue-primary"
          style={{
            right: 0,
            bottom: -150,
          }}
          rotate={180}
        />
        <Triangle
          light="flutter-blue-primary-light"
          dark="flutter-blue-primary-light"
          style={{
            right: -150,
          }}
          rotate={90}
        />
        <div className={cx(styles.content, 'text-white')}>
          <h1>{siteConfig.title}</h1>
          <h2>{siteConfig.tagline}</h2>
          <div className={styles.actions}>
            {/* <Link to={`${siteConfig.baseUrl}docs/overview`}>Get Started &raquo;</Link> */}
            <Link to="https://github.com/fluttercommunity/plus_plugins">GitHub &raquo;</Link>
          </div>
        </div>
      </section>
      <main>
        <div className={styles.plugins}>
          <table className={styles.table}>
            <thead>
              <tr>
                <th align="left">Plugin</th>
                <th>Pub</th>
                <th>Docs</th>
                <th>Android</th>
                <th>iOS</th>
                <th>Web</th>
                <th>MacOS</th>
                <th>Linux</th>
                <th>Windows</th>
              </tr>
            </thead>
            <tbody>
              {plugins.map((plugin: Plugin) => (
                <tr key={plugin.pub}>
                  <td align="left">
                    <strong>{plugin.name}</strong>
                  </td>
                  <td style={{ minWidth: 150 }}>
                    <a href={`https://pub.dev/packages/${plugin.pub}`}>
                      <img
                        src={`https://img.shields.io/pub/v/${plugin.pub}.svg`}
                        alt={`${plugin.name} Badge`}
                      />
                    </a>
                  </td>
                  <td>
                    <a href={`https://pub.dev/documentation/${plugin.pub}/latest/`}>
                      <Docs />
                    </a>
                  </td>
                  <td className="icon">
                    <Maintainer username={plugin.maintainer.android} />
                    {plugin.support.android == undefined ? (
                      <Dash />
                    ) : plugin.support.android ? (
                      <Check />
                    ) : (
                      <Cross />
                    )}
                  </td>
                  <td className="icon">
                    <Maintainer username={plugin.maintainer.ios} />
                    {plugin.support.ios == undefined ? (
                      <Dash />
                    ) : plugin.support.ios ? (
                      <Check />
                    ) : (
                      <Cross />
                    )}
                  </td>
                  <td className="icon">
                    <Maintainer username={plugin.maintainer.web} />
                    {plugin.support.web == undefined ? (
                      <Dash />
                    ) : plugin.support.web ? (
                      <Check />
                    ) : (
                      <Cross />
                    )}
                  </td>
                  <td className="icon">
                    <Maintainer username={plugin.maintainer.macos} />
                    {plugin.support.macos == undefined ? (
                      <Dash />
                    ) : plugin.support.macos ? (
                      <Check />
                    ) : (
                      <Cross />
                    )}
                  </td>
                  <td className="icon">
                    <Maintainer username={plugin.maintainer.linux} />
                    {plugin.support.linux == undefined ? (
                      <Dash />
                    ) : plugin.support.linux ? (
                      <Check />
                    ) : (
                      <Cross />
                    )}
                  </td>
                  <td className="icon">
                    <Maintainer username={plugin.maintainer.windows} />
                    {plugin.support.windows == undefined ? (
                      <Dash />
                    ) : plugin.support.windows ? (
                      <Check />
                    ) : (
                      <Cross />
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </main>
    </Layout>
  );
}

function Maintainer({ username }: any) {
  const [isOpen, setOpen] = useState(false);
  const toggleTooltip = (e: any) => {
    e.preventDefault();
    setOpen(!isOpen);
  };

  return username ? (
    <div
      className="tooltip"
      onClick={toggleTooltip}
      onMouseLeave={() => {
        setOpen(false);
      }}
    >
      {isOpen && (
        <>
          <a
            className="tooltip__link"
            target="_blank"
            rel="noreferrer"
            href={`https://github.com/${username}`}
            onClick={(e: any) => {
              e.stopPropagation();
            }}
          >
            {username}
            {/* <div className="tooltip__arrow"></div> */}
          </a>
        </>
      )}
    </div>
  ) : null;
}

function GithubIcon() {
  return (
    <svg viewBox="0 0 24 24" width="25px" height="25px" fill="#72acea">
      <path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12" />
    </svg>
  );
}

function Docs() {
  return <span style={{ color: '#72acea', fontSize: '1.5rem' }}>&#x1F4D8;</span>;
}

function Dash() {
  return <span style={{ color: '#acacac', fontSize: '1.5rem' }}>&#x2796;</span>;
}

function Check() {
  return <span style={{ color: '#4caf50', fontSize: '1.5rem' }}>&#x2714;</span>;
}

function Cross() {
  return <span style={{ color: '#f44336', fontSize: '2.1rem' }}>&#x2A2F;</span>;
}

export default Home;
