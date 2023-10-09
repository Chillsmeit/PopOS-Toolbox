#!/bin/bash
installconky () {
	mkdir "$HOME/.conky"
	mkdir "$HOME/.fonts"
	touch "$HOME/.conky/Weekday.conf"
	touch "$HOME/.conky/Date.conf"
	touch "$HOME/.conky/conky.sh"
	touch "$HOME/.conky/convert.lua"
	cat <<'EOF' > "$HOME/.conky/convert.lua"
#! /usr/bin/lua
local function quote(s)
    if not s:find("[\n'\\]") then
        return "'" .. s .. "'";
    end;
    local q = '';
    while s:find(']' .. q .. ']', 1, true) do
        q = q .. '=';
    end;
    return string.format('[%s[\n%s]%s]', q, s, q);
end;

local bool_setting = {
    background = true, disable_auto_reload = true, double_buffer = true, draw_borders = true,
    draw_graph_borders = true, draw_outline = true, draw_shades = true, extra_newline = true,
    format_human_readable = true, no_buffers = true, out_to_console = true,
    out_to_wayland = true,
    out_to_ncurses = true, out_to_stderr = true, out_to_x = true, override_utf8_locale = true,
    own_window = true, own_window_argb_visual = true, own_window_transparent = true,
    short_units = true, show_graph_range = true, show_graph_scale = true,
    times_in_seconds = true, top_cpu_separate = true, uppercase = true, use_xft = true,
    draw_blended = true, forced_redraw = true
};

local num_setting = {
    border_inner_margin = true, border_outer_margin = true, border_width = true,
    cpu_avg_samples = true, diskio_avg_samples = true, gap_x = true, gap_y = true,
    imlib_cache_flush_interval = true, imlib_cache_size = true,
    max_port_monitor_connections = true, max_text_width = true, max_user_text = true,
    maximum_width = true, mpd_port = true, music_player_interval = true, net_avg_samples = true,
    own_window_argb_value = true, pad_percents = true, stippled_borders = true,
    text_buffer_size = true, top_name_width = true, total_run_times = true,
    update_interval = true, update_interval_on_battery = true, xftalpha = true,
    xinerama_head = true,
};

local split_setting = {
    default_bar_size = true, default_gauge_size = true, default_graph_size = true,
    minimum_size = true
};

local colour_setting = {
    color0 = true, color1 = true, color2 = true, color3 = true, color4 = true, color5 = true,
    color6 = true, color7 = true, color8 = true, color9 = true, default_color = true,
    default_outline_color = true, default_shade_color = true, own_window_colour = true
};

local function alignment_map(value)
    local map = { m = 'middle', t = 'top', b = 'bottom', r = 'right', l = 'left' };
    if map[value] == nil then
        return value;
    else
        return map[value];
    end;
end;

local function handle(setting, value)
    setting = setting:lower();
    if setting == '' then
        return '';
    end;
    if split_setting[setting] then
        local x, y = value:match('^(%S+)%s*(%S*)$');
        local ret = setting:gsub('_size', '_width = ') .. x .. ',';
        if y ~= '' then
            ret = ret .. ' ' .. setting:gsub('_size', '_height = ') .. y .. ',';
        end;
        return '\t' .. ret;
    end;
    if bool_setting[setting] then
        value = value:lower();
        if value == 'yes' or value == 'true' or value == '1' or value == '' then
            value = 'true';
        else
            value = 'false';
        end;
    elseif not num_setting[setting] then
        if setting == 'alignment' and value:len() == 2 then
            value = alignment_map(value:sub(1,1)) .. '_' .. alignment_map(value:sub(2,2));
        elseif colour_setting[setting] and value:match('^[0-9a-fA-F]+$') then
            value = '#' .. value;
        elseif setting == 'xftfont' then
            setting = 'font';
        end;
        value = quote(value);
    end;
    return '\t' .. setting .. ' = ' .. value .. ',';
end;

local function convert(s)
    local setting, comment = s:match('^([^#]*)#?(.*)\n$');
    if comment ~= '' then
        comment = '--' .. comment;
    end;
    comment = comment .. '\n';
    return handle(setting:match('^%s*(%S*)%s*(.-)%s*$')) ..  comment;
end;

local input;
local output;

if conky == nil then --> standalone program
    -- 1 arg: arg is input and outputfile
    -- 2 args: 1st is inputfile, 2nd is outputfile
    -- 0, 3 or more args: print usage to STDERR and quit
    if #arg == 1 or #arg == 2 then
        if os.execute('command -v dos2unix 2>&1 >/dev/null') == 0 then
            os.execute('dos2unix ' .. arg[1]);
        end
        input = io.input(arg[1]);
    else
        io.stderr:write(usage);
        return;
    end;
else
    -- we are called from conky, the filename is the first argument
    input = io.open(..., 'r');
end;


local config = input:read('*a');
input:close();

local settings, text = config:match('^(.-)TEXT\n(.*)$');

local converted = 'conky.config = {\n' .. settings:gsub('.-\n', convert) .. '};\n\nconky.text = ' ..
                quote(text) .. ';\n';

if conky == nil then
    if #arg == 2 then
        output = io.output(arg[2]);
    else
        output = io.output(arg[1]);
    end
    output:write(converted);
    output:close();
else
    return assert(load(converted, 'converted config'));
end;
EOF

	cat <<EOF > "$HOME/.conky/conky.sh"
#!/bin/bash
conky -c "$HOME/.conky/Weekday.conf" &
conky -c "$HOME/.conky/Date.conf"
EOF

	cat <<'EOF' > "$HOME/.conky/Date.conf"
conky.config = {
-- Conky settings #
	background = false,
	update_interval = 30,
	double_buffer = true,
	no_buffers = true,

-- Window specifications #
	own_window = true,
	own_window_type = 'normal',
	own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
	own_window_title = '',
	own_window_transparent = true,
	own_window_argb_visual = true,
	own_window_argb_value = 200,

	minimum_width = 252, minimum_height = 100,

-- Alignment #
	alignment = 'top_middle',
	gap_x = -10,
	gap_y = 160,

	border_inner_margin = 15,
	border_outer_margin = 0,

-- Graphics settings #
	draw_shades = false,
	draw_outline = false,
	draw_borders = false,
	draw_graph_borders = false,

-- Text settings #
	use_xft = true,
	xftalpha = 0,
	font = 'Neptune Trial:size=18',

-- Color scheme #
	default_color = '#333333',

	color1 = '#0099CC',
	color2 = '#9933CC',
	color3 = '#669900',
	color4 = '#FF8800',
	color5 = '#CC0000',
	color6 = '#AAAAAA',
	color7 = '#DDDDDD',

};

conky.text = [[
${alignc}$font${color D6D5D4}${time %d}$color ${time  %B} ${time %Y}$font
${voffset -50}
]];
EOF

	cat <<'EOF' > "$HOME/.conky/Weekday.conf"
conky.config = {
--Conky
	background = true,
	update_interval = 1,

	cpu_avg_samples = 2,
	net_avg_samples = 2,
	temperature_unit = 'celsius',

	double_buffer = true,
	no_buffers = true,
	text_buffer_size = 2048,
	alignment = 'top_middle',
	gap_x = 0,
	gap_y = 25,
	minimum_width = 0, minimum_height = 550,
	maximum_width = 850,
	own_window = true,
	own_window_type = 'desktop',
	own_window_transparent = true,
	own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
	own_window_argb_visual = true,
	own_window_argb_value = 0,

	border_inner_margin = 0,
	border_outer_margin = 0,


	draw_shades = false,
	draw_outline = false,
	draw_borders = false,
	draw_graph_borders = false,
	default_shade_color = '#112422',

	use_xft = true,
	font = 'Neptune Trial:size=10',
	xftalpha = 0,
	uppercase = true,

	default_color = '#D6D5D4',
	own_window_colour = '#000000',
};

conky.text = [[


${font Anurati-Regular:size=75}${color D6D5D4}${time %A}


]];
EOF

	# Export Array of required package names
	required_dependencies=(
	"conky"
	)

	# Execute missingpackages to check if packages are already installed
	source "subscripts/installdependencies.sh"
	installdependencies

	# Make conky script executable
	chmod +x "$HOME/.conky/conky.sh"
	
	# Create autostart directory if it doesn't exist
	mkdir -p "$HOME/.config/autostart"

	# Create .desktop entry to launch conky
	touch "$HOME/.config/autostart/conky.desktop"
	cat <<EOF > "$HOME/.config/autostart/conky.desktop"
[Desktop Entry]
Name=Conky
Exec=$HOME/.conky/conky.sh
Terminal=false
Type=Application
StartupNotify=false
EOF
	Menu_OneMessage "Please Follow instructions for getting the Fonts"
	read -r "Press Enter to Continue..."
	Menu_TwoMessages "\033]8;;https://troisieme-type.com/anurati-pro\aAnurati Free Font\033]8;;\a" "\033]8;;https://www.behance.net/gallery/17625495/Neptune-Free-Font\aNeptune Free Font\033]8;;\a"
	read -r "Press Enter to Continue..."

}