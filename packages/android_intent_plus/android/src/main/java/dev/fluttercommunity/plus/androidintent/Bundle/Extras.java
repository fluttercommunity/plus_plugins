package dev.fluttercommunity.plus.androidintent.Bundle;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.BundleParcelable;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.base.ParcelableBase;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutBool;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutBoolArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutBundle;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutParcelableArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutParcelableArrayList;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutInt;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutIntArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutIntArrayList;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutString;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutStringArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutStringArrayList;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import dev.fluttercommunity.plus.androidintent.Bundle.TypeAdapters.RuntimeTypeAdapterFactory;

public class Extras {
  public static android.os.Bundle convert(String arguments) {
    RuntimeTypeAdapterFactory<ParcelableBase> parcelableBaseRuntimeTypeAdapterFactory = RuntimeTypeAdapterFactory.
        of(ParcelableBase.class, "javaClass")
        .registerSubtype(BundleParcelable.class, "BundleParcelable");
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

    final android.os.Bundle bundle = new android.os.Bundle();
    if (arguments == null) {
      return bundle;
    }
    ExtrasRoot extrasRoot = gson.fromJson(arguments, ExtrasRoot.class);
    for (PutBase putBase : extrasRoot.extras
    ) {
      ConvertExtras.convert(bundle, putBase);
    }
    return bundle;
  }
}
