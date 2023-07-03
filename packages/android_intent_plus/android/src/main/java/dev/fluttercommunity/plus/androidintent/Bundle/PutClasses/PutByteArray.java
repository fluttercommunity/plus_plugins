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

public class PutByteArray extends PutBase<List<Byte>> {

  public static final String JAVA_CLASS = "PutByteArray";

  public PutByteArray(String key, List<Byte> value) {
    super(key, JAVA_CLASS, value);
  }

  public static void convert(Bundle bundle, PutByteArray putByteArray) {
    bundle.putByteArray(putByteArray.key, toPrimitiveArray(putByteArray.value));
  }

  private static byte[] toPrimitiveArray(final List<Byte> byteList) {
    final byte[] primitives = new byte[byteList.size()];
    for (int i = 0; i < byteList.size(); i++) {
      primitives[i] = byteList.get(i);
    }
    return primitives;
  }

  public static PutByteArray fromJson(JSONObject jsonObject) throws JSONException {
    final ArrayList<Byte> arrayList = new ArrayList<>();
    final JSONArray jsonArray = jsonObject.getJSONArray(Constants.VALUE);
    for (int i = 0; i < jsonArray.length(); i++) {
      arrayList.add((byte) jsonArray.getInt(i));
    }
    return new PutByteArray(jsonObject.getString(Constants.KEY), arrayList);
  }

  @Override
  public JSONObject toJson() throws JSONException {
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("key", key);
    jsonObject.put("javaClass", JAVA_CLASS);
    jsonObject.put("value", new JSONArray(Helpers.convertToArrayListOfInt(value)));
    return jsonObject;
  }
}
