package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses;

import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;
import org.json.JSONException;
import org.json.JSONObject;

public class PutString extends PutBase {

  public static final String javaClass = "PutString";
  final String value;

  public PutString(String key, String value) {
    super(key);
    this.value = value;
  }

  public static void convert(Bundle bundle, PutString putString) {
    bundle.putString(putString.key, putString.value);
  }

  public static PutString fromJson(JSONObject jsonObject) throws JSONException {
    return new PutString(
        jsonObject.getString(Constants.KEY), jsonObject.getString(Constants.VALUE));
  }
}
