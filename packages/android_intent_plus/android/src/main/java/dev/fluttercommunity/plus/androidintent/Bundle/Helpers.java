package dev.fluttercommunity.plus.androidintent.Bundle;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Helpers {

  public static <T> T notNullOrThrow(T value, String errorMessage) throws Exception {
    if (value == null) {
      throw new Exception(errorMessage);
    }
    return value;
  }

  public static List<Boolean> convertToArrayList(boolean[] arr) {
    if (arr == null) return null;
    List<Boolean> result = new ArrayList<>();
    for (boolean i : arr) {
      result.add(i);
    }
    return result;
  }

  public static List<Byte> convertToArrayList(byte[] arr) {
    if (arr == null) return null;
    List<Byte> result = new ArrayList<>();
    for (byte i : arr) {
      result.add(i);
    }
    return result;
  }

  public static List<Integer> convertToArrayListOfInt(List<Byte> arr) {
    if (arr == null) return null;
    List<Integer> result = new ArrayList<>();
    for (byte i : arr) {
      result.add((int) i);
    }
    return result;
  }

  public static List<String> convertToArrayListOfString(List<Character> arr) {
    if (arr == null) return null;
    List<String> result = new ArrayList<>();
    for (char i : arr) {
      result.add(String.valueOf(i));
    }
    return result;
  }

  public static List<Double> convertToArrayList(double[] arr) {
    if (arr == null) return null;
    List<Double> result = new ArrayList<>();
    for (double i : arr) {
      result.add(i);
    }
    return result;
  }

  public static List<Float> convertToArrayList(float[] arr) {
    if (arr == null) return null;
    List<Float> result = new ArrayList<>();
    for (float i : arr) {
      result.add(i);
    }
    return result;
  }

  public static List<Integer> convertToArrayList(int[] arr) {
    if (arr == null) return null;
    List<Integer> result = new ArrayList<>();
    for (int i : arr) {
      result.add(i);
    }
    return result;
  }

  public static List<Long> convertToArrayList(long[] arr) {
    if (arr == null) return null;
    List<Long> result = new ArrayList<>();
    for (long i : arr) {
      result.add(i);
    }
    return result;
  }

  public static List<Character> convertToArrayList(char[] arr) {
    if (arr == null) return null;
    List<Character> result = new ArrayList<>();
    for (char i : arr) {
      result.add(i);
    }
    return result;
  }

  public static List<Short> convertToArrayList(short[] arr) {
    if (arr == null) return null;
    List<Short> result = new ArrayList<>();
    for (short i : arr) {
      result.add(i);
    }
    return result;
  }

  public static <T> List<T> convertToArrayList(T[] arr) {
    if (arr == null) return null;
    List<T> result = new ArrayList<>();
    Collections.addAll(result, arr);
    return result;
  }

  public static <T> List<T> convertToArrayList(List<T> arr) {
    if (arr == null) return null;
    return new ArrayList<>(arr);
  }
}
