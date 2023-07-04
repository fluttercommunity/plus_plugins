package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import org.json.JSONException;
import org.json.JSONObject;

public class PutShort extends PutBase<Short> {

  public static final String JAVA_CLASS = "PutShort";

  public PutShort(String key, Short value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutShort putShort) {
    bundle.putShort(putShort.key, putShort.value);
  }

  public static PutShort fromJson(JSONObject jsonObject) throws JSONException {
    return new PutShort(
        jsonObject.getString(Constants.KEY), (short) jsonObject.getInt(Constants.VALUE));
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
