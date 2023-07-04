package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import org.json.JSONException;
import org.json.JSONObject;

public class PutInt extends PutBase<Integer> {

  public static final String JAVA_CLASS = "PutInt";

  public PutInt(String key, Integer value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutInt putInt) {
    bundle.putInt(putInt.key, putInt.value);
  }

  public static PutInt fromJson(JSONObject jsonObject) throws JSONException {
    return new PutInt(jsonObject.getString(Constants.KEY), jsonObject.getInt(Constants.VALUE));
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
