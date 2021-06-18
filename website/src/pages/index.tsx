import React, { useState } from 'react';
import cx from 'classnames';
import Layout from '@theme/Layout';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';

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

function Home(): JSX.Element {
  const context = useDocusaurusContext();
  const { siteConfig } = context;

  return (
    <Layout title={siteConfig.title} description={siteConfig.tagline}>
      <section
        className={cx(
          styles.hero,
          'bg-flutter-blue-primary-dark dark-bg-flutter-blue-primary-dark',
        )}
      >
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
            <Link to={`${siteConfig.baseUrl}docs/overview`}>Get Started &raquo;</Link>
            <Link to="https://github.com/fluttercommunity/plus_plugins">GitHub &raquo;</Link>
          </div>
          <div
            style={{
              paddingTop: '1rem',
            }}
          >
            <a
              href="https://flutter.dev/docs/development/packages-and-plugins/favorites"
              target="_blank"
              rel="noreferrer noopener"
            >
              <img
                src="./img/flutter-favorite-badge.png"
                width="75"
                height="75"
                alt="flutter favorite"
              />
            </a>
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
                    <a href={`/docs/${plugin.pub}/overview`}>
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

function Maintainer({ username }: { username: string | undefined }): JSX.Element | null {
  const [isOpen, setOpen] = useState(false);
  const toggleTooltip = (e: React.MouseEvent): void => {
    e.preventDefault();
    setOpen(!isOpen);
  };

  const stopPropagation = (e: React.MouseEvent): void => {
    e.stopPropagation();
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
            onClick={stopPropagation}
          >
            {username}
            {/* <div className="tooltip__arrow"></div> */}
          </a>
        </>
      )}
    </div>
  ) : null;
}

function Docs(): JSX.Element {
  return <span style={{ color: '#72acea', fontSize: '1.5rem' }}>&#x1F4D8;</span>;
}

function Dash(): JSX.Element {
  return <span style={{ color: '#acacac', fontSize: '1.5rem' }}>&#x2796;</span>;
}

function Check(): JSX.Element {
  return <span style={{ color: '#4caf50', fontSize: '1.5rem' }}>&#x2714;</span>;
}

function Cross(): JSX.Element {
  return <span style={{ color: '#f44336', fontSize: '2.1rem' }}>&#x2A2F;</span>;
}

export default Home;
