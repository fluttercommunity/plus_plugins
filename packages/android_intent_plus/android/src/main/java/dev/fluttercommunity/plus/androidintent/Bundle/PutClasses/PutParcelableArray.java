package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Parcelable;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.base.ParcelableBase;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PutParcelableArray extends PutBase<List<ParcelableBase>> {

  public static final String JAVA_CLASS = "PutParcelableArray";

  public PutParcelableArray(String key, List<ParcelableBase> value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(android.os.Bundle bundle, PutParcelableArray putParcelableArray) {
    bundle.putParcelableArray(
        putParcelableArray.key,
        PutParcelableArrayList.convertToListOfParcelable(putParcelableArray.value)
            .toArray(new Parcelable[0]));
  }

  public static PutParcelableArray fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<ParcelableBase> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add(PutParcelable.parcelableBaseFromJson(jsonArray.getJSONObject(i)));
    }
    return new PutParcelableArray(jsonObject.getString(Constants.KEY), arrayList);
  }

  @Override
  public JSONObject toJson() throws JSONException {
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("key", key);
    jsonObject.put("javaClass", JAVA_CLASS);
    JSONArray jsonArray = new JSONArray();
    for (ParcelableBase item : value) {
      jsonArray.put(ParcelableBase.toJson(item));
    }
    jsonObject.put("value", jsonArray);
    return jsonObject;
  }
}
