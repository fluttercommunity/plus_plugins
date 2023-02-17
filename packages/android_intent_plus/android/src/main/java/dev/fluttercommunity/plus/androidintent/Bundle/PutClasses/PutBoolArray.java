package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutBoolArray extends PutBase {
  public PutBoolArray(String key, List<Boolean> value) {
    super(key);
    this.value = value;
  }

  final List<Boolean> value;

  static public void convert(Bundle bundle, PutBoolArray putBoolArray) {
    bundle.putBooleanArray(putBoolArray.key, toPrimitiveArray(putBoolArray.value));
  }

  static private boolean[] toPrimitiveArray(final List<Boolean> booleanList) {
    final boolean[] primitives = new boolean[booleanList.size()];
    for (int i = 0; i < booleanList.size(); i++) {
      primitives[i] = booleanList.get(i);
    }
    return primitives;
  }
}
