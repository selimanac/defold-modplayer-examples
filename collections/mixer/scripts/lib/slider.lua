slider = {}

slider.TYPE = {
    CENTER = 2,
    BALANCE = 1
}

local limits = {0.99, 0.5}

local sliders = {}
local count = 0
local TOUCH = hash("touch")
local is_draging = false
local current_slider = {}
local slider_pos = 0
local vec3 = vmath.vector3
local set_position = gui.set_position
local is_fading = false
local fading_sliders = {}

local fading_m1 = false
local fading_m2 = false

local function update(_x)
    slider_pos = ((current_slider.current_x + current_slider.drag_start_x) - _x) * -1

    if slider_pos > current_slider.width then
        slider_pos = current_slider.width
    elseif slider_pos < -current_slider.width then
        slider_pos = -current_slider.width
    end

    set_position(current_slider.node, vec3(slider_pos, current_slider.position.y, current_slider.position.z))
    current_slider.position.x = slider_pos
    current_slider.value = limits[current_slider.type] + (slider_pos / (current_slider.width * current_slider.type))
    current_slider.callback(current_slider.value, current_slider.music_id)
end

local function auto_update(_s, _x)
    if _s.value >= 0 and _s.value <= 1.0 then
        set_position(_s.node, vec3(_x, _s.position.y, _s.position.z))
        _s.position.x = _x
        _s.value = limits[_s.type] + (_x / (_s.width * _s.type))
        _s.current_x = -_x
        _s.callback(_s.value, _s.music_id)
        return true
    else
        return false
    end
end

local function release()
    is_draging = false
    current_slider.current_x = -current_slider.position.x
    current_slider = {}
end

function slider:check(action_id, action)
    if action_id == TOUCH and action.pressed then
        for i = 1, count do
            if gui.pick_node(sliders[i].node, action.x, action.y) then
                is_draging = true
                current_slider = sliders[i]
                current_slider.drag_start_x = action.x
            end
        end
    elseif action.released then
        if is_draging then
            release()
        end
    end

    if is_draging then
        update(action.x)
    end
end

local function get_sliders()
    for i = 1, count do
        if sliders[i].name == "music_volume_1" or sliders[i].name == "music_volume_2" then
            table.insert(fading_sliders, sliders[i])
        end
    end
    is_fading = true
end

function slider:crossfade()
    if is_fading == false then
        get_sliders()
    end
    if is_fading then
        for i = 1, #fading_sliders do
            if fading_sliders[i].name == "music_volume_1" then
                fading_m1 = auto_update(fading_sliders[i], fading_sliders[i].position.x - 1)
            else
                fading_m2 = auto_update(fading_sliders[i], fading_sliders[i].position.x + 1)
            end
        end

        if fading_m1 == false and fading_m2 == false then
            return false
        else
            return true
        end
    end
end

-- name, node, width, value, callback, type, music id
function slider:add(_name, _node, _width, _value, _callback, _type, _id)
    local temp_table = {}
    local node = gui.get_node(_node)
    local pos = gui.get_position(node)
    local a = _width * _value
    local b = a - (_width / _type)
    b = b * 2
    pos.x = b
    set_position(node, vmath.vector3(pos.x, pos.y, pos.z))

    temp_table = {
        name = _name,
        node = node,
        position = pos,
        width = _width,
        value = _value,
        drag_start_x = pos.x,
        current_x = -pos.x,
        callback = _callback,
        type = _type,
        music_id = _id
    }
    _callback(_value, _id)
    table.insert(sliders, temp_table)
    count = #sliders
end

return slider
