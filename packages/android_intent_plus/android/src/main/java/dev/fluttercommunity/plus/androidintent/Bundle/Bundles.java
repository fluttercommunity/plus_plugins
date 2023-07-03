package dev.fluttercommunity.plus.androidintent.Bundle;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class Bundles {
  public static final String JAVA_CLASS = "Bundles";
  public final List<Bundle> value;

  public Bundles(List<Bundle> value) {
    this.value = value;
  }

  static public Bundles bundlesFromJsonString(String jsonString) throws JSONException {
    if (jsonString == null) {
      return new Bundles(new ArrayList<>());
    }
    JSONObject jsonObject = new JSONObject(jsonString);
    return Bundles.fromJson(jsonObject);
  }

  static public Bundles fromJson(JSONObject jsonObject) throws JSONException {
    ArrayList<Bundle> listOfBundles = new ArrayList<>();
    JSONArray jsonArray = jsonObject.getJSONArray("value");
    for (int bundlesIndex = 0; bundlesIndex < jsonArray.length(); bundlesIndex++) {
      listOfBundles.add(Bundle.fromJson(jsonArray.getJSONObject(bundlesIndex)));
    }
    return new Bundles(listOfBundles);
  }

  public static Bundles fromListOfAndroidOsBundle(List<android.os.Bundle> androidOsBundles) {
    ArrayList<Bundle> bundles = new ArrayList<>();
    for (android.os.Bundle androidOsBundle : androidOsBundles) {
      bundles.add(Bundle.fromAndroidOsBundle(androidOsBundle));
    }
    return new Bundles(bundles);
  }

  public JSONObject toJson() throws JSONException {
    JSONObject jsonObject = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    for (Bundle bundle : value) {
      jsonArray.put(bundle.toJson());
    }
    jsonObject.put("javaClass", JAVA_CLASS);
    jsonObject.put("value", jsonArray);
    return jsonObject;
  }

  public List<android.os.Bundle> toListOfAndroidOsBundle() {
    List<android.os.Bundle> androidOsBundles = new ArrayList<>();
    for (Bundle bundle : value) {
      final android.os.Bundle androidOsBundle = new android.os.Bundle();
      for (PutBase<?> putBase : bundle.value) {
        PutBase.addToAndroidOsBundle(androidOsBundle, putBase);
      }
      androidOsBundles.add(androidOsBundle);
    }
    return androidOsBundles;
  }
}
