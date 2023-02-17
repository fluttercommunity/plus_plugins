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

  static List<Bundle> fromJson(JSONObject jsonObject) throws JSONException {
    ArrayList<Bundle> bundles = new ArrayList<>();
    if (jsonObject.getString(Constants.JAVA_CLASS).equals("Bundles")) {
      JSONArray values = (JSONArray) (jsonObject.get(Constants.VALUE));
      for (int i = 0; i < values.length(); i++) {
        JSONObject value = (JSONObject) values.get(i);
        bundles.add(Bundle.fromJson(value));
      }
    }
    return bundles;
  }
}
