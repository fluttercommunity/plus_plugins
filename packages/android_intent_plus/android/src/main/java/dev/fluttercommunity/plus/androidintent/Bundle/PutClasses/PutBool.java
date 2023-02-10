package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutBool extends PutBase {
  public PutBool(String key, boolean value) {
    super(key);
    this.value = value;
  }

  final Boolean value;

  static public void convert(Bundle bundle, PutBool putBool) {
    bundle.putBoolean(putBool.key, putBool.value);
  }
}
