class AndroidIntentOptions {
  /// Constants that can be set on an intent to tweak how it is finally handled.
  /// Some of the constants are mirrored to Dart via [Flag].
  ///
  /// See https://developer.android.com/reference/android/content/Intent.html#setFlags(int).
  final int? flags;

  final String? componentName;

  /// See https://developer.android.com/reference/android/content/Intent.html#setPackage(java.lang.String).
  final String? packageName;

  AndroidIntentOptions._({this.flags, this.componentName, this.packageName});

  factory AndroidIntentOptions({
    List<int>? flags,
    String? componentName,
    String? packageName,
  }) {
    int convertFlags(List<int> flags) {
      bool isPowerOfTwo(int x) {
        /* First x in the below expression is for the case when x is 0 */
        return x != 0 && ((x & (x - 1)) == 0);
      }

      var finalValue = 0;
      for (var i = 0; i < flags.length; i++) {
        if (!isPowerOfTwo(flags[i])) {
          throw ArgumentError.value(
              flags[i], 'flag\'s value must be power of 2');
        }
        finalValue |= flags[i];
      }
      return finalValue;
    }

    return AndroidIntentOptions._(
      flags: flags?.isNotEmpty == true ? convertFlags(flags!) : null,
      componentName: componentName,
      packageName: packageName,
    );
  }
}
