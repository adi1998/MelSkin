local socket = require("socket")

local OpenRGB = {}
OpenRGB.__index = OpenRGB

local MAGIC = "ORGB"
local PORT = 6742

-- Packet IDs
local PKT = {
    REQUEST_CONTROLLER_COUNT = 0,
    REQUEST_CONTROLLER_DATA = 1,
    REQUEST_PROTOCOL_VERSION = 40,
    SET_CLIENT_NAME = 50,
    NET_PACKET_ID_RGBCONTROLLER_UPDATELEDS = 1050,

}

--------------------------------------------------
-- Binary helpers (Lua 5.2 compatible)
--------------------------------------------------

local function pack_u32(n)
    local b1 = n % (2^8)
    local b2 = math.floor(n / (2^8)) % (2^8)
    local b3 = math.floor(n / (2^16)) % (2^8)
    local b4 = math.floor(n / (2^24)) % (2^8)
    return string.char(b1, b2, b3, b4)
end

local function pack_u16(n)
    local b1 = n % (2^8)
    local b2 = math.floor(n / (2^8)) % (2^8)
    return string.char(b1, b2)
end

local function unpack_u32(s, pos)
    pos = pos or 1
    local b1, b2, b3, b4 = s:byte(pos, pos + 3)
    local value =
        b1 +
        b2 * (2^8) +
        b3 * (2^16) +
        b4 * (2^24)
    return value, pos + 4
end

local function unpack_u32_arr(s, pos, n)
    local arr = {}
    for i = 1, n do
        local u32; u32, pos = unpack_u32(s, pos)
        table.insert(arr, u32)
    end
    return arr
end

local function unpack_u16(s, pos)
    pos = pos or 1
    local b1, b2 = s:byte(pos, pos + 1)
    local value =
        b1 +
        b2 * (2^8)
    return value, pos + 2
end

local function unpack_i32(s, pos)
    pos = pos or 1
    local b1, b2, b3, b4 = s:byte(pos, pos + 3)
    local value =
        b1 +
        b2 * (2^8) +
        b3 * (2^16) +
        b4 * (2^24)
    
    -- convert unsigned -> signed
    if value >= 2^31 then
        value = value - 2^32
    end

    return value, pos + 4
end

local function unpack_string(s, pos, len)
    local value = string.sub(s, pos, pos+len-2)
    return value, pos+len
end

local function unpack_RGBColor(s, pos)
    local rgb; rgb, pos = unpack_u32(s, pos)
    local r = rgb % (2^8)
    local g = math.floor(rgb/(2^8)) % (2^8)
    local b = math.floor(rgb/(2^16)) % (2^8)
    return { r = r, g = g, b = b}, pos
end

local function unpack_RGBColorN(s, pos, num_colors)
    local colors = {}
    for i = 1, num_colors do
        local color; color, pos = unpack_RGBColor(s, pos)
        table.insert(colors, color)
    end
    return colors, pos
end

local function pack_RGBColor(color)
    return string.char(color.r, color.g, color.b, 0)
end

local function pack_RGBColorN(color_list)
    local n = #color_list
    local value = ""
    
    for idx, color in ipairs(color_list) do
        value = value .. pack_RGBColor(color)
    end
    return value
end

local function unpack_Mode_Data(s, pos, num_modes)
    local modes = {}
    for i = 1, num_modes do
        local mode = {}
        mode.mode_name_len, pos = unpack_u16(s, pos)
        mode.mode_name, pos = unpack_string(s, pos, mode.mode_name_len)
        mode.mode_value, pos = unpack_i32(s, pos)
        mode.mode_flags, pos = unpack_u32(s, pos)
        mode.mode_speed_min, pos = unpack_u32(s, pos)
        mode.mode_speed_max, pos = unpack_u32(s, pos)
        mode.mode_brightness_min, pos = unpack_u32(s, pos)
        mode.mode_brightness_max, pos = unpack_u32(s, pos)
        mode.mode_colors_min, pos = unpack_u32(s, pos)
        mode.mode_colors_max, pos = unpack_u32(s, pos)
        mode.mode_speed, pos = unpack_u32(s, pos)
        mode.mode_brightness, pos = unpack_u32(s, pos)
        mode.mode_direction, pos = unpack_u32(s, pos)
        mode.mode_color_mode, pos = unpack_u32(s, pos)
        mode.mode_num_colors, pos = unpack_u16(s, pos)
        mode.mode_colors, pos = unpack_RGBColorN(s, pos, mode.mode_num_colors)
        table.insert(modes,mode)
    end
    return modes, pos
end

local function unpack_Segment_Data(s, pos,  num_segments)
    local segments = {}
    for i = 1, num_segments do
        local segment = {}
        segment.segment_name_len, pos = unpack_u16(s, pos)
        segment.segment_name, pos = unpack_string(s, pos, segment.segment_name_len)
        segment.segment_type, pos = unpack_i32(s, pos)
        segment.segment_start_idx, pos = unpack_u32(s, pos)
        segment.segment_leds_count, pos = unpack_u32(s, pos)
        table.insert(segments, segment)
    end
    return segments, pos
end

local function unpack_Zone_Data(s, pos, num_zones)
    local zones = {}
    for i = 1, num_zones do
        local zone = {}
        zone.zone_name_len, pos = unpack_u16(s, pos)
        zone.zone_name, pos = unpack_string(s, pos, zone.zone_name_len)
        zone.zone_type, pos = unpack_i32(s, pos)
        zone.zone_leds_min, pos = unpack_u32(s, pos)
        zone.zone_leds_max, pos = unpack_u32(s, pos)
        zone.zone_leds_count, pos = unpack_u32(s, pos)
        zone.zone_matrix_len, pos = unpack_u16(s, pos)
        if zone.zone_matrix_len > 0 then
            zone.zone_matrix_height, pos = unpack_u32(s, pos)
            zone.zone_matrix_width, pos = unpack_u32(s, pos)
            zone.zone_matrix_data, pos = unpack_u32_arr(s, pos, zone.zone_matrix_len - 8)
        end
        zone.num_segments, pos = unpack_u16(s, pos)
        zone.segments, pos = unpack_Segment_Data(s, pos, zone.num_segments)
        zone.zone_flags, pos = unpack_u32(s, pos)
        table.insert(zones,zone)
    end
    return zones, pos
end

local function unpack_LED_Data(s, pos, num_leds)
    local leds = {}
    for i = 1, num_leds do
        local led = {}
        led.led_name_len, pos = unpack_u16(s, pos)
        led.led_name, pos = unpack_string(s, pos, led.led_name_len)
        led.led_value, pos = unpack_u32(s, pos)
        table.insert(leds,led)
    end
    return leds, pos
end

local function unpack_LED_Alt_Names(s, pos, num_led_alt_names)
    local alt_names = {}
    for i = 1, num_led_alt_names do
        local alt_name = {}
        alt_name.led_alt_name_len, pos = unpack_u16(s, pos)
        alt_name.led_alt_name, pos = unpack_string(s, pos, alt_name.led_alt_name_len)
        table.insert(alt_names, alt_name)
    end
    return alt_names, pos
end

--------------------------------------------------
-- Packet header
--------------------------------------------------

local function build_header(pkt_dev_idx, pkt_id, pkt_size)
    return MAGIC ..
        pack_u32(pkt_dev_idx) ..
        pack_u32(pkt_id) ..
        pack_u32(pkt_size)
end

--------------------------------------------------
-- Connection
--------------------------------------------------

function OpenRGB.connect(host, port)
    local self = setmetatable({}, OpenRGB)

    self.host = host or "127.0.0.1"
    self.port = port or PORT

    self.sock = assert(socket.tcp())
    assert(self.sock:connect(self.host, self.port))

    self.protocol_version = 0

    return self
end

--------------------------------------------------
-- Packet send
--------------------------------------------------

function OpenRGB:send_packet(dev_idx, pkt_id, payload)
    payload = payload or ""

    local header = build_header(dev_idx, pkt_id, #payload)

    self.sock:send(header .. payload)
end

--------------------------------------------------
-- Receive header
--------------------------------------------------

function OpenRGB:recv_header()
    local data = self.sock:receive(16)
    if not data then return nil end

    local magic = data:sub(1,4)

    if magic ~= MAGIC then
        error("Invalid OpenRGB packet")
    end

    local pos = 5
    local dev; dev, pos = unpack_u32(data, pos)
    local pkt; pkt, pos = unpack_u32(data, pos)
    local size; size, pos = unpack_u32(data, pos)

    return {
        dev = dev,
        pkt = pkt,
        size = size
    }
end

--------------------------------------------------
-- Receive payload
--------------------------------------------------

function OpenRGB:recv_payload(size)
    if size == 0 then
        return ""
    end

    return self.sock:receive(size)
end

--------------------------------------------------
-- Protocol negotiation
--------------------------------------------------

function OpenRGB:negotiate_protocol(max_version)
    max_version = max_version or 5

    local payload = pack_u32(max_version)

    self:send_packet(0, PKT.REQUEST_PROTOCOL_VERSION, payload)

    self.sock:settimeout(1)

    local header = self:recv_header()

    if not header then
        self.protocol_version = 0
        return 0
    end

    local payload = self:recv_payload(header.size)

    local server_ver = unpack_u32(payload)

    self.protocol_version = math.min(server_ver, max_version)

    return self.protocol_version
end

--------------------------------------------------
-- Client name
--------------------------------------------------

function OpenRGB:set_client_name(name)
    local payload = name .. "\0"
    self:send_packet(0, PKT.SET_CLIENT_NAME, payload)
end

--------------------------------------------------
-- Controller count
--------------------------------------------------

function OpenRGB:get_controller_count()
    self:send_packet(0, PKT.REQUEST_CONTROLLER_COUNT, "")

    local header = self:recv_header()
    local payload = self:recv_payload(header.size)

    local count = unpack_u32(payload)

    return count
end

--------------------------------------------------
-- Controller data (raw)
--------------------------------------------------

function dump(o, depth)
    depth = depth or 0
    if type(o) == 'table' then
        local s = "\n" .. string.rep("\t", depth) .. '{\n'
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. string.rep("\t",(depth+1)) .. '['..k..'] = ' .. dump(v, depth + 1) .. ',\n'
        end
        return s .. string.rep("\t", depth) .. '}'
    elseif type(o) == "string" then
        return "\"" .. o .. "\""
    else
        return tostring(o)
    end
end

function ParseControllerData(data)
    local controller_data = {}
    local pos = 1
    controller_data.data_size, pos = unpack_u32(data, pos)
    controller_data.type, pos = unpack_i32(data, pos)
    controller_data.name_len, pos = unpack_u16(data, pos)
    controller_data.name, pos = unpack_string(data, pos, controller_data.name_len)
    controller_data.vendor_len, pos = unpack_u16(data, pos)
    controller_data.vendor, pos = unpack_string(data, pos, controller_data.vendor_len)
    controller_data.description_len, pos = unpack_u16(data, pos)
    controller_data.description, pos = unpack_string(data, pos, controller_data.description_len)
    controller_data.version_len, pos = unpack_u16(data, pos)
    controller_data.version, pos = unpack_string(data, pos, controller_data.version_len)
    controller_data.serial_len, pos = unpack_u16(data, pos)
    controller_data.serial, pos = unpack_string(data, pos, controller_data.serial_len)
    controller_data.location_len, pos = unpack_u16(data, pos)
    controller_data.location, pos = unpack_string(data, pos, controller_data.location_len)
    controller_data.num_modes, pos = unpack_u16(data, pos)
    controller_data.active_mode, pos = unpack_i32(data, pos)
    controller_data.modes, pos = unpack_Mode_Data(data, pos, controller_data.num_modes)
    controller_data.num_zones, pos = unpack_u16(data, pos)
    controller_data.zones, pos = unpack_Zone_Data(data, pos, controller_data.num_zones)
    controller_data.num_leds, pos = unpack_u16(data, pos)
    controller_data.leds, pos = unpack_LED_Data(data, pos, controller_data.num_leds)
    controller_data.num_colors, pos = unpack_u16(data, pos)
    controller_data.colors, pos = unpack_RGBColorN(data, pos, controller_data.num_colors)
    controller_data.num_led_alt_names, pos = unpack_u16(data, pos)
    controller_data.led_alt_names, pos = unpack_LED_Alt_Names(data, pos, controller_data.num_led_alt_names)
    controller_data.flags, pos = unpack_u32(data, pos)
    print(dump(controller_data))
    return controller_data
end

function OpenRGB:get_controller_data(idx)

    local payload = ""

    if self.protocol_version > 0 then
        payload = pack_u32(self.protocol_version)
    end

    self:send_packet(idx, PKT.REQUEST_CONTROLLER_DATA, payload)

    local header = self:recv_header()
    payload = self:recv_payload(header.size)

    local controller_data = ParseControllerData(payload)

    return controller_data
end

function OpenRGB:UpdateLEDs(pkt_dev_idx, led_color)
    local payload = ""
    local n = #led_color
    payload = payload .. pack_u32(4 + 2 + 4*n) -- data_size
    payload = payload .. pack_u16(n) -- num_colors
    payload = payload .. pack_RGBColorN(led_color) -- led_color

    self:send_packet(pkt_dev_idx, PKT.NET_PACKET_ID_RGBCONTROLLER_UPDATELEDS, payload)
end

return OpenRGB