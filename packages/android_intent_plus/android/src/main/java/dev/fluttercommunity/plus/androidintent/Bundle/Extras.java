package dev.fluttercommunity.plus.androidintent.Bundle;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class Extras {
  public static List<android.os.Bundle> convert(String arguments) {
    List<android.os.Bundle> androidOsBundles = new ArrayList<>();
    if (arguments == null) {
      return androidOsBundles;
    }
    Bundles bundles = CreateExtras.create(arguments);
    for (Bundle bundle : bundles.value) {
      final android.os.Bundle androidOsBundle = new android.os.Bundle();
      for (PutBase putBase : bundle.value) {
        ConvertExtras.convert(androidOsBundle, putBase);
      }
      androidOsBundles.add(androidOsBundle);
    }
    return androidOsBundles;
  }
}
