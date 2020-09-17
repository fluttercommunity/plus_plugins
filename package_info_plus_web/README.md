# package_info_plus_web

The web implementation of [`package_info_plus`][1].

## Usage
### Using this package
To use this plugin please upgrade to latest version of flutter master channel
### Import the package

This package has been endorsed, meaning that you only need to add `package_info_plus`
as a dependency in your `pubspec.yaml`. It will be automatically included in your app
when you depend on `package:package_info_plus`.

This is what the above means to your `pubspec.yaml`:

```yaml
...
dependencies:
  ...
  package_info_plus: ^0.4.5
  ...
```

If you wish to use the web package only, you can add  `package_info_plus_web` as a
dependency:

```yaml
...
dependencies:
  ...
  package_info_plus_web: ^0.0.1
  ...
```

### Use the plugin
Once you have the correct `package_info_plus` dependency in your pubspec, you should be able to use package:package_info_plus as normal, even from your web code.

[1]: ../package_info_plus
