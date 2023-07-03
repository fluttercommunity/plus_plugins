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

public class PutDoubleArray extends PutBase<List<Double>> {

  public static final String JAVA_CLASS = "PutDoubleArray";

  public PutDoubleArray(String key, List<Double> value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutDoubleArray putDoubleArray) {
    bundle.putDoubleArray(putDoubleArray.key, toPrimitiveArray(putDoubleArray.value));
  }

  private static double[] toPrimitiveArray(final List<Double> doubleList) {
    final double[] primitives = new double[doubleList.size()];
    for (int i = 0; i < doubleList.size(); i++) {
      primitives[i] = doubleList.get(i);
    }
    return primitives;
  }

  public static PutDoubleArray fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<Double> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add(jsonArray.getDouble(i));
    }
    return new PutDoubleArray(jsonObject.getString(Constants.KEY), arrayList);
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
