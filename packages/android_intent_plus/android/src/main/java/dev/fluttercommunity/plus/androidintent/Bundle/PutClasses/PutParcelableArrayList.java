package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Parcelable;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.base.ParcelableBase;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import dev.fluttercommunity.plus.androidintent.GetType;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PutParcelableArrayList extends PutBase<List<ParcelableBase>> {

  public static final String JAVA_CLASS = "PutParcelableArrayList";

  public PutParcelableArrayList(String key, List<ParcelableBase> value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(
      android.os.Bundle bundle, PutParcelableArrayList putParcelableArrayList) {
    bundle.putParcelableArrayList(
        putParcelableArrayList.key, convertToListOfParcelable(putParcelableArrayList.value));
  }

  public static PutParcelableArrayList fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<ParcelableBase> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add(PutParcelable.parcelableBaseFromJson(jsonArray.getJSONObject(i)));
    }
    return new PutParcelableArrayList(jsonObject.getString(Constants.KEY), arrayList);
  }

  public static ArrayList<Parcelable> convertToListOfParcelable(List<ParcelableBase> values) {
    ArrayList<Parcelable> parcelables = new ArrayList<>();
    for (ParcelableBase parcelableBase : values) {
      if (parcelableBase
          instanceof dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.Bundle) {
        parcelables.add(PutParcelable.convertToParcelable(parcelableBase));
      } else {
        throw new RuntimeException(GetType.name(parcelableBase.getClass()));
      }
    }
    return parcelables;
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
