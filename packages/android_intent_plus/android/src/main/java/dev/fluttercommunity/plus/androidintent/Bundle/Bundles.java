package dev.fluttercommunity.plus.androidintent.Bundle;

import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.Bundle;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

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
