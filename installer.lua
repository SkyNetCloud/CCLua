term.clear()
local token = ''
local module_name = ''
local username = ''
local type = ''
local updating = false
local user = ''

-- Alternative (and much more versatile) function than "pastebin get"
local function getPaste(id, filename)
    local site = http.get("https://raw.githubusercontent.com/SkyNetCloud/CloudNanny/master/modules/"..filename)
    local content = site.readAll()
    if content then
        local file = fs.open(filename, "w")
        file.write(content)
        file.close()
    else
        -- Unable to connect to Pastebin for whatever reason
        error("Unable to contact Github!")
    end
end

--[[Even better installation function that installs all files
    You'd just need to define which computer is using which module
    or find a way to have each computer use all modules at once
    It is possible, I guarantee it.
    Remove brackets to enable
local function getFiles()
    local files = {
        installer = "Q8ah3K9S",
        player_module = "rWp0GXDW",
        redstone_module = "KkCYWkSU",
        fluid_module = "x7K3zUAC",
        energy_module = "RxLuZWHp",
        hash_api = "FLQ68J88",
        startup = "KnmEN37h"
    }
    for i, v in pairs(files) do
        local site = http.get("http://pastebin.com/raw.php?i="..v)
        local content = site.readAll()
        if content then
            local file = fs.open(i, "w")
            file.write(content)
            file.close()
        else
            -- Unable to connect
        end
    end
end

Alternatively, you can host all of these files on Github, and retrieve them from it too.
Use "https://raw.githubusercontent.com/jaranvil/CloudNanny/master/modules/"..filename
instead of "http://pastebin.com/raw.php?i="..pasteID
to retrieve them. It's very nice to do it that way, considering you can set up an automatic updater.
]]

function draw_text_term(x, y, text, text_color, bg_color)
    term.setTextColor(text_color)
    term.setBackgroundColor(bg_color)
    term.setCursorPos(x,y)
    write(text)
end

function draw_line_term(x, y, length, color)
    term.setBackgroundColor(color)
    term.setCursorPos(x,y)
    term.write(string.rep(" ", length))
end

function bars()
	draw_line_term(1, 1, 51, colors.lime)
	draw_line_term(1, 19, 51, colors.lime)
	draw_text_term(12, 1, 'SkyNetCloud Github Module Installer', colors.gray, colors.lime)
end

-- saves current token variable to local text file
function save_config()
    sw = fs.open("config.txt", "w")
	sw.writeLine(module_name)
	sw.writeLine(type)
    sw.close()
end

function load_config()
    sr = fs.open("config.txt", "r")
	module_name = sr.readLine()
	type = sr.readLine()
    sr.close()
end

function launch_module()
    shell.run("CN_module")
end

function install_module()
	if type == '1' then
		pastebin = rs_info
	elseif type == '2' then
		pastebin = energy_module
	end
	
	term.clear()
	bars()
	draw_text_term(1, 3, 'successfully logged in', colors.lime, colors.black)
	sleep(0.5)
	draw_text_term(1, 4, 'installing...', colors.white, colors.black)
	sleep(0.5)
	
	draw_text_term(1, 5, 'removing old versions', colors.white, colors.black)
	if fs.exists("CN_module") then
	    fs.delete("CN_module")
	end
	sleep(0.5)
	
	draw_text_term(1, 6, 'fetch from pastebin', colors.white, colors.black)
	term.setCursorPos(1,7)
	term.setTextColor(colors.white)
    getPaste(pastebin, "CN_module")
    
    sleep(0.5)
  
    draw_text_term(1, 9, 'create startup file', colors.white, colors.black)
	term.setCursorPos(1,10)
	term.setTextColor(colors.white)
    if fs.exists("startup") then
        fs.delete("startup")
    end
    getPaste(startup, "startup")
    sleep(1)
  
    draw_text_term(1, 13, 'Setup Complete', colors.lime, colors.black)

    draw_text_term(1, 14, 'press enter to continue', colors.lightGray, colors.black)

    if updating then

    else
        input = read()
    end

    launch_module()
end


function login()
		save_config()
		install_module()
end

function name()
	term.clear()
	bars()
	
	draw_text_term(1, 3, 'Give this module a unique name:', colors.lime, colors.black)
	term.setCursorPos(2,4)
	term.setTextColor(colors.white)
	module_name = read()
    login()
end


function rf_info()
	
	-- code to check that openperipheral sensor is present. give relavent error
	
	type = '1'
	name()
end


function choose_module(input) 
	if input == '1' then
		rf_info()
	elseif input == '2' then
		type = '2'
		name()
	end
end

function install_select()
	term.clear()
	bars()
	draw_text_term(15, 3, 'Welcome to CloudNanny!', colors.lime, colors.black)
	draw_text_term(1, 5, 'What module would you like to install?', colors.white, colors.black)
	
	draw_text_term(2, 7, '1. Player Tracking', colors.white, colors.black)
	draw_text_term(2, 8, '2. Energy Monitor', colors.white, colors.black)
	draw_text_term(1, 13, 'Enter number:', colors.white, colors.black)
	term.setCursorPos(1,14)
	term.setTextColor(colors.white)
	input = read()
	
	choose_module(input)
end

function start()
    term.clear()
    if fs.exists("config.txt") then
        load_config()
        updating = true
        install_module()
    else
        install_select()
    end
end

start()