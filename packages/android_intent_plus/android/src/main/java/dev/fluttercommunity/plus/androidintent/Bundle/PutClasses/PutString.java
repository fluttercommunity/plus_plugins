package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutString extends PutBase {
  public PutString(String key, String value) {
    super(key);
    this.value = value;
  }

  final String value;

  public static void convert(Bundle bundle, PutString putString) {
    bundle.putString(putString.key, putString.value);
  }
}
