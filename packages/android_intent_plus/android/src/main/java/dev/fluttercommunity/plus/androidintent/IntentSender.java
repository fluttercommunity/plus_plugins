package dev.fluttercommunity.plus.androidintent;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import androidx.annotation.Nullable;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.Map;

/** Forms and launches intents. */
public final class IntentSender {
  private static final String TAG = "IntentSender";

  @Nullable private Activity activity;
  @Nullable private Context applicationContext;

  /**
   * Caches the given {@code activity} and {@code applicationContext} to use for sending intents
   * later.
   *
   * <p>Either may be null initially, but at least {@code applicationContext} should be set before
   * calling {@link #send}.
   *
   * <p>See also {@link #setActivity}, {@link #setApplicationContext}, and {@link #send}.
   */
  public IntentSender(@Nullable Activity activity, @Nullable Context applicationContext) {
    this.activity = activity;
    this.applicationContext = applicationContext;
  }

  /**
   * Creates and launches an intent with the given params using the cached {@link Activity} and
   * {@link Context}.
   *
   * <p>This will fail to create and send the intent if {@code applicationContext} hasn't been set
   * at the time of calling.
   *
   * <p>This uses {@code activity} to start the intent whenever it's not null. Otherwise it falls
   * back to {@code applicationContext} and adds {@link Intent#FLAG_ACTIVITY_NEW_TASK} to the intent
   * before launching it.
   */
  void send(Intent intent) {
    if (applicationContext == null) {
      Log.wtf(TAG, "Trying to send an intent before the applicationContext was initialized.");
      return;
    }

    Log.v(TAG, "Sending intent " + intent);

    if (activity != null) {
      activity.startActivity(intent);
    } else {
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      applicationContext.startActivity(intent);
    }
  }

  /**
   * Like with {@code send}, creates and launches an intent with the given params, but wraps the
   * {@code Intent} with {@code Intent.createChooser}.
   */
  public void launchChooser(Intent intent, String title) {
    send(Intent.createChooser(intent, title));
  }

  /** Creates an intent and sends it as Broadcast. */
  public void sendBroadcast(Intent intent) {
    if (applicationContext == null) {
      Log.wtf(TAG, "Trying to send broadcast before the applicationContext was initialized.");
      return;
    }

    Log.v(TAG, "Sending broadcast " + intent);
    applicationContext.sendBroadcast(intent);
  }

  /**
   * Verifies the given intent and returns whether the application context class can resolve it.
   *
   * <p>This will fail to create and send the intent if {@code applicationContext} hasn't been set *
   * at the time of calling.
   *
   * <p>This currently only supports resolving activities.
   *
   * @param intent Fully built intent.
   * @return Whether the package manager found {@link android.content.pm.ResolveInfo} using its
   *     {@link PackageManager#resolveActivity(Intent, int)} method.
   * @see #buildIntent(String, Integer, String, Uri, Bundle, String, ComponentName, String)
   */
  boolean canResolveActivity(Intent intent) {
    if (applicationContext == null) {
      Log.wtf(TAG, "Trying to resolve an activity before the applicationContext was initialized.");
      return false;
    }

    final PackageManager packageManager = applicationContext.getPackageManager();
    return packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY) != null;
  }

  /**
   * Get the default activity that will resolve the intent
   *
   * <p>This will fail to create and send the intent if {@code applicationContext} hasn't been set *
   * at the time of calling.
   *
   * <p>This currently only supports resolving activities.
   *
   * @param intent Fully built intent.
   * @return Whether the package manager found {@link android.content.pm.ResolveInfo} using its
   *     {@link PackageManager#resolveActivity(Intent, int)} method.
   * @see #buildIntent(String, Integer, String, Uri, Bundle, String, ComponentName, String)
   */
  @Nullable
  Map<String, Object> getResolvedActivity(Intent intent) {
    if (applicationContext == null) {
      Log.wtf(TAG, "Trying to resolve an activity before the applicationContext was initialized.");
      return null;
    }

    final PackageManager packageManager = applicationContext.getPackageManager();
    ResolveInfo resolveInfo =
        packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY);

    if (resolveInfo != null) {
      Map<String, Object> resultMap = new HashMap<>();
      resultMap.put("activityName", resolveInfo.activityInfo.name);
      resultMap.put("packageName", resolveInfo.activityInfo.packageName);
      resultMap.put("appName", resolveInfo.loadLabel(packageManager));
      return resultMap;
    }

    return null;
  }

  /** Caches the given {@code activity} to use for {@link #send}. */
  void setActivity(@Nullable Activity activity) {
    this.activity = activity;
  }

  /** Caches the given {@code applicationContext} to use for {@link #send}. */
  void setApplicationContext(@Nullable Context applicationContext) {
    this.applicationContext = applicationContext;
  }

  /**
   * Constructs a new intent with the data specified.
   *
   * @param action the Intent action, such as {@code ACTION_VIEW}.
   * @param flags forwarded to {@link Intent#addFlags(int)} if non-null.
   * @param category forwarded to {@link Intent#addCategory(String)} if non-null.
   * @param data forwarded to {@link Intent#setData(Uri)} if non-null and 'type' parameter is null.
   *     If both 'data' and 'type' is non-null they're forwarded to {@link
   *     Intent#setDataAndType(Uri, String)}
   * @param arguments forwarded to {@link Intent#putExtras(Bundle)} if non-null.
   * @param packageName forwarded to {@link Intent#setPackage(String)} if non-null. This is forced
   *     to null if it can't be resolved.
   * @param componentName forwarded to {@link Intent#setComponent(ComponentName)} if non-null.
   * @param type forwarded to {@link Intent#setType(String)} if non-null and 'data' parameter is
   *     null. If both 'data' and 'type' is non-null they're forwarded to {@link
   *     Intent#setDataAndType(Uri, String)}
   * @return Fully built intent.
   */
  Intent buildIntent(
      @Nullable String action,
      @Nullable Integer flags,
      @Nullable String category,
      @Nullable Uri data,
      @Nullable Bundle arguments,
      @Nullable String packageName,
      @Nullable ComponentName componentName,
      @Nullable String type) {
    if (applicationContext == null) {
      Log.wtf(TAG, "Trying to build an intent before the applicationContext was initialized.");
      return null;
    }

    Intent intent = new Intent();

    if (action != null) {
      intent.setAction(action);
    }
    if (flags != null) {
      intent.addFlags(flags);
    }
    if (!TextUtils.isEmpty(category)) {
      intent.addCategory(category);
    }
    if (data != null && type == null) {
      intent.setData(data);
    }
    if (type != null && data == null) {
      intent.setType(type);
    }
    if (type != null && data != null) {
      intent.setDataAndType(data, type);
    }
    if (arguments != null) {
      intent.putExtras(arguments);
    }
    if (!TextUtils.isEmpty(packageName)) {
      intent.setPackage(packageName);
      if (componentName != null) {
        intent.setComponent(componentName);
      }
    }

    return intent;
  }

  public Intent parse(String uri) throws URISyntaxException {
    return Intent.parseUri(uri, Intent.URI_INTENT_SCHEME);
  }
}
