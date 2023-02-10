package dev.fluttercommunity.plus.androidintent.Bundle;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.base.ParcelableBase;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutBool;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutBoolArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutBundle;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutInt;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutIntArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutIntArrayList;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutParcelableArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutParcelableArrayList;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutString;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutStringArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutStringArrayList;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import dev.fluttercommunity.plus.androidintent.Bundle.TypeAdapters.RuntimeTypeAdapterFactory;

public class Extras {
  public static List<android.os.Bundle> convert(String arguments) {
    RuntimeTypeAdapterFactory<ParcelableBase> parcelableBaseRuntimeTypeAdapterFactory = RuntimeTypeAdapterFactory.
        of(ParcelableBase.class, "javaClass")
        .registerSubtype(Bundle.class, "Bundle");
    RuntimeTypeAdapterFactory<PutBase> putBaseRuntimeTypeAdapterFactory = RuntimeTypeAdapterFactory
        .of(PutBase.class, "javaClass")
        .registerSubtype(PutBool.class, "PutBool")
        .registerSubtype(PutBoolArray.class, "PutBoolArray")
        .registerSubtype(PutBundle.class, "PutBundle")
        .registerSubtype(PutParcelableArray.class, "PutParcelableArray")
        .registerSubtype(PutParcelableArrayList.class, "PutParcelableArrayList")
        .registerSubtype(PutInt.class, "PutInt")
        .registerSubtype(PutIntArray.class, "PutIntArray")
        .registerSubtype(PutIntArrayList.class, "PutIntArrayList")
        .registerSubtype(PutString.class, "PutString")
        .registerSubtype(PutStringArray.class, "PutStringArray")
        .registerSubtype(PutStringArrayList.class, "PutStringArrayList");

    Gson gson = new GsonBuilder()
        .registerTypeAdapterFactory(parcelableBaseRuntimeTypeAdapterFactory)
        .registerTypeAdapterFactory(putBaseRuntimeTypeAdapterFactory)
        .create();

    List<android.os.Bundle> androidOsBundles = new ArrayList<>();
    if (arguments == null) {
      return androidOsBundles;
    }

    Bundles bundles = gson.fromJson(arguments, Bundles.class);
    for (Bundle bundle : bundles.values
    ) {
      final android.os.Bundle androidOsBundle = new android.os.Bundle();
      for (PutBase putBase : bundle.values) {
        ConvertExtras.convert(androidOsBundle, putBase);
      }
      androidOsBundles.add(androidOsBundle);
    }
    return androidOsBundles;
  }
}
