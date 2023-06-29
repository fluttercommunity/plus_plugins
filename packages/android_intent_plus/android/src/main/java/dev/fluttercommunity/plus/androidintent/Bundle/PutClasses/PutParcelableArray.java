package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Parcelable;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.ConvertExtras;
import dev.fluttercommunity.plus.androidintent.Bundle.Json;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.base.ParcelableBase;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PutParcelableArray extends PutBase {

  public static final String javaClass = "PutParcelableArray";
  final List<ParcelableBase> value;

  public PutParcelableArray(String key, List<ParcelableBase> value) {
    super(key);
    this.value = value;
  }

  public static void convert(android.os.Bundle bundle, PutParcelableArray putParcelableArray) {
    bundle.putParcelableArray(
        putParcelableArray.key,
        convertToParcelable(putParcelableArray.value).toArray(new Parcelable[0]));
  }

  public static ArrayList<Parcelable> convertToParcelable(List<ParcelableBase> values) {
    ArrayList<Parcelable> parcelables = new ArrayList<>();
    for (ParcelableBase parcelableBase : values) {
      if (parcelableBase instanceof Bundle) {
        Bundle bundleParcelable = (Bundle) parcelableBase;
        final android.os.Bundle bundle = new android.os.Bundle();
        for (PutBase putBase : bundleParcelable.value) {
          ConvertExtras.convert(bundle, putBase);
        }
        parcelables.add(bundle);
      }
    }
    return parcelables;
  }

  public static PutParcelableArray fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<ParcelableBase> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add(Json.parcelableBaseFromJson(jsonArray.getJSONObject(i)));
    }
    return new PutParcelableArray(jsonObject.getString(Constants.KEY), arrayList);
  }
}
