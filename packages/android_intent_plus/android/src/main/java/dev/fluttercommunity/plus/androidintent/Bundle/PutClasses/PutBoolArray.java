package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PutBoolArray extends PutBase<List<Boolean>> {

  public static final String JAVA_CLASS = "PutBoolArray";

  public PutBoolArray(String key, List<Boolean> value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutBoolArray putBoolArray) {
    bundle.putBooleanArray(putBoolArray.key, toPrimitiveArray(putBoolArray.value));
  }

  private static boolean[] toPrimitiveArray(final List<Boolean> booleanList) {
    final boolean[] primitives = new boolean[booleanList.size()];
    for (int i = 0; i < booleanList.size(); i++) {
      primitives[i] = booleanList.get(i);
    }
    return primitives;
  }

  public static PutBoolArray fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<Boolean> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add(jsonArray.getBoolean(i));
    }
    return new PutBoolArray(jsonObject.getString(Constants.KEY), arrayList);
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
