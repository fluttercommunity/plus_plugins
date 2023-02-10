package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import dev.fluttercommunity.plus.androidintent.Bundle.ConvertExtras;

public class PutBundle extends PutBase {
  public PutBundle(String key, List<PutBase> values) {
    super(key);
    this.values = values;
  }

  final List<PutBase> values;

  static public void convert(Bundle bundle, PutBundle putBundle) {
    Bundle subBundle = new Bundle();
    for (PutBase putBase: putBundle.values) {
      ConvertExtras.convert(subBundle, putBase);
    }
    bundle.putBundle(putBundle.key, subBundle);
  }
}
