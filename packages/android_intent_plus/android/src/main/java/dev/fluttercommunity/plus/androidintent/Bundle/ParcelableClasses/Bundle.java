package dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.base.ParcelableBase;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Bundle extends ParcelableBase {
  public static final String JAVA_CLASS = "Bundle";
  public List<PutBase<?>> value;

  public Bundle(List<PutBase<?>> value) {
    this.value = value;
  }

  public Bundle() {
    this.value = new ArrayList<>();
  }

  public static Bundle fromJson(JSONObject bundleJSONObject) throws JSONException {
    final Bundle bundle = new Bundle();

    if (bundleJSONObject.getString(Constants.JAVA_CLASS).equals(Bundle.JAVA_CLASS)) {
      JSONArray jsonArray = bundleJSONObject.getJSONArray(Constants.VALUE);
      for (int i = 0; i < jsonArray.length(); i++) {
        JSONObject value = jsonArray.getJSONObject(i);
        bundle.value.add(PutBase.fromJson(value));
      }
    }
    return bundle;
  }

  public static Bundle fromAndroidOsBundle(android.os.Bundle androidOsBundle) {
    Bundle bundle = new Bundle();
    for (String key : androidOsBundle.keySet()) {
      PutBase.addToBundle(bundle, key, androidOsBundle.get(key));
    }
    return bundle;
  }

  public JSONObject toJson() throws JSONException {
    JSONObject bundle = new JSONObject();
    bundle.put("javaClass", JAVA_CLASS);
    JSONArray values = new JSONArray();
    for (PutBase<?> putBase : value) {
      values.put(putBase.toJson());
    }
    bundle.put("value", values);
    return bundle;
  }
}
