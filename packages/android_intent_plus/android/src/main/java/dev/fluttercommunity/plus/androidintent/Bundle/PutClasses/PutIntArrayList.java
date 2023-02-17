package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutIntArrayList extends PutBase {
  public PutIntArrayList(String key, List<Integer> value) {
    super(key);
    this.value = value;
  }

  final List<Integer> value;

  static public void convert(Bundle bundle, PutIntArrayList putIntArray) {
    bundle.putIntegerArrayList(putIntArray.key, new ArrayList<>(putIntArray.value));
  }
}
