package dev.fluttercommunity.plus.androidintent.Bundle;

import static org.junit.Assert.assertEquals;

import android.os.Bundle;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.file.Files;
import java.util.List;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;

@RunWith(RobolectricTestRunner.class)
public class ExtrasTest {

  private Gson gson;
  private ClassLoader classLoader;

  private String loadFromFile(String resource) throws IOException {
    URL url = classLoader.getResource(resource);
    String pathName = url.getFile();
    File file = new File(pathName);
    return new String(Files.readAllBytes(file.toPath()));
  }

  @Before
  public void setup() {
    gson = new GsonBuilder().registerTypeAdapterFactory(new BundleTypeAdapterFactory()).create();
    classLoader = getClass().getClassLoader();
  }

  @Test
  public void convertWithEmptyExtras() throws IOException {
    List<Bundle> bundles = Extras.convert(loadFromFile("EmptyExtras.json"));
    String bundleAsString = gson.toJson(bundles);
    JsonElement bundleAsJson = JsonParser.parseString(bundleAsString);
    JsonElement resultAsJson = JsonParser.parseString(loadFromFile("EmptyExtrasResult.json"));
    assertEquals(bundleAsJson, resultAsJson);
  }

  @Test
  public void convertWithNestedExtras() throws IOException {
    List<Bundle> bundles = Extras.convert(loadFromFile("NestedExtras.json"));
    String bundleAsString = gson.toJson(bundles);
    JsonElement bundleAsJson = JsonParser.parseString(bundleAsString);
    JsonElement resultAsJson = JsonParser.parseString(loadFromFile("NestedExtrasResult.json"));
    assertEquals(bundleAsJson, resultAsJson);
  }
}
