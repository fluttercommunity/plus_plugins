package dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base;

import android.os.Parcelable;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.Constants;
import dev.fluttercommunity.plus.androidintent.Bundle.Helpers;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.Bundle;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.base.ParcelableBase;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutBool;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutBoolArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutBundle;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutByte;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutByteArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutChar;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutCharArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutCharSequence;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutCharSequenceArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutCharSequenceArrayList;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutDouble;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutDoubleArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutFloat;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutFloatArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutInt;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutIntArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutIntegerArrayList;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutLong;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutLongArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutParcelable;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutParcelableArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutParcelableArrayList;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutShort;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutShortArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutString;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutStringArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutStringArrayList;
import dev.fluttercommunity.plus.androidintent.GetType;

public abstract class PutBase<T> {

  public final String key;

  public final String javaClass;

  public final T value;

  public PutBase(String key, String javaClass, T value) {
    this.key = key;
    this.javaClass = javaClass;
    this.value = value;
  }

  public static PutBase<?> fromJson(JSONObject json) throws JSONException, RuntimeException {
    final String javaClass = json.getString(Constants.JAVA_CLASS);
    switch (javaClass) {
      case PutBool.JAVA_CLASS:
        return PutBool.fromJson(json);
      case PutBoolArray.JAVA_CLASS:
        return PutBoolArray.fromJson(json);
      case PutBundle.JAVA_CLASS:
        return PutBundle.fromJson(json);
      case PutByte.JAVA_CLASS:
        return PutByte.fromJson(json);
      case PutByteArray.JAVA_CLASS:
        return PutByteArray.fromJson(json);
      case PutChar.JAVA_CLASS:
        return PutChar.fromJson(json);
      case PutCharArray.JAVA_CLASS:
        return PutCharArray.fromJson(json);
      case PutCharSequence.JAVA_CLASS:
        return PutCharSequence.fromJson(json);
      case PutCharSequenceArray.JAVA_CLASS:
        return PutCharSequenceArray.fromJson(json);
      case PutCharSequenceArrayList.JAVA_CLASS:
        return PutCharSequenceArrayList.fromJson(json);
      case PutDouble.JAVA_CLASS:
        return PutDouble.fromJson(json);
      case PutDoubleArray.JAVA_CLASS:
        return PutDoubleArray.fromJson(json);
      case PutFloat.JAVA_CLASS:
        return PutFloat.fromJson(json);
      case PutFloatArray.JAVA_CLASS:
        return PutFloatArray.fromJson(json);
      case PutInt.JAVA_CLASS:
        return PutInt.fromJson(json);
      case PutIntArray.JAVA_CLASS:
        return PutIntArray.fromJson(json);
      case PutIntegerArrayList.JAVA_CLASS:
        return PutIntegerArrayList.fromJson(json);
      case PutLong.JAVA_CLASS:
        return PutLong.fromJson(json);
      case PutLongArray.JAVA_CLASS:
        return PutLongArray.fromJson(json);
      case PutParcelable.JAVA_CLASS:
        return PutParcelable.fromJson(json);
      case PutParcelableArray.JAVA_CLASS:
        return PutParcelableArray.fromJson(json);
      case PutParcelableArrayList.JAVA_CLASS:
        return PutParcelableArrayList.fromJson(json);
      case PutShort.JAVA_CLASS:
        return PutShort.fromJson(json);
      case PutShortArray.JAVA_CLASS:
        return PutShortArray.fromJson(json);
      case PutString.JAVA_CLASS:
        return PutString.fromJson(json);
      case PutStringArray.JAVA_CLASS:
        return PutStringArray.fromJson(json);
      case PutStringArrayList.JAVA_CLASS:
        return PutStringArrayList.fromJson(json);
    }
    throw new RuntimeException(String.format("JavaClass (%s) not found (PutBase.fromJson)", javaClass));
  }

  public static void addToAndroidOsBundle(android.os.Bundle bundle, PutBase<?> putBase) {
    if (putBase instanceof PutBool) {
      PutBool.convert(bundle, (PutBool) putBase);
    } else if (putBase instanceof PutBoolArray) {
      PutBoolArray.convert(bundle, (PutBoolArray) putBase);
    } else if (putBase instanceof PutBundle) {
      PutBundle.convert(bundle, (PutBundle) putBase);
    } else if (putBase instanceof PutByte) {
      PutByte.convert(bundle, (PutByte) putBase);
    } else if (putBase instanceof PutByteArray) {
      PutByteArray.convert(bundle, (PutByteArray) putBase);
    } else if (putBase instanceof PutChar) {
      PutChar.convert(bundle, (PutChar) putBase);
    } else if (putBase instanceof PutCharArray) {
      PutCharArray.convert(bundle, (PutCharArray) putBase);
    } else if (putBase instanceof PutCharSequence) {
      PutCharSequence.convert(bundle, (PutCharSequence) putBase);
    } else if (putBase instanceof PutCharSequenceArray) {
      PutCharSequenceArray.convert(bundle, (PutCharSequenceArray) putBase);
    } else if (putBase instanceof PutCharSequenceArrayList) {
      PutCharSequenceArrayList.convert(bundle, (PutCharSequenceArrayList) putBase);
    } else if (putBase instanceof PutDouble) {
      PutDouble.convert(bundle, (PutDouble) putBase);
    } else if (putBase instanceof PutDoubleArray) {
      PutDoubleArray.convert(bundle, (PutDoubleArray) putBase);
    } else if (putBase instanceof PutFloat) {
      PutFloat.convert(bundle, (PutFloat) putBase);
    } else if (putBase instanceof PutFloatArray) {
      PutFloatArray.convert(bundle, (PutFloatArray) putBase);
    } else if (putBase instanceof PutParcelable) {
      PutParcelable.convert(bundle, (PutParcelable) putBase);
    } else if (putBase instanceof PutParcelableArray) {
      PutParcelableArray.convert(bundle, (PutParcelableArray) putBase);
    } else if (putBase instanceof PutParcelableArrayList) {
      PutParcelableArrayList.convert(bundle, (PutParcelableArrayList) putBase);
    } else if (putBase instanceof PutInt) {
      PutInt.convert(bundle, (PutInt) putBase);
    } else if (putBase instanceof PutIntArray) {
      PutIntArray.convert(bundle, (PutIntArray) putBase);
    } else if (putBase instanceof PutIntegerArrayList) {
      PutIntegerArrayList.convert(bundle, (PutIntegerArrayList) putBase);
    } else if (putBase instanceof PutLong) {
      PutLong.convert(bundle, (PutLong) putBase);
    } else if (putBase instanceof PutLongArray) {
      PutLongArray.convert(bundle, (PutLongArray) putBase);
    } else if (putBase instanceof PutShort) {
      PutShort.convert(bundle, (PutShort) putBase);
    } else if (putBase instanceof PutShortArray) {
      PutShortArray.convert(bundle, (PutShortArray) putBase);
    } else if (putBase instanceof PutString) {
      PutString.convert(bundle, (PutString) putBase);
    } else if (putBase instanceof PutStringArray) {
      PutStringArray.convert(bundle, (PutStringArray) putBase);
    } else if (putBase instanceof PutStringArrayList) {
      PutStringArrayList.convert(bundle, (PutStringArrayList) putBase);
    } else {
      throw new RuntimeException(GetType.name(putBase.getClass()));
    }
  }

  public static void addToBundle(Bundle bundle, String key, Object x) {
    if (x instanceof Boolean) {
      Boolean value = (Boolean) x;
      bundle.value.add(new PutBool(key, value));
    } else if (x instanceof boolean[]) {
      boolean[] value = (boolean[]) x;
      bundle.value.add(new PutBoolArray(key, Helpers.convertToArrayList(value)));
    } else if (x instanceof Byte) {
      byte value = (Byte) x;
      bundle.value.add(new PutByte(key, value));
    } else if (x instanceof byte[]) {
      byte[] value = (byte[]) x;
      bundle.value.add(new PutByteArray(key, Helpers.convertToArrayList(value)));
    } else if (x instanceof Character) {
      Character value = (Character) x;
      bundle.value.add(new PutChar(key, value));
    } else if (x instanceof char[]) {
      char[] value = (char[]) x;
      bundle.value.add(new PutCharArray(key, Helpers.convertToArrayList(value)));
    } else if (x instanceof Short) {
      Short value = (Short) x;
      bundle.value.add(new PutShort(key, value));
    } else if (x instanceof short[]) {
      short[] value = (short[]) x;
      bundle.value.add(new PutShortArray(key, Helpers.convertToArrayList(value)));
    } else if (x instanceof String) {
      String value = (String) x;
      bundle.value.add(new PutString(key, value));
    } else if (x instanceof String[]) {
      String[] value = (String[]) x;
      bundle.value.add(new PutStringArray(key, Helpers.convertToArrayList(value)));
    } else if (x instanceof CharSequence) {
      CharSequence value = (CharSequence) x;
      bundle.value.add(new PutCharSequence(key, value));
    } else if (x instanceof CharSequence[]) {
      CharSequence[] value = (CharSequence[]) x;
      bundle.value.add(new PutCharSequenceArray(key, Helpers.convertToArrayList(value)));
    } else if (x instanceof ArrayList<?>) {
      ArrayList<?> value = (ArrayList<?>) x;
      if (value.get(0) instanceof String) {
        @SuppressWarnings("unchecked")
        ArrayList<String> value2 = (ArrayList<String>) value;
        bundle.value.add(new PutStringArrayList(key, value2));
      } else if (value.get(0) instanceof CharSequence) {
        @SuppressWarnings("unchecked")
        ArrayList<CharSequence> value2 = (ArrayList<CharSequence>) value;
        bundle.value.add(new PutCharSequenceArrayList(key, value2));
      } else if (value.get(0) instanceof Integer) {
        @SuppressWarnings("unchecked")
        ArrayList<Integer> value2 = (ArrayList<Integer>) value;
        bundle.value.add(new PutIntegerArrayList(key, value2));
      } else if (value.get(0) instanceof Parcelable) {
        @SuppressWarnings("unchecked")
        ArrayList<Parcelable> value2 = (ArrayList<Parcelable>) value;
        List<ParcelableBase> parcelableBaseList = new ArrayList<>();
        for (Parcelable parcelable : value2) {
          parcelableBaseList.add(ParcelableBase.createParcelableBase(parcelable));
        }
        bundle.value.add(new PutParcelableArrayList(key, parcelableBaseList));
      } else {
        throw new RuntimeException(GetType.name(x.getClass()) + " in android_bundle Bundle.addToBundle (ArrayList)");
      }
    } else if (x instanceof Double) {
      Double value = (Double) x;
      bundle.value.add(new PutDouble(key, value));
    } else if (x instanceof double[]) {
      double[] value = (double[]) x;
      bundle.value.add(new PutDoubleArray(key, Helpers.convertToArrayList(value)));
    } else if (x instanceof Float) {
      float value = (Float) x;
      bundle.value.add(new PutFloat(key, value));
    } else if (x instanceof float[]) {
      float[] value = (float[]) x;
      bundle.value.add(new PutFloatArray(key, Helpers.convertToArrayList(value)));
    } else if (x instanceof Integer) {
      Integer value = (Integer) x;
      bundle.value.add(new PutInt(key, value));
    } else if (x instanceof int[]) {
      int[] value = (int[]) x;
      bundle.value.add(new PutIntArray(key, Helpers.convertToArrayList(value)));
    } else if (x instanceof Long) {
      Long value = (Long) x;
      bundle.value.add(new PutLong(key, value));
    } else if (x instanceof long[]) {
      long[] value = (long[]) x;
      bundle.value.add(new PutLongArray(key, Helpers.convertToArrayList(value)));
    } else if (x instanceof android.os.Bundle) {
      android.os.Bundle value = (android.os.Bundle) x;
      bundle.value.add(new PutBundle(key, Bundle.fromAndroidOsBundle(value).value));
    } else if (x instanceof Parcelable) {
      Parcelable value = (Parcelable) x;
      bundle.value.add(new PutParcelable(key, ParcelableBase.createParcelableBase(value)));
    } else if (x instanceof Parcelable[]) {
      Parcelable[] value = (Parcelable[]) x;
      List<ParcelableBase> parcelableBaseList = new ArrayList<>();
      for (Parcelable parcelable : value) {
        parcelableBaseList.add(ParcelableBase.createParcelableBase(parcelable));
      }
      bundle.value.add(new PutParcelableArray(key, parcelableBaseList));
    } else {
      throw new RuntimeException(GetType.name(x.getClass()) + " in android_bundle Bundle.addToBundle");
    }
  }

  public abstract JSONObject toJson() throws JSONException;
}
