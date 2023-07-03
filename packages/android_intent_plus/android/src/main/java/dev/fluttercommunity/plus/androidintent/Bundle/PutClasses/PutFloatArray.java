package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.Helpers;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutFloatArray extends PutBase<List<Float>> {

  public static final String JAVA_CLASS = "PutFloatArray";

  public PutFloatArray(String key, List<Float> value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutFloatArray putFloatArray) {
    bundle.putFloatArray(putFloatArray.key, toPrimitiveArray(putFloatArray.value));
  }

  private static float[] toPrimitiveArray(final List<Float> doubleList) {
    final float[] primitives = new float[doubleList.size()];
    for (int i = 0; i < doubleList.size(); i++) {
      primitives[i] = doubleList.get(i);
    }
    return primitives;
  }

  public static PutFloatArray fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<Float> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add((float) jsonArray.getDouble(i));
    }
    return new PutFloatArray(jsonObject.getString(Constants.KEY), arrayList);
  }

  @Override
  public JSONObject toJson() throws JSONException {
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("key", key);
    jsonObject.put("javaClass", JAVA_CLASS);
    jsonObject.put("value", new JSONArray(Helpers.convertToArrayList(value)));
    return jsonObject;
  }
}
