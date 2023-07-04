package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PutStringArrayList extends PutBase<List<String>> {

  public static final String JAVA_CLASS = "PutStringArrayList";

  public PutStringArrayList(String key, List<String> value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutStringArrayList putStringArrayList) {
    bundle.putStringArrayList(putStringArrayList.key, new ArrayList<>(putStringArrayList.value));
  }

  public static PutStringArrayList fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<String> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add(jsonArray.getString(i));
    }
    return new PutStringArrayList(jsonObject.getString(Constants.KEY), arrayList);
  }

  @Override
  public JSONObject toJson() throws JSONException {
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("key", key);
    jsonObject.put("javaClass", JAVA_CLASS);
    jsonObject.put("value", new JSONArray(value));
    return jsonObject;
  }
}
