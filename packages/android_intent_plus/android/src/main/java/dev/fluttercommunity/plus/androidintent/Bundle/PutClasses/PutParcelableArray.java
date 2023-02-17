package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Parcelable;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.ConvertExtras;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.base.ParcelableBase;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutParcelableArray extends PutBase {
  final List<ParcelableBase> value;

  public PutParcelableArray(String key, List<ParcelableBase> value) {
    super(key);
    this.value = value;
  }

  public static void convert(android.os.Bundle bundle, PutParcelableArray putParcelableArray) {
    bundle.putParcelableArray(putParcelableArray.key, convertToParcelable(putParcelableArray.value).toArray(new Parcelable[0]));
  }

  public static ArrayList<Parcelable> convertToParcelable(List<ParcelableBase> values) {
    ArrayList<Parcelable> parcelables = new ArrayList<>();
    for (ParcelableBase parcelableBase : values) {
      if (parcelableBase instanceof Bundle) {
        Bundle bundleParcelable = (Bundle) parcelableBase;
        final android.os.Bundle bundle = new android.os.Bundle();
        for (PutBase putBase : bundleParcelable.value) {
          ConvertExtras.convert(bundle, putBase);
        }
        parcelables.add(bundle);
      }
    }
    return parcelables;
  }
}
