package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PutShortArray extends PutBase<List<Short>> {

  public static final String JAVA_CLASS = "PutShortArray";

  public PutShortArray(String key, List<Short> value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutShortArray putShortArray) {
    bundle.putShortArray(putShortArray.key, toPrimitiveArray(putShortArray.value));
  }

  private static short[] toPrimitiveArray(final List<Short> shortList) {
    final short[] primitives = new short[shortList.size()];
    for (int i = 0; i < shortList.size(); i++) {
      primitives[i] = shortList.get(i);
    }
    return primitives;
  }

  public static PutShortArray fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<Short> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add((short) jsonArray.getInt(i));
    }
    return new PutShortArray(jsonObject.getString(Constants.KEY), arrayList);
  }

  @Override
  public JSONObject toJson() throws JSONException {
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("key", key);
    jsonObject.put("javaClass", JAVA_CLASS);
    jsonObject.put("value", new JSONArray(value));
    return jsonObject;
  }
}
