button = {}

local buttons = {}
local count = 0
local TOUCH = hash("touch")
local current_button = {}

local function toggle_sprite(current_button)
    if current_button.status == 1 then
        current_button.status = 2
    else
        current_button.status = 1
    end
    gui.animate(current_button.back_node, "scale", 0.9, gui.EASING_OUTBACK, 0.1, 0, nil, gui.PLAYBACK_ONCE_PINGPONG)
    gui.animate(current_button.icon_node, "scale", 0.8, gui.EASING_OUTBACK, 0.1, 0, nil, gui.PLAYBACK_ONCE_PINGPONG)
    local anim_id = current_button.anims[current_button.status]
    gui.play_flipbook(current_button.icon_node, anim_id)
    current_button.second_callback(current_button.music_id, current_button.status)
end

local function initial_btn()
    gui.animate(current_button.back_node, "scale", 0.9, gui.EASING_OUTBACK, 0.1, 0, nil, gui.PLAYBACK_ONCE_PINGPONG)
    gui.animate(current_button.icon_node, "scale", 0.8, gui.EASING_OUTBACK, 0.1, 0, nil, gui.PLAYBACK_ONCE_PINGPONG)
    current_button.callback(current_button.music_id, current_button.status)
    if current_button.second_callback == nil then
        for i = 1, count do
            if current_button.template == buttons[i].template and current_button.name ~= buttons[i].name and buttons[i].status == 2 then
                toggle_sprite(buttons[i])
                buttons[i].initial = true
            end
        end
    end
    current_button.initial = false
end

function button:check(action_id, action)
    if action_id == TOUCH and action.pressed then
        for i = 1, count do
            if gui.pick_node(buttons[i].node, action.x, action.y) then
                current_button = buttons[i]

                if current_button.is_toggle and current_button.initial == false then
                    toggle_sprite(current_button)
                else
                    if current_button.is_toggle then
                        toggle_sprite(current_button)
                    end
                    initial_btn()
                end
            end
        end
    end
end

function button:add(_name, _template, _node, _icon, _back, _id, _callback, _second_callback, toggle)
    local temp_table = {}
    local node = gui.get_node(_template .. "/" .. _node)
    local icon_node = gui.get_node(_template .. "/" .. _icon)
    local anim_0 = nil
    local anim_1 = nil
    local is_toggle = false
    local back_node = gui.get_node(_template .. "/" .. _back)
    if toggle ~= nil then
        anim_0 = gui.get_flipbook(icon_node)
        is_toggle = true
        anim_1 = hash(toggle)
    end
    temp_table = {
        name = _name,
        template = _template,
        node = node,
        status = 1,
        initial = true,
        callback = _callback,
        second_callback = _second_callback,
        music_id = _id,
        is_toggle = is_toggle,
        icon_node = icon_node,
        back_node = back_node,
        anims = {anim_0, anim_1}
    }
    table.insert(buttons, temp_table)
    count = #buttons
end

return button
