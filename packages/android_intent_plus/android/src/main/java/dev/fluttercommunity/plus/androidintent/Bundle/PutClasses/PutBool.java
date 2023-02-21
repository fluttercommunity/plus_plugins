package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import org.json.JSONException;
import org.json.JSONObject;

public class PutBool extends PutBase {

  public static final String javaClass = "PutBool";
  final Boolean value;

  public PutBool(String key, boolean value) {
    super(key);
    this.value = value;
  }

  public static void convert(Bundle bundle, PutBool putBool) {
    bundle.putBoolean(putBool.key, putBool.value);
  }

  public static PutBool fromJson(JSONObject jsonObject) throws JSONException {
    return new PutBool(jsonObject.getString(Constants.KEY), jsonObject.getBoolean(Constants.VALUE));
  }
}
