package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;


public class PutIntegerArrayList extends PutBase<List<Integer>> {

  public static final String JAVA_CLASS = "PutIntegerArrayList";

  public PutIntegerArrayList(String key, List<Integer> value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutIntegerArrayList putIntegerArrayList) {
    bundle.putIntegerArrayList(putIntegerArrayList.key, new ArrayList<>(putIntegerArrayList.value));
  }

  public static PutIntegerArrayList fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<Integer> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add(jsonArray.getInt(i));
    }
    return new PutIntegerArrayList(jsonObject.getString(Constants.KEY), arrayList);
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
