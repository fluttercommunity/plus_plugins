package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PutBoolArray extends PutBase {

  public static final String javaClass = "PutBoolArray";
  final List<Boolean> value;

  public PutBoolArray(String key, List<Boolean> value) {
    super(key);
    this.value = value;
  }

  public static void convert(Bundle bundle, PutBoolArray putBoolArray) {
    bundle.putBooleanArray(putBoolArray.key, toPrimitiveArray(putBoolArray.value));
  }

  private static boolean[] toPrimitiveArray(final List<Boolean> booleanList) {
    final boolean[] primitives = new boolean[booleanList.size()];
    for (int i = 0; i < booleanList.size(); i++) {
      primitives[i] = booleanList.get(i);
    }
    return primitives;
  }

  public static PutBoolArray fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<Boolean> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add(jsonArray.getBoolean(i));
    }
    return new PutBoolArray(jsonObject.getString(Constants.KEY), arrayList);
  }
}
