package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PutLongArray extends PutBase<List<Long>> {

  public static final String JAVA_CLASS = "PutLongArray";

  public PutLongArray(String key, List<Long> value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutLongArray putLongArray) {
    bundle.putLongArray(putLongArray.key, toPrimitiveArray(putLongArray.value));
  }

  private static long[] toPrimitiveArray(final List<Long> longList) {
    final long[] primitives = new long[longList.size()];
    for (int i = 0; i < longList.size(); i++) {
      primitives[i] = longList.get(i);
    }
    return primitives;
  }

  public static PutLongArray fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<Long> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add(jsonArray.getLong(i));
    }
    return new PutLongArray(jsonObject.getString(Constants.KEY), arrayList);
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
