package io.flutter.plugins.androidintentexample;

import android.annotation.SuppressLint;
import android.content.IntentFilter;
import android.os.Bundle;
import androidx.core.content.ContextCompat;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {

  @SuppressLint("WrongConstant")
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    IntentFilter filter = new IntentFilter("com.example.broadcast");
    MyBroadcastReceiver receiver = new MyBroadcastReceiver();
    ContextCompat.registerReceiver(this, receiver, filter, ContextCompat.RECEIVER_EXPORTED);
  }
}
