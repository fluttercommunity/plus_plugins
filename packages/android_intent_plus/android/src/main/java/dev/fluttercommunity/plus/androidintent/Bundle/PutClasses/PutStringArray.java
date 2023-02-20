package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutStringArray extends PutBase {

  public final static String javaClass = "PutStringArray";
  final List<String> value;

  public PutStringArray(String key, List<String> value) {
    super(key);
    this.value = value;
  }

  public static void convert(Bundle bundle, PutStringArray putStringArray) {
    bundle.putStringArray(putStringArray.key, toPrimitiveArray(putStringArray.value));
  }

  static private String[] toPrimitiveArray(final List<String> stringList) {
    final String[] primitives = new String[stringList.size()];
    for (int i = 0; i < stringList.size(); i++) {
      primitives[i] = stringList.get(i);
    }
    return primitives;
  }

  public static PutStringArray fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<String> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add(jsonArray.getString(i));
    }
    return new PutStringArray(jsonObject.getString(Constants.KEY), arrayList);
  }
}
