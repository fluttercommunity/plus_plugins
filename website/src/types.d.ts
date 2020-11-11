/// <reference types="@docusaurus/module-type-aliases" />

declare module '*.scss' {
  const content: { [className: string]: string };
  export default content;
}

declare module '*.png' {
  const image: any;
  export default image;
}
