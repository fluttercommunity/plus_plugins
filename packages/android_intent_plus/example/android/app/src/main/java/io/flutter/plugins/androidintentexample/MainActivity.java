package io.flutter.plugins.androidintentexample;

import android.content.IntentFilter;
import android.os.Bundle;
import dev.fluttercommunity.plus.androidintent.AndroidIntentPlugin;
import io.flutter.app.FlutterActivity;

public class MainActivity extends FlutterActivity {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    AndroidIntentPlugin.registerWith(
        registrarFor("dev.fluttercommunity.plus.androidintent.AndroidIntentPlugin"));

    IntentFilter filter = new IntentFilter("com.example.broadcast");
    MyBroadcastReceiver receiver = new MyBroadcastReceiver();
    registerReceiver(receiver, filter);
  }
}
