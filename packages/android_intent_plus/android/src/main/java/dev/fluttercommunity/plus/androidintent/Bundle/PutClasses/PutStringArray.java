package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutStringArray extends PutBase {
  public PutStringArray(String key, List<String> value) {
    super(key);
    this.value = value;
  }

  final List<String> value;

  public static void convert(Bundle bundle, PutStringArray putStringArray) {
    bundle.putStringArray(putStringArray.key, toPrimitiveArray(putStringArray.value));
  }

  static private String[] toPrimitiveArray(final List<String> stringList) {
    final String[] primitives = new String[stringList.size()];
    for (int i = 0; i < stringList.size(); i++) {
      primitives[i] = stringList.get(i);
    }
    return primitives;
  }
}
