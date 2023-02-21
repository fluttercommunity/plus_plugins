package dev.fluttercommunity.plus.androidintent.Bundle;

import java.util.ArrayList;
import org.json.JSONArray;
import org.json.JSONException;

public class CreateExtras {

  public static Bundles create(String jsonString) {
    Bundles bundles = new Bundles(new ArrayList<>());
    try {
      JSONArray jsonArray = new JSONArray(jsonString);
      bundles.value.addAll(Bundles.fromJson(jsonArray));
      return bundles;
    } catch (JSONException e) {
      throw new RuntimeException(e);
    }
  }
}
