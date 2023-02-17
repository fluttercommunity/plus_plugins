package dev.fluttercommunity.plus.androidintent.Bundle;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class CreateExtras {


  static public Bundles create(String jsonString) {
    Bundles bundles = new Bundles(new ArrayList<>());
    try {
      JSONObject jsonObject = new JSONObject(jsonString);
      bundles.value.addAll(Bundles.fromJson(jsonObject));
      return bundles;
    } catch (JSONException e) {
      throw new RuntimeException(e);
    }
  }
}
