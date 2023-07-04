package dev.fluttercommunity.plus.androidintent.Bundle;

import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONException;

public class AndroidOsBundle {
  public static List<android.os.Bundle> fromJsonString(String arguments) throws JSONException {
    List<android.os.Bundle> androidOsBundles = new ArrayList<>();
    if (arguments == null) {
      return androidOsBundles;
    }
    Bundles bundles = Bundles.bundlesFromJsonString(arguments);
    for (dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.Bundle bundle :
        bundles.value) {
      final android.os.Bundle androidOsBundle = new android.os.Bundle();
      for (PutBase<?> putBase : bundle.value) {
        PutBase.addToAndroidOsBundle(androidOsBundle, putBase);
      }
      androidOsBundles.add(androidOsBundle);
    }
    return androidOsBundles;
  }
}
