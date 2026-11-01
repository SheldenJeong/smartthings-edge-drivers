local ZigbeeDriver = require "st.zigbee"
local capabilities = require "st.capabilities"

local TUYA_CLUSTER = 0xEF00
local TUYA_COMMAND_RESPONSE = 0x01
local TUYA_COMMAND_REPORT = 0x02

local function decode_unsigned(bytes, first, length)
  if length < 1 or length > 4 or first + length - 1 > #bytes then
    return nil
  end

  local value = 0
  for index = first, first + length - 1 do
    value = value * 256 + bytes:byte(index)
  end
  return value
end

local function emit_data_point(device, data_point, data_type, bytes, first, length)
  if data_type ~= 0x02 then
    return
  end

  local value = decode_unsigned(bytes, first, length)
  if value == nil then
    return
  end

  if data_point == 0x02 then
    device:emit_event(capabilities.carbonDioxideMeasurement.carbonDioxide({
      value = value,
      unit = "ppm"
    }))
  elseif data_point == 0x12 then
    if length == 4 and value >= 0x80000000 then
      value = value - 0x100000000
    end
    device:emit_event(capabilities.temperatureMeasurement.temperature({
      value = value / 10,
      unit = "C"
    }))
  elseif data_point == 0x13 then
    device:emit_event(capabilities.relativeHumidityMeasurement.humidity({
      value = value / 10,
      unit = "%"
    }))
  end
end

local function tuya_cluster_handler(_, device, message)
  local bytes = message.body.zcl_body.body_bytes
  if bytes == nil then
    return
  end

  local cursor = 3
  while cursor + 3 <= #bytes do
    local data_point = bytes:byte(cursor)
    local data_type = bytes:byte(cursor + 1)
    local length = bytes:byte(cursor + 2) * 256 + bytes:byte(cursor + 3)
    local data_start = cursor + 4
    local next_record = data_start + length

    if length < 1 or next_record - 1 > #bytes then
      return
    end

    emit_data_point(device, data_point, data_type, bytes, data_start, length)
    cursor = next_record
  end
end

local driver_template = {
  zigbee_handlers = {
    cluster = {
      [TUYA_CLUSTER] = {
        [TUYA_COMMAND_RESPONSE] = tuya_cluster_handler,
        [TUYA_COMMAND_REPORT] = tuya_cluster_handler
      }
    }
  }
}

local driver = ZigbeeDriver("tuya-ts0601-co2-zigbee", driver_template)
driver:run()
