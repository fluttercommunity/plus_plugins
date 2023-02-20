package dev.fluttercommunity.plus.androidintent.Bundle;

import org.json.JSONArray;
import org.json.JSONException;

import java.util.ArrayList;

public class CreateExtras {

  static public Bundles create(String jsonString) {
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
