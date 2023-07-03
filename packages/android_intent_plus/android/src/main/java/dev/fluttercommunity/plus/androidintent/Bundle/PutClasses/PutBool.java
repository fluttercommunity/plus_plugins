package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import org.json.JSONException;
import org.json.JSONObject;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutBool extends PutBase<Boolean> {

  public final static String JAVA_CLASS = "PutBool";

  public PutBool(String key, boolean value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutBool putBool) {
    bundle.putBoolean(putBool.key, putBool.value);
  }

  public static PutBool fromJson(JSONObject jsonObject) throws JSONException {
    return new PutBool(jsonObject.getString(Constants.KEY), jsonObject.getBoolean(Constants.VALUE));
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
