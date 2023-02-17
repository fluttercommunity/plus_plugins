package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;

import org.json.JSONException;
import org.json.JSONObject;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class PutInt extends PutBase {
  public final static String javaClass = "PutInt";
  final Integer value;

  public PutInt(String key, Integer value) {
    super(key);
    this.value = value;
  }

  public static void convert(Bundle bundle, PutInt putInt) {
    bundle.putInt(putInt.key, putInt.value);
  }

  public static PutInt fromJson(JSONObject jsonObject) throws JSONException {
    return new PutInt(jsonObject.getString(Constants.KEY), jsonObject.getInt(Constants.VALUE));
  }
}
