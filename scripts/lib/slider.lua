slider = {}

local sliders = {}
local count = 0
local TOUCH = hash("touch")
local is_draging = false
local current_slider = {}
local slider_pos = 0

local function update(_x)
    slider_pos = ((current_slider.current_x + current_slider.drag_start_x) - _x) * -1

    if slider_pos > current_slider.width then
        slider_pos = current_slider.width
    elseif slider_pos < -current_slider.width then
        slider_pos = -current_slider.width
    end
    gui.set_position(current_slider.node, vmath.vector3(slider_pos, current_slider.position.y, current_slider.position.z))
    current_slider.position.x = slider_pos
    current_slider.value = 0.5 + (slider_pos / (current_slider.width * 2))
    current_slider.callback(current_slider.value)
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

-- name, node, width, value, callback
function slider:add(_name, _node, _width, _value, _callback)
    local temp_table = {}
    local node = gui.get_node(_node)
    local pos = gui.get_position(node)
    local a = _width * _value
    local b = a - (_width / 2)
    b = b * 2
    pos.x = b
    gui.set_position(node, vmath.vector3(pos.x, pos.y, pos.z))

    temp_table = {
        name = master_volume_slider,
        node = node,
        position = pos,
        width = _width,
        value = _value,
        drag_start_x = pos.x,
        current_x = -pos.x,
        callback = _callback
    }
    table.insert(sliders, temp_table)
    count = #sliders
end

return slider
