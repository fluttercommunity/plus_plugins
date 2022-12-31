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
        // todo check if there exists a sensor of type {sensorType} before setting the event stream
        when (sensor) {
            null -> {
                sensor = when (sensorManager.getDefaultSensor(sensorType)) {
                    null -> null
                    else -> {
                        sensorManager.getDefaultSensor(sensorType)
                    }
                }

                when (sensor) {
                    null -> {}
                    else -> {
                        sensorEventListener = createSensorEventListener(events)
                        sensorManager.registerListener(sensorEventListener, sensor, SensorManager.SENSOR_DELAY_NORMAL)
                    }
                }
            }
            else -> {}
        }
    }

    override fun onCancel(arguments: Any?) {
        when (sensor) {
            null -> {}
            else -> {
                sensorManager.unregisterListener(sensorEventListener)
            }
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
