package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import org.json.JSONException;
import org.json.JSONObject;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;


public class PutDouble extends PutBase<Double> {

  public static final String JAVA_CLASS = "PutDouble";

  public PutDouble(String key, Double value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutDouble putDouble) {
    bundle.putDouble(putDouble.key, putDouble.value);
  }

  public static PutDouble fromJson(JSONObject jsonObject) throws JSONException {
    return new PutDouble(jsonObject.getString(Constants.KEY), jsonObject.getDouble(Constants.VALUE));
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
