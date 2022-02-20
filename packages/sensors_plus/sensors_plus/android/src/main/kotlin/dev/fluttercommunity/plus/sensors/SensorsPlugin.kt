package dev.fluttercommunity.plus.sensors

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

/** SensorsPlugin  */
class SensorsPlugin : FlutterPlugin {
    private lateinit var accelerometerChannel: EventChannel
    private lateinit var userAccelChannel: EventChannel
    private lateinit var gyroscopeChannel: EventChannel
    private lateinit var magnetometerChannel: EventChannel

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        setupEventChannels(binding.applicationContext, binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        teardownEventChannels()
    }

    private fun setupEventChannels(context: Context, messenger: BinaryMessenger) {
        val sensorsManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager

        accelerometerChannel = EventChannel(messenger, ACCELEROMETER_CHANNEL_NAME)
        val accelerationStreamHandler = StreamHandlerImpl(
                sensorsManager,
                Sensor.TYPE_ACCELEROMETER
        )
        accelerometerChannel.setStreamHandler(accelerationStreamHandler)

        userAccelChannel = EventChannel(messenger, USER_ACCELEROMETER_CHANNEL_NAME)
        val linearAccelerationStreamHandler = StreamHandlerImpl(
                sensorsManager,
                Sensor.TYPE_LINEAR_ACCELERATION
        )
        userAccelChannel.setStreamHandler(linearAccelerationStreamHandler)

        gyroscopeChannel = EventChannel(messenger, GYROSCOPE_CHANNEL_NAME)
        val gyroScopeStreamHandler = StreamHandlerImpl(
                sensorsManager,
                Sensor.TYPE_GYROSCOPE
        )
        gyroscopeChannel.setStreamHandler(gyroScopeStreamHandler)

        magnetometerChannel = EventChannel(messenger, MAGNETOMETER_CHANNEL_NAME)
        val magnetometerStreamHandler = StreamHandlerImpl(
                sensorsManager,
                Sensor.TYPE_MAGNETIC_FIELD
        )
        magnetometerChannel.setStreamHandler(magnetometerStreamHandler)
    }

    private fun teardownEventChannels() {
        accelerometerChannel.setStreamHandler(null)
        userAccelChannel.setStreamHandler(null)
        gyroscopeChannel.setStreamHandler(null)
        magnetometerChannel.setStreamHandler(null)
    }

    companion object {
        private const val ACCELEROMETER_CHANNEL_NAME = "dev.fluttercommunity.plus/sensors/accelerometer"
        private const val GYROSCOPE_CHANNEL_NAME = "dev.fluttercommunity.plus/sensors/gyroscope"
        private const val USER_ACCELEROMETER_CHANNEL_NAME = "dev.fluttercommunity.plus/sensors/user_accel"
        private const val MAGNETOMETER_CHANNEL_NAME = "dev.fluttercommunity.plus/sensors/magnetometer"
    }
}
