package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import org.json.JSONException;
import org.json.JSONObject;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;


public class PutFloat extends PutBase<Float> {

  public static final String JAVA_CLASS = "PutFloat";

  public PutFloat(String key, Float value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutFloat putDouble) {
    bundle.putFloat(putDouble.key, putDouble.value);
  }

  public static PutFloat fromJson(JSONObject jsonObject) throws JSONException {
    return new PutFloat(jsonObject.getString(Constants.KEY), (float) jsonObject.getDouble(Constants.VALUE));
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
