package dev.fluttercommunity.plus.androidintent;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import dev.fluttercommunity.plus.androidintent.Bundle.Bundles;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;

//These tests are "Java side only" tests.
//These tests are for testing the deserializing, serializing and normalizing of the Java classes.
//The "Dart side only" tests are at
//android_bundle/test/to_and_from_json_test.dart

@RunWith(RobolectricTestRunner.class)
public class RubigoBroadcastAndroidPluginTest {
  private ClassLoader classLoader;

  private String loadFromFileGenerated(String resource) throws IOException {
    return loadFromFile(resource, true);
  }

  private String loadFromFileManual(String resource) throws IOException {
    return loadFromFile(resource, false);
  }

  private String loadFromFile(String resource, boolean generated) throws IOException {
    if (generated) {
      resource = Paths.get("generated", resource).toString();
    }
    URL url = classLoader.getResource(resource);
    String pathName = url.getFile();
    File file = new File(pathName);
    return new String(Files.readAllBytes(file.toPath()));
  }

  @Before
  public void setup() {
    classLoader = getClass().getClassLoader();
  }

  private Bundles performToBundlesTest(String sourceAsJsonString, Bundles expected)
      throws JSONException {
    //Create a Bundles object from the json string
    Bundles sourceBundles = Bundles.bundlesFromJsonString(sourceAsJsonString);
    //Compare the sourceBundles object with the expected object
    assertThat(sourceBundles).usingRecursiveComparison().isEqualTo(expected);
    return sourceBundles;
  }

  private void performToJsonTest(Bundles sourceBundles, Bundles expectedBundles)
      throws JSONException {
    //Convert the sourceBundles object to a List<android.os.Bundle>
    List<android.os.Bundle> androidOsBundles = sourceBundles.toListOfAndroidOsBundle();
    Bundles resultBundles = Bundles.fromListOfAndroidOsBundle(androidOsBundles);
    //Convert the resultBundles object back to a JSONObject
    JSONObject expectedJson = expectedBundles.toJson();
    //Compare the json objects
    JSONObject resultJson = resultBundles.toJson();
    assertThat(resultJson).usingRecursiveComparison().isEqualTo(expectedJson);
  }

  @Test
  public void emptyBundle() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("emptyBundle.json");
    Bundles expectedBundles = TestValues.emptyBundle();
    final Bundles bundles = performToBundlesTest(sourceAsJsonString, expectedBundles);
    performToJsonTest(bundles, expectedBundles);
  }

  @Test
  public void bundleWithBoolean() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithBoolean.json");
    Bundles expectedBundles = TestValues.bundleWithBoolean();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expectedBundles);
    performToJsonTest(sourceBundles, expectedBundles);
  }

  @Test
  public void bundleWithBooleanArray() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithBooleanArray.json");
    Bundles expected = TestValues.bundleWithBooleanArray();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithBundle() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithBundle.json");
    Bundles expected = TestValues.bundleWithBundle();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithByte() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithByte.json");
    Bundles expected = TestValues.bundleWithByte();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithByteArray() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithByteArray.json");
    Bundles expected = TestValues.bundleWithByteArray();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithChar() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithChar.json");
    Bundles expected = TestValues.bundleWithChar();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithCharArray() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithCharArray.json");
    Bundles expected = TestValues.bundleWithCharArray();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithCharSequence() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithCharSequence.json");
    Bundles expected = TestValues.bundleWithCharSequence();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    //A CharSequence is stored as a String in a Bundle, so we need to convert the expected object
    Bundles other = TestValues.bundleWithString();
    performToJsonTest(sourceBundles, other);
  }

  @Test
  public void bundleWithCharSequenceArray() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithCharSequenceArray.json");
    Bundles expected = TestValues.bundleWithCharSequenceArray();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    //A CharSequenceArray is stored as a Array of String in a Bundle, so we need to convert the expected object
    Bundles other = TestValues.bundleWithStringArray();
    performToJsonTest(sourceBundles, other);
  }

  @Test
  public void bundleWithCharSequenceArrayList() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithCharSequenceArrayList.json");
    Bundles expected = TestValues.bundleWithCharSequenceArrayList();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    //A CharSequenceArray is stored as a Array of String in a Bundle, so we need to convert the expected object
    Bundles other = TestValues.bundleWithStringArrayList();
    performToJsonTest(sourceBundles, other);
  }

  @Test
  public void bundleWithDouble() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithDouble.json");
    Bundles expected = TestValues.bundleWithDouble();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithDoubleArray() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithDoubleArray.json");
    Bundles expected = TestValues.bundleWithDoubleArray();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithFloat() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithFloat.json");
    Bundles expected = TestValues.bundleWithFloat();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithFloatArray() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithFloatArray.json");
    Bundles expected = TestValues.bundleWithFloatArray();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithInt() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithInt.json");
    Bundles expected = TestValues.bundleWithInt();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithIntArray() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithIntArray.json");
    Bundles expected = TestValues.bundleWithIntArray();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithIntegerArrayList() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithIntegerArrayList.json");
    Bundles expected = TestValues.bundleWithIntegerArrayList();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithLong() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithLong.json");
    Bundles expected = TestValues.bundleWithLong();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithLongArray() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithLongArray.json");
    Bundles expected = TestValues.bundleWithLongArray();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithParcelable() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithParcelable.json");
    Bundles expected = TestValues.bundleWithParcelable();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    //A PutParcelable is stored as a Bundle in a Bundle, so we need to convert the expected object
    Bundles other = TestValues.bundleWithBundle();
    performToJsonTest(sourceBundles, other);
  }

  @Test
  public void bundleWithParcelableArray() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithParcelableArray.json");
    Bundles expected = TestValues.bundleWithParcelableArray();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithParcelableArrayList() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithParcelableArrayList.json");
    Bundles expected = TestValues.bundleWithParcelableArrayList();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithShort() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithShort.json");
    Bundles expected = TestValues.bundleWithShort();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithShortArray() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithShortArray.json");
    Bundles expected = TestValues.bundleWithShortArray();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithString() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithString.json");
    Bundles expected = TestValues.bundleWithString();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithStringArray() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithStringArray.json");
    Bundles expected = TestValues.bundleWithStringArray();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithStringArrayList() throws IOException, JSONException {
    String sourceAsJsonString = loadFromFileGenerated("bundleWithStringArrayList.json");
    Bundles expected = TestValues.bundleWithStringArrayList();
    final Bundles sourceBundles = performToBundlesTest(sourceAsJsonString, expected);
    performToJsonTest(sourceBundles, expected);
  }

  @Test
  public void bundleWithUnknownPutBaseInBundle() {
    assertThatThrownBy(
            () -> {
              String sourceAsJsonString =
                  loadFromFileManual("bundleWithUnknownPutBaseInBundle.json");
              JSONObject sourceAsJson = new JSONObject(sourceAsJsonString);
              @SuppressWarnings("unused")
              Bundles sourceBundles = Bundles.fromJson(sourceAsJson);
            })
        .isInstanceOf(RuntimeException.class)
        .hasMessage("JavaClass (PutStringUNKNOWN) not found (PutBase.fromJson)");
  }

  @Test
  public void bundleWithUnknownBundleInParcelable() {
    assertThatThrownBy(
            () -> {
              String sourceAsJsonString =
                  loadFromFileManual("bundleWithUnknownBundleInParcelable.json");
              JSONObject sourceAsJson = new JSONObject(sourceAsJsonString);
              @SuppressWarnings("unused")
              Bundles sourceBundles = Bundles.fromJson(sourceAsJson);
            })
        .isInstanceOf(RuntimeException.class)
        .hasMessage("JavaClass (BundleUNKNOWN) not found (Json.parcelableBaseFromJson)");
  }

  @Test
  public void bundleWithUnknownBundleInParcelableArray() {
    assertThatThrownBy(
            () -> {
              String sourceAsJsonString =
                  loadFromFileManual("bundleWithUnknownBundleInParcelableArray.json");
              JSONObject sourceAsJson = new JSONObject(sourceAsJsonString);
              @SuppressWarnings("unused")
              Bundles sourceBundles = Bundles.fromJson(sourceAsJson);
            })
        .isInstanceOf(RuntimeException.class)
        .hasMessage("JavaClass (BundleUNKNOWN) not found (Json.parcelableBaseFromJson)");
  }

  @Test
  public void bundleWithUnknownBundleInParcelableArrayList() {
    assertThatThrownBy(
            () -> {
              String sourceAsJsonString =
                  loadFromFileManual("bundleWithUnknownBundleInParcelableArrayList.json");
              JSONObject sourceAsJson = new JSONObject(sourceAsJsonString);
              @SuppressWarnings("unused")
              Bundles sourceBundles = Bundles.fromJson(sourceAsJson);
            })
        .isInstanceOf(RuntimeException.class)
        .hasMessage("JavaClass (BundleUNKNOWN) not found (Json.parcelableBaseFromJson)");
  }
}
