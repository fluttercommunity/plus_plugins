package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutBundleParcelableArrayList extends PutBase {
  final List<List<PutBase>> values;

  public PutBundleParcelableArrayList(String key, List<List<PutBase>> values) {
    super(key);
    this.values = values;
  }

  public static void convert(Bundle bundle, PutBundleParcelableArrayList putParcelableArray) {
    bundle.putParcelableArrayList(putParcelableArray.key, PutBundleParcelableArray.convertToParcelable(putParcelableArray.values));
  }
}
