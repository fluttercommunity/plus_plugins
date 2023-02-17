package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.base.ParcelableBase;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutParcelableArrayList extends PutBase {
  final List<ParcelableBase> value;

  public PutParcelableArrayList(String key, List<ParcelableBase> value) {
    super(key);
    this.value = value;
  }

  public static void convert(Bundle bundle, PutParcelableArrayList putParcelableArray) {
    bundle.putParcelableArrayList(putParcelableArray.key, PutParcelableArray.convertToParcelable(putParcelableArray.value));
  }
}
