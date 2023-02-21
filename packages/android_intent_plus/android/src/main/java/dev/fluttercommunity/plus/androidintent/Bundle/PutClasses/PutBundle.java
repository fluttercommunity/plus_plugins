package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.ConvertExtras;
import dev.fluttercommunity.plus.androidintent.Bundle.Json;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PutBundle extends PutBase {

  public static final String javaClass = "PutBundle";
  final List<PutBase> value;

  public PutBundle(String key, List<PutBase> value) {
    super(key);
    this.value = value;
  }

  public static void convert(Bundle bundle, PutBundle putBundle) {
    Bundle subBundle = new Bundle();
    for (PutBase putBase : putBundle.value) {
      ConvertExtras.convert(subBundle, putBase);
    }
    bundle.putBundle(putBundle.key, subBundle);
  }

  public static PutBundle fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<PutBase> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add(Json.putBaseFromJson(jsonArray.getJSONObject(i)));
    }
    return new PutBundle(jsonObject.getString(Constants.KEY), arrayList);
  }
}
