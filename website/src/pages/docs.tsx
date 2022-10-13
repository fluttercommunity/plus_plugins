import React, { ReactElement } from 'react';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import { Redirect } from '@docusaurus/router';

const docsRedirect = (): ReactElement => {
  const context = useDocusaurusContext();
  const { siteConfig } = context;

  return <Redirect to={`${siteConfig.baseUrl}docs/overview`} />;
};

export default docsRedirect;
