package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import org.json.JSONException;
import org.json.JSONObject;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;


public class PutCharSequence extends PutBase<CharSequence> {

  public static final String JAVA_CLASS = "PutCharSequence";

  public PutCharSequence(String key, CharSequence value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutCharSequence putCharSequence) {
    bundle.putCharSequence(putCharSequence.key, putCharSequence.value);
  }

  public static PutCharSequence fromJson(JSONObject jsonObject) throws JSONException {
    return new PutCharSequence(jsonObject.getString(Constants.KEY), jsonObject.getString(Constants.VALUE));
  }

  @Override
  public JSONObject toJson() throws JSONException {
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("key", key);
    jsonObject.put("javaClass", JAVA_CLASS);
    jsonObject.put("value", value);
    return jsonObject;
  }
}
