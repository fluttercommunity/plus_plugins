package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import android.os.Parcelable;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.ConvertExtras;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.BundleParcelable;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.base.ParcelableBase;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutParcelableArray extends PutBase {
  final List<ParcelableBase> values;

  public PutParcelableArray(String key, List<ParcelableBase> values) {
    super(key);
    this.values = values;
  }

  public static void convert(Bundle bundle, PutParcelableArray putParcelableArray) {
    bundle.putParcelableArray(putParcelableArray.key, convertToParcelable(putParcelableArray.values).toArray(new Parcelable[0]));
  }

  public static ArrayList<Parcelable> convertToParcelable(List<ParcelableBase> values) {
    ArrayList<Parcelable> parcelables = new ArrayList<>();
    for (ParcelableBase parcelableBase : values) {
      if (parcelableBase instanceof BundleParcelable) {
        BundleParcelable bundleParcelable = (BundleParcelable) parcelableBase;
        final Bundle bundle = new Bundle();
        for (PutBase putBase : bundleParcelable.values) {
          ConvertExtras.convert(bundle, putBase);
        }
        parcelables.add(bundle);
      }
    }
    return parcelables;
  }
}
