package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import android.os.Parcelable;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import dev.fluttercommunity.plus.androidintent.Bundle.ConvertExtras;

public class PutBundleParcelableArray extends PutBase {
  final List<List<PutBase>> values;

  public PutBundleParcelableArray(String key, List<List<PutBase>> values) {
    super(key);
    this.values = values;
  }

  public static void convert(Bundle bundle, PutBundleParcelableArray putBundleParcelableArray) {
    bundle.putParcelableArray(putBundleParcelableArray.key, convertToParcelable(putBundleParcelableArray.values).toArray(new Parcelable[0]));
  }

  public static ArrayList<Parcelable> convertToParcelable(List<List<PutBase>> values) {
    ArrayList<Parcelable> parcelables = new ArrayList<>();
    for (List<PutBase> listOfPutBase : values) {
      final Bundle bundle = new Bundle();
      for (PutBase putBase : listOfPutBase) {
        ConvertExtras.convert(bundle, putBase);
      }
      parcelables.add(bundle);
    }
    return parcelables;
  }
}
