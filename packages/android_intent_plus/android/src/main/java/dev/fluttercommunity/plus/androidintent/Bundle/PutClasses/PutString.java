package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import org.json.JSONException;
import org.json.JSONObject;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutString extends PutBase {
  public final static String javaClass = "PutString";
  final String value;

  public PutString(String key, String value) {
    super(key);
    this.value = value;
  }

  public static void convert(Bundle bundle, PutString putString) {
    bundle.putString(putString.key, putString.value);
  }

  public static PutString fromJson(JSONObject jsonObject) throws JSONException {
    return new PutString(jsonObject.getString(Constants.KEY), jsonObject.getString(Constants.VALUE));
  }
}
