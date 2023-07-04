package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PutIntArray extends PutBase<List<Integer>> {

  public static final String JAVA_CLASS = "PutIntArray";

  public PutIntArray(String key, List<Integer> value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutIntArray putIntArray) {
    bundle.putIntArray(putIntArray.key, toPrimitiveArray(putIntArray.value));
  }

  private static int[] toPrimitiveArray(final List<Integer> integerList) {
    final int[] primitives = new int[integerList.size()];
    for (int i = 0; i < integerList.size(); i++) {
      primitives[i] = integerList.get(i);
    }
    return primitives;
  }

  public static PutIntArray fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<Integer> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add(jsonArray.getInt(i));
    }
    return new PutIntArray(jsonObject.getString(Constants.KEY), arrayList);
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
