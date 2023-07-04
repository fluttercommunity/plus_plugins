package dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.base;

import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.Bundle;
import org.json.JSONException;
import org.json.JSONObject;

public class ParcelableBase {

  public static JSONObject toJson(ParcelableBase parcelableBase) throws JSONException {
    if (parcelableBase instanceof Bundle) {
      return ((Bundle) parcelableBase).toJson();
    } else {
      throw new RuntimeException(
          "Unknown Parcelable type: "
              + (parcelableBase == null ? "null" : parcelableBase.getClass().getName()));
    }
  }

  public static ParcelableBase createParcelableBase(android.os.Parcelable parcelable) {
    if (parcelable instanceof android.os.Bundle) {
      android.os.Bundle bundle = (android.os.Bundle) parcelable;
      return Bundle.fromAndroidOsBundle(bundle);
    } else {
      throw new RuntimeException(
          "Unknown Parcelable type: "
              + (parcelable == null ? "null" : parcelable.getClass().getName()));
    }
  }
}
