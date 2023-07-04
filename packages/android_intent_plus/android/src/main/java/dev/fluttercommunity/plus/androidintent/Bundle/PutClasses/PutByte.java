package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import org.json.JSONException;
import org.json.JSONObject;

public class PutByte extends PutBase<Byte> {

  public static final String JAVA_CLASS = "PutByte";

  public PutByte(String key, Byte value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutByte putByte) {
    bundle.putByte(putByte.key, putByte.value);
  }

  public static PutByte fromJson(JSONObject jsonObject) throws JSONException {
    return new PutByte(
        jsonObject.getString(Constants.KEY), (byte) jsonObject.getInt(Constants.VALUE));
  }

  @Override
  public JSONObject toJson() throws JSONException {
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("key", key);
    jsonObject.put("javaClass", JAVA_CLASS);
    jsonObject.put("value", (int) value);
    return jsonObject;
  }
}
