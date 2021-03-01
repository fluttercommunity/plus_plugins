import React, { ReactElement } from 'react';
import { Redirect } from 'react-router-dom';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';

const docsRedirect = (): ReactElement => {
  const context = useDocusaurusContext();
  const { siteConfig } = context;

  return <Redirect to={`${siteConfig.baseUrl}docs/overview`} />;
};

export default docsRedirect;
