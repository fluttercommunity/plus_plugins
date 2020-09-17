# package_info_plus_macos

The macos implementation of [`package_info_plus`][1].

## Usage

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

If you wish to use the macos package only, you can add  `package_info_plus_macos` as a
dependency:

```yaml
...
dependencies:
  ...
  package_info_plus_macos: ^0.0.1
  ...
```

[1]: ../package_info_plus/package_info_plus