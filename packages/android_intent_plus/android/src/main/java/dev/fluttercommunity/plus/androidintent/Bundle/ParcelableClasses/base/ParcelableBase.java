package dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.base;

import org.json.JSONException;
import org.json.JSONObject;

import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.Bundle;

public class ParcelableBase {

  static public JSONObject toJson(ParcelableBase parcelableBase) throws JSONException {
    if (parcelableBase instanceof Bundle) {
      return ((Bundle) parcelableBase).toJson();
    } else {
      throw new RuntimeException("Unknown Parcelable type: " + (parcelableBase == null ? "null" : parcelableBase.getClass().getName()));
    }
  }

  static public ParcelableBase createParcelableBase(android.os.Parcelable parcelable) {
    if (parcelable instanceof android.os.Bundle) {
      android.os.Bundle bundle = (android.os.Bundle) parcelable;
      return Bundle.fromAndroidOsBundle(bundle);
    } else {
      throw new RuntimeException("Unknown Parcelable type: " + (parcelable == null ? "null" : parcelable.getClass().getName()));
    }
  }
}
