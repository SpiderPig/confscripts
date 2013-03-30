require 'cairo'
require 'imlib2'
require 'mouse'
--------------------------------------------------------------------------------
--                                                                  appearance
font="Droid Sans"
font_size=20
font_size_sm=9

xpos,ypos=0,20

color_txt1=0xadadad
color_txt2=0x7f757b
color_txt3=0x5f656b
color_txt_urgent=0x00ffff

color_graph1=0x63a5b3
color_graph2=0xadadad

color_alert=0xFF0000

font_slant=CAIRO_FONT_SLANT_NORMAL
font_face=CAIRO_FONT_WEIGHT_BOLD

icon_path=os.getenv('HOME').."/.icons/pannel/"

-- define the physical screen layout. 
screens = {
{
   width=0,
   head=1,            -- corresponds to the xwindow screen order
   xpos=2,            -- viewport position
   connected='yes',
},
{
   width=0,
   head=2,
   xpos=1,
   connected='yes',
}
}

-- save state of workspace and screen
desktops = {
{
   workspace=1,
   layout='temp',
   urgent=0,
},
{
   workspace=2,
   layout='temp',
   urgent=0,
}
}
vis=""

-- example mouse region will be dynamicaly filled from the gauge definitions
mregions = {
{
  x1=1280,                         y1=16,
  x2=1296,                         y2=32,
   onclick=function(x, y)
              os.execute("echo hi")
           end
}
}

--------------------------------------------------------------------------------
--                                                                    gauge DATA
gauge = {
cpu0 = {
    type="gauge",
    name='cpu',                    arg='cpu0',                  max_value=100,
    x=150,                         y=18,
    graph_radius=16,
    graph_thickness=2,
    graph_start_angle=0,
    graph_unit_angle=3.59,          graph_unit_thickness=0.9,
    graph_bg_colour=color_graph1,      graph_bg_alpha=0.3,
    graph_fg_colour=color_graph1,      graph_fg_alpha=1.0,
    hand_fg_colour=color_graph1,       hand_fg_alpha=1.0,
    txt_radius=0,
    txt_weight=1,                  txt_size=10.0,
    txt_fg_colour=color_graph1,        txt_fg_alpha=0,
    graduation_radius=0,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=color_graph1, graduation_fg_alpha=0.3,
    caption='',
    caption_weight=1,              caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.3,
},
cpu1 = {
    type="gauge",
    name='cpu',                    arg='cpu1',                  max_value=100,
    x=0,                           y=0,      relativeto='cpu0',
    graph_radius=13,
    graph_thickness=2,
    graph_start_angle=0,
    graph_unit_angle=3.59,          graph_unit_thickness=0.9,
    graph_bg_colour=color_graph1,      graph_bg_alpha=0.3,
    graph_fg_colour=color_graph1,      graph_fg_alpha=1.0,
    hand_fg_colour=color_graph1,       hand_fg_alpha=1.0,
    txt_radius=0,
    txt_weight=1,                  txt_size=10.0,
    txt_fg_colour=color_graph1,        txt_fg_alpha=0,
    graduation_radius=0,
    graduation_thickness=5,        graduation_mark_thickness=2,
    graduation_unit_angle=27,
    graduation_fg_colour=color_graph1, graduation_fg_alpha=0.3,
    caption='',
    caption_weight=1,              caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.3,
},
cpu2 = {
    type="gauge",
    name='cpu',                    arg='cpu2',                  max_value=100,
    x=0,                           y=0,      relativeto='cpu0',
    graph_radius=10,
    graph_thickness=2,
    graph_start_angle=0,
    graph_unit_angle=3.59,         graph_unit_thickness=0.9,
    graph_bg_colour=color_graph1,      graph_bg_alpha=0.3,
    graph_fg_colour=color_graph1,      graph_fg_alpha=1.0,
    hand_fg_colour=color_graph1,       hand_fg_alpha=1.0,
    txt_radius=0,
    txt_weight=1,                  txt_size=10.0,
    txt_fg_colour=color_graph1,        txt_fg_alpha=0,
    graduation_radius=0,
    graduation_thickness=5,        graduation_mark_thickness=2,
    graduation_unit_angle=27,
    graduation_fg_colour=color_graph1, graduation_fg_alpha=0.3,
    caption='',
    caption_weight=1,              caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.3,
},
cpu3 = {
    type="gauge",
    name='cpu',                    arg='cpu3',                  max_value=100,
    x=0,                           y=0,      relativeto='cpu0',
    graph_radius=7,
    graph_thickness=2,
    graph_start_angle=0,
    graph_unit_angle=3.59,          graph_unit_thickness=0.9,
    graph_bg_colour=color_graph1,      graph_bg_alpha=0.3,
    graph_fg_colour=color_graph1,      graph_fg_alpha=1.0,
    hand_fg_colour=color_graph1,       hand_fg_alpha=1.0,
    txt_radius=0,
    txt_weight=1,                  txt_size=10.0,
    txt_fg_colour=color_graph1,        txt_fg_alpha=0,
    graduation_radius=0,
    graduation_thickness=5,        graduation_mark_thickness=2,
    graduation_unit_angle=27,
    graduation_fg_colour=color_graph1, graduation_fg_alpha=0.3,
    caption='',
    caption_weight=1,              caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.3,
},
freq = {
    type="text",
    name='freq_g',                 arg='',
    x=20,                         y=-8,      relativeto='cpu0',
    prefix='',                     suffix='GHz',
    text_fg_colour=color_txt1,     text_fg_alpha=0.7,
    prefix_fg_colour=color_txt1,   prefix_fg_alpha=0.7,
    suffix_fg_colour=color_txt3,   suffix_fg_alpha=0.7,
    font=font,
    size=12,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},
load = {
    type="text",
    name='loadavg',                 arg='1',
    x=20,                          y=16,        relativeto='cpu0', 
    prefix='',                     suffix='',
    text_fg_colour=color_txt1,     text_fg_alpha=0.7,
    prefix_fg_colour=color_txt1,   prefix_fg_alpha=0.7,
    suffix_fg_colour=color_txt3,   suffix_fg_alpha=0.7,
    font=font,
    size=12,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},
memgauge = {
    type="gauge",
    name='memperc',                arg='',                      max_value=100,
    x=270,                         y=32,
    graph_radius=29,
    graph_thickness=3,
    graph_start_angle=-90,
    graph_unit_angle=1.55,          graph_unit_thickness=2,
    graph_bg_colour=color_graph1,      graph_bg_alpha=0.3,
    graph_fg_colour=color_graph1,      graph_fg_alpha=0.2,
    hand_fg_colour=color_graph1,       hand_fg_alpha=1.0,
    txt_radius=16,
    txt_weight=1,                  txt_size=10.0,
    txt_fg_colour=color_graph1,        txt_fg_alpha=0.8,
    graduation_radius=20,
    graduation_thickness=3,        graduation_mark_thickness=2,
    graduation_unit_angle=9,
    graduation_fg_colour=color_graph1, graduation_fg_alpha=0.3,
    caption='',
    caption_weight=1,              caption_size=10.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
mem = {
    type="text",
    name='mem',                 arg='',
    x=10,                         y=0,        relativeto='memgauge', 
    prefix='',                     suffix='',
    text_fg_colour=color_txt1,     text_fg_alpha=0.7,
    prefix_fg_colour=color_txt1,   prefix_fg_alpha=0.7,
    suffix_fg_colour=color_txt3,   suffix_fg_alpha=0.7,
    font=font,
    size=12,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},
swapgauge = {
    type="gauge",
    name='swapperc',               arg='',                      max_value=100,
    x=0,                         y=0,       relativeto='memgauge',
    graph_radius=24,
    graph_thickness=3,
    graph_start_angle=-90,
    graph_unit_angle=1.50,          graph_unit_thickness=2,
    graph_bg_colour=color_graph1,      graph_bg_alpha=0.3,
    graph_fg_colour=color_graph1,      graph_fg_alpha=0.2,
    hand_fg_colour=color_graph1,       hand_fg_alpha=1.0,
    txt_radius=16,
    txt_weight=1,                  txt_size=6.0,
    txt_fg_colour=color_graph1,        txt_fg_alpha=0.8,
    graduation_radius=20,
    graduation_thickness=3,        graduation_mark_thickness=2,
    graduation_unit_angle=9,
    graduation_fg_colour=color_graph1, graduation_fg_alpha=0,
    caption='',
    caption_weight=1,              caption_size=10.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
fsroot = {
    type="gauge",
    name='fs_used_perc',           arg='/',                     max_value=100,
    x=420,                         y=18,
    graph_radius=14,
    graph_thickness=4,
    graph_start_angle=270,
    graph_unit_angle=3.59,         graph_unit_thickness=4,
    graph_bg_colour=color_graph1,      graph_bg_alpha=0.3,
    graph_fg_colour=color_graph1,      graph_fg_alpha=0.2,
    hand_fg_colour=color_graph1,       hand_fg_alpha=0,
    txt_radius=12,
    txt_weight=1,                  txt_size=10.0,
    txt_fg_colour=color_graph1,        txt_fg_alpha=0.0,
    graduation_radius=46,
    graduation_thickness=0,        graduation_mark_thickness=0,
    graduation_unit_angle=20,
    graduation_fg_colour=color_graph1, graduation_fg_alpha=0,
    caption='/',
    caption_weight=1,              caption_size=14.0,
    caption_fg_colour=color_txt1,  caption_fg_alpha=0.7,
    caption_x=-9,                   caption_y=3,
    alert_high=70,
    alert_graph_fg_colour=color_alert,     alert_graph_bg_colour=color_alert,
},
fshome = {
    type="gauge",
    name='fs_used_perc',           arg='/home/',                max_value=100,
    x=460,                         y=18,
    graph_radius=14,
    graph_thickness=4,
    graph_start_angle=270,
    graph_unit_angle=3.59,         graph_unit_thickness=4,
    graph_bg_colour=color_graph1,      graph_bg_alpha=0.3,
    graph_fg_colour=color_graph1,      graph_fg_alpha=0.2,
    hand_fg_colour=color_graph1,       hand_fg_alpha=0,
    txt_radius=12,
    txt_weight=1,                  txt_size=10.0,
    txt_fg_colour=color_graph1,        txt_fg_alpha=0.0,
    graduation_radius=46,
    graduation_thickness=0,        graduation_mark_thickness=0,
    graduation_unit_angle=20,
    graduation_fg_colour=color_graph1, graduation_fg_alpha=0,
    caption='~',
    caption_weight=1,              caption_size=14.0,
    caption_fg_colour=color_txt1,  caption_fg_alpha=0.7,
    caption_x=-9,                   caption_y=3,
    alert_high=70,
    alert_graph_fg_colour=color_alert,     alert_graph_bg_colour=color_alert,
    hideeval='${if_mounted /home}show${else}hide${endif}',
},
host = {
    type="text",
    name='nodename_short',         arg='',
    x=0,                           y=20,
    prefix='',                     suffix='',
    text_fg_colour=color_txt1,     text_fg_alpha=0.7,
    prefix_fg_colour=color_txt1,   prefix_fg_alpha=1,
    suffix_fg_colour=color_txt1,   suffix_fg_alpha=1,
    font=font,
    size=font_size,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},
uptime = {
    type="text",
    name='uptime',                 arg='',
    x=20,                          y=30,
    prefix='',                     suffix='',
    text_fg_colour=color_txt3,     text_fg_alpha=0.7,
    prefix_fg_colour=color_txt1,   prefix_fg_alpha=1,
    suffix_fg_colour=color_txt1,   suffix_fg_alpha=1,
    font=font,
    size=font_size_sm,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},
host_s2 = {
    type="text",
    name='nodename_short',         arg='',
    x=0,                           y=20,       relativeto='screen2_l',
    prefix='',                     suffix='',
    text_fg_colour=color_txt1,     text_fg_alpha=0.7,
    prefix_fg_colour=color_txt1,   prefix_fg_alpha=1,
    suffix_fg_colour=color_txt1,   suffix_fg_alpha=1,
    font=font,
    size=font_size,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},
time = {
    type="text",
    name='time',        arg='%H:%M:%S',
    x=-10,                          y=22,   relativeto='abs_right',
    align_x='right',
--    x=conky_window.width-200,      y=24,
    prefix='',                     suffix='',
    text_fg_colour=color_txt1,     text_fg_alpha=0.7,
    prefix_fg_colour=color_txt1,   prefix_fg_alpha=1,
    suffix_fg_colour=color_txt3,   suffix_fg_alpha=1,
    font=font,
    size=16,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},
date = {
    type="text",
    name='time',        arg='%Y %m %d / %a',
    x=-4,                          y=33,   relativeto='abs_right',
    align_x='right',
--    x=conky_window.width-200,      y=24,
    prefix='',                     suffix='',
    text_fg_colour=color_txt1,     text_fg_alpha=0.7,
    prefix_fg_colour=color_txt1,   prefix_fg_alpha=1,
    suffix_fg_colour=color_txt3,   suffix_fg_alpha=1,
    font=font,
    size=10,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},
time2 = {
    type="text",
    name='time',        arg='%H:%M:%S',
    x=-10,                          y=22,   relativeto='abs_scr2',
    align_x='right',
    hideeval='${if_match "${battery_short}" != "U"}show${else}hide${endif}', 
--    x=conky_window.width-200,      y=24,
    prefix='',                     suffix='',
    text_fg_colour=color_txt1,     text_fg_alpha=0.7,
    prefix_fg_colour=color_txt1,   prefix_fg_alpha=1,
    suffix_fg_colour=color_txt3,   suffix_fg_alpha=1,
    font=font,
    size=16,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},
date2 = {
    type="text",
    name='time',        arg='%Y %m %d / %a',
    x=-4,                          y=33,   relativeto='abs_scr2',
    align_x='right',
    hideeval='${if_match "${battery_short}" != "U"}show${else}hide${endif}', 
--    x=conky_window.width-200,      y=24,
    prefix='',                     suffix='',
    text_fg_colour=color_txt1,     text_fg_alpha=0.7,
    prefix_fg_colour=color_txt1,   prefix_fg_alpha=1,
    suffix_fg_colour=color_txt3,   suffix_fg_alpha=1,
    font=font,
    size=10,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},

--{
--    type="text",
----    name='acpitemp',                 arg='',
--    cmd="(sensors || echo \'CPU Temperature:+0.0\')|grep \'CPU Temperature\'|perl -pe \'s/.*:\\s*\[+-\](\[0-9\]*).*/\\1/\'",
--    rate=4,
--    x=790,                         y=12,
--    prefix='cpu ',                     suffix='°c',
--    text_fg_colour=color_txt1,     text_fg_alpha=0.7,
--    prefix_fg_colour=color_txt3,   prefix_fg_alpha=0.7,
--    suffix_fg_colour=color_txt1,   suffix_fg_alpha=0.7,
--    font=font,
--    size=12,
--    slant=CAIRO_FONT_SLANT_NORMAL,
--    face=CAIRO_FONT_WEIGHT_BOLD,
--},
-- {
--     type="text",
-- --    name='',                 arg='',
--     cmd="env -u DISPLAY hddtemp -q /dev/sd?|perl -pe \'s/.*not available//; s/.*:.*:\\s+(\\d+).*/\\1/;  if ($_ > $g){$g = $_;} $_=$g;\'|tail -1",
--     rate=5,
--     x=720,                         y=12,
--     prefix='hdd ',                     suffix='°c',
--     text_fg_colour=color_txt1,     text_fg_alpha=0.7,
--     prefix_fg_colour=color_txt3,   prefix_fg_alpha=0.7,
--     suffix_fg_colour=color_txt1,   suffix_fg_alpha=0.7,
--     font=font,
--     size=12,
--     slant=CAIRO_FONT_SLANT_NORMAL,
--     face=CAIRO_FONT_WEIGHT_BOLD,
-- },
--{
--    type="text",
----    name='nvidia temp',                 arg='',
--    cmd="nvidia-settings -q gpucoretemp | (grep 'Attribute' || echo \'0 0 0 0\')| awk '{print $4}' | tr -d \'.\'",
--    rate=7,
--    x=860,                         y=12,
--    prefix='gpu ',                     suffix='°c',
--    text_fg_colour=color_txt1,     text_fg_alpha=0.7,
--    prefix_fg_colour=color_txt3,   prefix_fg_alpha=0.7,
--    suffix_fg_colour=color_txt1,   suffix_fg_alpha=0.7,
--    font=font,
--    size=12,
--    slant=CAIRO_FONT_SLANT_NORMAL,
--    face=CAIRO_FONT_WEIGHT_BOLD,
--},
tempcpu = {
    type="gauge",
    arg='',                      max_value=100,
    cmd="(sensors 2>&1|| echo \'CPU Temperature:+0.0\')|grep \'CPU Temperature\'|perl -pe \'s/.*:\\s*\[+-\](\[0-9\]*).*/\\1/\'",
    hideonvalue=0,
    x=700,                         y=32,
--    x=48,                         y=0,    relativeto='temphdd',
    graph_radius=24,
    graph_thickness=5,
    graph_start_angle=-90,
    graph_unit_angle=.9,               graph_unit_thickness=2,
    graph_bg_colour=color_graph1,      graph_bg_alpha=0.3,
    graph_fg_colour=color_graph1,      graph_fg_alpha=0.2,
    hand_fg_colour=color_graph1,       hand_fg_alpha=1.0,
    txt_radius=34,
    txt_weight=1,                      txt_size=10,
    txt_fg_colour=color_graph1,        txt_fg_alpha=0.8,
    graduation_radius=20,
    graduation_thickness=3,        graduation_mark_thickness=2,
    graduation_unit_angle=9,
    graduation_fg_colour=color_graph1, graduation_fg_alpha=0,
    caption='cpu',
    caption_weight=1,              caption_size=10.0,
    caption_fg_colour=color_txt1,    caption_fg_alpha=0.5,
    caption_x=12,                   caption_y=-3,
    alert_high=60,
    alert_graph_fg_colour=color_alert,     alert_graph_bg_colour=color_alert,
},
temphdd = {
    type="gauge",
    arg='',                      max_value=70,
    cmd="env -u DISPLAY hddtemp -q /dev/sd?|perl -pe \'s/.*not available//; s/.*:.*:\\s+(\\d+).*/\\1/;  if ($_ > $g){$g = $_;} $_=$g;\'|tail -1",
    hideonvalue=0,
    x=740,                         y=32,
    graph_radius=24,
    graph_thickness=5,
    graph_start_angle=-90,
    graph_unit_angle=1.3,               graph_unit_thickness=2,
    graph_bg_colour=color_graph1,      graph_bg_alpha=0.3,
    graph_fg_colour=color_graph1,      graph_fg_alpha=0.2,
    hand_fg_colour=color_graph1,       hand_fg_alpha=1.0,
    txt_radius=34,
    txt_weight=1,                      txt_size=10,
    txt_fg_colour=color_graph1,        txt_fg_alpha=0.8,
    graduation_radius=20,
    graduation_thickness=3,        graduation_mark_thickness=2,
    graduation_unit_angle=9,
    graduation_fg_colour=color_graph1, graduation_fg_alpha=0,
    caption='hdd',
    caption_weight=1,                caption_size=10.0,
    caption_fg_colour=color_txt1,    caption_fg_alpha=0.5,
    caption_x=12,                   caption_y=-3,
    alert_high=40,
    alert_graph_fg_colour=color_alert,     alert_graph_bg_colour=color_alert,
},
tempgpu = {
    type="gauge",
    arg='',                      max_value=100,
    cmd="nvidia-settings -q gpucoretemp 2>&1| (grep 'Attribute' || echo \'0 0 0 0\')| awk '{print $4}' | tr -d \'.\'",
    hideonvalue=0,
    x=780,                         y=32,
    graph_radius=24,
    graph_thickness=5,
    graph_start_angle=-90,
    graph_unit_angle=.9,               graph_unit_thickness=2,
    graph_bg_colour=color_graph1,      graph_bg_alpha=0.3,
    graph_fg_colour=color_graph1,      graph_fg_alpha=0.2,
    hand_fg_colour=color_graph1,       hand_fg_alpha=1.0,
    txt_radius=34,
    txt_weight=1,                      txt_size=10,
    txt_fg_colour=color_graph1,        txt_fg_alpha=0.8,
    graduation_radius=20,
    graduation_thickness=3,        graduation_mark_thickness=2,
    graduation_unit_angle=9,
    graduation_fg_colour=color_graph1, graduation_fg_alpha=0,
    caption='gpu',
    caption_weight=1,                caption_size=10.0,
    caption_fg_colour=color_txt1,    caption_fg_alpha=0.5,
    caption_x=12,                   caption_y=-3,
    alert_high=60,
    alert_graph_fg_colour=color_alert,     alert_graph_bg_colour=color_alert,
},
mixer = {
    type="gauge",
    id='mixer',
 --   name='mixer',           arg='',
    cmd='amixer get Master|perl -pe \'s/.*: Playback \\d+ \\\[(\\d+)%\\\].*/\\1/; if ($_ > $g){$g = $_;} $_=$g;\'|tail -1',
    max_value=100,
    x=1200,                         y=18,
    graph_radius=14,
    graph_thickness=4,
    graph_start_angle=0,
    graph_unit_angle=3.59,         graph_unit_thickness=4,
    graph_bg_colour=color_graph1,      graph_bg_alpha=0.3,
    graph_fg_colour=color_graph1,      graph_fg_alpha=0.3,
    hand_fg_colour=color_graph1,       hand_fg_alpha=0,
    txt_radius=12,
    txt_weight=1,                  txt_size=10.0,
    txt_fg_colour=color_graph1,        txt_fg_alpha=0.0,
    graduation_radius=10,
    graduation_thickness=4,        graduation_mark_thickness=3,
    graduation_unit_angle=30,
    graduation_fg_colour=color_graph1, graduation_fg_alpha=0.7,
    caption='',
    caption_weight=1,              caption_size=9.0,
    caption_fg_colour=color_txt1,  caption_fg_alpha=0.7,
    hideonvalue=-1,
    tick = function(data)
              local file = io.popen("amixer get Master|perl -pe \'s/.* \\\[(o\[nf\]f?)\]/\\1/\'|tail -1")
              local mute= file:read("*a")
              file:close()
              if mute == "off\n" then
                 data.graph_bg_colour=color_txt3
                 data.graph_fg_colour=color_txt3
                 data.graduation_fg_colour=color_txt3
              else
                 data.graph_bg_colour=color_graph1
                 data.graph_fg_colour=color_graph1
                 data.graduation_fg_colour=color_graph1
              end
           end,
    onclick = function(data, x, y)
                 local dist = math.sqrt((x - data.drawn_x)^2.0 + (y - data.drawn_y)^2.0)
--                 print ((x - data.drawn_x), (y - data.drawn_y))
                 if dist < 5.0 then
                    os.execute("((amixer sset Master toggle)&)")
                 else
                    local at = math.atan2 ((y - data.drawn_y), (x - data.drawn_x))
                    if at < 0 then at = at + math.pi * 2 end
                    local ang = position_to_angle(data['graph_start_angle'], at)
                    if ang < 9 or ang > 351 then ang = 360 end
                    local val = ang / data['graph_unit_angle']
--                    print (val)
                    os.execute("((amixer sset Master "..val.."%)&)")
                 end
              end,
    extent_x=15,                    extent_y=15,
},
workspace1 = {
    type="text",                   arg='',
    x=-200,                        y=24,    relativeto='abs_scr2',
    value='',
    prefix='',                     suffix='',
    text_fg_colour=color_txt1,     text_fg_alpha=0.7,
    prefix_fg_colour=color_txt1,   prefix_fg_alpha=0.7,
    suffix_fg_colour=color_txt3,   suffix_fg_alpha=0.7,
    font=font,
    size=16,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},
layout1 = {
    type="text",                   arg='',
    x=-6,                          y=-8,      relativeto='workspace1',
    align_x='right',
    value='',
    prefix='',                     suffix='',
    text_fg_colour=color_txt3,     text_fg_alpha=0.7,
    prefix_fg_colour=color_txt3,   prefix_fg_alpha=0.7,
    suffix_fg_colour=color_txt3,   suffix_fg_alpha=0.7,
    font=font,
    size=10,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},
workspacevis = {
    type="text",                   arg='',
    x=-6,                          y=8,       relativeto='workspace1', 
    align_x='right',
    hideeval='hide',
    value='',
    prefix='',                     suffix='',
    text_fg_colour=color_txt3,     text_fg_alpha=0.7,
    prefix_fg_colour=color_txt3,   prefix_fg_alpha=0.7,
    suffix_fg_colour=color_txt3,   suffix_fg_alpha=0.7,
    font=font,
    size=12,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},
workspace2 = {
    type="text",                   arg='',
    x=140,                         y=24,       relativeto='abs_scr2',
    value='',
    prefix='',                     suffix='',
    text_fg_colour=color_txt1,     text_fg_alpha=0.7,
    prefix_fg_colour=color_txt1,   prefix_fg_alpha=0.7,
    suffix_fg_colour=color_txt3,   suffix_fg_alpha=0.7,
    font=font,
    size=16,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},
layout2 = {
    type="text",                   arg='',
    x=20,                          y=-8,      relativeto='workspace2',
    value='',
    prefix='',                     suffix='',
    text_fg_colour=color_txt3,     text_fg_alpha=0.7,
    prefix_fg_colour=color_txt3,   prefix_fg_alpha=0.7,
    suffix_fg_colour=color_txt3,   suffix_fg_alpha=0.7,
    font=font,
    size=10,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},

wifi = {
    type="gauge",
    arg='',                      max_value=100,
    rate=4,
    x=1080,                         y=32,
    graph_radius=22,
    graph_thickness=8,
    graph_start_angle=-90,
    graph_unit_angle=1.2,               graph_unit_thickness=2,
    graph_bg_colour=color_graph1,      graph_bg_alpha=0.3,
    graph_fg_colour=color_graph1,      graph_fg_alpha=0.2,
    hand_fg_colour=color_graph1,       hand_fg_alpha=0.0,
    txt_radius=34,
    txt_weight=1,                      txt_size=10,
    txt_fg_colour=color_graph1,        txt_fg_alpha=0.8,
    graduation_radius=20,
    graduation_thickness=3,        graduation_mark_thickness=2,
    graduation_unit_angle=9,
    graduation_fg_colour=color_graph1, graduation_fg_alpha=0,
    caption='wifi',
    caption_weight=1,                caption_size=10.0,
    caption_fg_colour=color_txt1,    caption_fg_alpha=0.5,
    caption_x=20,                   caption_y=-3,
    alert_low=10,
    alert_graph_fg_colour=color_alert,     alert_graph_bg_colour=color_alert,
    tick = function(data)
              -- set wifi values and dynamic visuals
              local file = io.popen("iwconfig wlan0 2>/dev/null|tr -d \'\\n\'|perl -pe \'s/(\\S*).*ESSID:\"?(\[^\" ]*)\"?.*Access Point: (\\S*).*Tx-Power=(\\S*)(.*Link Quality=(\\d+\\/\\d+))?.*/\\1|\\2|\\3|\\4|\\6\\|n/\'")
              local wifi= file:read("*a")
              file:close()
              --        print ("wifi: "..wifi)
              start, finish, Niface = string.find (wifi, "([^|]*)")
              start, finish, Nessid = string.find (wifi, "|([^|]*)|", finish)
              start, finish, Nap    = string.find (wifi, "|([^|]*)", finish)
              start, finish, Npow   = string.find (wifi, "|([^|]*)", finish)
              start, finish, NlinkNum  = string.find (wifi, "|(%d*)", finish)
              start, finish, NlinkDen  = string.find (wifi, "/(.*)|", finish)
              if NlinkNum ~= nil and NlinkDen ~= nil then
                 Nlink = 100 * tonumber(NlinkNum) / tonumber(NlinkDen)
              else
                 Nlink = 0
              end
              --        print ("wifi "..Niface.."/"..Nessid.."/"..Nap.."/"..Npow.."/"..Nlink)

              data.hideeval         = nil
              if Niface == nil or string.len(Niface) < 1 then
                 data.hideeval         = 'hide'
              elseif Npow == 'off' then
                 data.caption          = Niface
                 data.caption_fg_colour= color_txt3
                 data.graph_fg_colour  = color_graph2
                 data.graph_bg_colour  = color_graph2
                 data.alert_low        = nil
              elseif Nap == 'Not-Associated' then
                 data.caption          = Nessid
                 data.caption_fg_colour= color_txt1
                 data.graph_fg_colour  = color_graph2
                 data.graph_bg_colour  = color_graph2
                 data.alert_low        = nil
              else
                 data.caption          = Nessid
                 data.caption_fg_colour= color_txt1
                 data.graph_fg_colour  = color_graph1
                 data.graph_bg_colour  = color_graph1
                 data.alert_low        = 10
              end
              data.txt_fg_colour    = data.graph_fg_colour
              data.value            = Nlink
           end,
    onclick = function(data, x, y)
                 print (x,y)
                 os.execute("((wifi-radar)&)")
              end,
    extent_x=22, extent_y=22,
},

-- {
--    type="text",
--    name='memmax}-${memeasyfree',        arg='',
--    x=2940,                         y=16,
--    prefix='Mef',                  suffix='',
--    text_fg_colour=color_txt1,     text_fg_alpha=1,
--    prefix_fg_colour=color_txt1,   prefix_fg_alpha=1,
--    suffix_fg_colour=color_txt3,   suffix_fg_alpha=1,
--    font=font,
--    size=12,
--    slant=CAIRO_FONT_SLANT_NORMAL,
--    face=CAIRO_FONT_WEIGHT_BOLD,
-- },


bat = {
    type="gauge",
    name='battery_percent',        arg='',  max_value=100,
    rate=1,
    x=1000,                        y=18,
--    hideeval='${if_match "${battery_short}" == "U"}hide${else}show${endif}', 
    hideonvalue=0,
    graph_radius=12,
    graph_thickness=8,
    graph_start_angle=0,
    graph_unit_angle=3.599,            graph_unit_thickness=2,
    graph_bg_colour=color_graph1,      graph_bg_alpha=0.3,
    graph_fg_colour=color_graph1,      graph_fg_alpha=0.2,
    hand_fg_colour=color_graph1,       hand_fg_alpha=0.0,
    txt_radius=34,
    txt_weight=1,                      txt_size=10,
    txt_fg_colour=color_graph1,        txt_fg_alpha=0.8,
    graduation_radius=20,
    graduation_thickness=3,        graduation_mark_thickness=2,
    graduation_unit_angle=9,
    graduation_fg_colour=color_graph1, graduation_fg_alpha=0,
    caption='',
    caption_weight=1,                caption_size=10.0,
    caption_fg_colour=color_txt1,    caption_fg_alpha=0.5,
    caption_x=20,                   caption_y=-3,
    alert_low=20,
    alert_graph_fg_colour=color_alert,     alert_graph_bg_colour=color_alert,
    tick = function(data)
              local str = conky_parse('${battery_short}')
              if str == 'U' then data.hide = 'hide' end
           end
},
ac = {
    type="text",
    name='if_match \"${acpiacadapter}\" == \"on-line\"}AC${else}Bt${endif',          arg='',
    value='AC',
    x=-6,                           y=5,        relativeto='bat',
    hideeval='${if_match "${acpiacadapter}" == "on-line"}show${else}hide${endif}', 
--    hideeval='${if_match \"${battery_short}\" == \"U\"}hide${else}show${endif}', 
    prefix='',                     suffix='',
    text_fg_colour=color_txt1,     text_fg_alpha=  0.7,
    prefix_fg_colour=color_txt1,   prefix_fg_alpha=0.7,
    suffix_fg_colour=color_txt3,   suffix_fg_alpha=0.7,
    font=font,
    size=10,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},
btime = {
    type="text",
    name='battery_time',           arg='',
    hideeval='${if_match "${acpiacadapter}" == "on-line"}hide${else}show${endif}', 
    x=-80,                         y=-8,        relativeto='bat',
    prefix='',                     suffix='',
    text_fg_colour=color_txt1,     text_fg_alpha  = 0.7,
    prefix_fg_colour=color_txt1,   prefix_fg_alpha= 0.7,
    suffix_fg_colour=color_txt3,   suffix_fg_alpha= 0.7,
    font=font,
    size=10,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},





{
    type="text",
    name='tcp_portmon',        arg='22 23 count',
    hideeval='${if_match ${tcp_portmon 22 23 count} < 1}hide${else}show${endif}', 
    x=620,                        y=32,         relativeto='screen2_l',
    prefix='SSH:',                 suffix='',
    text_fg_colour=color_txt1,     text_fg_alpha = 0.7,
    prefix_fg_colour=color_txt1,   prefix_fg_alpha=0.7,
    suffix_fg_colour=color_txt3,   suffix_fg_alpha=0.7,
    font=font,
    size=12,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},
--{
--    type="text",
--    name='tcp_portmon',        arg='22 23 rhost 0',
--    x=2540,                        y=16,
--    prefix='PRIV:',                 suffix='',
--    text_fg_colour=color_txt1,     text_fg_alpha=1,
--    prefix_fg_colour=color_txt1,   prefix_fg_alpha=1,
--    suffix_fg_colour=color_txt3,   suffix_fg_alpha=1,
--    font=font,
--    size=12,
--    slant=CAIRO_FONT_SLANT_NORMAL,
--    face=CAIRO_FONT_WEIGHT_BOLD,
--},
-- {
--      type="text",
--      name='acpiacadapter',           arg='',
--      hideeval='${if_match "${battery_short}" == "U"}hide${else}show${endif}', 
--  --    hideeval='${if_match "${acpiacadapter}" == "on-line"}hide${else}show${endif}', 
--      x=-80,                         y=0,        relativeto='bat',
--      prefix='|',                     suffix='|',
--      text_fg_colour=color_txt1,     text_fg_alpha  = 0.7,
--      prefix_fg_colour=color_txt1,   prefix_fg_alpha= 0.7,
--      suffix_fg_colour=color_txt3,   suffix_fg_alpha= 0.7,
--      font=font,
--      size=10,
--      slant=CAIRO_FONT_SLANT_NORMAL,
--      face=CAIRO_FONT_WEIGHT_BOLD,
--  },

{
    type="image",
--    name='',           arg='',
    value=icon_path..'clock.xpm',
    hideeval='${if_match "${exec if [[ $(atq|wc -l) -gt 0 ]]; then echo -n yes; else echo -n no; fi}" == "no"}hide${else}show${endif}', 
    rate=5,
    x=1260,                         y=16, --        relativeto='bat',
 --   w=16,                           h=16,
},
snort = {
    type="image",     -- touch -r /var/log/snort/alert ~/tmp/snorttime
--    name='',           arg='',
    value=icon_path..'bug.xpm',
    hideeval='${if_match "${exec if [ ~/tmp/snorttime -ot /var/log/snort/alert ]; then echo -n yes; else echo -n no; fi}" == "no"}hide${else}show${endif}', 
    rate=5,
    x=1280,                         y=16,
    onclick = function(data, x, y)
                 os.execute("((touch -r /var/log/snort/alert ~/tmp/snorttime)&)")
              end
},
{
    type="image",
--    name='',           arg='',
    value=icon_path..'attention.xpm',
    hideeval='${if_match "${exec rc-status -c >/dev/null 2>&1; if [[ $? -eq 0 ]]; then echo -n yes; else echo -n no; fi}" == "no"}hide${else}show${endif}', 
    rate=5,
    x=1300,                         y=16, --        relativeto='bat',
 --   w=16,                           h=16,
},
{
    type="image",
--    name='',           arg='',
    value=icon_path..'mail.xpm',
    hideeval='${if_match "${exec checkgmail >/dev/null; if [[ $? -eq 0 ]]; then echo -n yes; else echo -n no; fi}" == "no"}hide${else}show${endif}', 
    rate=600,
    x=1320,                         y=16, --        relativeto='bat',
 --   w=16,                           h=16,
    onclick = function(data, x, y)
                 os.execute("((firefox \'https://mail.google.com/mail/?tab=wm#inbox\')&)")
              end
},
iptssh = {
    type="image",
--    name='',           arg='',
    value=icon_path..'shield.png',
-- perl -pe 's/src=([0-9.]*).*last_seen: (\d*).*oldest_pkt: (\d*).*/\1/; if($3 < 4){$_="";}' /proc/net/xt_recent/SSH |wc -l
    hideeval='${if_match ${exec perl -pe \'s/src=(\[0-9.\]*).*last_seen: (\\d*).*oldest_pkt: (\\d*).*/\\1/; if($3 < 4){$_=\"\";}\' /proc/net/xt_recent/SSH 2>/dev/null |wc -l} > 0}show${else}hide${endif}', 
    rate=5,
    x=1340,                         y=16, --        relativeto='bat',
    w=16,                           h=16,
},
{
    type="text",                   arg='',
    x=0,                           y=-1,       relativeto='iptssh', 
    value='XX',
-- perl -pe 's/src=([0-9.]*).*last_seen: (\d*).*oldest_pkt: (\d*).*/\1/; if($3 < 4){$_="";} else {$_=`geoiplookup $_`;  if(! s/.*Country Edition: (.*),.*/\1\n/s ){$_="";}} ' /proc/net/xt_recent/SSH
    cmd='perl -pe \'s/src=(\[0-9.\]*).*last_seen: (\\d*).*oldest_pkt: (\\d*).*/\\1/; if($3 < 4){$_=\"\";} else {$_=`geoiplookup $_`;  if(! s/.*Country Edition: (.*),.*/\\1\\n/s ){$_=\"\";}} \' /proc/net/xt_recent/SSH 2>/dev/null',
    rate=5,
    prefix='',                     suffix='',
    text_fg_colour=color_txt1,     text_fg_alpha=0.7,
    prefix_fg_colour=color_txt1,   prefix_fg_alpha=0.7,
    suffix_fg_colour=color_txt1,   suffix_fg_alpha=0.7,
    font=font,
    size=12,
    slant=CAIRO_FONT_SLANT_NORMAL,
    face=CAIRO_FONT_WEIGHT_BOLD,
},

-- {
--     type="text",
--     value='DISKS',
--     x=400,                           y=32,
--     prefix='',                     suffix='',
--     text_fg_colour=color_txt1,     text_fg_alpha=  0.7,
--     prefix_fg_colour=color_txt1,   prefix_fg_alpha=0.7,
--     suffix_fg_colour=color_txt3,   suffix_fg_alpha=0.7,
--     font=font,
--     size=10,
--     slant=CAIRO_FONT_SLANT_NORMAL,
--     face=CAIRO_FONT_WEIGHT_BOLD,
--     orient=-90,
-- },
}

-------------------------------------------------------------------------------
--                                                                 rgb_to_r_g_b
-- converts color in hexa to decimal
--
function rgb_to_r_g_b(colour, alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

-------------------------------------------------------------------------------
--                                                            angle_to_position
-- convert degree to rad and rotate (0 degree is top/north)
--
function angle_to_position(start_angle, current_angle)
    local pos = current_angle + start_angle
    return ( ( pos * (math.pi / 180) ) - (math.pi / 2) )
end

function position_to_angle(start_angle, position)
   local pos = (position + (math.pi / 2)) * (180 / math.pi)
   return (pos - start_angle) % 360
end


function compute_relative(data)
    local x, y = data['x'], data['y']
    local relativeto = 'screen1_l'

    if data['relativeto'] ~= nil then
       relativeto = data['relativeto']
    end

    if gauge[relativeto].drawn_x ~= nil then
       x = x + gauge[relativeto].drawn_x;
       y = y + gauge[relativeto].drawn_y;
    elseif relativeto ~= 'screen1_l' and
           relativeto ~= 'screen1_r' and
           relativeto ~= 'screen2_l' and
           relativeto ~= 'screen2_r' and
           relativeto ~= 'abs_left'  and
           relativeto ~= 'abs_right' and
           relativeto ~= 'abs_scr2'  then
       rx, ry = compute_relative(gauge[relativeto])
       x = x + rx
       y = y + ry
    else
       x = x + gauge[relativeto].x
       y = y + gauge[relativeto].y
    end

    data.drawn_x, data.drawn_y = x, y
    return x, y
end

-------------------------------------------------------------------------------
--                                                              draw_gauge_ring
-- displays gauges
--
function draw_gauge_ring(display, data, value)
    local max_value = data['max_value']
    local x, y = compute_relative(data)

    local graph_radius = data['graph_radius']
    local graph_thickness, graph_unit_thickness = data['graph_thickness'], data['graph_unit_thickness']
    local graph_start_angle = data['graph_start_angle']
    local graph_unit_angle = data['graph_unit_angle']
    local graph_bg_colour, graph_bg_alpha = data['graph_bg_colour'], data['graph_bg_alpha']
    local graph_fg_colour, graph_fg_alpha = data['graph_fg_colour'], data['graph_fg_alpha']
    local hand_fg_colour, hand_fg_alpha = data['hand_fg_colour'], data['hand_fg_alpha']
    if (data['alert_high'] ~= nil and value >= data['alert_high']) or (data['alert_low'] ~= nil and value <= data['alert_low']) then
       if data['alert_graph_fg_colour'] ~= nil then graph_fg_colour = data['alert_graph_fg_colour'] end
       if data['alert_graph_bg_colour'] ~= nil then graph_bg_colour = data['alert_graph_bg_colour'] end
    end
    local graph_end_angle = (max_value * graph_unit_angle) % 360

    -- background ring
    cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, 0), angle_to_position(graph_start_angle, graph_end_angle))
    cairo_set_source_rgba(display, rgb_to_r_g_b(graph_bg_colour, graph_bg_alpha))
    cairo_set_line_width(display, graph_thickness)

--    if only this were true
--    extents=cairo_extents_t:create()
--    cairo_stroke_extents(display, extents)
--    data['extent_x1'], data['extent_y1'] = extents.x1, extents.y1
--    data['extent_x2'], data['extent_y2'] = extents.x2, extents.y2
    cairo_stroke(display)
    
--    data['extent_x'] = math.abs(math.cos(angle_to_position(graph_start_angle, 0)) * graph_radius -
--                        math.cos(angle_to_position(graph_start_angle, graph_end_angle)) * graph_radius)
--    data['extent_y'] = math.abs(math.sin(angle_to_position(graph_start_angle, 0)) * graph_radius -
--                        math.sin(angle_to_position(graph_start_angle, graph_end_angle)) * graph_radius)

    -- arc of value
    local val = value % (max_value + 1)
    local start_arc = 0
    local stop_arc = 0
    local i = 1
    while i <= val do
        start_arc = (graph_unit_angle * i) - graph_unit_thickness
        stop_arc = (graph_unit_angle * i)
        cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
        cairo_set_source_rgba(display, rgb_to_r_g_b(graph_fg_colour, graph_fg_alpha))
        cairo_stroke(display)
        i = i + 1
    end
    local angle = start_arc

    -- hand
    start_arc = (graph_unit_angle * val) - (graph_unit_thickness * 2)
    stop_arc = (graph_unit_angle * val)
    cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
    cairo_set_source_rgba(display, rgb_to_r_g_b(hand_fg_colour, hand_fg_alpha))
    cairo_stroke(display)

    -- graduations marks
    local graduation_radius = data['graduation_radius']
    local graduation_thickness, graduation_mark_thickness = data['graduation_thickness'], data['graduation_mark_thickness']
    local graduation_unit_angle = data['graduation_unit_angle']
    local graduation_fg_colour, graduation_fg_alpha = data['graduation_fg_colour'], data['graduation_fg_alpha']
    if graduation_radius > 0 and graduation_thickness > 0 and graduation_unit_angle > 0 then
        local nb_graduation = graph_end_angle / graduation_unit_angle
        local i = 0
        while i < nb_graduation do
            cairo_set_line_width(display, graduation_thickness)
            start_arc = (graduation_unit_angle * i) - (graduation_mark_thickness / 2)
            stop_arc = (graduation_unit_angle * i) + (graduation_mark_thickness / 2)
            cairo_arc(display, x, y, graduation_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
            cairo_set_source_rgba(display,rgb_to_r_g_b(graduation_fg_colour,graduation_fg_alpha))
            cairo_stroke(display)
            cairo_set_line_width(display, graph_thickness)
            i = i + 1
        end
    end

    -- text
    local txt_radius = data['txt_radius']
    local txt_weight, txt_size = data['txt_weight'], data['txt_size']
    local txt_fg_colour, txt_fg_alpha = data['txt_fg_colour'], data['txt_fg_alpha']
    local movex = txt_radius * math.cos(angle_to_position(graph_start_angle, angle))
    local movey = txt_radius * math.sin(angle_to_position(graph_start_angle, angle))
    cairo_select_font_face (display, font, CAIRO_FONT_SLANT_NORMAL, txt_weight)
    cairo_set_font_size (display, txt_size)
    cairo_set_source_rgba (display, rgb_to_r_g_b(txt_fg_colour, txt_fg_alpha))
    cairo_move_to (display, x + movex - (txt_size / 2), y + movey + 3)
    cairo_show_text (display, value)
    cairo_stroke (display)

    -- caption
    local caption = data['caption']
    local caption_weight, caption_size = data['caption_weight'], data['caption_size']
    local caption_fg_colour, caption_fg_alpha = data['caption_fg_colour'], data['caption_fg_alpha']
    local tox = graph_radius * (math.cos((graph_start_angle * 2 * math.pi / 360)-(math.pi/2)))
    local toy = graph_radius * (math.sin((graph_start_angle * 2 * math.pi / 360)-(math.pi/2)))
    if data['caption_x'] ~= nil then
       tox = data['caption_x']
       toy = data['caption_y']
    end
    cairo_select_font_face (display, font, CAIRO_FONT_SLANT_NORMAL, caption_weight);
    cairo_set_font_size (display, caption_size)
    cairo_set_source_rgba (display, rgb_to_r_g_b(caption_fg_colour, caption_fg_alpha))
    cairo_move_to (display, x + tox + 5, y + toy + 1)
    -- bad hack but not enough time !
    if graph_start_angle < 105 then
        cairo_move_to (display, x + tox - 30, y + toy + 1)
    end
    cairo_show_text (display, caption)
    cairo_stroke (display)
end


function draw_text_field(display, data, value)
    local x, y = compute_relative(data)

--    local text_bg_colour, graph_bg_alpha = data['graph_bg_colour'], data['graph_bg_alpha']
    local text_fg_colour, text_fg_alpha = data['text_fg_colour'], data['text_fg_alpha']
    local prefix_fg_colour, prefix_fg_alpha = data['prefix_fg_colour'], data['prefix_fg_alpha']
    local suffix_fg_colour, suffix_fg_alpha = data['suffix_fg_colour'], data['suffix_fg_alpha']

    local font = data['font']
    local font_size = data['size']
    local font_slant = data['slant']
    local font_face = data['face']

    cairo_select_font_face (display, font, font_slant, font_face);
    cairo_set_font_size (display, font_size)

    local extents=cairo_text_extents_t:create()
    cairo_text_extents(display, value, extents)
    tolua.takeownership(extents)
    local width=extents.width
    local height=extents.height

    data['extent_x'], data['extent_y'] = width, height

    if data['align_x'] ~= nil and data['align_x'] == 'right' then
       x = x - width
       data['drawn_x'] = data['drawn_x'] - width
    end

    cairo_move_to (display,x,y)
    if data.orient ~= nil then
       cairo_rotate(display, data.orient * math.pi/180)
    end
    cairo_set_source_rgba (display, rgb_to_r_g_b(prefix_fg_colour, prefix_fg_alpha));
    cairo_show_text (display, data['prefix'])
    cairo_set_source_rgba (display, rgb_to_r_g_b(text_fg_colour, text_fg_alpha));
    cairo_show_text (display, value)
    cairo_set_source_rgba (display, rgb_to_r_g_b(suffix_fg_colour, suffix_fg_alpha));
    cairo_show_text (display, data['suffix'])
    cairo_stroke (display)
    cairo_identity_matrix(display)
end



function draw_image(display, data, value)
    local x, y = compute_relative(data)
    local h, w = data['h'], data['w']

    if data['imagedata'] == nil then
       data['imagedata'] = imlib_load_image(value)
       print ("loading image "..value)
    end

    if data['imagedata'] == nil then return end

    imlib_context_set_image(data['imagedata'])
    if data['h'] == nil or data['w'] == nil then
       data['extent_x'], data['extent_y'] = imlib_image_get_width(), imlib_image_get_height()
       imlib_render_image_on_drawable(x, y)
    else
       data['extent_x'], data['extent_y'] = w, h
       imlib_render_image_on_drawable_at_size(x, y, w, h)
    end


--    imlib_free_image()

end


-------------------------------------------------------------------------------
--                                                               go_gauge_rings
-- loads data and displays gauges
--
function go_gauge_rings(display)
    local function load_graph_object(display, data)
       local str, value = '', 0
        local rate, hide = 0, '' 
       
       if data['value'] ~= nil then
          str=data['value']
          value = tonumber(str)
       end

       if data['rate'] == nil then
          rate=1
       else
          rate=tonumber(data['rate'])
       end

       if update_num % rate == 0 or data['cached'] == nil then
          if data['name'] ~= nil then
             str = string.format('${%s %s}',data['name'], data['arg'])
             str = conky_parse(str)
          end

          if data['cmd'] ~= nil then
             local file = io.popen(data['cmd'])
             str= file:read("*a")
             start, finish, str = string.find (str, "(.*)\n") 
             file:close()
          end

          if data['tick'] ~= nil then
             data.tick(data)
          end

          data['cached']=str
          value = tonumber(str)
       else
          str=data['cached']
          value = tonumber(str)
       end

       if data.relativeto == nil then
          data.drawn_x = data.x
          data.drawn_y = data.y
       end

       if data.hideeval ~= nil then
          if data['hideeval'] == "hide" then
             hide = 'hide'
          elseif update_num % rate == 0 or data['hidecache'] == nil then
             hide = string.format('%s',data['hideeval'])
             hide = conky_parse(hide)
             data['hidecache'] = hide
          else
             hide = data['hidecache']
          end
       end

       if data.hideonvalue ~= nil then
          if value == nil or value == data.hideonvalue then
             hide = 'hide'
          end
       end

       if hide ~= "hide" then
              if data.type == "text"  then draw_text_field(display, data, str)
          elseif data.type == "image" then draw_image(display, data, str)
          end

          if value ~= nil then
             if  data.type == "gauge" then draw_gauge_ring(display, data, value)
             end
          end
       end --if hide
       
        if data['onclick'] ~= nil and
          data['drawn_x'] ~= nil and data['drawn_y'] ~= nil and
          data['extent_x'] ~= nil and data['extent_y'] ~= nil then
          local lx1, ly1 = data.drawn_x, data.drawn_y
          local lx2, ly2 = data.drawn_x + data.extent_x,  data.drawn_y + data.extent_y
          if data['type'] == "gauge" then
             lx1 = data.drawn_x - data['graph_radius'] - data['graph_thickness']
             ly1 = data.drawn_y - data['graph_radius'] - data['graph_thickness']
             lx2 = data.drawn_x + data['graph_radius'] + data['graph_thickness']
             ly2 = data.drawn_y + data['graph_radius'] + data['graph_thickness']
          elseif data['type'] == "text" then
             ly2 = data.drawn_y
             ly1 = ly2 - data.extent_y
          end
          table.insert(mregions, {x1=lx1,  y1=ly1,
                                  x2=lx2,  y2=ly2,
                                  onclick=function(x, y)
                                             return data.onclick (data, x, y)
                                          end
                               })
       end
    end
    
    mregions={}

    for i in pairs(gauge) do
       load_graph_object(display, gauge[i])
    end
end

-------------------------------------------------------------------------------
--                                                                         MAIN
function conky_main()
    if conky_window == nil then 
        return
    end

    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    local display = cairo_create(cs)
    
    local updates = conky_parse('${updates}')
    update_num = tonumber(updates)


-- examine the monitor configuration
--    if update_num < 5 || update_num % 300 == 0 then
       for i in pairs(screens) do
          screens[i].head = 0
       end
       
       local file = io.popen("xdpyinfo -ext XINERAMA|grep -e ' *head #[0-9]'")
       local count=1
       while true do
          local xinfo = file:read("*line")
          if xinfo == nil then break end
          start, finish, width  = string.find(xinfo, "%s*head%s#%d:%s(%d*)")
          start, finish, xpos   = string.find(xinfo, "x%d* @ (%d*)", finish)
          screens[count].head    = count
          screens[count].width   = width
          screens[count].xpos    = xpos
          screens[count].connected = 'yes'  -- need to detect this
          count = count + 1
       end
       file:close()

       local function compare(a,b)
          return a.xpos < b.xpos
       end
       table.sort(screens, compare)

       --    for i in pairs(screens) do
       --       print ("screen "..i.." head="..screens[i].head.." xp="..screens[i].xpos.." w="..screens[i].width)
       --    end
--    end

-- overide detection of connected monitor
       local file = io.open(os.getenv('HOME').."/tmp/disvga")
       if file ~= nil then
          local mondisconected = file:read("*line")
          file:close()
          if mondisconected == 'yes' then  screens[1].connected = 'no' end
       end


-- read in changes to dynamic log state
        --  expects xmonads dynamiclog format to be sorted by getSortByXineramaRule
        -- screen1ws screen2ws wsN ... wsM : Layout
        -- colors by dzenColor will be stripped ws's should not be  wrapped
        -- handles urgent workspaces with cyan background or wrapped with a leading '*'
        local file = io.popen("tail -1 ~/.xmonad/dynlogpipe| perl -pe \' s/\\^bg\\(cyan\\)/\\*/g; s/\\^\[^)\]*\\)//g \'")
        local dynlog= file:read("*a")
        file:close()
        -- print ("dynlog: "..dynlog)
        if string.len (dynlog) > 2 then
           start, finish, dt1 = string.find (dynlog, "(%S*)")
           start, finish, dt2 = string.find (dynlog, "%s(%S*)", finish)
           start, finish, vis = string.find (dynlog, "%s(.*):", finish)
           start, finish, lay = string.find (dynlog, ":%s(.*)\n", finish)
           local dt_name=conky_parse('${desktop_name}')

           if string.sub(dt1, 1, 1) == '*' then
              desktops[1].workspace=string.sub(dt1,2)
              desktops[1].urgent=1
           else
              desktops[1].workspace=dt1
              desktops[1].urgent=0
           end

           if screens[2].head > 0 then
              if string.sub(dt2, 1, 1) == '*' then
                 desktops[2].workspace=string.sub(dt2,2)
                 desktops[2].urgent=1
              else
                 desktops[2].workspace=dt2
                 desktops[2].urgent=0
              end
           end

           for i in pairs(desktops) do
              if dt_name == desktops[i].workspace then
                 desktops[i].layout = lay
              end
           end
        end

        if screens[1].connected == 'no' then
           -- if our first screen is not visible then stick its ws number in the list so we see it on the other screen
           if desktops[screens[1].head].urgent > 0 then vis = vis.."*" end
           vis = vis..desktops[screens[1].head].workspace.." "
--           print (screens[1].head.." "..desktops[screens[1].head].workspace)
        end


       gauge['workspace1'].value = desktops[screens[1].head].workspace
       gauge['layout1'].value = desktops[screens[1].head].layout
       if desktops[screens[1].head].urgent == 1 then gauge['workspace1'].text_fg_colour=color_txt_urgent else gauge['workspace1'].text_fg_colour=color_txt1 end
       gauge['workspace2'].value = desktops[screens[2].head].workspace
       gauge['layout2'].value = desktops[screens[2].head].layout
       if desktops[screens[2].head].urgent == 1 then gauge['workspace2'].text_fg_colour=color_txt_urgent else gauge['workspace2'].text_fg_colour=color_txt1 end

       gauge['workspacevis'].value = vis
       local count = 1
       finish = 1
       while true do
          start, finish, v = string.find (vis, "%s?(%S*)%s?", finish)
          if v == nil or v == '' or count > 5 then break end
          viskey='vis'..count
          if count > 1 then
             visrel = 'vis'..(count - 1)
             visx, visy = -4, 0
          else
             visrel = gauge['workspacevis'].relativeto
             visx, visy = -8, 8
          end

          if string.sub(v, 1, 1) == '*' then
             v = string.sub(v, 2)
             vcolor=color_txt_urgent
          else
             vcolor=color_txt3
          end
          
          if gauge[viskey] == nil then
             gauge[viskey] = {
                type="text",                   arg='',
                x=visx,                        y=visy,
                relativeto=visrel, 
                align_x='right',
                value=v,
                prefix='',                     suffix='',
                text_fg_colour=vcolor,         text_fg_alpha=1.0,
                prefix_fg_colour=color_txt3,   prefix_fg_alpha=0.7,
                suffix_fg_colour=color_txt3,   suffix_fg_alpha=0.7,
                font=font,
                size=12,
                slant=CAIRO_FONT_SLANT_NORMAL,
                face=CAIRO_FONT_WEIGHT_BOLD,
                onclick = function(data, x, y)
                             print (data.value)
                             os.execute("((xdotool set_desktop "..data.value..")&)")
                          end,
             }
          else
--             gauge[viskey].visx, gauge[viskey].visy = x,y
             gauge[viskey].relativeto=visrel
             gauge[viskey].value=v
             gauge[viskey].text_fg_colour=vcolor
          end
          count = count + 1
       end
       while count <= 22 do
          viskey='vis'..count
          gauge[viskey] = nil
          count = count + 1
       end

-- set field properties dynamically to allow for shifting when vga is disconnected on a laptop
        if screens[1].connected == 'yes' then
           gauge['screen1_l'] =      {x=0,                      y=0}
           gauge['screen1_r'] =      {x=screens[1].width,       y=0}
           gauge['screen2_l'] =      {x=screens[1].width + 1,   y=0}
           gauge['screen2_r'] =      {x=conky_window.width,     y=0}

           gauge['workspace1'].x = -170
           gauge['workspace1'].relativeto = 'abs_scr2'
           gauge['layout1'].align_x = 'right'
           gauge['layout1'].x = -6
           gauge['workspace2'].x = 140
           gauge['workspace2'].relativeto = 'abs_scr2'
           gauge['layout2'].align_x = 'left'
           gauge['layout2'].x = 20
           gauge['workspacevis'].relativeto = 'workspace1'
        else
           gauge['screen1_l'] =      {x=screens[1].width + 1,   y=0}
           gauge['screen1_r'] =      {x=conky_window.width,     y=0}
           gauge['screen2_l'] =      {x=0,                      y=0}
           gauge['screen2_r'] =      {x=screens[1].width,       y=0}

           gauge['workspace2'].x = -170
           gauge['workspace2'].relativeto = 'abs_right'
           gauge['layout2'].align_x = 'right'
           gauge['layout2'].x = -6
           gauge['workspace1'].x = 140
           gauge['workspace1'].relativeto = 'abs_left'
           gauge['layout1'].align_x = 'left'
           gauge['layout1'].x = 20
           gauge['workspacevis'].relativeto = 'workspace2'
        end
           gauge['abs_left']  =      {x=0,                      y=0}
           gauge['abs_right'] =      {x=conky_window.width,     y=0}
           gauge['abs_scr2'] =       {x=screens[1].width,       y=0}

    
    if update_num > 5 then
        go_gauge_rings(display)

-- Process mouse events
        --overx, overy = mouse_location("status bar")
        local function process_mregion(region, x, y)
           if x >= region['x1'] and
              x <= region['x2'] and
              y >= region['y1'] and
              y <= region['y2'] then
              region.onclick(x, y)
           end
        end

        while true do
           clickx, clicky = mouse_click("status bar")
           if clickx ~= nil and clicky ~= nil then
              if mregions ~= nil then
                 --print ("mouse "..clickx.." "..clicky)
                 for i in pairs(mregions) do
                    process_mregion(mregions[i], clickx, clicky)
                 end
              end
           else
              break
           end
        end
    end
    
    cairo_surface_destroy(cs)
    cairo_destroy(display)
end

function conky_shutdown()
   mouse_shutdown("status bar")
end