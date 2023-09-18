#!/bin/bash
installconky () {
	cd "$HOME" || exit
	mkdir .conky
	mkdir .fonts
	cd "$HOME/.conky" || exit
	touch Weekday.conf
	touch Date.conf
	touch conky.sh
	touch convert.lua
	cat <<'EOF' > convert.lua
#! /usr/bin/lua

local usage = [[
Usage: convert.lua old_conkyrc [new_conkyrc]

Tries to convert conkyrc from the old v1.x format to the new, lua-based format.

Keep in mind that there is no guarantee that the output will work correctly
with conky, or that it will be able to convert every conkyrc. However, it
should provide a good starting point.

Although you can use this script with only 1 arg and let it overwrite the old
config, it's suggested to use 2 args so that the new config is written in a new
file (so that you have backup if something went wrong).

Optional: Install dos2unix. We will attempt to use this if it is available
because Conky configs downloaded from Internet sometimes are created on DOS/Windows
machines with different line endings than Conky configs created on Unix/Linux.

For more information about the new format, read the wiki page
<https://github.com/brndnmtthws/conky/wiki>
]];

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


cat <<'EOF' > conky.sh
#!/bin/bash
conky -c "$HOME/.conky/Weekday.conf" &
conky -c "$HOME/.conky/Date.conf"
EOF

cat <<'EOF' > Date.conf
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
	font = 'Neptune:size=18',

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

cat <<'EOF' > Weekday.conf
conky.config = {
--Conky By Jesse Avalos See me on Eye candy Linux (Google +) for more conkys.
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
	font = 'Neptune:size=10',
	xftalpha = 0,
	uppercase = true,

	default_color = '#D6D5D4',
	own_window_colour = '#000000',
};

conky.text = [[


${font Anurati-Regular:size=75}${color D6D5D4}${time %A}


]];
EOF
# Extract the first link from the first URL of Anurati Font
anuratifont_link=$(curl -s "https://befonts.com/anurati-font.html" | grep -o "https://befonts.com/downfile[^'\"]*" | sed 's/\&amp;/\&/g' | head -1)
if [ -z "$anuratifont_link" ]; then
    echo "First download link not found. Exiting."
    exit 1
fi

# Extract the final download link from the first link of the Anurati Font
anuratifont_downloadlink=$(curl -s "$anuratifont_link" | grep -o "https://befonts.com/wp-content/uploads[^'\"]*" | sed 's/\&amp;/\&/g' | head -1)
if [ -z "$anuratifont_downloadlink" ]; then
    echo "Final download link not found. Exiting."
    exit 1
fi

# Download the zip file
filename=$(basename "$anuratifont_downloadlink")
curl -o "$filename" "$anuratifont_downloadlink"
echo "File downloaded: $filename"
7z x $filename

# Extract the first link from the first URL of the Neptune Font
neptunefont_link=$(curl -s "https://www.freefonts.io/downloads/neptune-font/" | grep -o "https://www.freefonts.io/wp-content/uploads[^'\"]*" | sed 's/\&amp;/\&/g' | head -1)
if [ -z "$neptunefont_link" ]; then
    echo "First download link not found. Exiting."
    exit 1
fi

# Download the zip file
filename=$(basename "$neptunefont_link")
curl -o "$filename" "$neptunefont_link"
echo "File downloaded: $filename"
7z x $filename

find . -type f -name "*.otf" ! -path "./.*" -exec mv {} . \;
rm -r */
rm *.zip
cp *.otf "$HOME/.fonts"
}