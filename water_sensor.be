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
var cooked_analog_h2o_sensor
var live_h2o_reading_ratio
var live_h2o_percentage
var current_sensor_value

# Def readings

def analog_h2o_callback()
  raw_analog_h2o_sensor = json.load(tasmota.read_sensors())
  med_analog_h2o_sensor = raw_analog_h2o_sensor.item("ANALOG")
  cooked_analog_h2o_sensor = med_analog_h2o_sensor.item("A1")
  current_sensor_value = cooked_analog_h2o_sensor - analog_min
  live_h2o_reading_ratio = current_sensor_value/sensor_range
  live_h2o_percentage = 100 * (1 - live_h2o_reading_ratio)
  print(live_h2o_percentage)
  tasmota.set_timer(1000,analog_h2o_callback)
end

tasmota.set_timer(1000,analog_h2o_callback)