package dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.Json;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.base.ParcelableBase;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class Bundle extends ParcelableBase {

  public final static String javaClass = "Bundle";

  public List<PutBase> value = new ArrayList<>();

  public static Bundle fromJson(JSONObject bundleJSONObject) throws JSONException {
    final Bundle bundle = new Bundle();

    if (bundleJSONObject.getString(Constants.JAVA_CLASS).equals(Bundle.javaClass)) {
      JSONArray jsonArray = (JSONArray) (bundleJSONObject.get(Constants.VALUE));
      for (int i = 0; i < jsonArray.length(); i++) {
        JSONObject value = (JSONObject) jsonArray.get(i);
        bundle.value.add(Json.putBaseFromJson(value));
      }
    }
    return bundle;
  }
}
