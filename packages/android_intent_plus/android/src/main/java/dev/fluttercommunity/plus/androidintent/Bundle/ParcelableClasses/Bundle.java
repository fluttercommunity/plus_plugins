package dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.Json;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.base.ParcelableBase;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Bundle extends ParcelableBase {

  public static final String javaClass = "Bundle";

  public List<PutBase> value = new ArrayList<>();

  public static Bundle fromJson(JSONObject bundleJSONObject) throws JSONException {
    final Bundle bundle = new Bundle();

    if (bundleJSONObject.getString(Constants.JAVA_CLASS).equals(Bundle.javaClass)) {
      JSONArray jsonArray = bundleJSONObject.getJSONArray(Constants.VALUE);
      for (int i = 0; i < jsonArray.length(); i++) {
        JSONObject value = jsonArray.getJSONObject(i);
        bundle.value.add(Json.putBaseFromJson(value));
      }
    }
    return bundle;
  }
}
