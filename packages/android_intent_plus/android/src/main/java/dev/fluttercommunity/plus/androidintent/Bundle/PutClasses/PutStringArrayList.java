package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutStringArrayList extends PutBase {
  public PutStringArrayList(String key, List<String> value) {
    super(key);
    this.value = value;
  }

  final List<String> value;

  public static void convert(Bundle bundle, PutStringArrayList putStringArray) {
    bundle.putStringArrayList(putStringArray.key, new ArrayList<>(putStringArray.value));
  }
}
