package dev.fluttercommunity.plus.androidintent.Bundle;

import org.json.JSONException;
import org.json.JSONObject;

import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.base.ParcelableBase;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutBool;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutBoolArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutBundle;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutInt;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutIntArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutIntArrayList;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutParcelableArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutParcelableArrayList;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutString;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutStringArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutStringArrayList;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class Json {
  public static PutBase putBaseFromJson(Object json) throws JSONException {
    if (json instanceof JSONObject) {
      JSONObject jsonObject = (JSONObject) json;
      switch (jsonObject.getString(Constants.JAVA_CLASS)) {
        case PutBool.javaClass:
          return PutBool.fromJson(jsonObject);
        case PutBoolArray.javaClass:
          return PutBoolArray.fromJson(jsonObject);
        case PutBundle.javaClass:
          return PutBundle.fromJson(jsonObject);
        case PutInt.javaClass:
          return PutInt.fromJson(jsonObject);
        case PutIntArray.javaClass:
          return PutIntArray.fromJson(jsonObject);
        case PutIntArrayList.javaClass:
          return PutIntArrayList.fromJson(jsonObject);
        case PutParcelableArray.javaClass:
          return PutParcelableArray.fromJson(jsonObject);
        case PutParcelableArrayList.javaClass:
          return PutParcelableArrayList.fromJson(jsonObject);
        case PutString.javaClass:
          return PutString.fromJson(jsonObject);
        case PutStringArray.javaClass:
          return PutStringArray.fromJson(jsonObject);
        case PutStringArrayList.javaClass:
          return PutStringArrayList.fromJson(jsonObject);

      }
    }
    throw new RuntimeException("Type not found");
  }

  public static ParcelableBase parcelableBaseFromJson(Object json) throws JSONException {
    if (json instanceof JSONObject) {
      JSONObject jsonObject = (JSONObject) json;
      //noinspection SwitchStatementWithTooFewBranches
      switch (jsonObject.getString(Constants.JAVA_CLASS)) {
        case Bundle.javaClass:
          return Bundle.fromJson(jsonObject);
      }
    }
    throw new RuntimeException("Type not found");
  }
}
