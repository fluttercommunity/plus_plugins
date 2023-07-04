package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.Helpers;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PutCharArray extends PutBase<List<Character>> {

  public static final String JAVA_CLASS = "PutCharArray";

  public PutCharArray(String key, List<Character> value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutCharArray putCharArray) {
    bundle.putCharArray(putCharArray.key, toPrimitiveArray(putCharArray.value));
  }

  private static char[] toPrimitiveArray(final List<Character> characterList) {
    final char[] primitives = new char[characterList.size()];
    for (int i = 0; i < characterList.size(); i++) {
      primitives[i] = characterList.get(i);
    }
    return primitives;
  }

  public static PutCharArray fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<Character> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add(jsonArray.getString(i).charAt(0));
    }
    return new PutCharArray(jsonObject.getString(Constants.KEY), arrayList);
  }

  @Override
  public JSONObject toJson() throws JSONException {
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("key", key);
    jsonObject.put("javaClass", JAVA_CLASS);
    jsonObject.put("value", new JSONArray(Helpers.convertToArrayListOfString(value)));
    return jsonObject;
  }
}
