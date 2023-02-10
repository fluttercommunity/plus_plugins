package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutInt extends PutBase {
  public PutInt(String key, Integer value) {
    super(key);
    this.value = value;
  }

  final Integer value;

  public static void convert(Bundle bundle, PutInt putInt) {
    bundle.putInt(putInt.key, putInt.value);
  }
}
