package dev.fluttercommunity.plus.androidintent;

import dev.fluttercommunity.plus.androidintent.Bundle.Bundles;
import dev.fluttercommunity.plus.androidintent.Bundle.ParcelableClasses.Bundle;
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
import java.util.Arrays;
import java.util.Collections;

@SuppressWarnings("ArraysAsListWithZeroOrOneArgument")
public class TestValues {
  static Bundles emptyBundle() {
    return new Bundles(Collections.singletonList(new Bundle()));
  }

  public static Bundles bundleWithBoolean() {
    return new Bundles(
        Arrays.asList(
            new Bundle(Arrays.asList(new PutBool("key1", true), new PutBool("key2", false)))));
  }

  public static Bundles bundleWithBooleanArray() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutBoolArray("key1", Arrays.asList(true, false, true)),
                    new PutBoolArray("key2", Arrays.asList(false, true, false))))));
  }

  public static Bundles bundleWithBundle() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutBundle(
                        "key1",
                        Arrays.asList(
                            new PutString("subKey1", "value1"), new PutInt("subKey2", 1))),
                    new PutBundle(
                        "key2",
                        Arrays.asList(
                            new PutString("subKey1", "value2"), new PutInt("subKey2", 2)))))));
  }

  public static Bundles bundleWithByte() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(new PutByte("key1", (byte) -128), new PutByte("key2", (byte) 127)))));
  }

  public static Bundles bundleWithByteArray() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutByteArray("key1", Arrays.asList((byte) -128, (byte) 0, (byte) 127)),
                    new PutByteArray("key2", Arrays.asList((byte) 127, (byte) 0, (byte) -128))))));
  }

  public static Bundles bundleWithChar() {
    return new Bundles(
        Arrays.asList(
            new Bundle(Arrays.asList(new PutChar("key1", 'a'), new PutChar("key2", 'b')))));
  }

  public static Bundles bundleWithCharArray() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutCharArray("key1", Arrays.asList('a', 'b', 'c')),
                    new PutCharArray("key2", Arrays.asList('c', 'b', 'a'))))));
  }

  public static Bundles bundleWithCharSequence() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutCharSequence("key1", "value1"),
                    new PutCharSequence("key2", "value2")))));
  }

  public static Bundles bundleWithCharSequenceArray() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutCharSequenceArray("key1", Arrays.asList("value1", "value2", "value3")),
                    new PutCharSequenceArray(
                        "key2", Arrays.asList("value4", "value5", "value6"))))));
  }

  public static Bundles bundleWithCharSequenceArrayList() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutCharSequenceArrayList(
                        "key1", Arrays.asList("value1", "value2", "value3")),
                    new PutCharSequenceArrayList(
                        "key2", Arrays.asList("value4", "value5", "value6"))))));
  }

  public static Bundles bundleWithDouble() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutDouble("key1", -9.999999e+96),
                    new PutDouble("key2", 1e-101),
                    new PutDouble("key3", 9.999999e+96)))));
  }

  public static Bundles bundleWithDoubleArray() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutDoubleArray("key1", Arrays.asList(-9.999999e+96, 1e-101, 9.999999e+96)),
                    new PutDoubleArray(
                        "key2", Arrays.asList(9.999999e+96, 1e-101, -9.999999e+96))))));
  }

  public static Bundles bundleWithFloat() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutFloat("key1", -3.4028235e+38f),
                    new PutFloat("key2", 1.4e-45f),
                    new PutFloat("key3", 3.4028235e+38f)))));
  }

  public static Bundles bundleWithFloatArray() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutFloatArray(
                        "key1", Arrays.asList(-3.4028235e+38f, 1.4e-45f, 3.4028235e+38f)),
                    new PutFloatArray(
                        "key2", Arrays.asList(3.4028235e+38f, 1.4e-45f, -3.4028235e+38f))))));
  }

  public static Bundles bundleWithInt() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(new PutInt("key1", -2147483648), new PutInt("key2", 2147483647)))));
  }

  public static Bundles bundleWithIntArray() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutIntArray("key1", Arrays.asList(-2147483648, 0, 2147483647)),
                    new PutIntArray("key2", Arrays.asList(2147483647, 0, -2147483648))))));
  }

  public static Bundles bundleWithIntegerArrayList() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutIntegerArrayList("key1", Arrays.asList(-2147483648, 0, 2147483647)),
                    new PutIntegerArrayList("key2", Arrays.asList(2147483647, 0, -2147483648))))));
  }

  public static Bundles bundleWithLong() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutLong("key1", -9223372036854775808L),
                    new PutLong("key2", 9223372036854775807L)))));
  }

  public static Bundles bundleWithLongArray() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutLongArray(
                        "key1", Arrays.asList(-9223372036854775808L, 0L, 9223372036854775807L)),
                    new PutLongArray(
                        "key2", Arrays.asList(9223372036854775807L, 0L, -9223372036854775808L))))));
  }

  public static Bundles bundleWithShort() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutShort("key1", (short) -32768), new PutShort("key2", (short) 32767)))));
  }

  public static Bundles bundleWithShortArray() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutShortArray(
                        "key1", Arrays.asList((short) -32768, (short) 0, (short) 32767)),
                    new PutShortArray(
                        "key2", Arrays.asList((short) 32767, (short) 0, (short) -32768))))));
  }

  public static Bundles bundleWithString() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(new PutString("key1", "value1"), new PutString("key2", "value2")))));
  }

  public static Bundles bundleWithStringArray() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutStringArray("key1", Arrays.asList("value1", "value2", "value3")),
                    new PutStringArray("key2", Arrays.asList("value4", "value5", "value6"))))));
  }

  public static Bundles bundleWithStringArrayList() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutStringArrayList("key1", Arrays.asList("value1", "value2", "value3")),
                    new PutStringArrayList("key2", Arrays.asList("value4", "value5", "value6"))))));
  }

  public static Bundles bundleWithParcelable() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutParcelable(
                        "key1",
                        new Bundle(
                            Arrays.asList(
                                new PutString("subKey1", "value1"), new PutInt("subKey2", 1)))),
                    new PutParcelable(
                        "key2",
                        new Bundle(
                            Arrays.asList(
                                new PutString("subKey1", "value2"), new PutInt("subKey2", 2))))))));
  }

  public static Bundles bundleWithParcelableArray() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutParcelableArray(
                        "key1",
                        Arrays.asList(
                            new Bundle(
                                Arrays.asList(
                                    new PutString("subKey1", "value1"), new PutInt("subKey2", 1))),
                            new Bundle(
                                Arrays.asList(
                                    new PutString("subKey1", "value2"),
                                    new PutInt("subKey2", 2))))),
                    new PutParcelableArray(
                        "key2",
                        Arrays.asList(
                            new Bundle(
                                Arrays.asList(
                                    new PutString("subKey1", "value3"), new PutInt("subKey2", 3))),
                            new Bundle(
                                Arrays.asList(
                                    new PutString("subKey1", "value4"),
                                    new PutInt("subKey2", 4)))))))));
  }

  public static Bundles bundleWithParcelableArrayList() {
    return new Bundles(
        Arrays.asList(
            new Bundle(
                Arrays.asList(
                    new PutParcelableArrayList(
                        "key1",
                        Arrays.asList(
                            new Bundle(
                                Arrays.asList(
                                    new PutString("subKey1", "value1"), new PutInt("subKey2", 1))),
                            new Bundle(
                                Arrays.asList(
                                    new PutString("subKey1", "value2"),
                                    new PutInt("subKey2", 2))))),
                    new PutParcelableArrayList(
                        "key2",
                        Arrays.asList(
                            new Bundle(
                                Arrays.asList(
                                    new PutString("subKey1", "value3"), new PutInt("subKey2", 3))),
                            new Bundle(
                                Arrays.asList(
                                    new PutString("subKey1", "value4"),
                                    new PutInt("subKey2", 4)))))))));
  }
}
