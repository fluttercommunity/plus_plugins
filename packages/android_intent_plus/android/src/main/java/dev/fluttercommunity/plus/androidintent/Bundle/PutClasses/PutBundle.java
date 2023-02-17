package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import dev.fluttercommunity.plus.androidintent.Bundle.ConvertExtras;

public class PutBundle extends PutBase {
  public PutBundle(String key, List<PutBase> value) {
    super(key);
    this.value = value;
  }

  final List<PutBase> value;

  static public void convert(Bundle bundle, PutBundle putBundle) {
    Bundle subBundle = new Bundle();
    for (PutBase putBase: putBundle.value) {
      ConvertExtras.convert(subBundle, putBase);
    }
    bundle.putBundle(putBundle.key, subBundle);
  }
}
