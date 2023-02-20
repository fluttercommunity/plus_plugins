package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutIntArrayList extends PutBase {

  public final static String javaClass = "PutIntArrayList";
  final List<Integer> value;

  public PutIntArrayList(String key, List<Integer> value) {
    super(key);
    this.value = value;
  }

  static public void convert(Bundle bundle, PutIntArrayList putIntArray) {
    bundle.putIntegerArrayList(putIntArray.key, new ArrayList<>(putIntArray.value));
  }

  public static PutIntArrayList fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<Integer> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add(jsonArray.getInt(i));
    }
    return new PutIntArrayList(jsonObject.getString(Constants.KEY), arrayList);
  }
}
