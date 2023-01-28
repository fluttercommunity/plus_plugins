package dev.fluttercommunity.plus.sensors

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink

internal class StreamHandlerImpl(
    private val sensorManager: SensorManager,
    private val sensorType: Int
) : EventChannel.StreamHandler {
    private var sensorEventListener: SensorEventListener? = null

    private var sensor: Sensor? = null

    override fun onListen(arguments: Any?, events: EventSink) {
        when (sensor) {
            null -> {
                sensor = when (sensorManager.getDefaultSensor(sensorType)) {
                    null -> null
                    else -> sensorManager.getDefaultSensor(sensorType)
                }
                when (sensor) {
                    null -> events.error(
                        "", // todo complete error code here
                        "Sensor Not Found",
                        "It seems that your device doesn't support ${getSensorName(sensorType)} Sensor"
                    )
                    else -> {
                        sensorEventListener = createSensorEventListener(events)
                        sensorManager.registerListener(
                            sensorEventListener,
                            sensor,
                            SensorManager.SENSOR_DELAY_NORMAL
                        )
                    }
                }
            }
            else -> {} // todo not needed sensor var will always be null at first
        }
    }

    override fun onCancel(arguments: Any?) {
        when (sensor) {
            null -> {}
            else -> sensorManager.unregisterListener(sensorEventListener)
        }
    }

    private fun getSensorName(sensorType: Int): String {
        return when (sensorType) {
            Sensor.TYPE_ACCELEROMETER -> "Accelerometer"
            Sensor.TYPE_LINEAR_ACCELERATION -> "User Accelerometer"
            Sensor.TYPE_GYROSCOPE -> "Gyroscope"
            Sensor.TYPE_MAGNETIC_FIELD -> "Magnetometer"
            else -> "Undefined"
        }
    }

    private fun createSensorEventListener(events: EventSink): SensorEventListener {
        return object : SensorEventListener {
            override fun onAccuracyChanged(sensor: Sensor, accuracy: Int) {}

            override fun onSensorChanged(event: SensorEvent) {
                val sensorValues = DoubleArray(event.values.size)
                event.values.forEachIndexed { index, value ->
                    sensorValues[index] = value.toDouble()
                }
                events.success(sensorValues)
            }
        }
    }
}
