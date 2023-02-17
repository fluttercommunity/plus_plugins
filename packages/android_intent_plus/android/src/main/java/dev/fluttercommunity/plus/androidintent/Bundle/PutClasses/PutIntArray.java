package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutIntArray extends PutBase {
  public PutIntArray(String key, List<Integer> value) {
    super(key);
    this.value = value;
  }

  final List<Integer> value;

  static public void convert(Bundle bundle, PutIntArray putIntArray) {
    bundle.putIntArray(putIntArray.key, toPrimitiveArray(putIntArray.value));
  }

  static private int[] toPrimitiveArray(final List<Integer> integerList) {
    final int[] primitives = new int[integerList.size()];
    for (int i = 0; i < integerList.size(); i++) {
      primitives[i] = integerList.get(i);
    }
    return primitives;
  }
}
