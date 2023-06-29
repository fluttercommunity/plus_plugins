package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.Json;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.base.ParcelableBase;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PutParcelableArrayList extends PutBase {

  public static final String javaClass = "PutParcelableArrayList";
  final List<ParcelableBase> value;

  public PutParcelableArrayList(String key, List<ParcelableBase> value) {
    super(key);
    this.value = value;
  }

  public static void convert(Bundle bundle, PutParcelableArrayList putParcelableArray) {
    bundle.putParcelableArrayList(
        putParcelableArray.key, PutParcelableArray.convertToParcelable(putParcelableArray.value));
  }

  public static PutParcelableArrayList fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<ParcelableBase> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add(Json.parcelableBaseFromJson(jsonArray.getJSONObject(i)));
    }
    return new PutParcelableArrayList(jsonObject.getString(Constants.KEY), arrayList);
  }
}
