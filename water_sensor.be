import json
import string
import mqtt

var sensorCalibration = {'analog_max':3580,'analog_min':1720,'calib_01':0,'calib_02':0}

# Constants

var analog_max = sensorCalibration.item('analog_max')
var analog_min = sensorCalibration.item('analog_min')
var sensor_range = analog_max - analog_min

# Readings

var raw_analog_h2o_sensor
var med_analog_h2o_sensor
var cooked_analog_h2o_sensor_01 = 0.00
var live_h2o_reading_ratio = 0.00
var live_h2o_percentage = 0.00
var current_sensor_value = 0.00
var h2o_json_payload_01 = 0

# MQTT Topics

var water_sensor_topic_01 = "nexus/sensor/watersensors/status"

# Def readings
# Excuse my dear debugging notes.

def analog_h2o_callback()
  raw_analog_h2o_sensor = json.load(tasmota.read_sensors())
  med_analog_h2o_sensor = raw_analog_h2o_sensor.item("ANALOG")
  cooked_analog_h2o_sensor_01 = med_analog_h2o_sensor.item("A1")
  current_sensor_value = cooked_analog_h2o_sensor_01 - analog_min
  live_h2o_reading_ratio = real(current_sensor_value)/real(sensor_range)
  print("Ratio: " + str(live_h2o_reading_ratio))
  live_h2o_percentage = 100 * (1 - live_h2o_reading_ratio)
  print("Percentage: " + str(live_h2o_percentage))
  h2o_json_payload_01 = str(live_h2o_percentage)
  mqtt.publish("nexus/sensor/watersensors/01/status", h2o_json_payload_01)
  tasmota.set_timer(5000,analog_h2o_callback)
end

tasmota.set_timer(5000,analog_h2o_callback)
end

tasmota.set_timer(1000,analog_h2o_callback)
