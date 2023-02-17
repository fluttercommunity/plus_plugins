package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutStringArrayList extends PutBase {
  public final static String javaClass = "PutStringArrayList";
  final List<String> value;

  public PutStringArrayList(String key, List<String> value) {
    super(key);
    this.value = value;
  }

  public static void convert(Bundle bundle, PutStringArrayList putStringArray) {
    bundle.putStringArrayList(putStringArray.key, new ArrayList<>(putStringArray.value));
  }

  public static PutStringArrayList fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<String> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add(jsonArray.getString(i));
    }
    return new PutStringArrayList(jsonObject.getString(Constants.KEY), arrayList);
  }
}
