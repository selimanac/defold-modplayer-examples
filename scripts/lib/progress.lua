progress = {}

-- M1
local m1_elapsed_time = 0.0
local m1_total_time = 0.0
local m1_elapsed_time_txt = nil
local m1_total_time_txt = nil
local m1_progress_bar = nil
local m1_progress_bar_width = 0
local m1_progress_bar_total_size = 0

-- M2
local m2_elapsed_time = 0.0
local m2_total_time = 0.0
local m2_elapsed_time_txt = nil
local m2_total_time_txt = nil
local m2_progress_bar = nil
local m2_progress_bar_width = 1
local m2_progress_bar_total_size = 0
local vec3 = vmath.vector3
local set_size = gui.set_size
local set_txt = gui.set_text

local function round(x)
    return math.floor((x / 60) * 1000) / 1000
end

function progress:update(m1, m2)
    if player.is_music_playing(m1) then
        m1_elapsed_time = round(player.music_played(m1))
        set_txt(m1_elapsed_time_txt, m1_elapsed_time)
        m1_progress_bar_width = (m1_progress_bar_total_size.x * m1_elapsed_time) / m1_total_time
        set_size(m1_progress_bar, vec3(m1_progress_bar_width, m1_progress_bar_total_size.y, m1_progress_bar_total_size.z))
    end

    if player.is_music_playing(m2) then
        m2_elapsed_time = round(player.music_played(m2))
        set_txt(m2_elapsed_time_txt, m2_elapsed_time)
        m2_progress_bar_width = (m2_progress_bar_total_size.x * m2_elapsed_time) / m2_total_time
        set_size(m2_progress_bar, vec3(m2_progress_bar_width, m2_progress_bar_total_size.y, m2_progress_bar_total_size.z))
    end
end

function progress:init(m1, m2)
    -- Timers
    m1_elapsed_time_txt = gui.get_node("music_timer_1/time_elapsed")
    m1_total_time_txt = gui.get_node("music_timer_1/time_remaining")
    m1_progress_bar = gui.get_node("music_timer_1/time_bar")
    m1_progress_bar_total_size = gui.get_size(m1_progress_bar)

    m2_elapsed_time_txt = gui.get_node("music_timer_2/time_elapsed")
    m2_total_time_txt = gui.get_node("music_timer_2/time_remaining")
    m2_progress_bar = gui.get_node("music_timer_2/time_bar")
    m2_progress_bar_total_size = gui.get_size(m2_progress_bar)

    m1_total_time = round(player.music_lenght(m1))
    m2_total_time = round(player.music_lenght(m2))

    gui.set_text(m1_total_time_txt, m1_total_time)
    gui.set_text(m2_total_time_txt, m2_total_time)

    gui.set_size(m1_progress_bar, vmath.vector3(m1_progress_bar_width, m1_progress_bar_total_size.y, m1_progress_bar_total_size.z))
    gui.set_size(m2_progress_bar, vmath.vector3(m2_progress_bar_width, m2_progress_bar_total_size.y, m2_progress_bar_total_size.z))
end



return progress
