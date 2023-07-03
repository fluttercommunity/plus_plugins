package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.Helpers;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;


public class PutCharSequenceArray extends PutBase<List<CharSequence>> {

  public static final String JAVA_CLASS = "PutCharSequenceArray";

  public PutCharSequenceArray(String key, List<CharSequence> value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutCharSequenceArray putStringArray) {
    bundle.putCharSequenceArray(putStringArray.key, toPrimitiveArray(putStringArray.value));
  }

  private static CharSequence[] toPrimitiveArray(final List<CharSequence> stringList) {
    final CharSequence[] primitives = new String[stringList.size()];
    for (int i = 0; i < stringList.size(); i++) {
      primitives[i] = stringList.get(i);
    }
    return primitives;
  }

  public static PutCharSequenceArray fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<CharSequence> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add(jsonArray.getString(i));
    }
    return new PutCharSequenceArray(jsonObject.getString(Constants.KEY), arrayList);
  }

  @Override
  public JSONObject toJson() throws JSONException {
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("key", key);
    jsonObject.put("javaClass", JAVA_CLASS);
    jsonObject.put("value", new JSONArray(Helpers.convertToArrayList(value)));
    return jsonObject;
  }
}
