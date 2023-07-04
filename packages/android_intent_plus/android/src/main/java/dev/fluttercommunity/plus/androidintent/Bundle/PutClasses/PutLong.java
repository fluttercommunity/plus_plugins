package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import org.json.JSONException;
import org.json.JSONObject;

public class PutLong extends PutBase<Long> {

  public static final String JAVA_CLASS = "PutLong";

  public PutLong(String key, Long value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutLong putLong) {
    bundle.putLong(putLong.key, putLong.value);
  }

  public static PutLong fromJson(JSONObject jsonObject) throws JSONException {
    return new PutLong(jsonObject.getString(Constants.KEY), jsonObject.getLong(Constants.VALUE));
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
