package io.flutter.plugins.androidintentexample;

import android.content.IntentFilter;
import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    IntentFilter filter = new IntentFilter("com.example.broadcast");
    MyBroadcastReceiver receiver = new MyBroadcastReceiver();
    registerReceiver(receiver, filter);
  }
}
