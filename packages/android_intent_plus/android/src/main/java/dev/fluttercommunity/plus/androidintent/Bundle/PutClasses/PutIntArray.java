package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutIntArray extends PutBase {
  public final static String javaClass = "PutIntArray";
  final List<Integer> value;

  public PutIntArray(String key, List<Integer> value) {
    super(key);
    this.value = value;
  }

  static public void convert(Bundle bundle, PutIntArray putIntArray) {
    bundle.putIntArray(putIntArray.key, toPrimitiveArray(putIntArray.value));
  }

  static private int[] toPrimitiveArray(final List<Integer> integerList) {
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
}
