package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PutIntArrayList extends PutBase {

  public static final String javaClass = "PutIntArrayList";
  final List<Integer> value;

  public PutIntArrayList(String key, List<Integer> value) {
    super(key);
    this.value = value;
  }

  public static void convert(Bundle bundle, PutIntArrayList putIntArray) {
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
