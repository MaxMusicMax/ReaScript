--@description Mouse Modifier; Preset Switcher
--@version 1.0
--@author MaxMusicMax
-- https://forum.cockos.com/showthread.php?p=2059855
-- #######################################
-- #######################################
-- 1111111111111111111111

-- categories_mouse_modifiers
-- Выводим label в консоль при выборе
-- Show Preset Name

-- default_presets_at_startup
-- main_menu_structure
-- font_size
-- name_window_v9qkNIb02dve2mWVraFo
-- script_path
-- ini_manager
-- Default menu item
-- DrawWithBorder
-- SavePresetsToINI
-- SaveCurrentPreset
-- LoadPresets
-- SaveLastSelectedPreset
-- ApplyPreset
-- SortPresets
-- DrawSortedPresets
-- DrawMenu
-- LoadLastSelectedPreset
-- DeleteLastSelectedPreset
-- EnsureDefaultPresets
-- cboc2 / create_button_one_click2
-- ShowMenuItems
-- SetDefaultMenuItemImGui
-- function main
-- #######################################
-- #######################################
-- default_preset_at_startup
-- Переменная для значения [Default Preset] при запуске

-- default_presets_at_startup
local default_presets_at_startup = {
    ["Main - Default Preset"] = "action_id=39835,39784,39282,25196,25165,25128,39801,25096,39129,39167,25480,39407,39359,25321,39448,25033,39321,39673,39289,39705,39487,39641,39417,39961,39545,39033,39065,39896,39864,39736,39097,39513,39001,39929,25071,25257,25001,25225,25289,25420,25353,25385,25448,39609,39233,39577,39201",
    ["Main - Marquee add to item selection"] = "action_id=39835,39784,39282,25196,25165,25128,39801,25096,39129,39167,25480,39407,39359,25321,39448,25033,39321,39673,39289,39705,39487,39641,39417,39961,39545,39033,39065,39896,39864,39736,39097,39513,39001,39929,25071,25257,25001,25225,25289,25420,25353,25385,25448,39609,39233,39577,39205",
    ["Main - Select Time"] = "action_id=39835,39784,39282,25196,25165,25128,39801,25096,39129,39167,25480,39407,39368,25321,39448,25033,39321,39673,39289,39705,39487,39641,39417,39961,39545,39051,39065,39896,39864,39736,39097,39513,39019,39929,25071,25257,25001,25225,25289,25420,25353,25385,25448,39609,39225,39577,39199",
    ["Main - Draw Empty MIDI Item"] = "action_id=39835,39784,39282,25196,25165,25128,39801,25096,39129,39167,25480,39407,39368,25321,39448,25033,39321,39673,39289,39705,39487,39641,39417,39961,39545,39033,39065,39896,39864,39736,39097,39513,39001,39929,25071,25257,25001,25225,25289,25420,25353,25385,25448,39609,39233,39577,39197",
    ["MIDI CC lane left click/drag - Edit CC events"] = "action_id=39835,39784,39282,25196,25165,25128,39801,25096,39129,39167,25480,39407,39368,25321,39448,25033,39321,39673,39289,39705,39487,39641,39417,39961,39545,39033,39065,39896,39864,39736,39097,39513,39001,39929,25071,25257,25001,25225,25289,25420,25353,25385,25448,39609,39233,39577,39201",
    ["MIDI CC lane left click/drag - Edit CC events ignoring selection"] = "action_id=39835,39784,39282,25196,25165,25128,39801,25096,39129,39167,25480,39407,39359,25321,39448,25033,39321,39673,39289,39705,39487,39641,39417,39961,39545,39033,39065,39896,39864,39736,39097,39513,39001,39929,25071,25257,25001,25225,25289,25420,25353,25385,25448,39609,39233,39577,39201",
    ["MIDI - Marquee add to note selection"] = "action_id=39835,39784,39282,25196,25165,25128,39801,25096,39129,39167,25480,39407,39359,25321,39448,25033,39321,39673,39289,39705,39489,39641,39417,39961,39545,39033,39065,39896,39864,39736,39097,39513,39001,39929,25071,25257,25001,25225,25289,25420,25353,25385,25448,39609,39233,39577,39201",
    ["MIDI piano roll left drag - Scrub preview MIDI"] = "action_id=39835,39784,39282,25196,25165,25128,39801,25096,39129,39167,25480,39407,39359,25321,39448,25033,39321,39673,39289,39705,39496,39641,39417,39961,39545,39033,39065,39896,39864,39736,39097,39513,39001,39929,25071,25257,25001,25225,25289,25420,25353,25385,25448,39609,39233,39577,39201",
    -- ["www"] = "www",
}
-- #######################################
-- #######################################
--[[
Example — Default Preset Mouse Modifier (MaxMusicMax)

local default_presets_at_startup = {
    ["Default Preset"] = "action_id=39835,39784,39282,25196,25165,25128,39801,25096,39129,39167,25480,39407,39368,25321,39448,25033,39321,39673,39289,39705,39487,39641,39417,39961,39545,39033,39065,39896,39864,39736,39097,39513,39001,39929,25071,25257,25001,25225,25289,25420,25353,25385,25448,39609,39233,39577,39205",
    -- ["www"] = "action_id=www",
}

]]--
-- #######################################
-- #######################################
function print_rs (param)
	reaper.ShowConsoleMsg (tostring (param) .. "\n");
end
-- #######################################
-- #######################################
function printTable(tbl, indent)
    indent = indent or 0  -- Устанавливаем отступ по умолчанию в 0, если он не задан
    local prefix = string.rep("  ", indent)  -- Создаем строку отступа на основе текущего уровня отступа

    for k, v in pairs(tbl) do  -- Проходим по всем парам ключ-значение в таблице
        if type(v) == "table" then  -- Если значение является таблицей
            reaper.ShowConsoleMsg(prefix .. tostring(k) .. ": {\n")  -- Печатаем ключ и открывающую скобку для новой таблицы
            printTable(v, indent + 1)  -- Рекурсивно вызываем printTable для вложенной таблицы, увеличивая уровень отступа
            reaper.ShowConsoleMsg(prefix .. "}\n")  -- Печатаем закрывающую скобку для таблицы
        else  -- Если значение не является таблицей
            reaper.ShowConsoleMsg(prefix .. tostring(k) .. ": " .. tostring(v) .. "\n")  -- Печатаем ключ и значение
        end
    end
end
-- #######################################
-- #######################################
function printValue(value, indent)
    indent = indent or 0  -- Устанавливаем отступ по умолчанию в 0, если он не задан
    local prefix = string.rep("  ", indent)  -- Создаем строку отступа на основе текущего уровня отступа

    if type(value) == "table" then  -- Если значение является таблицей
        reaper.ShowConsoleMsg(prefix .. "{\n")  -- Печатаем открывающую скобку для таблицы
        for k, v in pairs(value) do  -- Проходим по всем парам ключ-значение в таблице
            reaper.ShowConsoleMsg(prefix .. "  " .. tostring(k) .. ": ")  -- Печатаем ключ с отступом
            printValue(v, indent + 1)  -- Рекурсивно вызываем printValue для значения, увеличивая уровень отступа
        end
        reaper.ShowConsoleMsg(prefix .. "}\n")  -- Печатаем закрывающую скобку для таблицы
    else  -- Если значение не является таблицей
        reaper.ShowConsoleMsg(prefix .. tostring(value) .. "\n")  -- Печатаем значение
    end
end
-- #######################################
-- #######################################
reaper.PreventUIRefresh(1);
-- #######################################
-- #######################################
-- main_menu_structure
local main_menu_structure = {

	{label = "Menu", children = {
		{label = "Mouse Modifiers Save", show_content = "Mouse_Modifiers_Content_Show"},
		{label = "User Preset Mouse Modifiers", show_content = "Preset_Mouse_Modifiers_Content_Show"},
		{label = "Settings", show_content = "Settings_Content_Show"},
		{is_separator = true}, -- Разделитель
		{label = "Set Alpha Tab ImGui", show_content = "Alpha_Window_ImGui_Content_Show"},
		{label = "Set Default Tab ImGui", action_function = function() SetDefaultMenuItemImGui () end},
	}},
	
	--[[
	
	{label = "Menu", children = {
		{label = "Content 1", show_content = "Content_1_Show"},
		{is_separator = true}, -- Разделитель
		{label = "Content 2", show_content = "Content_2_Show"},
	}},
	
	{label = "Example", children = {
		{label = "Color 1", action_function = function() reaper.ShowMessageBox("Color 1 selected", "Information", 0) end},
		{label = "Content 1", show_content = "Content_1_Content_Show"},
		{label = "Options: Preferences", action_id = "40016"},
		{label = "Gui; Color switch", action_id = "_RS251990727759d3dff9cf84df740cd6a87ea0d169"},
	}},
	]]--
}
-- #######################################
-- #######################################
-- categories_mouse_modifiers

local categories_mouse_modifiers = {
	
	{ -- Arrange view
		label = "Arrange view", children = {
			{
				label = "Arrange view middle click", children = {
					{label = "No action", action_id = "39832" },
					{label = "Move edit cursor ignoring snap", action_id = "39835" },
					{label = "Restore previous zoom level", action_id = "39834" },
					{label = "Restore previous zoom/scroll", action_id = "39833" },
				},
			},
			{
				label = "Arrange view middle drag", children = {
					{label = "No action", action_id = "39768" },
					{label = "Hand scroll", action_id = "39770" },
					{label = "Hand scroll and horizontal zoom", action_id = "39777" },
					{label = "Hand scroll and reverse horizontal zoom (deprecated)", action_id = "39778" },
					{label = "Horizontal zoom", action_id = "39779" },
					{label = "Jog audio", action_id = "39772" },
					{label = "Jog audio (looped-segment mode)", action_id = "39774" },
					{label = "Marquee zoom", action_id = "39775" },
					{label = "Move edit cursor without scrub/jog", action_id = "39776" },
					{label = "Reverse horizontal zoom (deprecated)", action_id = "39780" },
					{label = "Scroll browser-style", action_id = "39771" },
					{label = "Scrub audio", action_id = "39769" },
					{label = "Scrub audio (looped-segment mode)", action_id = "39773" },
					{label = "Set edit cursor and hand scroll", action_id = "39783" },
					{label = "Set edit cursor and horizontal zoom", action_id = "39781" },
					{label = "Set edit cursor and reverse horizontal zoom (deprecated)", action_id = "39782" },
					{label = "Set edit cursor, hand scroll and horizontal zoom", action_id = "39784" },
					{label = "Set edit cursor, hand scroll and reverse horizontal zoom (deprecated)", action_id = "39785" },
				},
			},
			{
				label = "Arrange view right drag", children = {
					{label = "No action", action_id = "39256" },
					{label = "Add to razor edit area", action_id = "39282" },
					{label = "Add to razor edit area ignoring snap", action_id = "39283" },
					{label = "Hand scroll", action_id = "39264" },
					{label = "Hand scroll and horizontal zoom", action_id = "39271" },
					{label = "Hand scroll and reverse horizontal zoom (deprecated)", action_id = "39272" },
					{label = "Horizontal zoom", action_id = "39273" },
					{label = "Jog audio", action_id = "39267" },
					{label = "Jog audio (looped-segment mode)", action_id = "39269" },
					{label = "Marquee add to item selection", action_id = "39263" },
					{label = "Marquee select items", action_id = "39257" },
					{label = "Marquee select items and time", action_id = "39258" },
					{label = "Marquee select items and time ignoring snap", action_id = "39259" },
					{label = "Marquee toggle item selection", action_id = "39262" },
					{label = "Marquee zoom", action_id = "39270" },
					{label = "Remove from razor edit area", action_id = "39286" },
					{label = "Remove from razor edit area ignoring snap", action_id = "39287" },
					{label = "Reverse horizontal zoom (deprecated)", action_id = "39274" },
					{label = "Scroll browser-style", action_id = "39265" },
					{label = "Scrub audio", action_id = "39266" },
					{label = "Scrub audio (looped-segment mode)", action_id = "39268" },
					{label = "Select razor edit area", action_id = "39280" },
					{label = "Select razor edit area and time", action_id = "27256" },
					{label = "Select razor edit area and time ignoring snap", action_id = "27257" },
					{label = "Select razor edit area from cursor", action_id = "39284" },
					{label = "Select razor edit area from cursor ignoring snap", action_id = "39285" },
					{label = "Select razor edit area ignoring snap", action_id = "39281" },
					{label = "Select time", action_id = "39260" },
					{label = "Select time ignoring snap", action_id = "39261" },
					{label = "Set edit cursor and hand scroll", action_id = "39277" },
					{label = "Set edit cursor and horizontal zoom", action_id = "39275" },
					{label = "Set edit cursor and reverse horizontal zoom (deprecated)", action_id = "39276" },
					{label = "Set edit cursor, hand scroll and horizontal zoom", action_id = "39278" },
					{label = "Set edit cursor, hand scroll and reverse horizontal zoom (deprecated)", action_id = "39279" },
				},
			},
		},
	},
	
	{ -- Automation item
		label = "Automation item", children = {
			{
				label = "Automation item double click", children = {
					{label = "No action", action_id = "25192" },
					{label = "Load automation item", action_id = "25196" },
					{label = "Set loop points to item", action_id = "25195" },
					{label = "Set time selection to item", action_id = "25194" },
					{label = "Show automation item properties", action_id = "25193" },
				},
			},
			{
				label = "Automation item edge left drag", children = {
					{label = "No action", action_id = "25160" },
					{label = "Collect points into automation item", action_id = "25165" },
					{label = "Collect points into automation item ignoring snap", action_id = "25166" },
					{label = "Move automation item edge", action_id = "25161" },
					{label = "Move automation item edge ignoring snap", action_id = "25162" },
					{label = "Move automation item edge relative to other selected items", action_id = "25169" },
					{label = "Move automation item edge relative to other selected items ignoring snap", action_id = "25170" },
					{label = "Stretch automation item", action_id = "25163" },
					{label = "Stretch automation item ignoring snap", action_id = "25164" },
					{label = "Stretch automation item relative to other selected items ignoring snap", action_id = "25168" },
					{label = "Stretch automation items relative to other selected items", action_id = "25167" },
				},
			},
			{
				label = "Automation item left drag", children = {
					{label = "No action", action_id = "25128" },
					{label = "Copy and pool automation item", action_id = "25131" },
					{label = "Copy and pool automation item ignoring snap", action_id = "25132" },
					{label = "Copy and pool automation item ignoring snap and time selection", action_id = "25136" },
					{label = "Copy and pool automation item ignoring time selection", action_id = "25135" },
					{label = "Copy automation item", action_id = "25133" },
					{label = "Copy automation item ignoring snap", action_id = "25134" },
					{label = "Copy automation item ignoring snap and time selection", action_id = "25138" },
					{label = "Copy automation item ignoring time selection", action_id = "25137" },
					{label = "Move automation item", action_id = "25129" },
					{label = "Move automation item contents", action_id = "25139" },
					{label = "Move automation item ignoring snap", action_id = "25130" },
				},
			},
		},
	},
	
	{ -- Edit cursor handle left drag
		label = "Edit cursor handle left drag", children = {
			{label = "No action", action_id = "39800" },
			{label = "Jog audio", action_id = "39802" },
			{label = "Jog audio (looped-segment mode)", action_id = "39804" },
			{label = "Scrub audio", action_id = "39801" },
			{label = "Scrub audio (looped-segment mode)", action_id = "39803" },
		},
	},
	
	{ -- Envelope
		label = "Envelope", children = {
			{
				label = "Envelope lane left drag", children = {
					{label = "No action", action_id = "25096" },
					{label = "Draw a copy of the selected automation item", action_id = "25103" },
					{label = "Draw a copy of the selected automation item ignoring snap", action_id = "25104" },
					{label = "Draw a new automation item", action_id = "25105" },
					{label = "Draw a new automation item ignoring snap", action_id = "25106" },
					{label = "Draw a pooled copy of the selected automation item", action_id = "25101" },
					{label = "Draw a pooled copy of the selected automation item ignoring snap", action_id = "25102" },
					{label = "Freehand draw envelope", action_id = "25100" },
					{label = "Freehand draw envelope ignoring snap", action_id = "25099" },
					{label = "Insert envelope point", action_id = "25097" },
					{label = "Insert envelope point ignoring snap", action_id = "25098" },
				},
			},
			{
				label = "Envelope point left drag", children = {
					{label = "No action", action_id = "39128" },
					{label = "Copy envelope point", action_id = "39136" },
					{label = "Copy envelope point ignoring snap", action_id = "39137" },
					{label = "Delete envelope point", action_id = "39132" },
					{label = "Freehand draw envelope", action_id = "39141" },
					{label = "Freehand draw envelope ignoring snap", action_id = "39131" },
					{label = "Move envelope point", action_id = "39129" },
					{label = "Move envelope point horizontally", action_id = "39138" },
					{label = "Move envelope point horizontally ignoring snap", action_id = "39139" },
					{label = "Move envelope point ignoring snap", action_id = "39130" },
					{label = "Move envelope point on one axis only", action_id = "39134" },
					{label = "Move envelope point on one axis only ignoring snap", action_id = "39135" },
					{label = "Move envelope point vertically", action_id = "39140" },
					{label = "Move envelope point vertically (fine)", action_id = "39133" },
				},
			},
			{
				label = "Envelope segment left drag", children = {
					{label = "No action", action_id = "39160" },
					{label = "Edit envelope segment curvature", action_id = "39166" },
					{label = "Edit envelope segment curvature (gang selected points)", action_id = "39169" },
					{label = "Freehand draw envelope", action_id = "39170" },
					{label = "Freehand draw envelope ignoring snap", action_id = "39164" },
					{label = "Insert envelope point", action_id = "39162" },
					{label = "Insert envelope point ignoring snap", action_id = "39163" },
					{label = "Move envelope segment", action_id = "39167" },
					{label = "Move envelope segment (fine)", action_id = "39165" },
					{label = "Move envelope segment ignoring time selection", action_id = "39161" },
					{label = "Move envelope segment preserving edge points", action_id = "39168" },
				},
			},
		},
	},
	
	{ -- Fixed lane header left click
		label = "Fixed lane header left click", children = {
			{label = "No action", action_id = "25480" },
			{label = "Play all lanes", action_id = "25484" },
			{label = "Play only this lane", action_id = "25483" },
			{label = "Play only this lane while mouse button is pressed", action_id = "25486" },
			{label = "Select items in lane", action_id = "25481" },
			{label = "Toggle playing this lane", action_id = "25485" },
			{label = "Toggle selection of items in lane", action_id = "25482" },
		},
	},
	
	{ -- MIDI
		label = "MIDI", children = {
			{
				label = "MIDI CC event left click/drag", children = {
					{label = "No action", action_id = "39384" },
					{label = "Copy CC event", action_id = "39390" },
					{label = "Copy CC event ignoring snap", action_id = "39391" },
					{label = "Delete CC events", action_id = "39387" },
					{label = "Draw/edit CC events ignoring selection", action_id = "39402" },
					{label = "Draw/edit CC events ignoring snap and selection", action_id = "39404" },
					{label = "Edit CC events", action_id = "39408" },
					{label = "Edit CC events ignoring selection", action_id = "39407" },
					{label = "Edit selected CC events if any, otherwise draw/edit", action_id = "39405" },
					{label = "Edit selected CC events if any, otherwise draw/edit ignoring snap", action_id = "39406" },
					{label = "Linear ramp CC events", action_id = "39409" },
					{label = "Linear ramp CC events ignoring selection", action_id = "39403" },
					{label = "Marquee add to CC selection", action_id = "39397" },
					{label = "Marquee select CC", action_id = "39395" },
					{label = "Marquee select CC and time", action_id = "39398" },
					{label = "Marquee select CC and time ignoring snap", action_id = "39399" },
					{label = "Marquee toggle CC selection", action_id = "39396" },
					{label = "Move CC event", action_id = "39385" },
					{label = "Move CC event ignoring snap", action_id = "39386" },
					{label = "Move CC event on one axis only", action_id = "39388" },
					{label = "Move CC event on one axis only ignoring snap", action_id = "39389" },
					{label = "Move CC horizontally", action_id = "39392" },
					{label = "Move CC horizontally ignoring snap", action_id = "39393" },
					{label = "Move CC vertically", action_id = "39394" },
					{label = "Reset CC events to default", action_id = "39410" },
					{label = "Select time", action_id = "39400" },
					{label = "Select time ignoring snap", action_id = "39401" },
					{label = "Set new default value for CC events", action_id = "39411" },
				},
			},
			{
				label = "MIDI CC lane left click/drag", children = {
					{label = "No action", action_id = "39352" },
					{label = "Delete CC events", action_id = "39355" },
					{label = "Deselect events", action_id = "39373" },
					{label = "Draw/edit CC events ignoring selection", action_id = "39353" },
					{label = "Draw/edit CC events ignoring snap and selection", action_id = "39358" },
					{label = "Edit CC events", action_id = "39368" },
					{label = "Edit CC events ignoring selection", action_id = "39359" },
					{label = "Edit selected CC events if any, otherwise draw/edit", action_id = "39354" },
					{label = "Edit selected CC events if any, otherwise draw/edit ignoring snap", action_id = "39360" },
					{label = "Insert CC event", action_id = "39369" },
					{label = "Insert CC event ignoring snap", action_id = "39370" },
					{label = "Linear ramp CC events", action_id = "39357" },
					{label = "Linear ramp CC events ignoring selection", action_id = "39356" },
					{label = "Marquee add to CC selection", action_id = "39363" },
					{label = "Marquee select CC", action_id = "39361" },
					{label = "Marquee select CC and time", action_id = "39364" },
					{label = "Marquee select CC and time ignoring snap", action_id = "39365" },
					{label = "Marquee toggle CC selection", action_id = "39362" },
					{label = "Reset CC events to default", action_id = "39371" },
					{label = "Select time", action_id = "39366" },
					{label = "Select time ignoring snap", action_id = "39367" },
					{label = "Set new default value for CC events", action_id = "39372" },
				},
			},
			{
				label = "MIDI CC segment left click/drag", children = {
					{label = "No action", action_id = "25320" },
					{label = "Draw/edit CC events ignoring selection", action_id = "25324" },
					{label = "Draw/edit CC events ignoring snap and selection", action_id = "25325" },
					{label = "Edit CC segment curvature", action_id = "25327" },
					{label = "Insert CC event", action_id = "25322" },
					{label = "Insert CC event ignoring snap", action_id = "25323" },
					{label = "Move CC segment", action_id = "25326" },
					{label = "Move CC segment ignoring time selection", action_id = "25321" },
				},
			},
			{
				label = "MIDI editor right drag", children = {
					{label = "No action", action_id = "39448" },
					{label = "Delete notes/CC", action_id = "39454" },
					{label = "Delete notes/CC immediately (suppress right-click context menu)", action_id = "39458" },
					{label = "Hand scroll", action_id = "39457" },
					{label = "Marquee add to notes/CC selection", action_id = "39456" },
					{label = "Marquee select notes/CC", action_id = "39449" },
					{label = "Marquee select notes/CC and time", action_id = "39450" },
					{label = "Marquee select notes/CC and time ignoring snap", action_id = "39451" },
					{label = "Marquee toggle note/CC selection", action_id = "39455" },
					{label = "Select notes touched while dragging", action_id = "39459" },
					{label = "Select time", action_id = "39452" },
					{label = "Select time ignoring snap", action_id = "39453" },
					{label = "Toggle selection for notes touched while dragging", action_id = "39460" },
				},
			},
			{
				label = "MIDI marker/region lanes left drag", children = {
					{label = "No action", action_id = "25032" },
					{label = "Hand scroll", action_id = "25033" },
					{label = "Hand scroll and horizontal zoom", action_id = "25034" },
					{label = "Hand scroll and reverse horizontal zoom (deprecated)", action_id = "25035" },
					{label = "Horizontal zoom", action_id = "25036" },
					{label = "Reverse horizontal zoom (deprecated)", action_id = "25037" },
					{label = "Set edit cursor and hand scroll", action_id = "25040" },
					{label = "Set edit cursor and horizontal zoom", action_id = "25038" },
					{label = "Set edit cursor and reverse horizontal zoom (deprecated)", action_id = "25039" },
					{label = "Set edit cursor, hand scroll and horizontal zoom", action_id = "25041" },
					{label = "Set edit cursor, hand scroll and reverse horizontal zoom (deprecated)", action_id = "25042" },
				},
			},
			{
				label = "MIDI note edge left drag", children = {
					{label = "No action", action_id = "39320" },
					{label = "Move note edge", action_id = "39321" },
					{label = "Move note edge ignoring selection", action_id = "39325" },
					{label = "Move note edge ignoring snap", action_id = "39322" },
					{label = "Move note edge ignoring snap and selection", action_id = "39326" },
					{label = "Stretch notes", action_id = "39323" },
					{label = "Stretch notes ignoring snap", action_id = "39324" },
				},
			},
			{
				label = "MIDI note left click", children = {
					{label = "No action", action_id = "39672" },
					{label = "Add a range of notes to selection", action_id = "39677" },
					{label = "Add a range of notes to selection and set time selection to selected notes", action_id = "39691" },
					{label = "Add all notes in measure to selection", action_id = "39689" },
					{label = "Add note and all later notes of same pitch to selection", action_id = "39687" },
					{label = "Add note and all later notes to selection", action_id = "39685" },
					{label = "Double note length", action_id = "39682" },
					{label = "Erase note", action_id = "39678" },
					{label = "Halve note length", action_id = "39683" },
					{label = "Select all notes in measure", action_id = "39688" },
					{label = "Select note", action_id = "39673" },
					{label = "Select note and all later notes", action_id = "39684" },
					{label = "Select note and all later notes of same pitch", action_id = "39686" },
					{label = "Select note and move edit cursor", action_id = "39674" },
					{label = "Select note and move edit cursor ignoring snap", action_id = "39675" },
					{label = "Set note channel higher", action_id = "39680" },
					{label = "Set note channel lower", action_id = "39681" },
					{label = "Toggle note mute", action_id = "39679" },
					{label = "Toggle note selection", action_id = "39676" },
					{label = "Toggle note selection and set time selection to selected notes", action_id = "39690" },
				},
			},
			{
				label = "MIDI note left drag", children = {
					{label = "No action", action_id = "39288" },
					{label = "Copy note", action_id = "39295" },
					{label = "Copy note horizontally", action_id = "39313" },
					{label = "Copy note horizontally ignoring snap", action_id = "39314" },
					{label = "Copy note ignoring snap", action_id = "39296" },
					{label = "Copy note vertically", action_id = "39315" },
					{label = "Edit note velocity", action_id = "39297" },
					{label = "Edit note velocity (fine)", action_id = "39298" },
					{label = "Erase notes", action_id = "39291" },
					{label = "Marquee add to note selection", action_id = "39305" },
					{label = "Marquee select notes", action_id = "39303" },
					{label = "Marquee select notes and time", action_id = "39306" },
					{label = "Marquee select notes and time ignoring snap", action_id = "39307" },
					{label = "Marquee toggle note selection", action_id = "39304" },
					{label = "Move note", action_id = "39289" },
					{label = "Move note horizontally", action_id = "39299" },
					{label = "Move note horizontally ignoring snap", action_id = "39300" },
					{label = "Move note ignoring selection", action_id = "39318" },
					{label = "Move note ignoring snap", action_id = "39290" },
					{label = "Move note ignoring snap and selection", action_id = "39319" },
					{label = "Move note on one axis only", action_id = "39293" },
					{label = "Move note on one axis only ignoring snap", action_id = "39294" },
					{label = "Move note vertically", action_id = "39301" },
					{label = "Move note vertically ignoring scale/key", action_id = "27288" },
					{label = "Move note vertically ignoring scale/key", action_id = "27289" },
					{label = "Select notes touched while dragging", action_id = "39316" },
					{label = "Select time", action_id = "39292" },
					{label = "Select time ignoring snap", action_id = "39302" },
					{label = "Stretch note lengths (arpeggiate legato)", action_id = "39312" },
					{label = "Stretch note lengths ignoring snap (arpeggiate legato)", action_id = "39311" },
					{label = "Stretch note positions (arpeggiate)", action_id = "39309" },
					{label = "Stretch note positions ignoring snap (arpeggiate)", action_id = "39308" },
					{label = "Stretch note selection vertically (arpeggiate)", action_id = "39310" },
					{label = "Toggle selection for notes touched while dragging", action_id = "39317" },
				},
			},
			{
				label = "MIDI piano roll left click", children = {
					{label = "No action", action_id = "39704" },
					{label = "Deselect all notes", action_id = "39707" },
					{label = "Deselect all notes and move edit cursor", action_id = "39705" },
					{label = "Deselect all notes and move edit cursor ignoring snap", action_id = "39706" },
					{label = "Insert note", action_id = "39708" },
					{label = "Insert note ignoring snap", action_id = "39709" },
					{label = "Insert note ignoring snap, leaving other notes selected", action_id = "39713" },
					{label = "Insert note, leaving other notes selected", action_id = "39712" },
					{label = "Set draw channel higher", action_id = "39710" },
					{label = "Set draw channel lower", action_id = "39711" },
				},
			},
			{
				label = "MIDI piano roll left drag", children = {
					{label = "No action", action_id = "39480" },
					{label = "Copy selected notes", action_id = "39507" },
					{label = "Copy selected notes ignoring snap", action_id = "39508" },
					{label = "Erase notes", action_id = "39483" },
					{label = "Insert note", action_id = "39511" },
					{label = "Insert note ignoring scale/key, drag to extend or change pitch", action_id = "27483" },
					{label = "Insert note ignoring scale/key, drag to move", action_id = "27481" },
					{label = "Insert note ignoring snap", action_id = "27480" },
					{label = "Insert note ignoring snap and scale/key, drag to extend or change pitch", action_id = "27484" },
					{label = "Insert note ignoring snap and scale/key, drag to move", action_id = "27482" },
					{label = "Insert note ignoring snap, drag to edit velocity", action_id = "39498" },
					{label = "Insert note ignoring snap, drag to extend", action_id = "39495" },
					{label = "Insert note ignoring snap, drag to extend or change pitch", action_id = "39482" },
					{label = "Insert note ignoring snap, drag to move", action_id = "39497" },
					{label = "Insert note, drag to edit velocity", action_id = "39499" },
					{label = "Insert note, drag to extend", action_id = "39494" },
					{label = "Insert note, drag to extend or change pitch", action_id = "39481" },
					{label = "Insert note, drag to move", action_id = "39492" },
					{label = "Marquee add to note selection", action_id = "39489" },
					{label = "Marquee select notes", action_id = "39487" },
					{label = "Marquee select notes and time", action_id = "39490" },
					{label = "Marquee select notes and time ignoring snap", action_id = "39491" },
					{label = "Marquee toggle note selection", action_id = "39488" },
					{label = "Move selected notes", action_id = "39509" },
					{label = "Move selected notes ignoring snap", action_id = "39510" },
					{label = "Paint a row of notes of the same pitch", action_id = "39493" },
					{label = "Paint a stack of notes of the same time position", action_id = "39500" },
					{label = "Paint a straight line of notes", action_id = "39503" },
					{label = "Paint a straight line of notes ignoring snap", action_id = "39504" },
					{label = "Paint notes", action_id = "39502" },
					{label = "Paint notes and chords", action_id = "39485" },
					{label = "Paint notes ignoring snap", action_id = "39501" },
					{label = "Scrub preview MIDI", action_id = "39496" },
					{label = "Select notes touched while dragging", action_id = "39505" },
					{label = "Select time", action_id = "39484" },
					{label = "Select time ignoring snap", action_id = "39486" },
					{label = "Toggle selection for notes touched while dragging", action_id = "39506" },
				},
			},
			{
				label = "MIDI ruler left click", children = {
					{label = "No action", action_id = "39640" },
					{label = "Clear loop or time selection", action_id = "39644" },
					{label = "Move edit cursor", action_id = "39641" },
					{label = "Move edit cursor ignoring snap", action_id = "39642" },
					{label = "Select notes or CC in time selection", action_id = "39643" },
				},
			},
			{
				label = "MIDI ruler left drag", children = {
					{label = "No action", action_id = "39416" },
					{label = "Edit loop point (ruler) or time selection (piano roll)", action_id = "39417" },
					{label = "Edit loop point (ruler) or time selection (piano roll) ignoring snap", action_id = "39418" },
					{label = "Edit loop point and time selection together", action_id = "39421" },
					{label = "Edit loop point and time selection together ignoring snap", action_id = "39422" },
					{label = "Move loop points (ruler) or time selection (piano roll)", action_id = "39419" },
					{label = "Move loop points (ruler) or time selection (piano roll) ignoring snap", action_id = "39420" },
					{label = "Move loop points and time selection together", action_id = "39423" },
					{label = "Move loop points and time selection together ignoring snap", action_id = "39424" },
				},
			},
			{
				label = "MIDI source loop end marker left drag", children = {
					{label = "No action", action_id = "39960" },
					{label = "Edit MIDI source loop length", action_id = "39961" },
					{label = "Edit MIDI source loop length ignoring snap", action_id = "39962" },
					{label = "Stretch MIDI source loop length", action_id = "39963" },
					{label = "Stretch MIDI source loop length ignoring snap", action_id = "39964" },
				},
			},
		},
	},
	
	{ -- Media item
		label = "Media item", children = {
			{
				label = "Media item bottom half left click", children = {
					{label = "Add items to selection", action_id = "39549" },
					{label = "Add items to selection and extend time selection", action_id = "39554" },
					{label = "Add items to selection and extend time selection ignoring snap", action_id = "39555" },
					{label = "Add items to selection and set time selection to selected items", action_id = "39561" },
					{label = "Add items to selection, if already selected extend time selection", action_id = "39550" },
					{label = "Add items to selection, if already selected extend time selection ignoring snap", action_id = "39551" },
					{label = "Add stretch marker", action_id = "39559" },
					{label = "Add/edit take marker", action_id = "39562" },
					{label = "Extend razor edit area", action_id = "39564" },
					{label = "Extend time selection", action_id = "39552" },
					{label = "Extend time selection ignoring snap", action_id = "39553" },
					{label = "Pass through to item click context", action_id = "39544" },
					{label = "Restore previous zoom", action_id = "39558" },
					{label = "Restore previous zoom/scroll", action_id = "39557" },
					{label = "Select item", action_id = "39547" },
					{label = "Select item and move edit cursor", action_id = "39545" },
					{label = "Select item and move edit cursor ignoring snap", action_id = "39546" },
					{label = "Select item ignoring grouping", action_id = "39556" },
					{label = "Select razor edit area", action_id = "39563" },
					{label = "Toggle item selection", action_id = "39548" },
					{label = "Toggle item selection and set time selection to selected items", action_id = "39560" },
				},
			},
			{
				label = "Media item bottom half left drag", children = {
					{label = "Add spectral edit to all channels", action_id = "29971" },
					{label = "Add spectral edit to one channel", action_id = "29972" },
					{label = "Add to razor edit area", action_id = "29967" },
					{label = "Add to razor edit area ignoring snap", action_id = "29968" },
					{label = "Adjust item volume", action_id = "39052" },
					{label = "Adjust item volume (fine)", action_id = "39053" },
					{label = "Adjust take pan", action_id = "27047" },
					{label = "Adjust take pitch (fine)", action_id = "39044" },
					{label = "Adjust take pitch (semitones)", action_id = "39043" },
					{label = "Copy item", action_id = "39034" },
					{label = "Copy item and move time selection", action_id = "39056" },
					{label = "Copy item and move time selection ignoring snap", action_id = "39057" },
					{label = "Copy item and move time selection ignoring snap, pooling MIDI source data", action_id = "27046" },
					{label = "Copy item and move time selection, pooling MIDI source data", action_id = "27045" },
					{label = "Copy item ignoring snap", action_id = "39037" },
					{label = "Copy item ignoring snap and time selection", action_id = "39050" },
					{label = "Copy item ignoring snap and time selection, pooling MIDI source data", action_id = "27042" },
					{label = "Copy item ignoring snap, pooling MIDI source data", action_id = "27040" },
					{label = "Copy item ignoring time selection", action_id = "39049" },
					{label = "Copy item ignoring time selection, pooling MIDI source data", action_id = "27041" },
					{label = "Copy item vertically", action_id = "27036" },
					{label = "Copy item vertically ignoring time selection", action_id = "27037" },
					{label = "Copy item vertically ignoring time selection, pooling MIDI source data", action_id = "27044" },
					{label = "Copy item vertically, pooling MIDI source data", action_id = "27043" },
					{label = "Copy item, pooling MIDI source data", action_id = "27039" },
					{label = "Marquee add to item selection", action_id = "39063" },
					{label = "Marquee select items", action_id = "39059" },
					{label = "Marquee select items and time", action_id = "39060" },
					{label = "Marquee select items and time ignoring snap", action_id = "39061" },
					{label = "Marquee toggle item selection", action_id = "39062" },
					{label = "Marquee zoom", action_id = "27048" },
					{label = "Move item", action_id = "39033" },
					{label = "Move item and time selection", action_id = "39054" },
					{label = "Move item and time selection ignoring snap", action_id = "39055" },
					{label = "Move item contents", action_id = "27058" },
					{label = "Move item contents and right edge ignoring snap, ripple later adjacent items", action_id = "27057" },
					{label = "Move item contents ignoring selection/grouping", action_id = "27059" },
					{label = "Move item contents ignoring snap", action_id = "39035" },
					{label = "Move item contents ignoring snap and selection/grouping", action_id = "27038" },
					{label = "Move item contents ignoring snap, ripple all adjacent items", action_id = "27055" },
					{label = "Move item contents ignoring snap, ripple earlier adjacent items", action_id = "27056" },
					{label = "Move item edges but not contents", action_id = "39038" },
					{label = "Move item ignoring selection/grouping", action_id = "39041" },
					{label = "Move item ignoring snap", action_id = "39036" },
					{label = "Move item ignoring snap and selection/grouping", action_id = "39042" },
					{label = "Move item ignoring snap and time selection", action_id = "39046" },
					{label = "Move item ignoring snap and time selection, disabling ripple edit", action_id = "27052" },
					{label = "Move item ignoring snap and time selection, enabling ripple edit for all tracks", action_id = "27054" },
					{label = "Move item ignoring snap and time selection, enabling ripple edit for this track", action_id = "27053" },
					{label = "Move item ignoring snap, time selection, and selection/grouping", action_id = "39048" },
					{label = "Move item ignoring time selection", action_id = "39045" },
					{label = "Move item ignoring time selection and selection/grouping", action_id = "39047" },
					{label = "Move item ignoring time selection, disabling ripple edit", action_id = "27049" },
					{label = "Move item ignoring time selection, enabling ripple edit for all tracks", action_id = "27051" },
					{label = "Move item ignoring time selection, enabling ripple edit for this track", action_id = "27050" },
					{label = "Move item loop section contents", action_id = "27061" },
					{label = "Move item loop section contents ignoring snap", action_id = "27060" },
					{label = "Move item vertically", action_id = "27032" },
					{label = "Move item vertically ignoring selection/grouping", action_id = "27033" },
					{label = "Move item vertically ignoring time selection", action_id = "27034" },
					{label = "Move item vertically ignoring time selection and selection/grouping", action_id = "27035" },
					{label = "Open source file in editor or external application", action_id = "39040" },
					{label = "Pass through to item drag context", action_id = "39032" },
					{label = "Render item to new file", action_id = "39039" },
					{label = "Select razor edit area", action_id = "27062" },
					{label = "Select razor edit area and time", action_id = "29969" },
					{label = "Select razor edit area and time ignoring snap", action_id = "29970" },
					{label = "Select razor edit area ignoring snap", action_id = "27063" },
					{label = "Select time", action_id = "39051" },
					{label = "Select time ignoring snap", action_id = "39058" },
				},
			},
			{
				label = "Media item edge left drag", children = {
					{label = "No action", action_id = "39064" },
					{label = "Add to razor edit area", action_id = "39087" },
					{label = "Add to razor edit area ignoring snap", action_id = "39088" },
					{label = "Adjust loop section start/end", action_id = "39083" },
					{label = "Adjust loop section start/end ignoring snap", action_id = "39084" },
					{label = "Move edge", action_id = "39065" },
					{label = "Move edge (relative edge edit)", action_id = "39073" },
					{label = "Move edge ignoring selection/grouping", action_id = "39069" },
					{label = "Move edge ignoring selection/grouping without changing fade time", action_id = "39079" },
					{label = "Move edge ignoring snap", action_id = "39067" },
					{label = "Move edge ignoring snap (relative edge edit)", action_id = "39075" },
					{label = "Move edge ignoring snap and selection/grouping", action_id = "39071" },
					{label = "Move edge ignoring snap and selection/grouping without changing fade time", action_id = "39080" },
					{label = "Move edge ignoring snap without changing fade time", action_id = "39078" },
					{label = "Move edge ignoring snap without changing fade time (relative edge edit)", action_id = "39082" },
					{label = "Move edge without changing fade time", action_id = "39077" },
					{label = "Move edge without changing fade time (relative edge edit)", action_id = "39081" },
					{label = "Select razor edit area", action_id = "39085" },
					{label = "Select razor edit area and time", action_id = "39089" },
					{label = "Select razor edit area and time ignoring snap", action_id = "39090" },
					{label = "Select razor edit area ignoring snap", action_id = "39086" },
					{label = "Stretch item", action_id = "39066" },
					{label = "Stretch item (relative edge edit)", action_id = "39074" },
					{label = "Stretch item ignoring selection/grouping", action_id = "39070" },
					{label = "Stretch item ignoring snap", action_id = "39068" },
					{label = "Stretch item ignoring snap (relative edge edit)", action_id = "39076" },
					{label = "Stretch item ignoring snap and selection/grouping", action_id = "39072" },
				},
			},
			{
				label = "Media item fade intersection left click", children = {
					{label = "No action", action_id = "39896" },
					{label = "Open crossfade editor", action_id = "39901" },
					{label = "Set both fades to next shape", action_id = "39897" },
					{label = "Set both fades to next shape ignoring selection", action_id = "39899" },
					{label = "Set both fades to previous shape", action_id = "39898" },
					{label = "Set both fades to previous shape ignoring selection", action_id = "39900" },
				},
			},
			{
				label = "Media item fade intersection left drag", children = {
					{label = "No action", action_id = "39864" },
					{label = "Adjust both fade curves horizontally", action_id = "39871" },
					{label = "Adjust both fade curves horizontally and vertically", action_id = "39876" },
					{label = "Adjust both fade curves horizontally and vertically ignoring selection/grouping", action_id = "39877" },
					{label = "Adjust both fade curves horizontally ignoring selection/grouping", action_id = "39872" },
					{label = "Adjust length of both fades preserving intersection", action_id = "39884" },
					{label = "Adjust length of both fades preserving intersection (relative edge edit)", action_id = "39886" },
					{label = "Adjust length of both fades preserving intersection ignoring selection/grouping", action_id = "39885" },
					{label = "Adjust length of both fades preserving intersection ignoring snap", action_id = "39873" },
					{label = "Adjust length of both fades preserving intersection ignoring snap (relative edge edit)", action_id = "39875" },
					{label = "Adjust length of both fades preserving intersection ignoring snap and selection/grouping", action_id = "39874" },
					{label = "Move both fades", action_id = "39878" },
					{label = "Move both fades (relative edge edit)", action_id = "39880" },
					{label = "Move both fades and stretch items", action_id = "39881" },
					{label = "Move both fades and stretch items (relative edge edit)", action_id = "39883" },
					{label = "Move both fades and stretch items ignoring selection/grouping", action_id = "39882" },
					{label = "Move both fades and stretch items ignoring snap", action_id = "39868" },
					{label = "Move both fades and stretch items ignoring snap (relative edge edit)", action_id = "39870" },
					{label = "Move both fades and stretch items ignoring snap and selection/grouping", action_id = "39869" },
					{label = "Move both fades ignoring selection/grouping", action_id = "39879" },
					{label = "Move both fades ignoring snap", action_id = "39865" },
					{label = "Move both fades ignoring snap (relative edge edit)", action_id = "39867" },
					{label = "Move both fades ignoring snap and selection/grouping", action_id = "39866" },
				},
			},
			{
				label = "Media item fade/autocrossfade left click", children = {
					{label = "No action", action_id = "39736" },
					{label = "Delete fade/crossfade", action_id = "39737" },
					{label = "Delete fade/crossfade ignoring selection", action_id = "39738" },
					{label = "Open crossfade editor", action_id = "39743" },
					{label = "Set fade/crossfade to next shape", action_id = "39739" },
					{label = "Set fade/crossfade to next shape ignoring selection", action_id = "39742" },
					{label = "Set fade/crossfade to previous shape", action_id = "39740" },
					{label = "Set fade/crossfade to previous shape ignoring selection", action_id = "39741" },
				},
			},
			{
				label = "Media item fade/autocrossfade left drag", children = {
					{label = "No action", action_id = "39096" },
					{label = "Adjust fade curve", action_id = "39109" },
					{label = "Adjust fade curve (relative edge edit)", action_id = "27099" },
					{label = "Adjust fade curve ignoring crossfaded items", action_id = "39111" },
					{label = "Adjust fade curve ignoring crossfaded items and selection/grouping", action_id = "39112" },
					{label = "Adjust fade curve ignoring selection/grouping", action_id = "39110" },
					{label = "Move crossfade", action_id = "39117" },
					{label = "Move crossfade (relative edge edit)", action_id = "39125" },
					{label = "Move crossfade and stretch items", action_id = "39119" },
					{label = "Move crossfade and stretch items (relative edge edit)", action_id = "39127" },
					{label = "Move crossfade and stretch items ignoring selection/grouping", action_id = "39123" },
					{label = "Move crossfade and stretch items ignoring snap", action_id = "39100" },
					{label = "Move crossfade and stretch items ignoring snap (relative edge edit)", action_id = "39108" },
					{label = "Move crossfade and stretch items ignoring snap and selection/grouping", action_id = "39104" },
					{label = "Move crossfade ignoring selection/grouping", action_id = "39121" },
					{label = "Move crossfade ignoring snap", action_id = "39098" },
					{label = "Move crossfade ignoring snap (relative edge edit)", action_id = "39106" },
					{label = "Move crossfade ignoring snap and selection/grouping", action_id = "39102" },
					{label = "Move fade", action_id = "39116" },
					{label = "Move fade (relative edge edit)", action_id = "39124" },
					{label = "Move fade and stretch crossfaded items", action_id = "39118" },
					{label = "Move fade and stretch crossfaded items (relative edge edit)", action_id = "39126" },
					{label = "Move fade and stretch crossfaded items ignoring selection/grouping", action_id = "39122" },
					{label = "Move fade and stretch crossfaded items ignoring snap", action_id = "39099" },
					{label = "Move fade and stretch crossfaded items ignoring snap (relative edge edit)", action_id = "39107" },
					{label = "Move fade and stretch crossfaded items ignoring snap and selection/grouping", action_id = "39103" },
					{label = "Move fade ignoring crossfaded items", action_id = "27096" },
					{label = "Move fade ignoring crossfaded items (relative edge edit)", action_id = "27098" },
					{label = "Move fade ignoring crossfaded items and selection/grouping", action_id = "27097" },
					{label = "Move fade ignoring selection/grouping", action_id = "39120" },
					{label = "Move fade ignoring snap", action_id = "39097" },
					{label = "Move fade ignoring snap (relative edge edit)", action_id = "39105" },
					{label = "Move fade ignoring snap and crossfaded items", action_id = "39113" },
					{label = "Move fade ignoring snap and crossfaded items (relative edge edit)", action_id = "39115" },
					{label = "Move fade ignoring snap and selection/grouping", action_id = "39101" },
					{label = "Move fade ignoring snap, selection/grouping, and crossfaded items", action_id = "39114" },
				},
			},
			{
				label = "Media item left click", children = {
					{label = "No action", action_id = "39512" },
					{label = "Add items to selection", action_id = "39517" },
					{label = "Add items to selection and extend time selection", action_id = "39522" },
					{label = "Add items to selection and extend time selection ignoring snap", action_id = "39523" },
					{label = "Add items to selection and set time selection to selected items", action_id = "39529" },
					{label = "Add items to selection, if already selected extend time selection", action_id = "39518" },
					{label = "Add items to selection, if already selected extend time selection ignoring snap", action_id = "39519" },
					{label = "Add stretch marker", action_id = "39527" },
					{label = "Add/edit take marker", action_id = "39530" },
					{label = "Extend razor edit area", action_id = "39532" },
					{label = "Extend time selection", action_id = "39520" },
					{label = "Extend time selection ignoring snap", action_id = "39521" },
					{label = "Restore previous zoom", action_id = "39526" },
					{label = "Restore previous zoom/scroll", action_id = "39525" },
					{label = "Select item", action_id = "39515" },
					{label = "Select item and move edit cursor", action_id = "39513" },
					{label = "Select item and move edit cursor ignoring snap", action_id = "39514" },
					{label = "Select item ignoring grouping", action_id = "39524" },
					{label = "Select razor edit area", action_id = "39531" },
					{label = "Toggle item selection", action_id = "39516" },
					{label = "Toggle item selection and set time selection to selected items", action_id = "39528" },
				},
			},
			{
				label = "Media item left drag", children = {
					{label = "No action", action_id = "39000" },
					{label = "Add spectral edit to all channels", action_id = "26971" },
					{label = "Add spectral edit to one channel", action_id = "26972" },
					{label = "Add to razor edit area", action_id = "26967" },
					{label = "Add to razor edit area ignoring snap", action_id = "26968" },
					{label = "Adjust item volume", action_id = "39020" },
					{label = "Adjust item volume (fine)", action_id = "39021" },
					{label = "Adjust take pan", action_id = "27015" },
					{label = "Adjust take pitch (fine)", action_id = "39012" },
					{label = "Adjust take pitch (semitones)", action_id = "39011" },
					{label = "Copy item", action_id = "39002" },
					{label = "Copy item and move time selection", action_id = "39024" },
					{label = "Copy item and move time selection ignoring snap", action_id = "39025" },
					{label = "Copy item and move time selection ignoring snap, pooling MIDI source data", action_id = "27014" },
					{label = "Copy item and move time selection, pooling MIDI source data", action_id = "27013" },
					{label = "Copy item ignoring snap", action_id = "39005" },
					{label = "Copy item ignoring snap and time selection", action_id = "39018" },
					{label = "Copy item ignoring snap and time selection, pooling MIDI source data", action_id = "27010" },
					{label = "Copy item ignoring snap, pooling MIDI source data", action_id = "27008" },
					{label = "Copy item ignoring time selection", action_id = "39017" },
					{label = "Copy item ignoring time selection, pooling MIDI source data", action_id = "27009" },
					{label = "Copy item vertically", action_id = "27004" },
					{label = "Copy item vertically ignoring time selection", action_id = "27005" },
					{label = "Copy item vertically ignoring time selection, pooling MIDI source data", action_id = "27012" },
					{label = "Copy item vertically, pooling MIDI source data", action_id = "27011" },
					{label = "Copy item, pooling MIDI source data", action_id = "27007" },
					{label = "Marquee add to item selection", action_id = "39031" },
					{label = "Marquee select items", action_id = "39027" },
					{label = "Marquee select items and time", action_id = "39028" },
					{label = "Marquee select items and time ignoring snap", action_id = "39029" },
					{label = "Marquee toggle item selection", action_id = "39030" },
					{label = "Marquee zoom", action_id = "27016" },
					{label = "Move item", action_id = "39001" },
					{label = "Move item and time selection", action_id = "39022" },
					{label = "Move item and time selection ignoring snap", action_id = "39023" },
					{label = "Move item contents", action_id = "27026" },
					{label = "Move item contents and right edge ignoring snap, ripple later adjacent items", action_id = "27025" },
					{label = "Move item contents ignoring selection/grouping", action_id = "27027" },
					{label = "Move item contents ignoring snap", action_id = "39003" },
					{label = "Move item contents ignoring snap and selection/grouping", action_id = "27006" },
					{label = "Move item contents ignoring snap, ripple all adjacent items", action_id = "27023" },
					{label = "Move item contents ignoring snap, ripple earlier adjacent items", action_id = "27024" },
					{label = "Move item edges but not contents", action_id = "39006" },
					{label = "Move item ignoring selection/grouping", action_id = "39009" },
					{label = "Move item ignoring snap", action_id = "39004" },
					{label = "Move item ignoring snap and selection/grouping", action_id = "39010" },
					{label = "Move item ignoring snap and time selection", action_id = "39014" },
					{label = "Move item ignoring snap and time selection, disabling ripple edit", action_id = "27020" },
					{label = "Move item ignoring snap and time selection, enabling ripple edit for all tracks", action_id = "27022" },
					{label = "Move item ignoring snap and time selection, enabling ripple edit for this track", action_id = "27021" },
					{label = "Move item ignoring snap, time selection, and selection/grouping", action_id = "39016" },
					{label = "Move item ignoring time selection", action_id = "39013" },
					{label = "Move item ignoring time selection and selection/grouping", action_id = "39015" },
					{label = "Move item ignoring time selection, disabling ripple edit", action_id = "27017" },
					{label = "Move item ignoring time selection, enabling ripple edit for all tracks", action_id = "27019" },
					{label = "Move item ignoring time selection, enabling ripple edit for this track", action_id = "27018" },
					{label = "Move item loop section contents", action_id = "27029" },
					{label = "Move item loop section contents ignoring snap", action_id = "27028" },
					{label = "Move item vertically", action_id = "27000" },
					{label = "Move item vertically ignoring selection/grouping", action_id = "27001" },
					{label = "Move item vertically ignoring time selection", action_id = "27002" },
					{label = "Move item vertically ignoring time selection and selection/grouping", action_id = "27003" },
					{label = "Open source file in editor or external application", action_id = "39008" },
					{label = "Render item to new file", action_id = "39007" },
					{label = "Select razor edit area", action_id = "27030" },
					{label = "Select razor edit area and time", action_id = "26969" },
					{label = "Select razor edit area and time ignoring snap", action_id = "26970" },
					{label = "Select razor edit area ignoring snap", action_id = "27031" },
					{label = "Select time", action_id = "39019" },
					{label = "Select time ignoring snap", action_id = "39026" },
				},
			},
			{
				label = "Media item stretch marker left drag", children = {
					{label = "No action", action_id = "39928" },
					{label = "Move contents under stretch marker", action_id = "39933" },
					{label = "Move contents under stretch marker ignoring selection/grouping", action_id = "39934" },
					{label = "Move contents under stretch marker pair", action_id = "39939" },
					{label = "Move contents under stretch marker pair ignoring selection/grouping", action_id = "39940" },
					{label = "Move stretch marker", action_id = "39929" },
					{label = "Move stretch marker ignoring selection/grouping", action_id = "39931" },
					{label = "Move stretch marker ignoring snap", action_id = "39930" },
					{label = "Move stretch marker ignoring snap and selection/grouping", action_id = "39932" },
					{label = "Move stretch marker pair", action_id = "39935" },
					{label = "Move stretch marker pair ignoring selection/grouping", action_id = "39937" },
					{label = "Move stretch marker pair ignoring snap", action_id = "39936" },
					{label = "Move stretch marker pair ignoring snap and selection/grouping", action_id = "39938" },
					{label = "Move stretch marker preserving all rates (rate envelope mode)", action_id = "39951" },
					{label = "Move stretch marker preserving all rates (rate envelope mode) ignoring selection/grouping", action_id = "39953" },
					{label = "Move stretch marker preserving all rates (rate envelope mode) ignoring snap", action_id = "39952" },
					{label = "Move stretch marker preserving all rates (rate envelope mode) ignoring snap and selection/grouping", action_id = "39954" },
					{label = "Move stretch marker preserving left-hand rate", action_id = "39947" },
					{label = "Move stretch marker preserving left-hand rate ignoring selection/grouping", action_id = "39949" },
					{label = "Move stretch marker preserving left-hand rate ignoring snap", action_id = "39948" },
					{label = "Move stretch marker preserving left-hand rate ignoring snap and selection/grouping", action_id = "39950" },
					{label = "Ripple contents under stretch markers", action_id = "39945" },
					{label = "Ripple contents under stretch markers ignoring selection/grouping", action_id = "39946" },
					{label = "Ripple move stretch markers", action_id = "39941" },
					{label = "Ripple move stretch markers ignoring selection/grouping", action_id = "39943" },
					{label = "Ripple move stretch markers ignoring snap", action_id = "39942" },
					{label = "Ripple move stretch markers ignoring snap and selection/grouping", action_id = "39944" },
				},
			},
			{
				label = "Media item stretch marker rate left drag", children = {
					{label = "No action", action_id = "25064" },
					{label = "Edit stretch marker rate", action_id = "25065" },
					{label = "Edit stretch marker rate ignoring selection/grouping", action_id = "25073" },
					{label = "Edit stretch marker rate preserving marker positions (rate envelope mode)", action_id = "25067" },
					{label = "Edit stretch marker rate preserving marker positions (rate envelope mode), ignoring selection/grouping", action_id = "25075" },
					{label = "Edit stretch marker rate, move contents under marker, ripple markers", action_id = "25069" },
					{label = "Edit stretch marker rate, move contents under marker, ripple markers, ignoring selection/grouping", action_id = "25077" },
					{label = "Edit stretch marker rate, ripple markers", action_id = "25071" },
					{label = "Edit stretch marker rate, ripple markers, ignoring selection/grouping", action_id = "25079" },
					{label = "Edit stretch marker rates on both sides", action_id = "25066" },
					{label = "Edit stretch marker rates on both sides ignoring selection/grouping", action_id = "25074" },
					{label = "Edit stretch marker rates on both sides preserving marker positions (rate envelope mode)", action_id = "25068" },
					{label = "Edit stretch marker rates on both sides preserving marker positions (rate envelope mode), ignoring selection/grouping", action_id = "25076" },
					{label = "Edit stretch marker rates on both sides, move contents under marker, ignoring selection/grouping, ripple markers", action_id = "25078" },
					{label = "Edit stretch marker rates on both sides, move contents under marker, ripple markers", action_id = "25070" },
					{label = "Edit stretch marker rates on both sides, ripple markers", action_id = "25072" },
					{label = "Edit stretch marker rates on both sides, ripple markers, ignoring selection/grouping", action_id = "25080" },
				},
			},
		},
	},
	
	{ -- Project
		label = "Project", children = {
			{
				label = "Project marker/region edge left drag", children = {
					{label = "No action", action_id = "25256" },
					{label = "Move project marker/region edge", action_id = "25257" },
					{label = "Move project marker/region edge ignoring snap", action_id = "25258" },
				},
			},
			{
				label = "Project marker/region lane left drag", children = {
					{label = "No action", action_id = "25000" },
					{label = "Hand scroll", action_id = "25001" },
					{label = "Hand scroll and horizontal zoom", action_id = "25002" },
					{label = "Hand scroll and reverse horizontal zoom (deprecated)", action_id = "25003" },
					{label = "Horizontal zoom", action_id = "25004" },
					{label = "Reverse horizontal zoom (deprecated)", action_id = "25005" },
					{label = "Set edit cursor and hand scroll", action_id = "25008" },
					{label = "Set edit cursor and horizontal zoom", action_id = "25006" },
					{label = "Set edit cursor and reverse horizontal zoom (deprecated)", action_id = "25007" },
					{label = "Set edit cursor, hand scroll and horizontal zoom", action_id = "25009" },
					{label = "Set edit cursor, hand scroll and reverse horizontal zoom (deprecated)", action_id = "25010" },
				},
			},
			{
				label = "Project region left drag", children = {
					{label = "No action", action_id = "25224" },
					{label = "Copy contents of project region", action_id = "25227" },
					{label = "Copy contents of project region ignoring snap", action_id = "25228" },
					{label = "Copy project region but not contents", action_id = "25231" },
					{label = "Copy project region but not contents ignoring snap", action_id = "25232" },
					{label = "Move contents of project region", action_id = "25225" },
					{label = "Move contents of project region ignoring snap", action_id = "25226" },
					{label = "Move project region but not contents", action_id = "25229" },
					{label = "Move project region but not contents ignoring snap", action_id = "25230" },
				},
			},
			{
				label = "Project tempo/time signature marker left drag", children = {
					{label = "No action", action_id = "25288" },
					{label = "Move project tempo/time signature marker", action_id = "25289" },
					{label = "Move project tempo/time signature marker ignoring snap", action_id = "25290" },
					{label = "Move project tempo/time signature marker, adjusting previous and current tempo", action_id = "25292" },
					{label = "Move project tempo/time signature marker, adjusting previous tempo", action_id = "25291" },
				},
			},
		},
	},
	
	{ -- Razor
		label = "Razor", children = {
			{
				label = "Razor edit area left click", children = {
					{label = "No action", action_id = "25416" },
					{label = "Delete area contents", action_id = "25418" },
					{label = "Move areas backwards without contents", action_id = "25421" },
					{label = "Move areas down without contents", action_id = "25424" },
					{label = "Move areas forwards without contents", action_id = "25422" },
					{label = "Move areas up without contents", action_id = "25423" },
					{label = "Remove areas", action_id = "25419" },
					{label = "Remove one area", action_id = "25417" },
					{label = "Split media items at area edges", action_id = "25420" },
				},
			},
			{
				label = "Razor edit area left drag", children = {
					{label = "No action", action_id = "25352" },
					{label = "Copy areas", action_id = "25355" },
					{label = "Copy areas horizontally", action_id = "25364" },
					{label = "Copy areas horizontally ignoring snap", action_id = "25366" },
					{label = "Copy areas ignoring envelope type", action_id = "25374" },
					{label = "Copy areas ignoring envelope type and snap", action_id = "25375" },
					{label = "Copy areas ignoring snap", action_id = "25356" },
					{label = "Copy areas on one axis only", action_id = "25367" },
					{label = "Copy areas on one axis only ignoring envelope type", action_id = "25377" },
					{label = "Copy areas on one axis only ignoring envelpe type and snap", action_id = "25378" },
					{label = "Copy areas on one axis only ignoring snap", action_id = "25368" },
					{label = "Copy areas vertically", action_id = "25361" },
					{label = "Copy areas vertically ignoring envelope type", action_id = "25376" },
					{label = "Move areas", action_id = "25353" },
					{label = "Move areas horizontally", action_id = "25362" },
					{label = "Move areas horizontally ignoring snap", action_id = "25365" },
					{label = "Move areas ignoring envelope type", action_id = "25369" },
					{label = "Move areas ignoring envelope type and snap", action_id = "25370" },
					{label = "Move areas ignoring snap", action_id = "25354" },
					{label = "Move areas ignoring snap, disabling ripple edit", action_id = "25382" },
					{label = "Move areas ignoring snap, enabling ripple edit for all tracks", action_id = "28344" },
					{label = "Move areas ignoring snap, enabling ripple edit for this track", action_id = "25383" },
					{label = "Move areas on one axis only", action_id = "25360" },
					{label = "Move areas on one axis only ignoring envelope type", action_id = "25372" },
					{label = "Move areas on one axis only ignoring envelpe type and snap", action_id = "25373" },
					{label = "Move areas on one axis only ignoring snap", action_id = "25363" },
					{label = "Move areas vertically", action_id = "25359" },
					{label = "Move areas vertically ignoring envelope type", action_id = "25371" },
					{label = "Move areas without contents", action_id = "25357" },
					{label = "Move areas without contents ignoring snap", action_id = "25358" },
					{label = "Move areas, disabling ripple edit", action_id = "25379" },
					{label = "Move areas, enabling ripple edit for all tracks", action_id = "25381" },
					{label = "Move areas, enabling ripple edit for this track", action_id = "25380" },
				},
			},
			{
				label = "Razor edit edge left drag", children = {
					{label = "No action", action_id = "25384" },
					{label = "Move edges", action_id = "25385" },
					{label = "Move edges ignoring snap", action_id = "25386" },
					{label = "Stretch areas", action_id = "25387" },
					{label = "Stretch areas ignoring snap", action_id = "25388" },
				},
			},
			{
				label = "Razor edit envelope area left drag", children = {
					{label = "No action", action_id = "25448" },
					{label = "Expand or compress envelope range", action_id = "25450" },
					{label = "Expand or compress envelope range toward top/bottom", action_id = "25451" },
					{label = "Move or tilt envelope vertically", action_id = "25449" },
					{label = "Move or tilt envelope vertically (fine)", action_id = "25452" },
				},
			},
		},
	},
	
	{ -- Ruler
		label = "Ruler", children = {
			{
				label = "Ruler left click", children = {
					{label = "No action", action_id = "39608" },
					{label = "Clear loop points", action_id = "39611" },
					{label = "Extend loop points", action_id = "39612" },
					{label = "Extend loop points ignoring snap", action_id = "39613" },
					{label = "Move edit cursor", action_id = "39609" },
					{label = "Move edit cursor ignoring snap", action_id = "39610" },
					{label = "Restore previous zoom level", action_id = "39616" },
					{label = "Restore previous zoom/scroll", action_id = "39615" },
					{label = "Seek playback without moving edit cursor", action_id = "39614" },
				},
			},
			{
				label = "Ruler left drag", children = {
					{label = "No action", action_id = "39224" },
					{label = "Edit loop point", action_id = "39225" },
					{label = "Edit loop point and time selection together", action_id = "39229" },
					{label = "Edit loop point and time selection together ignoring snap", action_id = "39230" },
					{label = "Edit loop point ignoring snap", action_id = "39226" },
					{label = "Hand scroll", action_id = "39233" },
					{label = "Hand scroll and horizontal zoom", action_id = "39234" },
					{label = "Hand scroll and reverse horizontal zoom (deprecated)", action_id = "39235" },
					{label = "Horizontal zoom", action_id = "39236" },
					{label = "Move loop points", action_id = "39227" },
					{label = "Move loop points and time selection together", action_id = "39231" },
					{label = "Move loop points and time selection together ignoring snap", action_id = "39232" },
					{label = "Move loop points ignoring snap", action_id = "39228" },
					{label = "Reverse horizontal zoom (deprecated)", action_id = "39237" },
					{label = "Set edit cursor and hand scroll", action_id = "39240" },
					{label = "Set edit cursor and horizontal zoom", action_id = "39238" },
					{label = "Set edit cursor and reverse horizontal zoom (deprecated)", action_id = "39239" },
					{label = "Set edit cursor, hand scroll and horizontal zoom", action_id = "39241" },
					{label = "Set edit cursor, hand scroll and reverse horizontal zoom (deprecated)", action_id = "39242" },
				},
			},
		},
	},
	
	{ -- Track
		label = "Track", children = {
			{
				label = "Track left click", children = {
					{label = "No action", action_id = "39576" },
					{label = "Clear time selection", action_id = "39580" },
					{label = "Deselect all items", action_id = "39579" },
					{label = "Deselect all items and move edit cursor", action_id = "39577" },
					{label = "Deselect all items and move edit cursor ignoring snap", action_id = "39578" },
					{label = "Extend time selection", action_id = "39581" },
					{label = "Extend time selection ignoring snap", action_id = "39582" },
					{label = "Restore previous zoom level", action_id = "39584" },
					{label = "Restore previous zoom/scroll", action_id = "39583" },
				},
			},
			{
				label = "Track left drag", children = {
					{label = "No action", action_id = "39192" },
					{label = "Add to razor edit area", action_id = "39219" },
					{label = "Add to razor edit area ignoring snap", action_id = "39220" },
					{label = "Draw a copy of the selected media item", action_id = "39193" },
					{label = "Draw a copy of the selected media item ignoring snap", action_id = "39194" },
					{label = "Draw a copy of the selected media item ignoring snap, looping the visible or time-selected section", action_id = "39216" },
					{label = "Draw a copy of the selected media item ignoring snap, pooling MIDI source data", action_id = "39209" },
					{label = "Draw a copy of the selected media item on the same track", action_id = "39195" },
					{label = "Draw a copy of the selected media item on the same track ignoring snap", action_id = "39196" },
					{label = "Draw a copy of the selected media item on the same track ignoring snap, pooling MIDI source data", action_id = "39211" },
					{label = "Draw a copy of the selected media item on the same track, pooling MIDI source data", action_id = "39210" },
					{label = "Draw a copy of the selected media item, looping the visible or time-selected section", action_id = "39215" },
					{label = "Draw a copy of the selected media item, pooling MIDI source data", action_id = "39208" },
					{label = "Draw an empty MIDI item", action_id = "39197" },
					{label = "Draw an empty MIDI item ignoring snap", action_id = "39198" },
					{label = "Edit loop points", action_id = "39212" },
					{label = "Edit loop points ignoring snap", action_id = "39213" },
					{label = "Marquee add to item selection", action_id = "39205" },
					{label = "Marquee select items", action_id = "39201" },
					{label = "Marquee select items and time", action_id = "39202" },
					{label = "Marquee select items and time ignoring snap", action_id = "39203" },
					{label = "Marquee toggle item selection", action_id = "39204" },
					{label = "Marquee zoom", action_id = "39214" },
					{label = "Move time selection", action_id = "39206" },
					{label = "Move time selection ignoring snap", action_id = "39207" },
					{label = "Select razor edit area", action_id = "39217" },
					{label = "Select razor edit area and time", action_id = "39221" },
					{label = "Select razor edit area and time ignoring snap", action_id = "39222" },
					{label = "Select razor edit area ignoring snap", action_id = "39218" },
					{label = "Select time", action_id = "39199" },
					{label = "Select time ignoring snap", action_id = "39200" },
				},
			},
		},
	},
	
}
-- main_menu_structure
-- #######################################
-- #######################################
local ctx = reaper.ImGui_CreateContext("_v9qkNIb02dve2mWVraFo") -- Пример: v9qkNIb02dve2mWVraFo _v9qkNIb02dve2mWVraFo
-- Любой Уникальный Идентификатор, Пример: v9qkNIb02dve2mWVraFo
-- #######################################
-- #######################################
-- Загружаем шрифты с разными размерами
-- font_size
local font_size_verdana_14 = reaper.ImGui_CreateFont('verdana', 14)
local font_size_verdana_16 = reaper.ImGui_CreateFont('verdana', 16)
local font_size_verdana_17 = reaper.ImGui_CreateFont('verdana', 17)
local font_size_verdana_18 = reaper.ImGui_CreateFont('verdana', 18)
local font_size_verdana_19 = reaper.ImGui_CreateFont('verdana', 19)
local font_size_verdana_20 = reaper.ImGui_CreateFont('verdana', 20)

-- Присоединяем шрифты к контексту
reaper.ImGui_Attach(ctx, font_size_verdana_14)
reaper.ImGui_Attach(ctx, font_size_verdana_16)
reaper.ImGui_Attach(ctx, font_size_verdana_17)
reaper.ImGui_Attach(ctx, font_size_verdana_18)
reaper.ImGui_Attach(ctx, font_size_verdana_19)
reaper.ImGui_Attach(ctx, font_size_verdana_20)
-- #######################################
-- #######################################
-- name_window_v9qkNIb02dve2mWVraFo
local alpha_window_ImGui = tonumber(reaper.GetExtState("MaxMusicMax_ImGuiWindow", "ImGuiAlphaWindow_v9qkNIb02dve2mWVraFo")) or 0.6
local name_window_v9qkNIb02dve2mWVraFo = "Mouse Modifier - Preset Switcher"
-- #######################################
-- #######################################
-- Default menu item
-- Пункт меню по умолчанию
local selected_content = "Mouse_Modifiers_Content_Show" -- Color_Content_Show / Frequent_Content_Show
local current_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiWindow", "ImGuiCurrentMenuItem_v9qkNIb02dve2mWVraFo")
local default_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiWindow", "ImGuiDefaultMenuItem_v9qkNIb02dve2mWVraFo")

if current_menu_item_imgui == "" then
	reaper.SetExtState("MaxMusicMax_ImGuiWindow", "ImGuiCurrentMenuItem_v9qkNIb02dve2mWVraFo", selected_content, true)
end

if default_menu_item_imgui == "" then
	reaper.SetExtState("MaxMusicMax_ImGuiWindow", "ImGuiDefaultMenuItem_v9qkNIb02dve2mWVraFo", selected_content, true)
else
	selected_content = default_menu_item_imgui
end
-- Пункт меню по умолчанию
-- ##################################################
-- ##################################################
-- script_path
-- local preset_file_save = reaper.GetResourcePath() .. "/maxmusicmax_mouse_modifier_preset_switcher.ini"
-- local preset_file_load = reaper.GetResourcePath() .. "/maxmusicmax_mouse_modifier_preset_switcher.ini"

-- Получаем полный путь к текущему скрипту
local script_path = debug.getinfo(1, "S").source:match("@(.*[/\\])")

-- Формируем путь для сохранения INI-файла
local preset_file_save = script_path .. "maxmusicmax_mouse_modifier_preset_switcher.ini"
local preset_file_load = preset_file_save -- Загружаем из того же файла

local settings_file_save = script_path .. "maxmusicmax_mouse_modifier_preset_switcher_settings.ini"
local settings_file_load = settings_file_save -- Загружаем из того же файла

local presets = {}
local selected_preset = nil
-- Переменные для управления вводом имени пресета
local showPresetNameDialog = false
local presetNameInput = ""
-- #################################################
-- #################################################
-- ini_manager

-- Чтение значения (get)
-- local value, err = ini_manager("get", ini_file, "General", "Volume")

-- Запись значения (set)
-- local success, err = ini_manager("set", ini_file, "General", "Volume", 0.8)

-- Удаление ключа (delete_key)
-- local success, err = ini_manager("delete_key", ini_file, "General", "Volume")

-- Удаление секции (delete_section)
-- local success, err = ini_manager("delete_section", ini_file, "General")

function ini_manager (mode, file_path, section, key, value)
	-- Локальная функция для чтения INI
	local function read_ini(file_path)
		local settings = {}
		local current_section
		local file = io.open(file_path, "r")
		if not file then return settings end -- Если файл не существует, возвращаем пустую таблицу

		for line in file:lines() do
			line = line:match("^%s*(.-)%s*$") -- Убираем пробелы по краям строки
			if line ~= "" and not line:match("^;") then -- Пропускаем пустые строки и комментарии
				local s = line:match("^%[([^%]]+)%]") -- Проверяем на секцию
				if s then
					current_section = s
					settings[current_section] = settings[current_section] or {}
				else
					local k, v = line:match("^([^=]+)%s*=%s*(.+)$") -- Парсим ключ=значение
					if k and v and current_section then
						settings[current_section][k:match("^%s*(.-)%s*$")] = v:match("^%s*(.-)%s*$")
					end
				end
			end
		end

		file:close()
		return settings
	end

	-- Локальная функция для записи INI
	local function write_ini(file_path, settings)
		local file = io.open(file_path, "w")
		if not file then return false, "Ошибка записи в файл: " .. file_path end

		for sec, params in pairs(settings) do
			file:write("[" .. sec .. "]\n")
			for k, v in pairs(params) do
				file:write(k .. "=" .. v .. "\n")
			end
			file:write("")
		end

		file:close()
		return true
	end

	-- Выполняем операцию в зависимости от режима
	local settings = read_ini(file_path)

	if mode == "get" then
		-- Получение значения
		if settings[section] then
			return settings[section][key]
		end
		return nil, "Ключ не найден"
	elseif mode == "set" then
		-- Установка значения
		settings[section] = settings[section] or {}
		settings[section][key] = tostring(value)
		return write_ini(file_path, settings)
	elseif mode == "delete_key" then
		-- Удаление ключа
		if settings[section] and settings[section][key] then
			settings[section][key] = nil
			return write_ini(file_path, settings)
		end
		return false, "Ключ не найден"
	elseif mode == "delete_section" then
		-- Удаление секции
		if settings[section] then
			settings[section] = nil
			return write_ini(file_path, settings)
		end
		return false, "Секция не найдена"
	else
		return false, "Неизвестный режим: " .. tostring(mode)
	end
end
-- #################################################
-- #################################################
-- DrawWithBorder
-- DrawWithBorder ("#00B359", border_width)
local function DrawWithBorder(ctx, element_type, label, color_hex, border_width)
	function HexToARGB(hex_color)
		-- Проверяем, что цвет в формате #RRGGBB
		if not hex_color:match("^#%x%x%x%x%x%x$") then
			reaper.ShowConsoleMsg("Ошибка: Некорректный формат HEX цвета. Используйте #RRGGBB.\n")
			return nil
		end

		-- Конвертируем компоненты
		local r = tonumber(string.sub(hex_color, 2, 3), 16) / 255
		local g = tonumber(string.sub(hex_color, 4, 5), 16) / 255
		local b = tonumber(string.sub(hex_color, 6, 7), 16) / 255
		local a = 1.0 -- По умолчанию непрозрачный

		-- Конвертируем в U32
		return reaper.ImGui_ColorConvertDouble4ToU32(r, g, b, a)
	end

	local border_color = HexToARGB(color_hex or "#FF0000")
	local draw_list = reaper.ImGui_GetWindowDrawList(ctx)

	if element_type == "TreeNode" then
		local is_open = reaper.ImGui_TreeNode(ctx, label)
		if not is_open then
			local min_x, min_y = reaper.ImGui_GetItemRectMin(ctx)
			local max_x, max_y = reaper.ImGui_GetItemRectMax(ctx)
			reaper.ImGui_DrawList_AddRect(draw_list, min_x, min_y, max_x, max_y, border_color, 0, 0, border_width)
		else
			reaper.ImGui_TreePop(ctx)
		end
		return is_open
	elseif element_type == "Text" then
		reaper.ImGui_Text(ctx, label)
		local min_x, min_y = reaper.ImGui_GetItemRectMin(ctx)
		local max_x, max_y = reaper.ImGui_GetItemRectMax(ctx)
		reaper.ImGui_DrawList_AddRect(draw_list, min_x, min_y, max_x, max_y, border_color, 0, 0, border_width)
	else
		reaper.ShowConsoleMsg("Unsupported element type: " .. tostring(element_type) .. "\n")
	end
end
-- #################################################
-- #################################################
-- SavePresetsToINI
-- Функция для сохранения пресетов в INI-файл
local function SavePresetsToINI(presets, filename)
    local file = io.open(filename, "w")
    if not file then
        reaper.ShowConsoleMsg("Ошибка: Не удалось открыть файл для записи.\n")
        return
    end

    for presetName, actionIDs in pairs(presets) do
        file:write("[" .. presetName .. "]\n")
        file:write("action_id=" .. table.concat(actionIDs, ",") .. "\n")
    end

    file:close()
    reaper.ShowConsoleMsg("Пресеты успешно сохранены в файл: " .. filename .. "\n")
end
-- #################################################
-- #################################################
-- SaveCurrentPreset
-- Функция для сохранения текущего состояния как пресета
local function SaveCurrentPreset(presetName)
    local currentActions = {}

    -- Рекурсивная функция для извлечения активных action_id
    local function ExtractActiveActions(items)
        for _, item in ipairs(items) do
            if item.children then
                ExtractActiveActions(item.children)
            elseif item.action_id then
                local command_id = reaper.NamedCommandLookup(item.action_id)
                if reaper.GetToggleCommandStateEx(0, command_id) == 1 then
                    table.insert(currentActions, item.action_id)
                end
            end
        end
    end

    ExtractActiveActions(categories_mouse_modifiers)

    if #currentActions > 0 then
        -- Сохраняем текущие действия в пресеты
        presets[presetName] = currentActions

        -- Открываем файл для чтения
        local file = io.open(preset_file_save, "r")
        local lines = {}
        local is_inside_preset = false
        local preset_found = false

        if file then
            for line in file:lines() do
                if line:match("^%[" .. presetName .. "%]$") then
                    -- Найден пресет, начинаем перезаписывать его содержимое
                    is_inside_preset = true
                    preset_found = true
                    table.insert(lines, "[" .. presetName .. "]")
                    table.insert(lines, "action_id=" .. table.concat(currentActions, ","))
                elseif is_inside_preset and line:match("^%[.+%]") then
                    -- Заканчиваем перезапись, как только встретили новую секцию
                    is_inside_preset = false
                    table.insert(lines, line)
                elseif not is_inside_preset then
                    table.insert(lines, line)
                end
            end
            file:close()
        end

        -- Если пресет не найден, добавляем его в конец
        if not preset_found then
            table.insert(lines, "[" .. presetName .. "]")
            table.insert(lines, "action_id=" .. table.concat(currentActions, ","))
        end

        -- Перезаписываем файл
        file = io.open(preset_file_save, "w")
        if file then
            for _, line in ipairs(lines) do
                file:write(line .. "\n")
            end
            file:close()
            -- reaper.ShowConsoleMsg("Пресет сохранён: " .. presetName .. "\n")
        else
            reaper.ShowConsoleMsg("Ошибка: Не удалось открыть файл для записи.\n")
        end
    else
        reaper.ShowConsoleMsg("Нет активных действий для сохранения в пресет.\n")
    end
end
-- #################################################
-- #################################################
-- LoadPresets
-- Загрузка пресетов из INI файла
local function LoadPresets()
    local file = io.open(preset_file_load, "r")
    if not file then
        -- reaper.ShowConsoleMsg("Error: Unable to open preset file for loading: " .. preset_file_load .. "\n")
        return
    end

    local current_preset = nil
    for line in file:lines() do
        local preset_name = line:match("^%[(.+)%]$")
        if preset_name then
            current_preset = preset_name
            presets[current_preset] = {}
        elseif current_preset and line:match("^action_id=") then
            local action_ids = line:match("^action_id=(.+)$")
            if action_ids then
                for id in action_ids:gmatch("[^,]+") do
                    table.insert(presets[current_preset], id)
                end
            end
        end
    end
    file:close()
end
-- #################################################
-- #################################################
-- SaveLastSelectedPreset
local function SaveLastSelectedPreset(preset_name, filename)
    -- Чтение файла в память
    local file = io.open(filename, "r")
    local lines = {}
    if file then
        for line in file:lines() do
            if not line:match("^%[Last_Selected_Preset%]") and not line:match("^name_preset=") then
                table.insert(lines, line)
            end
        end
        file:close()
    end

    -- Добавление или обновление секции [Last_Selected_Preset]
    table.insert(lines, "[Last_Selected_Preset]")
    table.insert(lines, "name_preset=" .. preset_name)
	
	-- Show Preset Name
	local show_preset_name_to_console, err = ini_manager("get", settings_file_load, "SettingsMouseModifiersPresetSwitcher", "name_mouse_modifiers_to_console")
	if show_preset_name_to_console == "true" then		
	-- Выводим label в консоль при выборе
		reaper.ClearConsole()
		print_rs (preset_name)
	else
		reaper.ClearConsole()
	end
	
	
    -- Запись обновлённых данных обратно в файл
    file = io.open(filename, "w")
    if not file then
        reaper.ShowConsoleMsg("Ошибка: Не удалось открыть файл для записи.\n")
        return
    end

    for _, line in ipairs(lines) do
        file:write(line .. "\n")
    end
    file:close()

    -- reaper.ShowConsoleMsg("Последний выбранный пресет сохранён: " .. preset_name .. "\n")
end
-- #################################################
-- #################################################
-- ApplyPreset
-- Применение выбранного пресета
local function ApplyPreset(preset_name)
    local actions = presets[preset_name]
	
    if not actions then return end

    for _, action_id in ipairs(actions) do
        -- Найти команду по action_id
        local command_id = reaper.NamedCommandLookup(action_id)
        if command_id and command_id > 0 then
            -- Выполнить команду
            reaper.Main_OnCommand(command_id, 0)

            -- Убедиться, что состояние изменилось
            local is_active = reaper.GetToggleCommandStateEx(0, command_id) == 1
            if not is_active then
                -- Если состояние не изменилось, повторно выполнить команду
                reaper.Main_OnCommand(command_id, 0)
            end
        else
            reaper.ShowConsoleMsg("Invalid action_id: " .. tostring(action_id) .. "\n")
        end
    end
	
	 -- Сохранить последний выбранный пресет
    SaveLastSelectedPreset(preset_name, preset_file_save)
end
-- #################################################
-- #################################################
-- SortPresets
local function SortPresets()
    local sorted_presets = {}
    local default_preset = nil

    -- Сохраняем "Default Preset", если он существует
    if presets["Default Preset"] then
        default_preset = {name = "Default Preset", actions = presets["Default Preset"]}
    end

    -- Сортируем остальные пресеты по алфавиту
    for preset_name, actions in pairs(presets) do
        if preset_name ~= "Default Preset" then
            table.insert(sorted_presets, {name = preset_name, actions = actions})
        end
    end

    table.sort(sorted_presets, function(a, b)
        return a.name:lower() < b.name:lower()
    end)

    -- Если "Default Preset" существует, добавляем его в начало списка
    if default_preset then
        table.insert(sorted_presets, 1, default_preset)
    end

    return sorted_presets
end
-- #################################################
-- #################################################
-- DrawSortedPresets
local function DrawSortedPresets()
	local sorted_presets = SortPresets()
	
	-- if reaper.ImGui_TreeNode(ctx, "User Presets") then
	if DrawWithBorder(ctx, "TreeNode", "User Presets", "#387BCB", 2) then
		for _, preset in ipairs(sorted_presets) do
			if preset.name ~= "Last_Selected_Preset" then -- Исключаем "Last_Selected_Preset"
				reaper.ImGui_Indent(ctx, 28)
				if reaper.ImGui_Selectable(ctx, preset.name, selected_preset == preset.name) then
					selected_preset = preset.name
					ApplyPreset(preset.name) -- Применяем пресет при выборе
				end
				reaper.ImGui_Unindent(ctx, 28)
			end
		end
		-- reaper.ImGui_TreePop(ctx)
	end
end
-- #################################################
-- #################################################
-- DrawMenu
-- Функция для отрисовки меню
local function DrawMenu(items, parent_label)
	for _, item in ipairs(items) do
		if item.children then
			-- Если есть children, отрисовываем как reaper.ImGui_CollapsingHeader
			if reaper.ImGui_CollapsingHeader(ctx, item.label) then
				reaper.ImGui_Indent(ctx, 24) -- Смещение для вложенности
				-- DrawMenu(item.children) -- Рекурсивный вызов для обработки вложенных элементов
				DrawMenu(item.children, item.label) -- Передаём текущий label как родителя
				reaper.ImGui_Unindent(ctx) -- Возвращаем смещение
			end
		elseif item.action_id then
			-- Если есть action_id, отрисовываем как reaper.ImGui_RadioButton
			local command_id = reaper.NamedCommandLookup(item.action_id)
			local is_active = reaper.GetToggleCommandStateEx(0, command_id) == 1
			if reaper.ImGui_RadioButton(ctx, item.label .. "##" .. item.action_id, is_active) then
				reaper.Main_OnCommand(command_id, 0)
				
				local name_mouse_modifiers_to_console, err = ini_manager("get", settings_file_load, "SettingsMouseModifiersPresetSwitcher", "name_mouse_modifiers_to_console")
				if name_mouse_modifiers_to_console == "true" then		
				-- Выводим label в консоль при выборе
					reaper.ClearConsole()
					print_rs ( parent_label .. " - " .. item.label )
				else
					reaper.ClearConsole()
				end
				
			end
		end
	end
end
-- #################################################
-- #################################################
function TreeNodeLibraryOutput(node)
	
	local function HexToColor(hex)
		hex = hex:gsub("#", "")
		local r = tonumber(hex:sub(1, 2), 16)
		local g = tonumber(hex:sub(3, 4), 16)
		local b = tonumber(hex:sub(5, 6), 16)
		return 0xFF + (b * 0x100) + (g * 0x10000) + (r * 0x1000000)
	end

	local function ThickSeparator(separator_horizontal, separator_color)
		local drawList = reaper.ImGui_GetWindowDrawList(ctx)
		local x1, y1 = reaper.ImGui_GetCursorScreenPos(ctx)
		local x2 = x1 + reaper.ImGui_GetWindowWidth(ctx)
		local thickness = tonumber(separator_horizontal) or 1
		local color = HexToColor(separator_color or "#FF0000")
		reaper.ImGui_DrawList_AddLine(drawList, x1, y1 + thickness, x2, y1 + thickness, color, thickness)
	end
	
	-- Обрабатываем разделитель
	if node.separator_horizontal then
		if node.separator_horizontal == "ImGui_SeparatorText" then
			local separator_text = node.separator_text or ""
			reaper.ImGui_SeparatorText(ctx, separator_text)
		else
			ThickSeparator(node.separator_horizontal, node.separator_color)
		end
		return
	end

	-- Обрабатываем вертикальный отступ
	if node.spacing_vertical then
		local spacing_vertical = tonumber(node.spacing_vertical)
		if spacing_vertical then
			reaper.ImGui_Dummy(ctx, 0, spacing_vertical)
		end
		return
	end

	-- Если node - таблица верхнего уровня, обрабатываем каждый её элемент
	if type(node) == "table" and node[1] then
		for _, child in ipairs(node) do
			TreeNodeLibraryOutput(child)
		end
		return
	end

	-- Если у узла есть label, строим его в интерфейсе
	if node.label then
		if node.children and #node.children > 0 then
			if reaper.ImGui_TreeNode(ctx, node.label) then
				for _, child in ipairs(node.children) do
					TreeNodeLibraryOutput(child)
				end
				reaper.ImGui_TreePop(ctx)
			end
		else
			local command_id = node.action_id and reaper.NamedCommandLookup(node.action_id)
			local is_active = command_id and reaper.GetToggleCommandStateEx(0, command_id) == 1 or false
			
			if reaper.ImGui_Selectable(ctx, node.label, is_active) then
				if command_id then
					reaper.Main_OnCommand(command_id, 0)
					
					local name_mouse_modifiers_to_console, err = ini_manager("get", settings_file_load, "SettingsMouseModifiersPresetSwitcher", "name_mouse_modifiers_to_console")
					if name_mouse_modifiers_to_console == "true" then
						reaper.ClearConsole()
						print_rs ( node.label )
					end
				elseif node.action_function then
					node.action_function()
				end
			end
		end
	end

end
-- #################################################
-- #################################################
-- LoadLastSelectedPreset
-- Функция для загрузки последнего выбранного пресета
local function LoadLastSelectedPreset()
    local file = io.open(preset_file_load, "r")
    if not file then
        return
    end

    for line in file:lines() do
        if line:match("%[Last_Selected_Preset%]") then
            local next_line = file:read() -- Читаем следующую строку
            if next_line then
                local preset_name = next_line:match("^name_preset=(.+)$")
                if preset_name and presets[preset_name] then
                    selected_preset = preset_name
                end
            end
            break
        end
    end
    file:close()
end
-- #################################################
-- #################################################
-- DeleteLastSelectedPreset
local function DeleteLastSelectedPreset()
	if not selected_preset or selected_preset == "Last_Selected_Preset" then
		-- reaper.ShowConsoleMsg("Нет выбранного пресета для удаления.\n")
		return
	end

	if presets[selected_preset] then
		presets[selected_preset] = nil

		-- Удаление пресета из INI-файла
		local file = io.open(preset_file_save, "r")
		if not file then
			-- reaper.ShowConsoleMsg("Ошибка: Не удалось открыть файл для удаления пресета.\n")
			return
		end

		local lines = {}
		local inside_preset = false
		local escaped_preset = selected_preset:gsub("(%W)", "%%%1") -- Экранирование символов

		for line in file:lines() do
			if line:match("^%[" .. escaped_preset .. "%]$") then
				inside_preset = true -- Начало секции удаляемого пресета
			elseif inside_preset and line:match("^%[") then
				inside_preset = false -- Конец секции
				table.insert(lines, line)
			elseif not inside_preset then
				table.insert(lines, line) -- Добавляем только строки вне удаляемой секции
			end
		end
		file:close()

		-- Проверка на наличие [Default Preset]
		local default_preset_exists = presets["Default Preset"] ~= nil
		local last_selected_rewritten = false

		-- Перезапись файла с учётом [Last_Selected_Preset]
		file = io.open(preset_file_save, "w")
		if file then
			for _, line in ipairs(lines) do
				if line:match("^%[Last_Selected_Preset%]") then
					last_selected_rewritten = true
					if default_preset_exists then
						file:write("[Last_Selected_Preset]\n")
						file:write("name_preset=Default Preset\n")
					end
				elseif not line:match("^name_preset=") or not last_selected_rewritten then
					file:write(line .. "\n")
				end
			end

			-- Если [Last_Selected_Preset] не найден, добавляем его в конец
			if not last_selected_rewritten and default_preset_exists then
				file:write("[Last_Selected_Preset]\n")
				file:write("name_preset=Default Preset\n")
			end

			file:close()
		else
			-- reaper.ShowConsoleMsg("Ошибка: Не удалось сохранить файл после удаления пресета.\n")
		end

		-- Если больше не осталось пресетов, очищаем файл
		if next(presets) == nil then
			local clear_file = io.open(preset_file_save, "w")
			if clear_file then
				clear_file:close()
				-- reaper.ShowConsoleMsg("Все пресеты удалены, файл очищен.\n")
			else
				-- reaper.ShowConsoleMsg("Ошибка: Не удалось очистить файл.\n")
			end
		end
	else
		-- reaper.ShowConsoleMsg("Пресет не найден: " .. tostring(selected_preset) .. "\n")
	end
end
-- ##################################################
-- ##################################################
-- EnsureDefaultPresets
local function EnsureDefaultPresets()
	local file = io.open(preset_file_save, "r")
	local lines = {}
	local sections_found = {}
	local section_data = {} -- Таблица для хранения содержимого всех секций

	-- Считываем текущий INI-файл и собираем секции
	if file then
		local current_section = nil
		for line in file:lines() do
			local section_name = line:match("^%[(.+)%]$")
			if section_name then
				current_section = section_name
				section_data[current_section] = {}
			elseif current_section then
				table.insert(section_data[current_section], line)
			end
			table.insert(lines, line)
		end
		file:close()
	end

	-- Проверяем и обновляем секции из default_presets_at_startup
	for section_name, content in pairs(default_presets_at_startup) do
		if section_data[section_name] then
			-- Перезаписываем содержимое существующей секции
			section_data[section_name] = {content}
		else
			-- Добавляем новую секцию
			section_data[section_name] = {content}
		end
	end

	-- Перезаписываем файл
	file = io.open(preset_file_save, "w")
	if file then
		for section_name, content in pairs(section_data) do
			file:write("[" .. section_name .. "]\n")
			for _, line in ipairs(content) do
				file:write(line .. "\n")
			end
		end
		file:close()
		-- reaper.ShowConsoleMsg("Секции обновлены.\n")
	else
		-- reaper.ShowConsoleMsg("Ошибка: Не удалось открыть файл для записи секций.\n")
	end
end

-- Вызов функции при запуске скрипта
EnsureDefaultPresets()
-- ##################################################
-- ##################################################
-- cboc2 / create_button_one_click2
function cboc2(label, callback_function, button_width, button_height )
	if reaper.ImGui_Button( ctx, label, button_width, button_height ) then
		callback_function()
		-- print_rs("create_button_one_click: " .. label)
	end
end
-- ##################################################
-- ##################################################
-- ShowMenuItems
local function ShowMenuItems(items)
	for _, item in ipairs(items) do
		if item.is_separator then
			reaper.ImGui_Separator(ctx)
		elseif item.children then
			if reaper.ImGui_BeginMenu(ctx, item.label) then
				ShowMenuItems(item.children)
				reaper.ImGui_EndMenu(ctx)
			end
		else
			if reaper.ImGui_MenuItem(ctx, item.label) then
				if item.action_id then
					reaper.Main_OnCommand(reaper.NamedCommandLookup(item.action_id), 0)
				elseif item.action_function then
					item.action_function()
				elseif item.show_content then
					selected_content = item.show_content
					reaper.SetExtState("MaxMusicMax_ImGuiWindow", "ImGuiCurrentMenuItem_v9qkNIb02dve2mWVraFo", selected_content, true)
				end
			end
		end
	end
end
-- ##################################################
-- ##################################################
-- SetDefaultMenuItemImGui
function SetDefaultMenuItemImGui ()
	current_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiWindow", "ImGuiCurrentMenuItem_v9qkNIb02dve2mWVraFo")
	reaper.SetExtState("MaxMusicMax_ImGuiWindow", "ImGuiDefaultMenuItem_v9qkNIb02dve2mWVraFo", current_menu_item_imgui, true)
end
-- ##################################################
-- ##################################################
-- function main
function main()
	reaper.ImGui_SetNextWindowBgAlpha(ctx, alpha_window_ImGui) -- Установить прозрачность фона окна
	reaper.ImGui_PushFont (ctx, font_size_verdana_17)
	-- reaper.ImGui_SetNextWindowSize(ctx, 500, 300, reaper.ImGui_Cond_FirstUseEver())

	local visible, open = reaper.ImGui_Begin(ctx, name_window_v9qkNIb02dve2mWVraFo, true, reaper.ImGui_WindowFlags_MenuBar())
	if visible then
		if reaper.ImGui_BeginMenuBar(ctx) then
			ShowMenuItems(main_menu_structure)
			reaper.ImGui_EndMenuBar(ctx)
		end
		
		-- #######################################
		-- main_menu_structure
		if selected_content == "" then
		elseif selected_content == "Preset_Mouse_Modifiers_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "User Preset Mouse Modifiers" )
			sorted_presets = SortPresets()
			
			if #sorted_presets > 0 then -- attempt to compare number with table
			
				for _, preset in ipairs(sorted_presets) do
					if preset.name ~= "Last_Selected_Preset" then -- Исключаем "Last_Selected_Preset"
						if reaper.ImGui_Selectable(ctx, preset.name, selected_preset == preset.name) then
							selected_preset = preset.name
							ApplyPreset(preset.name) -- Применяем пресет при выборе
						end
					end
				end
			else
				reaper.ImGui_Text(ctx, "No Preset")
			end
			
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			reaper.ImGui_SeparatorText( ctx, "Action Command" )
			cboc2 ( " Remove time selection ", function() reaper.Main_OnCommand("40635", 0) end, 300, 25 ) -- Time selection: Remove (unselect) time selection
			
		elseif selected_content == "Settings_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Settings" )
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			-- Show Name Mouse Modifiers To The Console When Selected
			local checkbox_name_mouse_modifiers_to_console, err1 = ini_manager("get", settings_file_load, "SettingsMouseModifiersPresetSwitcher", "name_mouse_modifiers_to_console") == "true"
			local changed1, new_state1 = reaper.ImGui_Checkbox(ctx, "Show Name Mouse Modifiers To The Console When Selected", checkbox_name_mouse_modifiers_to_console)
			if changed1 then
				checkbox_name_mouse_modifiers_to_console = new_state1
				local success, err1 = ini_manager("set", settings_file_save, "SettingsMouseModifiersPresetSwitcher", "name_mouse_modifiers_to_console", tostring(checkbox_name_mouse_modifiers_to_console))
			end
			-- Show Name Mouse Modifiers To The Console When Selected
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			-- Show Preset Name To Console When Selected
			local checkbox_show_preset_name_to_console, err2 = ini_manager("get", settings_file_load, "SettingsMouseModifiersPresetSwitcher", "show_preset_name_to_console") == "true"
			local changed2, new_state2 = reaper.ImGui_Checkbox(ctx, "Show Preset Name To Console When Selected", checkbox_show_preset_name_to_console)
			if changed2 then
				checkbox_show_preset_name_to_console = new_state2
				local success, err2 = ini_manager("set", settings_file_save, "SettingsMouseModifiersPresetSwitcher", "show_preset_name_to_console", tostring(checkbox_show_preset_name_to_console))
			end
			-- Show Preset Name To Console When Selected
			
		elseif selected_content == "Mouse_Modifiers_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Mouse Modifiers" )
			
				-- Кнопка "Save Preset"
			if reaper.ImGui_Button(ctx, " Save Preset ", 150, 30) then
				showPresetNameDialog = true
			end
			
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			
			-- Кнопка "Delete Preset"
			if reaper.ImGui_Button(ctx, " Delete Preset ", 150, 30) then
				DeleteLastSelectedPreset()
			end
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			-- DrawSortedPresets -- Отрисовка списка пресетов
			reaper.ImGui_PushFont(ctx, font_size_verdana_19)
			DrawSortedPresets() -- User Presets -- Теперь вызывается отсортированный вывод пресетов
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			reaper.ImGui_PopFont(ctx)
			
			-- DrawMenu
			-- DrawMenu(categories_mouse_modifiers) -- Передаём структуру меню
			TreeNodeLibraryOutput (categories_mouse_modifiers)

			-- Окно для ввода имени пресета
			if showPresetNameDialog then
				reaper.ImGui_OpenPopup(ctx, "Save Preset As")
			end

			if reaper.ImGui_BeginPopupModal(ctx, "Save Preset As", nil, reaper.ImGui_WindowFlags_AlwaysAutoResize()) then
				_, presetNameInput = reaper.ImGui_InputText(ctx, "Preset Name", presetNameInput, 128)

				if reaper.ImGui_Button(ctx, "Save") then
					if presetNameInput ~= "" then
						SaveCurrentPreset(presetNameInput)
						presetNameInput = ""
						showPresetNameDialog = false
						reaper.ImGui_CloseCurrentPopup(ctx)
					else
						reaper.ShowConsoleMsg("Имя пресета не может быть пустым.\n")
					end
				end

				reaper.ImGui_SameLine(ctx)

				if reaper.ImGui_Button(ctx, "Cancel") then
					presetNameInput = ""
					showPresetNameDialog = false
					reaper.ImGui_CloseCurrentPopup(ctx)
				end

				reaper.ImGui_EndPopup(ctx)
			end
			
		elseif selected_content == "Alpha_Window_ImGui_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Alpha Window ImGui" )
			local changed, new_alpha = reaper.ImGui_DragDouble(ctx, ' ', alpha_window_ImGui, 0.01, 0.0, 1.0, '%.2f')
			if changed then
				alpha_window_ImGui = new_alpha
				reaper.SetExtState("MaxMusicMax_ImGuiWindow", "ImGuiAlphaWindow_v9qkNIb02dve2mWVraFo", tostring(alpha_window_ImGui), true)
			end
		else
			reaper.ImGui_Text(ctx, "Select a menu item to see the content.")
		end
		-- main_menu_structure
		-- #######################################
		
		reaper.ImGui_End(ctx)
	end
	reaper.ImGui_PopFont (ctx)
	if open then
		reaper.defer(main)
	end
end

-- Загрузка пресетов и запуск интерфейса
LoadPresets()
LoadLastSelectedPreset()

reaper.defer(main)
-- #######################################
-- #######################################
reaper.PreventUIRefresh(-1);
reaper.TrackList_AdjustWindows(0)  -- Updates the window view
reaper.UpdateArrange();  -- Updates the window view
-- #######################################
-- #######################################