package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Parcelable;

import org.json.JSONException;
import org.json.JSONObject;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.base.ParcelableBase;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import dev.fluttercommunity.plus.androidintent.GetType;

public class PutParcelable extends PutBase<ParcelableBase> {

  public static final String JAVA_CLASS = "PutParcelable";

  public PutParcelable(String key, ParcelableBase value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(android.os.Bundle bundle, PutParcelable putParcelable) {
    bundle.putParcelable(putParcelable.key, convertToParcelable(putParcelable.value));
  }

  public static PutParcelable fromJson(JSONObject jsonObject) throws JSONException {
    final ParcelableBase parcelableBase = parcelableBaseFromJson(jsonObject.getJSONObject(Constants.VALUE));
    return new PutParcelable(jsonObject.getString(Constants.KEY), parcelableBase);
  }

  public static ParcelableBase parcelableBaseFromJson(JSONObject json) throws JSONException {
    //Add other parcelable classes here
    final String javaClass = json.getString(Constants.JAVA_CLASS);
    //noinspection SwitchStatementWithTooFewBranches
    switch (javaClass) {
      case Bundle.JAVA_CLASS:
        return Bundle.fromJson(json);
    }
    throw new RuntimeException(String.format("JavaClass (%s) not found (Json.parcelableBaseFromJson)", javaClass));
  }

  public static Parcelable convertToParcelable(ParcelableBase value) {
    if (value instanceof Bundle) {
      Bundle bundleParcelable = (Bundle) value;
      final android.os.Bundle bundle = new android.os.Bundle();
      for (PutBase<?> putBase : bundleParcelable.value) {
        PutBase.addToAndroidOsBundle(bundle, putBase);
      }
      return bundle;
    } else {
      throw new RuntimeException(GetType.name(value.getClass()));
    }
  }

  @Override
  public JSONObject toJson() throws JSONException {
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("key", key);
    jsonObject.put("javaClass", JAVA_CLASS);
    jsonObject.put("value", ParcelableBase.toJson(value));
    return jsonObject;
  }
}
