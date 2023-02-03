package dev.fluttercommunity.plus.androidintent;

import android.os.Bundle;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Map;

public class NestedArguments {

  static private final Gson gson = new GsonBuilder().registerTypeAdapterFactory(new BundleTypeAdapterFactory()).create();

  public static Bundle convertArguments(ArrayList<ArrayList<String>> nestedArgumentsArrayLists, Map<String, ?> nestedArguments) {
    final Bundle bundle = new Bundle();
    if (nestedArguments == null) {
      return bundle;
    }
    for (String key : nestedArguments.keySet()) {
      Object value = nestedArguments.get(key);
      addToBundle(bundle, nestedArgumentsArrayLists, value, key);
    }
    final String result = gson.toJson(bundle);
    return bundle;
  }

  private static void addToBundle(Bundle bundle, ArrayList<ArrayList<String>> nestedArgumentsArrayLists, Object value, String... keyList) {
    final String key = keyList[keyList.length - 1];
    if (value instanceof Integer) {
      putValueInt(bundle, key, (Integer) value);
    } else if (value instanceof String) {
      putValueString(bundle, key, (String) value);
    } else if (value instanceof Boolean) {
      putValueBoolean(bundle, key, (Boolean) value);
    } else if (value instanceof Double) {
      putValueDouble(bundle, key, (Double) value);
    } else if (value instanceof Long) {
      putValueLong(bundle, key, (Long) value);
    } else if (value instanceof byte[]) {
      putArrayByte(bundle, key, (byte[]) value, nestedArgumentsArrayLists);
    } else if (value instanceof int[]) {
      putArrayInt(bundle, key, (int[]) value, nestedArgumentsArrayLists);
    } else if (value instanceof long[]) {
      putArrayLong(bundle, key, (long[]) value, nestedArgumentsArrayLists);
    } else if (value instanceof double[]) {
      putArrayDouble(bundle, key, (double[]) value, nestedArgumentsArrayLists);
    } else if (Helpers.isTypedArrayList(value, String.class)) {
      putArrayString(bundle, key, (ArrayList<String>) value, nestedArgumentsArrayLists);
    } else if (Helpers.isStringKeyedMap(value)) {
      putArrayArrayString(bundle, key, (Map<String, ?>) value, nestedArgumentsArrayLists, keyList);
    } else if (Helpers.isTypedArrayList(value, Map.class)) {
      putArrayMapString(bundle, key, (ArrayList<Map<String, ?>>) value, nestedArgumentsArrayLists, keyList);
    } else {
      throw new UnsupportedOperationException("Unsupported type " + value);
    }
  }

  private static boolean usePlainArray(ArrayList<ArrayList<String>> nestedArgumentsArrayLists, String... keys) {
    if (nestedArgumentsArrayLists == null) {
      return true;
    }
    for (int listIndex = 0; listIndex < nestedArgumentsArrayLists.size(); listIndex++) {
      final ArrayList<String> listItem = nestedArgumentsArrayLists.get(listIndex);
      final String[] lookupListItem = listItem.toArray(new String[0]);
      if (Arrays.equals(lookupListItem, keys)) {
        return false;
      }
    }
    return true;
  }

  private static String[] append(String[] arr, String element) {
    if (arr == null) {
      arr = new String[0];
    }
    final int N = arr.length;
    arr = Arrays.copyOf(arr, N + 1);
    arr[N] = element;
    return arr;
  }

  private static void putValueInt(Bundle bundle, String key, Integer value) {
    bundle.putInt(key, value);
  }

  private static void putValueString(Bundle bundle, String key, String value) {
    bundle.putString(key, value);
  }

  private static void putValueBoolean(Bundle bundle, String key, Boolean value) {
    bundle.putBoolean(key, value);
  }

  private static void putValueDouble(Bundle bundle, String key, Double value) {
    bundle.putDouble(key, value);
  }

  private static void putValueLong(Bundle bundle, String key, Long value) {
    bundle.putLong(key, value);
  }

  private static void putArrayByte(Bundle bundle,
                                   String key,
                                   byte[] values,
                                   ArrayList<ArrayList<String>> nestedArgumentsArrayLists) {
    if (usePlainArray(nestedArgumentsArrayLists)) {
      bundle.putByteArray(key, values);
    } else {
      throw new RuntimeException("There is no ArrayList equivalent for bundle.putByteArray");
    }
  }

  private static void putArrayInt(Bundle bundle,
                                  String key,
                                  int[] values,
                                  ArrayList<ArrayList<String>> nestedArgumentsArrayLists) {
    if (usePlainArray(nestedArgumentsArrayLists)) {
      bundle.putIntArray(key, values);
    } else {
      ArrayList<Integer> integers = new ArrayList<>();
      for (int i : values) {
        integers.add(i);
      }
      bundle.putIntegerArrayList(key, integers);
    }
  }

  private static void putArrayLong(Bundle bundle,
                                   String key,
                                   long[] values,
                                   ArrayList<ArrayList<String>> nestedArgumentsArrayLists) {
    if (usePlainArray(nestedArgumentsArrayLists)) {
      bundle.putLongArray(key, values);
    } else {
      throw new RuntimeException("There is no ArrayList equivalent for bundle.putLongArray");
    }
  }

  private static void putArrayDouble(Bundle bundle,
                                     String key,
                                     double[] values,
                                     ArrayList<ArrayList<String>> nestedArgumentsArrayLists) {
    if (usePlainArray(nestedArgumentsArrayLists)) {
      bundle.putDoubleArray(key, values);
    } else {
      throw new RuntimeException("There is no ArrayList equivalent for bundle.putDoubleArray");
    }
  }

  private static void putArrayString(Bundle bundle,
                                     String key,
                                     ArrayList<String> values,
                                     ArrayList<ArrayList<String>> nestedArgumentsArrayLists) {
    if (usePlainArray(nestedArgumentsArrayLists)) {
      bundle.putStringArray(key, values.toArray(new String[0]));
    } else {
      bundle.putStringArrayList(key, values);
    }
  }

  private static void putArrayArrayString(Bundle bundle,
                                          String key,
                                          Map<String, ?> map,
                                          ArrayList<ArrayList<String>> nestedArgumentsArrayLists,
                                          String[] keyList) {
    Bundle subBundle = new Bundle();
    for (String subKey : map.keySet()) {
      addToBundle(subBundle, nestedArgumentsArrayLists, map.get(subKey), append(keyList, subKey));
    }
    bundle.putBundle(key, subBundle);
  }

//  private static void putArray(Bundle bundle,
//                               String key,
//                               Map<String, ?> map,
//                               ArrayList<ArrayList<String>> nestedArgumentsArrayLists,
//                               String[] keyList) {
//    ArrayList<Bundle> arrayListOfBundle = new ArrayList<>();
//    for (String subKey : map.keySet()) {
//      Bundle subBundle = new Bundle();
//      addToBundle(subBundle, nestedArgumentsArrayLists, map.get(subKey), append(keyList, subKey));
//      arrayListOfBundle.add(subBundle);
//    }
//    if (usePlainArray(nestedArgumentsArrayLists, keyList)) {
//      bundle.putParcelableArray(key, arrayListOfBundle.toArray(new Bundle[0]));
//    } else {
//      bundle.putParcelableArrayList(key, arrayListOfBundle);
//    }
//  }

  private static void putArrayMapString(Bundle bundle,
                                        String key,
                                        ArrayList<Map<String, ?>> values,
                                        ArrayList<ArrayList<String>> nestedArgumentsArrayLists,
                                        String[] keyList) {
    for (int i = 0; i < values.size(); i++) {
      addToBundle(bundle, nestedArgumentsArrayLists, values.get(i), keyList);
    }
  }
}
