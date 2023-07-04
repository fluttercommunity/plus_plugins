package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import org.json.JSONException;
import org.json.JSONObject;

public class PutString extends PutBase<String> {

  public static final String JAVA_CLASS = "PutString";

  public PutString(String key, String value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutString putString) {
    bundle.putString(putString.key, putString.value);
  }

  public static PutString fromJson(JSONObject jsonObject) throws JSONException {
    return new PutString(
        jsonObject.getString(Constants.KEY), jsonObject.getString(Constants.VALUE));
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
