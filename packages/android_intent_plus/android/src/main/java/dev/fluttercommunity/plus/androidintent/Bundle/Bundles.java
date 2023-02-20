package dev.fluttercommunity.plus.androidintent.Bundle;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.Bundle;

public class Bundles {

  public final List<Bundle> value;

  public Bundles(List<Bundle> value) {
    this.value = value;
  }

  static List<Bundle> fromJson(JSONArray jsonArray) throws JSONException {
    ArrayList<Bundle> bundles = new ArrayList<>();
    for (int bundlesIndex = 0; bundlesIndex < jsonArray.length(); bundlesIndex++) {
      JSONObject jsonObject = jsonArray.getJSONObject(bundlesIndex);
      bundles.add(Bundle.fromJson(jsonObject));
    }
    return bundles;
  }
}
