package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutIntArrayList extends PutBase {
  public PutIntArrayList(String key, List<Integer> values) {
    super(key);
    this.values = values;
  }

  final List<Integer> values;

  static public void convert(Bundle bundle, PutIntArrayList putIntArray) {
    bundle.putIntegerArrayList(putIntArray.key, new ArrayList<>(putIntArray.values));
  }
}
