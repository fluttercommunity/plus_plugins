package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutBundle extends PutBase<List<PutBase<?>>> {

  public static final String JAVA_CLASS = "PutBundle";

  public PutBundle(String key, List<PutBase<?>> value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutBundle putBundle) {
    Bundle subBundle = new Bundle();
    for (PutBase<?> putBase : putBundle.value) {
      PutBase.addToAndroidOsBundle(subBundle, putBase);
    }
    bundle.putBundle(putBundle.key, subBundle);
  }

  public static PutBundle fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<PutBase<?>> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add(PutBase.fromJson(jsonArray.getJSONObject(i)));
    }
    return new PutBundle(jsonObject.getString(Constants.KEY), arrayList);
  }

  @Override
  public JSONObject toJson() throws JSONException {
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("key", key);
    jsonObject.put("javaClass", JAVA_CLASS);
    final JSONArray jsonArray = new JSONArray();
    for (PutBase<?> putBase : value) {
      jsonArray.put(putBase.toJson());
    }
    jsonObject.put("value", jsonArray);
    return jsonObject;
  }
}
