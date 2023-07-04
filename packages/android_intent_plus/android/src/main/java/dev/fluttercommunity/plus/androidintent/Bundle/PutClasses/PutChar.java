package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import org.json.JSONException;
import org.json.JSONObject;

public class PutChar extends PutBase<Character> {

  public static final String JAVA_CLASS = "PutChar";

  public PutChar(String key, Character value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutChar putChar) {
    bundle.putChar(putChar.key, putChar.value);
  }

  public static PutChar fromJson(JSONObject jsonObject) throws JSONException {
    return new PutChar(
        jsonObject.getString(Constants.KEY), jsonObject.getString(Constants.VALUE).charAt(0));
  }

  @Override
  public JSONObject toJson() throws JSONException {
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("key", key);
    jsonObject.put("javaClass", JAVA_CLASS);
    jsonObject.put("value", value.toString());
    return jsonObject;
  }
}
