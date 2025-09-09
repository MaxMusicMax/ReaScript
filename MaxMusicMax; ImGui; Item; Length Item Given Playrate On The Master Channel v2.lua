--@description ImGui; Item; Length Item Given Playrate On The Master Channel v2
--@version 2.0
--@author MaxMusicMax
-- https://forum.cockos.com/showthread.php?p=2059855
-- #######################################
-- #######################################
local user_min_step = 10
-- min_step = (1 / sample_rate) длительность одного сэмпла в секундах.
--	Если sample_rate = 44100 → 1 / 44100 = 0.0000226757 секунды — это один сэмпл по времени
-- 0.0000226757 * user_min_step = 0.xxxxxxx секунды — шаг по времени при подсчётах
-- #######################################
-- #######################################
-- 1111111111111111111111111111
-- menu_structure
-- Item_Length_Content_Show
-- insert_empty_item_library

-- HexToColor
-- TreeNodeLibraryOutput
-- ImGuiSelectComboBox
-- get_font_size
-- LoadSavedFonts

-- GetPlayrateAtTimeBuilder
-- GetRealLengthWithPlayrate
-- GetTimeRange
-- GetMouseTimeWithPlayrate
-- FormatTimeHMSms_StartZero
-- FormatTimeHMSms_StartMinus

-- SetTakeMarkerAtEditCursor
-- DeleteTakeMarkersSelectItemOrTimeSelection
-- CreateProjectMarkerPositionColor
-- DeleteMarkersInTimeSelection
-- DeleteStartEndMarkers
-- SetTimeSelectionFromMarkers
-- SetStartEndMarkersFromSelectedItem

-- ShowMenuMain
-- SetDefaultMenuItemImGui
-- main_ImGui
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
-- menu_structure
local menu_structure = {
	{key = "Menu", children = {
		{key = "Item Length", show_content = "Item_Length_Content_Show"},
		{key = "Set Default Tab ImGui", action_function = function() SetDefaultMenuItemImGui () end},
		{key = "Set Font Size", show_content = "Set_Font_Size_Content_Show"},
		{key = "Set Alpha Tab ImGui", show_content = "Alpha_Window_ImGui_Content_Show"},
		-- {key = "Content 1", show_content = "Content_1_Show"},
		-- {key = "Content 2", show_content = "Content_2_Show"},
	}},

	-- {key = "Settings", children = {
	-- }},
	
	--[[
	{key = "Example", children = {
		{spacing_vertical = "5"},
		{separator_horizontal = "ImGui_SeparatorText", separator_text = "Set Project TimeBase"},
		{separator_horizontal = "3", separator_color = "#FF7373", separator_length = 100 },
		
		{key = "Content 1", show_content = "Content_1_Content_Show"},
		{key = "Color 1", action_function = function() reaper.ShowMessageBox("Color 1 selected", "Information", 0) end},
		{key = "Options: Preferences", action_id = "40016"},
		{key = "Gui; Color switch", action_id = "_RS251990727759d3dff9cf84df740cd6a87ea0d169"},
	}},
	]]--
}
-- menu_structure
-- #######################################
-- #######################################
local ctx = reaper.ImGui_CreateContext("kwoh0uz8nm_") -- Пример: kwoh0uz8nm
-- Любой Уникальный Идентификатор, Пример: kwoh0uz8nm
-- #######################################
-- #######################################
-- HexToColor
function HexToColor(hex)
	-- Убираем символ '#' в начале строки, если он есть
	hex = hex:gsub("#", "")
	-- Получаем компоненты цвета (красный, зелёный, синий)
	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)
	-- Возвращаем цвет в формате 0xAARRGGBB (с альфа-каналом FF)
	return 0xFF + (b * 0x100) + (g * 0x10000) + (r * 0x1000000)
end
-- HexToColor
-- #######################################
-- #######################################
-- TreeNodeLibraryOutput
function TreeNodeLibraryOutput(node)
	local function ThickSeparator(separator_horizontal, separator_color, separator_length)
		local drawList = reaper.ImGui_GetWindowDrawList(ctx) -- Передаём ctx
		local x1, y1 = reaper.ImGui_GetCursorScreenPos(ctx)
		-- Если указан separator_length, используем его, иначе на всю ширину окна
		local x2 = x1 + (separator_length or reaper.ImGui_GetWindowWidth(ctx))
		-- Толщина разделителя
		local thickness = tonumber(separator_horizontal) or 1
		-- Преобразуем цвет из #RRGGBB в формат 0xAARRGGBB
		local color = HexToColor(separator_color or "#3F3F48")
		-- Рисуем горизонтальную линию
		reaper.ImGui_DrawList_AddLine(drawList, x1, y1 + thickness, x2, y1 + thickness, color, thickness)
	end
	
	if node.separator_horizontal then
		if node.separator_horizontal == "ImGui_SeparatorText" then
			local separator_text = node.separator_text or "" -- Используем переданный текст или пустую строку
			reaper.ImGui_SeparatorText(ctx, separator_text)
		else
			-- ThickSeparator(node.separator_horizontal, node.separator_color)
			ThickSeparator(node.separator_horizontal, node.separator_color, node.separator_length)
		end
		return
	end
	
	if node.is_separator then -- Если это разделитель, выводим его
		reaper.ImGui_Separator(ctx)
		return
	end
	
	if node.spacing_vertical then -- Если встречаем spacing_vertical, добавляем вертикальное пространство
		local spacing_vertical = tonumber(node.spacing_vertical) -- Преобразуем значение в число
		if spacing_vertical then
			reaper.ImGui_Dummy(ctx, 0, spacing_vertical) -- Добавление вертикального пространства
		end
		return
	end
	
	if node.key then
		local flags = node.default_open and reaper.ImGui_TreeNodeFlags_DefaultOpen() or 0
		
		if node.children then
			if reaper.ImGui_TreeNodeEx(ctx, node.key, node.key, flags) then
				for _, child in ipairs(node.children) do
					TreeNodeLibraryOutput(child)
				end
				reaper.ImGui_TreePop(ctx)
			end
		else
			local command_id = node.action_id and reaper.NamedCommandLookup(node.action_id)
			local is_active = command_id and reaper.GetToggleCommandStateEx(0, command_id) == 1 or false

			if reaper.ImGui_Selectable(ctx, node.key, is_active) then
				if command_id then
					reaper.Main_OnCommand(command_id, 0)
				elseif node.action_function then
					node.action_function()
				end
				
				if node.set_focus ~= nil then -- node.set_focus — существует
					
				else -- node.set_focus — не существует
					reaper.JS_Window_SetFocus(reaper.GetMainHwnd())
					reaper.JS_Window_SetForeground(reaper.GetMainHwnd())
				end
				
			end
		end
		
	end
end
-- TreeNodeLibraryOutput
-- #######################################
-- #######################################
-- ImGuiSelectComboBox
function ImGuiSelectComboBox(ext_state_section, ext_state_key, combo_width)
	local selected_value = tonumber(reaper.GetExtState(ext_state_section, ext_state_key)) or 14

	reaper.ImGui_SetNextItemWidth(ctx, combo_width)

	if reaper.ImGui_BeginCombo(ctx, "##" .. ext_state_key, tostring(selected_value)) then
		for i = 14, 100, 2 do
			local is_selected = (selected_value == i)
			if reaper.ImGui_Selectable(ctx, tostring(i), is_selected) then
				selected_value = i
				reaper.SetExtState(ext_state_section, ext_state_key, tostring(selected_value), true)
				
			end
			if is_selected then
				reaper.ImGui_SetItemDefaultFocus(ctx)
			end
		end
		reaper.ImGui_EndCombo(ctx)
	end
end
-- ImGuiSelectComboBox("MaxMusicMax_ImGuiWindow", "ImGuiFontSize", 70)
-- #######################################
-- #######################################
-- get_font_size
function get_font_size(ext_state_section, ext_state_key)
	local param_return = tonumber(reaper.GetExtState(ext_state_section, ext_state_key))
	if not param_return then
		param_return = 16
		reaper.SetExtState(ext_state_section, ext_state_key, tostring(param_return), true)
	end
	return param_return
end
-- get_font_size
-- #######################################
-- #######################################
-- LoadSavedFonts
function LoadSavedFonts(line, key)
	local font_verdana = {}
	local extstate_path = reaper.GetResourcePath() .. "/reaper-extstate.ini"
	local file = io.open(extstate_path, "r")

	if file then
		local section_found = false
		for ln in file:lines() do
			if ln:match("%[" .. line .. "%]") then
				section_found = true
			elseif section_found and ln:match("^%[") then
				break -- Вышли за пределы секции
			elseif section_found then
				local k, v = ln:match("^(.-)=(.-)$")
				local size = tonumber(v)

				if k and size and k:find("^" .. key) then
					if not font_verdana[size] then
						font_verdana[size] = reaper.ImGui_CreateFont("verdana", size)
						reaper.ImGui_Attach(ctx, font_verdana[size])
					end
				end
			end
		end
		file:close()
	end

	return font_verdana
end
-- LoadSavedFonts
-- #######################################
-- #######################################
-- GetPlayrateAtTimeBuilder
function GetPlayrateAtTimeBuilder()
	local master = reaper.GetMasterTrack(0)
	local env = reaper.GetTrackEnvelopeByName(master, "Playrate")

	local points = {}
	if env and reaper.CountEnvelopePoints(env) > 0 then
		local count = reaper.CountEnvelopePoints(env)
		for i = 0, count - 1 do
			local _, time, value = reaper.GetEnvelopePoint(env, i)
			points[#points+1] = {time = time, value = value}
		end
	end

	return function(t)
		if #points == 0 then return reaper.Master_GetPlayRate() end
		if t <= points[1].time then return points[1].value end
		if t >= points[#points].time then return points[#points].value end
		for i = 1, #points - 1 do
			local p1, p2 = points[i], points[i+1]
			if t >= p1.time and t <= p2.time then
				local frac = (t - p1.time) / (p2.time - p1.time)
				return p1.value + frac * (p2.value - p1.value)
			end
		end
		return reaper.Master_GetPlayRate()
	end
end
-- GetPlayrateAtTimeBuilder
-- #######################################
-- #######################################
-- GetTimeRange
function GetTimeRange(mode)
	if mode == "time_selection" then
		local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
		return start_time, end_time
	elseif mode == "item" then
		local item = reaper.GetSelectedMediaItem(0, 0)
		if item then
			local start_time = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
			local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
			return start_time, start_time + length
		end

	elseif mode == "markers" then
		local start_pos, end_pos = nil, nil
		local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
		for i = 0, num_markers + num_regions - 1 do
			local retval, isrgn, pos, rgnend, name, idx = reaper.EnumProjectMarkers(i)
			if not isrgn then
				if name == "=START" then start_pos = pos end
				if name == "=END" then end_pos = pos end
			end
		end
		if start_pos and end_pos and end_pos > start_pos then
			return start_pos, end_pos
		else
			return nil, nil
		end
	end
	
	return nil, nil
end
-- GetTimeRange
-- #######################################
-- #######################################
-- GetRealLengthWithPlayrate
function GetRealLengthWithPlayrate2(start_time, end_time)
	if not start_time or not end_time or start_time >= end_time then
		return 0
	end

	local ok, sample_rate = reaper.GetAudioDeviceInfo("SRATE", "")
	sample_rate = tonumber(sample_rate)
	if not ok or not sample_rate or sample_rate <= 0 then
		return 0
	end

	local min_step = (1 / sample_rate) * user_min_step -- user_min_step

	local GetPlayrateAtTime = GetPlayrateAtTimeBuilder()

	local total_real_length = 0
	local t = start_time
	while t < end_time do
		local rate = GetPlayrateAtTime(t)
		total_real_length = total_real_length + min_step / rate
		t = t + min_step
	end

	return total_real_length
end

function GetRealLengthWithPlayrate(start_time, end_time)
	if not start_time or not end_time or start_time >= end_time then
		return 0
	end

	local ok, sample_rate = reaper.GetAudioDeviceInfo("SRATE", "")
	sample_rate = tonumber(sample_rate)
	if not ok or not sample_rate or sample_rate <= 0 then
		return 0
	end

	local master = reaper.GetMasterTrack(0)
	local env = reaper.GetTrackEnvelopeByName(master, "Playrate")

	if not env then
		-- Если огибающая отсутствует, используем глобальный playrate как одну точку
		local value = reaper.Master_GetPlayRate()
		return (end_time - start_time) / (value or 1)
	end

	local pointCount = reaper.CountEnvelopePoints(env)

	if pointCount == 1 then
		-- Если ровно одна точка, используем её значение playrate
		local _, _, value = reaper.GetEnvelopePoint(env, 0)
		return (end_time - start_time) / (value or 1)
	else
		-- Если больше одной точки, используем user_min_step и пошаговую обработку
		local min_step = (1 / sample_rate) * user_min_step
		local GetPlayrateAtTime = GetPlayrateAtTimeBuilder()
		local total_real_length = 0
		local t = start_time
		while t < end_time do
			local rate = GetPlayrateAtTime(t)
			total_real_length = total_real_length + min_step / rate
			t = t + min_step
		end
		return total_real_length
	end
end
-- GetRealLengthWithPlayrate
-- #######################################
-- #######################################
-- GetMouseTimeWithPlayrate
function GetMouseTimeWithPlayrate2(mode)
	local target_time = nil

	if mode == "mouse" or mode == "mouse_relative_time_selection" or mode == "mouse_relative_marker" then
		local context = reaper.BR_GetMouseCursorContext()
		if context ~= "arrange" and context ~= "ruler" then
			return nil
		end
		target_time = reaper.BR_GetMouseCursorContext_Position()

	elseif mode == "edit_cursor" or mode == "edit_cursor_relative_time_selection" or mode == "edit_cursor_relative_marker" then
		target_time = reaper.GetCursorPosition()
	else
		return nil
	end

	if not target_time then return nil end

	local reference_start = 0
	local reference_end = nil

	if mode == "mouse_relative_time_selection" or mode == "edit_cursor_relative_time_selection" then
		local start_time, end_time = GetTimeRange("time_selection")
		if not start_time or not end_time then return nil end
		reference_start = start_time
		reference_end = end_time

	elseif mode == "mouse_relative_marker" or mode == "edit_cursor_relative_marker" then
		local start_time, end_time = GetTimeRange("markers")
		if not start_time or not end_time then return nil end
		reference_start = start_time
		reference_end = end_time
	end

	if target_time < reference_start then return 0 end
	if reference_end and target_time > reference_end then return 0 end

	local GetPlayrateAtTime = GetPlayrateAtTimeBuilder()
	
	-- local _, sample_rate = reaper.GetAudioDeviceInfo("SRATE", "")
	-- local min_step = (1 / tonumber(sample_rate)) * 3000
	
	local _, sample_rate = reaper.GetAudioDeviceInfo("SRATE", "")
	sample_rate = tonumber(sample_rate)
	if not sample_rate or sample_rate == 0 then return 0 end
	local min_step = (1 / sample_rate) * user_min_step
	-- min_step = (1 / sample_rate) длительность одного сэмпла в секундах.
	--	Если sample_rate = 44100 → 1 / 44100 = 0.0000226757 секунды — это один сэмпл по времени
	-- 0.0000226757 * 3000 = 0.068 секунды — шаг по времени при подсчётах

	local real_time = 0
	local t = reference_start
	while t < target_time do
		local rate = GetPlayrateAtTime(t)
		real_time = real_time + min_step / rate
		t = t + min_step
	end

	return real_time
end

function GetMouseTimeWithPlayrate(mode)
	local target_time = nil

	if mode == "mouse" or mode == "mouse_relative_time_selection" or mode == "mouse_relative_marker" then
		local context = reaper.BR_GetMouseCursorContext()
		if context ~= "arrange" and context ~= "ruler" then
			return nil
		end
		target_time = reaper.BR_GetMouseCursorContext_Position()
	elseif mode == "edit_cursor" or mode == "edit_cursor_relative_time_selection" or mode == "edit_cursor_relative_marker" then
		target_time = reaper.GetCursorPosition()
	else
		return nil
	end

	if not target_time then return nil end

	local reference_start = 0
	local reference_end = nil

	if mode == "mouse_relative_time_selection" or mode == "edit_cursor_relative_time_selection" then
		local start_time, end_time = GetTimeRange("time_selection")
		if not start_time or not end_time then return nil end
		reference_start = start_time
		reference_end = end_time
	elseif mode == "mouse_relative_marker" or mode == "edit_cursor_relative_marker" then
		local start_time, end_time = GetTimeRange("markers")
		if not start_time or not end_time then return nil end
		reference_start = start_time
		reference_end = end_time
	end

	if target_time < reference_start then return 0 end
	if reference_end and target_time > reference_end then return 0 end

	local ok, sample_rate = reaper.GetAudioDeviceInfo("SRATE", "")
	sample_rate = tonumber(sample_rate)
	if not ok or not sample_rate or sample_rate <= 0 then return 0 end

	local master = reaper.GetMasterTrack(0)
	local env = reaper.GetTrackEnvelopeByName(master, "Playrate")

	if not env then
		-- Если огибающая отсутствует, используем глобальный playrate как одну точку
		local value = reaper.Master_GetPlayRate()
		return (target_time - reference_start) / (value or 1)
	end

	local pointCount = reaper.CountEnvelopePoints(env)

	if pointCount == 1 then
		-- Если ровно одна точка, используем её значение playrate
		local _, _, value = reaper.GetEnvelopePoint(env, 0)
		return (target_time - reference_start) / (value or 1)
	else
		-- Если больше одной точки, используем user_min_step и пошаговую обработку
		local min_step = (1 / sample_rate) * user_min_step
		local GetPlayrateAtTime = GetPlayrateAtTimeBuilder()
		local real_time = 0
		local t = reference_start
		while t < target_time do
			local rate = GetPlayrateAtTime(t)
			real_time = real_time + min_step / rate
			t = t + min_step
		end
		return real_time
	end
end
-- GetMouseTimeWithPlayrate
-- #######################################
-- #######################################
-- FormatTimeHMSms_StartZero
function FormatTimeHMSms_StartZero(seconds)
	if not seconds then return "00:00:00.000" end
	local h = math.floor(seconds / 3600)
	local m = math.floor((seconds % 3600) / 60)
	local s = math.floor(seconds % 60)
	local ms = math.floor((seconds - math.floor(seconds)) * 1000)
	return string.format("%02d:%02d:%02d.%03d", h, m, s, ms)
end
-- FormatTimeHMSms_StartZero
-- #######################################
-- #######################################
-- FormatTimeHMSms_StartMinus
function FormatTimeHMSms_StartMinus(seconds)
	if not seconds then return "00:00:00.000" end
	local formatted_time = reaper.format_timestr_pos(seconds, "", 3)
	local time_in_seconds = tonumber(formatted_time)
	
	local sign = ""
	if time_in_seconds < 0 then
		sign = "-"
		time_in_seconds = math.abs(time_in_seconds)
	end
	
	local hours = math.floor(time_in_seconds / 3600)
	local minutes = math.floor((time_in_seconds % 3600) / 60)
	local seconds = math.floor(time_in_seconds % 60)
	local milliseconds = math.floor((time_in_seconds - math.floor(time_in_seconds)) * 1000)
	return string.format("%s%02d:%02d:%02d.%03d", sign, hours, minutes, seconds, milliseconds)
end
-- FormatTimeHMSms_StartMinus
-- #######################################
-- #######################################
-- SetTakeMarkerAtEditCursor
function SetTakeMarkerAtEditCursor(color, name_marker)
	local function HexToInt(hex)
		local hex = hex:gsub("#", "")
		local R = tonumber("0x" .. hex:sub(1, 2))
		local G = tonumber("0x" .. hex:sub(3, 4))
		local B = tonumber("0x" .. hex:sub(5, 6))
		return reaper.ColorToNative(R, G, B)
	end

	local color_marker = HexToInt(color) | 0x1000000 -- Цвет метки

	local item = reaper.GetSelectedMediaItem(0, 0) -- Получаем первый выбранный айтем

	if item then -- Проверяем, выбран ли айтем
		local take = reaper.GetActiveTake(item) -- Получаем активный take

		if take then
			local item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION") -- Позиция начала айтема
			local item_len = reaper.GetMediaItemInfo_Value(item, "D_LENGTH") -- Длина айтема
			local take_rate = reaper.GetMediaItemTakeInfo_Value(take, "D_PLAYRATE") -- Playrate
			local take_offset = reaper.GetMediaItemTakeInfo_Value(take, "D_STARTOFFS") -- Offset для take

			-- Получаем позицию Edit Cursor
			local cursor_pos = reaper.GetCursorPosition()

			-- Проверяем, чтобы позиция Edit Cursor была в пределах айтема
			if cursor_pos >= item_pos and cursor_pos <= item_pos + item_len then
				-- Вычисляем позицию маркера относительно take с учётом Playrate и Offset
				local take_pos = (cursor_pos - item_pos) * take_rate + take_offset

				-- Устанавливаем маркер на вычисленную позицию
				local take_marker_index = -1 -- Индекс маркера

				reaper.SetTakeMarker(take, take_marker_index, name_marker, take_pos, color_marker)
			end
		end
	end

	reaper.Main_OnCommand(reaper.NamedCommandLookup(40289), 0) -- Item: Unselect (clear selection of) all items
end
-- SetTakeMarkerAtEditCursor
-- #######################################
-- #######################################
-- DeleteTakeMarkersSelectItemOrTimeSelection
function DeleteTakeMarkersSelectItemOrTimeSelection()
	reaper.Undo_BeginBlock()
	local time_sel_start, time_sel_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
	local use_time_selection = time_sel_start ~= time_sel_end  -- Проверяем, установлена ли Time Selection
	for i = 0, reaper.CountSelectedMediaItems(0) - 1 do
		local item = reaper.GetSelectedMediaItem(0, i)
		local item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")  -- Позиция айтема
		local item_len = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")  -- Длина айтема
		local item_end = item_pos + item_len
		local take = reaper.GetActiveTake(item)
		if take then
			local num_markers = reaper.GetNumTakeMarkers(take)
			for j = num_markers - 1, 0, -1 do  -- Удаляем с конца, чтобы не сбить индексы
				local marker_pos = reaper.GetTakeMarker(take, j)  -- Позиция маркера относительно айтема
				local marker_global_pos = item_pos + marker_pos  -- Глобальная позиция маркера в проекте
				-- Если Time Selection установлена, проверяем попадание маркера в диапазон
				if not use_time_selection or (marker_global_pos >= time_sel_start and marker_global_pos <= time_sel_end) then
					reaper.DeleteTakeMarker(take, j)
				end
			end
		end
	end
	reaper.Undo_EndBlock("Удаление Take Markers в выделенных айтемах", -1)
end
-- DeleteTakeMarkersSelectItemOrTimeSelection
-- #######################################
-- #######################################
-- CreateProjectMarkerPositionColor
function CreateProjectMarkerPositionColor (marker_name, marker_color, marker_position)
	local marker_color = marker_color:gsub("#","");
	local R = tonumber("0x"..marker_color:sub(1,2));
	local G = tonumber("0x"..marker_color:sub(3,4));
	local B = tonumber("0x"..marker_color:sub(5,6));

	-- local time_position = marker_position  -- 6589 миллисекунд = 6.589 секунд
	local time_position = marker_position or reaper.GetCursorPosition()
	reaper.AddProjectMarker2(0, false, time_position, 0, marker_name, -1, reaper.ColorToNative( R, G, B ) | 0x1000000 )
end
-- CreateProjectMarkerPositionColor
-- #######################################
-- #######################################
-- DeleteMarkersInTimeSelection
function DeleteMarkersInTimeSelection()
	local time_start, time_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
	if time_start == time_end then return end -- Нет Time Selection

	local num_markers, num_regions = reaper.CountProjectMarkers(0)
	local total = num_markers + num_regions

	-- Сначала собрать индексы нужных маркеров
	local to_delete = {}
	for i = 0, total - 1 do
		local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
		if retval and not isrgn and pos >= time_start and pos <= time_end then
			table.insert(to_delete, markrgnindexnumber)
		end
	end

	-- Удалить по собранным индексам
	for i = 1, #to_delete do
		reaper.DeleteProjectMarker(0, to_delete[i], false)
	end
end
-- DeleteMarkersInTimeSelection
-- #######################################
-- #######################################
-- DeleteStartEndMarkers
function DeleteStartEndMarkers()
	local _, num_markers, num_regions = reaper.CountProjectMarkers(0)

	for i = num_markers + num_regions - 1, 0, -1 do
		local retval, isrgn, pos, rgnend, name, idx = reaper.EnumProjectMarkers(i)
		if not isrgn and (name == "=START" or name == "=END") then
			reaper.DeleteProjectMarker(0, idx, false)
		end
	end
end
-- DeleteStartEndMarkers
-- #######################################
-- #######################################
-- SetTimeSelectionFromMarkers
function SetTimeSelectionFromMarkers()
	local start_pos, end_pos = nil, nil
	local _, num_markers, num_regions = reaper.CountProjectMarkers(0)
	for i = 0, num_markers + num_regions - 1 do
		local retval, isrgn, pos, rgnend, name, idx = reaper.EnumProjectMarkers(i)
		if not isrgn then
			if name == "=START" then start_pos = pos end
			if name == "=END" then end_pos = pos end
		end
	end
	if start_pos and end_pos and end_pos > start_pos then
		reaper.GetSet_LoopTimeRange(true, false, start_pos, end_pos, false)
		reaper.SetEditCurPos(start_pos, true, false) -- опционально: переместить курсор в начало
		reaper.UpdateArrange()
	else
		-- reaper.ShowMessageBox("Не удалось найти маркеры '=START' и '=END' или они расположены некорректно.", "Ошибка", 0)
	end
end
-- SetTimeSelectionFromMarkers
-- #######################################
-- #######################################
-- SetStartEndMarkersFromSelectedItem
function SetStartEndMarkersFromSelectedItem(mode)
	if mode ~= "item" and mode ~= "time_selection" then return end

	local start_pos, end_pos

	if mode == "item" then
		local item = reaper.GetSelectedMediaItem(0, 0)
		if not item then return end
		start_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
		end_pos = start_pos + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

	elseif mode == "time_selection" then
		start_pos, end_pos = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
		if start_pos == end_pos then return end
	end

	local start_idx, end_idx

	local _, num_markers, _ = reaper.CountProjectMarkers(0)
	for i = 0, num_markers - 1 do
		local _, _, pos, _, name, idx = reaper.EnumProjectMarkers(i)
		if name == "=START" then start_idx = idx end
		if name == "=END" then end_idx = idx end
	end

	if start_idx then
		reaper.SetProjectMarker(start_idx, false, start_pos, 0, "=START")
	end
	if end_idx then
		reaper.SetProjectMarker(end_idx, false, end_pos, 0, "=END")
	end
end
-- SetStartEndMarkersFromSelectedItem
-- #######################################
-- #######################################
local font_verdana = LoadSavedFonts("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiFontSize")
-- local font_verdana = LoadSavedFonts()
-- LoadSavedFonts()
-- Загружаем шрифты при запуске
-- local font_size_verdana_18 = reaper.ImGui_CreateFont('verdana', 18)
-- reaper.ImGui_Attach(ctx, font_size_verdana_18)
-- #######################################
-- #######################################
local alpha_window_ImGui = tonumber(reaper.GetExtState("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiAlphaWindow")) or 0.5
local kwoh0uz8nm_name_window = "· · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·"
-- #######################################
-- #######################################
-- Пункт меню по умолчанию
local selected_content = "Frequent_Content_Show" -- Color_Content_Show / Frequent_Content_Show
local current_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiCurrentMenuItem")
local default_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiDefaultMenuItem")

if current_menu_item_imgui == "" then
	reaper.SetExtState("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiCurrentMenuItem", selected_content, true)
end

if default_menu_item_imgui == "" then
	reaper.SetExtState("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiDefaultMenuItem", selected_content, true)
else
	selected_content = default_menu_item_imgui
end
-- Пункт меню по умолчанию
-- ##################################################
-- ##################################################
-- ShowMenuMain
function ShowMenuMain(items)
	local function ThickSeparator(separator_horizontal, separator_color, separator_length)
		local drawList = reaper.ImGui_GetWindowDrawList(ctx) -- Передаём ctx
		local x1, y1 = reaper.ImGui_GetCursorScreenPos(ctx)
		-- Если указан separator_length, используем его, иначе на всю ширину окна
		local x2 = x1 + (separator_length or reaper.ImGui_GetWindowWidth(ctx))
		-- Толщина разделителя
		local thickness = tonumber(separator_horizontal) or 1
		-- Преобразуем цвет из #RRGGBB в формат 0xAARRGGBB
		local color = HexToColor(separator_color or "#3F3F48")
		-- Рисуем горизонтальную линию
		reaper.ImGui_DrawList_AddLine(drawList, x1, y1 + thickness, x2, y1 + thickness, color, thickness)
	end

	for _, item in ipairs(items) do
		if item.spacing_vertical then -- Если встречаем spacing_vertical, добавляем вертикальное пространство
			local spacing_vertical = tonumber(item.spacing_vertical) -- Преобразуем значение в число
			if spacing_vertical then
				reaper.ImGui_Dummy(ctx, 0, spacing_vertical) -- Добавление вертикального пространства
			end
			-- return
		elseif item.separator_horizontal then
			if item.separator_horizontal == "ImGui_SeparatorText" then
				local separator_text = item.separator_text or "" -- Используем переданный текст или пустую строку
				reaper.ImGui_SeparatorText(ctx, separator_text)
			else
				ThickSeparator(item.separator_horizontal, item.separator_color, item.separator_length)
			end
		elseif item.children then
			if reaper.ImGui_BeginMenu(ctx, item.key) then
				ShowMenuMain(item.children)
				reaper.ImGui_EndMenu(ctx)
			end
		else
			if reaper.ImGui_MenuItem(ctx, item.key) then
				if item.action_id then
					reaper.Main_OnCommand(reaper.NamedCommandLookup(item.action_id), 0)
				elseif item.action_function then
					item.action_function()
				elseif item.show_content then
					selected_content = item.show_content
					reaper.SetExtState("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiCurrentMenuItem", selected_content, true)
				end
			end
		end
	end
end
-- ShowMenuMain
-- ##################################################
-- ##################################################
-- SetDefaultMenuItemImGui
function SetDefaultMenuItemImGui ()
	current_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiCurrentMenuItem")
	reaper.SetExtState("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiDefaultMenuItem", current_menu_item_imgui, true)
end
-- ##################################################
-- ##################################################
-- main_ImGui
function main_ImGui()
	reaper.ImGui_SetNextWindowBgAlpha(ctx, alpha_window_ImGui) -- Установить прозрачность фона окна
	reaper.ImGui_PushFont (ctx, font_verdana[get_font_size ("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiFontSizeGlobal")])
	-- reaper.ImGui_SetNextWindowSize(ctx, 500, 300, reaper.ImGui_Cond_FirstUseEver())

	local visible, open = reaper.ImGui_Begin(ctx, kwoh0uz8nm_name_window, true, reaper.ImGui_WindowFlags_MenuBar())
	if visible then
		if reaper.ImGui_BeginMenuBar(ctx) then
			ShowMenuMain(menu_structure)
			reaper.ImGui_EndMenuBar(ctx)
		end
		
		-- #######################################
		-- menu_structure___
		if selected_content == "" then
		elseif selected_content == "Item_Length_Content_Show" then
			reaper.ImGui_PushFont (ctx, font_verdana[get_font_size ("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiFontSize_ItemLengthContent")])
			
			if reaper.ImGui_BeginTabBar(ctx, "Item Length & Insert Marker") then
			
			
				-- Вкладка — Item Length —————————————————————————
				if reaper.ImGui_BeginTabItem(ctx, "Length") then
					local selected_input_width = 200
					
					
					reaper.ImGui_SetNextItemOpen(ctx, true, reaper.ImGui_Cond_Once())
					if reaper.ImGui_CollapsingHeader(ctx, "Item, Time, Marker", 0) then
						-- reaper.ImGui_Indent(ctx) -- сделать отступ слева
						
						
						-- Item Length
						reaper.ImGui_SeparatorText( ctx, "Item Length" )
						local item_start_time, item_end_time = GetTimeRange ("item")
						local input_item_text = GetRealLengthWithPlayrate(item_start_time, item_end_time)
						if input_item_text == 0 then
							input_item_text = "No Item Selected" -- input_item_text
						else
							input_item_text = FormatTimeHMSms_StartZero (input_item_text)
						end
						reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
						reaper.ImGui_InputText(ctx, "##input_item_text", input_item_text, reaper.ImGui_InputTextFlags_ReadOnly())
						-- Item Length
						
						
						-- Time Selection
						reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
						reaper.ImGui_SeparatorText( ctx, "Time Selection" )
						local time_selection_start_time, time_selection_end_time = GetTimeRange ("time_selection")
						local input_text_time_selection = GetRealLengthWithPlayrate(time_selection_start_time, time_selection_end_time)
						if input_text_time_selection == 0 then
							input_text_time_selection = "No Time Selection" -- input_item_text
						else
							input_text_time_selection = FormatTimeHMSms_StartZero (input_text_time_selection)
						end
						reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
						reaper.ImGui_InputText(ctx, "##input_text_time_selection", input_text_time_selection, reaper.ImGui_InputTextFlags_ReadOnly())
						-- Time Selection
						
						
						-- Marker Start End
						reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
						reaper.ImGui_SeparatorText( ctx, "Marker Start & End" )
						local marker_start_time, marker_end_time = GetTimeRange ("markers")
						local input_text_markers = GetRealLengthWithPlayrate(marker_start_time, marker_end_time)
						if input_text_markers == 0 then
							input_text_markers = "No Marker Start & End" -- input_item_text
						else
							input_text_markers = FormatTimeHMSms_StartZero (input_text_markers)
						end
						reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
						reaper.ImGui_InputText(ctx, "##input_text_markers", input_text_markers, reaper.ImGui_InputTextFlags_ReadOnly())
						-- Marker Start End
						
						
						reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
						-- reaper.ImGui_Unindent(ctx) -- вернуть отступ обратно
					end
					
					-- reaper.ImGui_SetNextItemOpen(ctx, true, reaper.ImGui_Cond_Once())
					if reaper.ImGui_CollapsingHeader(ctx, "Mouse", 0) then
						-- reaper.ImGui_Indent(ctx) -- сделать отступ слева
					
						-- Mouse Position Project
						reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
						reaper.ImGui_SeparatorText( ctx, "Mouse Position Project" )
						
						local cursorMouse_time_StartZero = FormatTimeHMSms_StartZero ( GetMouseTimeWithPlayrate ("mouse") )
						reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
						reaper.ImGui_InputText(ctx, "Start Zero", cursorMouse_time_StartZero, reaper.ImGui_InputTextFlags_ReadOnly())
						
						local cursorMouse_time_StartMinus = FormatTimeHMSms_StartMinus ( GetMouseTimeWithPlayrate ("mouse") )
						reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
						reaper.ImGui_InputText(ctx, "Start Minus", cursorMouse_time_StartMinus, reaper.ImGui_InputTextFlags_ReadOnly())
						-- Mouse Position Project
						
						
						-- Mouse Relative Time Selection
						reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
						reaper.ImGui_SeparatorText( ctx, "Mouse Relative Time Selection" )
						local mouse_relative_time_selection = FormatTimeHMSms_StartZero ( GetMouseTimeWithPlayrate ("mouse_relative_time_selection") )
						
						reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
						reaper.ImGui_InputText(ctx, "##Mouse Position", mouse_relative_time_selection, reaper.ImGui_InputTextFlags_ReadOnly())
						-- Mouse Relative Time Selection
						
						
						-- Mouse Relative Marker
						reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
						reaper.ImGui_SeparatorText( ctx, "Mouse Relative Marker" )
						local mouse_relative_marker = FormatTimeHMSms_StartZero ( GetMouseTimeWithPlayrate ("mouse_relative_marker") )
						
						reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
						reaper.ImGui_InputText(ctx, "##Mouse Relative Marker", mouse_relative_marker, reaper.ImGui_InputTextFlags_ReadOnly())
						-- Mouse Relative Marker
						reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
						-- reaper.ImGui_Unindent(ctx) -- вернуть отступ обратно
					end
					
					
					-- reaper.ImGui_SetNextItemOpen(ctx, true, reaper.ImGui_Cond_Once())
					if reaper.ImGui_CollapsingHeader(ctx, 'Edit Cursor', 0) then
						-- reaper.ImGui_Indent(ctx) -- сделать отступ слева
						
						
						-- Edit Cursor Position Project
						reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
						reaper.ImGui_SeparatorText( ctx, "Edit Cursor Position Project" )
						local EditCursor_StartZero = FormatTimeHMSms_StartZero ( GetMouseTimeWithPlayrate ("edit_cursor") )
						local EditCursor_StartMinus = FormatTimeHMSms_StartMinus ( GetMouseTimeWithPlayrate ("edit_cursor") )
						reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
						reaper.ImGui_InputText(ctx, "Start Zero ", EditCursor_StartZero, reaper.ImGui_InputTextFlags_ReadOnly())
						reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
						reaper.ImGui_InputText(ctx, "Start Minus ", EditCursor_StartMinus, reaper.ImGui_InputTextFlags_ReadOnly())
						-- Edit Cursor Position Project
						
						
						-- Edit Cursor Relative Time Selection
						reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
						reaper.ImGui_SeparatorText( ctx, "Edit Cursor Relative Time Selection" )
						local EditCursor_RelativeTimeSelection = FormatTimeHMSms_StartZero ( GetMouseTimeWithPlayrate ("edit_cursor_relative_time_selection") )
						reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
						reaper.ImGui_InputText(ctx, "##Edit Cursor Relative Time Selection", EditCursor_RelativeTimeSelection, reaper.ImGui_InputTextFlags_ReadOnly())
						-- Edit Cursor Relative Time Selection
						
						
						-- Edit Cursor Relative Marker
						reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
						reaper.ImGui_SeparatorText( ctx, "Edit Cursor Relative Marker" )
						local EditCursor_RelativeMarker = FormatTimeHMSms_StartZero ( GetMouseTimeWithPlayrate ("edit_cursor_relative_marker") )
						reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
						reaper.ImGui_InputText(ctx, "##Edit Cursor Relative Marker", EditCursor_RelativeMarker, reaper.ImGui_InputTextFlags_ReadOnly())
						-- Edit Cursor Relative Marker
						
						
						reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
						-- reaper.ImGui_Unindent(ctx) -- вернуть отступ обратно
					end
					
				reaper.ImGui_EndTabItem(ctx)
				end
				-- Вкладка — Item Length —————————————————————————
				
				
				-- Вкладка — Insert Marker —————————————————————————
				if reaper.ImGui_BeginTabItem(ctx, "Marker") then
					-- reaper.ImGui_SeparatorText( ctx, "Insert Marker" )
					
					-- insert_empty_item_library
					local insert_empty_item_library = {
						key = "Insert", default_open = true, children = {
						
							{key = "Set Item Marker At Edit Cursor", children = { -- default_open = true, 
								{key = "Empty", action_function = function() SetTakeMarkerAtEditCursor ( "#40FF00", "" ) end}, -- █ ● ▰ ✖ ×
								{key = "Introduction", action_function = function() SetTakeMarkerAtEditCursor ( "#40FF00", "Вступление" ) end}, -- █ ● ▰ ✖ ×
								{key = "Couplet", action_function = function() SetTakeMarkerAtEditCursor ( "#40FF00", "Куплет" ) end}, -- █ ● ▰ ✖ ×
								{key = "Chorus", action_function = function() SetTakeMarkerAtEditCursor ( "#40FF00", "Припев" ) end}, -- █ ● ▰ ✖ ×
								{spacing_vertical = "2"},
								{separator_horizontal = "2", separator_color = "#636372" },
								{spacing_vertical = "5"},
								{key = "× Delete Item Markers Select Item Or Time Selection", action_function = function() DeleteTakeMarkersSelectItemOrTimeSelection() end}, -- █ ● ▰ ✖ ×
								{key = "× Item: Delete all take markers", action_id = "42387"},
							},},
							
							{key = "Set Marker At Edit Cursor", default_open = true, children = {
								{key = "Set marker in time 00:01:30.950", action_function = function() CreateProjectMarkerPositionColor ( "00:01:30.950", "#FF0000", 94.950 ) end},
								{key = "Set marker in time 00:01:32.950", action_function = function() CreateProjectMarkerPositionColor ( "00:01:32.950", "#FF0000", 96.950 ) end},
								{spacing_vertical = "2"},
								{separator_horizontal = "2", separator_color = "#636372" },
								{spacing_vertical = "5"},
								{key = "Set marker =START to position Edit Cursor", action_function = function() CreateProjectMarkerPositionColor ( "=START", "#FF0000" ) end},
								{key = "Set Marker =END to position Edit Cursor", action_function = function() CreateProjectMarkerPositionColor ( "=END", "#FF0000" ) end},
								{spacing_vertical = "2"},
								{separator_horizontal = "2", separator_color = "#636372" },
								{spacing_vertical = "5"},
								{key = "Set Time Selection From Markers =START & =END", action_function = function() SetTimeSelectionFromMarkers (  ) end},
								{key = "Set Markers =START & =END From Selected Item", action_function = function() SetStartEndMarkersFromSelectedItem ("item") end},
								{key = "Set Markers =START & =END From Time Selection", action_function = function() SetStartEndMarkersFromSelectedItem ("time_selection") end},
								{spacing_vertical = "2"},
								{separator_horizontal = "2", separator_color = "#636372" },
								{spacing_vertical = "5"},
								
								-- {key = "× Delete Markers In Time Selection", action_function = function() DeleteMarkersInTimeSelection () end},
								{key = "× Delete Markers =START & =END", action_function = function() DeleteStartEndMarkers () end},
								{key = "× Markers: Remove all markers from time selection", action_id = "40420"},
								{key = "× Time selection: Remove (unselect) time selection", action_id = "40635"},
							},},
							{key = "Item properties", children = { -- default_open = true, 
								{key = "Item properties: Item ruler settings", action_id = "42355"},
								{spacing_vertical = "2"},
								{separator_horizontal = "2", separator_color = "#636372" },
								{spacing_vertical = "5"},
								{key = "Item properties: Display item time ruler", action_id = "42312"},
								{key = "Item properties: Display item time ruler in H:M:S:F format", action_id = "42314"},
								-- {key = "Item properties: Display item source time ruler in H:M:S:F format", action_id = "42358"},
								{key = "Item properties: Display item source time ruler in H:M:S:F format, apply media source BWF start offset", action_id = "42420"},
								{key = "Item properties: Display item source time ruler, apply media source BWF start offset", action_id = "42419"},
								{spacing_vertical = "2"},
								{separator_horizontal = "2", separator_color = "#636372" },
								{spacing_vertical = "5"},
								{key = "Item properties: Display item beats ruler (constant time signature)", action_id = "42315"},
								{key = "Item properties: Display item beats ruler (minimal, constant time signature)", action_id = "42359"},
								-- {key = "Item properties: Display item source time ruler", action_id = "42313"},
								{spacing_vertical = "20"},

							},},
						},
					}
					
					TreeNodeLibraryOutput(insert_empty_item_library)
					
					--[[
					
					Item properties: Display item beats ruler (constant time signature)¦42315
					Item properties: Display item beats ruler (minimal, constant time signature)¦42359
					Item properties: Display item source time ruler¦42313
					Item properties: Display item source time ruler in H:M:S:F format¦42358
					Item properties: Display item source time ruler in H:M:S:F format, apply media source BWF start offset¦42420
					Item properties: Display item source time ruler, apply media source BWF start offset¦42419
					Item properties: Display item time ruler¦42312
					Item properties: Display item time ruler in H:M:S:F format¦42314
					
					{key = "INSERT_001", action_id = "INSERT_001"},
					
					]]--
					
					
				reaper.ImGui_EndTabItem(ctx)
				end
				-- Вкладка — Insert Marker —————————————————————————
			
			
			reaper.ImGui_EndTabBar(ctx)
			end
			
			reaper.ImGui_PopFont(ctx)
		elseif selected_content == "Content_1_Show" then
			reaper.ImGui_SeparatorText( ctx, "Content 1" )
			
			reaper.ImGui_PushFont (ctx, font_verdana[get_font_size ("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiFontSizeContent_1")])
			reaper.ImGui_Text(ctx, "Content 1 - " .. get_font_size ("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiFontSizeContent_1"))
			reaper.ImGui_PopFont(ctx)
			
			local library_grid_main = {
				key = "Grid: Set to", default_open = true, children = {
					{spacing_vertical = "1"},
					{separator_horizontal = "3", separator_color = "#3F3F48" },
					{spacing_vertical = "7"},
					{key = "Grid: Set to 4", action_id = "41211"},
					{key = "Grid: Set to 3", action_id = "42006"},
					{key = "Grid: Set to 2", action_id = "41210"},
					{key = "Grid: Set to 1", action_id = "40781"},
					{key = "Grid: Set to 1/2", action_id = "40780"},
					{key = "Grid: Set to 1/4", action_id = "40779"},
					{key = "Grid: Set to 1/8", action_id = "40778"},
					{key = "Grid: Set to 1/16", action_id = "40776"},
					{spacing_vertical = "1"},
					{separator_horizontal = "3", separator_color = "#3F3F48" },
					{spacing_vertical = "7"},
					--[[
					{key = "User Functions", children = {
						{spacing_vertical = "1"},
						{separator_horizontal = "2", separator_color = "#EBEBEB" },
						{separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},
						{separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 148 },
					
						{key = "Command ID 1", action_id = "41930"},
						{key = "Command ID 2", action_id = "_RS251990727759d3dff9cf84df740cd6a87ea0d169"},
						{key = "User Function 2", action_function = function() reaper.Main_OnCommand(40772, 0) end},
						{key = "User Function 3", action_function = function() print_rs("=====") end},
					}},
					]]--
				},
			}
			
			TreeNodeLibraryOutput(library_grid_main) -- передаём корневой элемент
			
		elseif selected_content == "Content_2_Show" then
			reaper.ImGui_SeparatorText( ctx, "Content 2" )
			
			reaper.ImGui_PushFont (ctx, font_verdana[get_font_size ("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiFontSizeContent_2")])
			reaper.ImGui_Text(ctx, "Content 2 - " .. get_font_size ("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiFontSizeContent_2"))
			reaper.ImGui_PopFont(ctx)
			
			
			reaper.ImGui_TextWrapped(ctx, "MaxMusicMax MaxMusicMax MaxMusicMax MaxMusicMax MaxMusicMax MaxMusicMax MaxMusicMax MaxMusicMax MaxMusicMax MaxMusicMax MaxMusicMax MaxMusicMax ")
			
			
		elseif selected_content == "Set_Font_Size_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Set Font Size" )
			reaper.ImGui_Text(ctx, "Restart the script for some settings to take effect")
			reaper.ImGui_Dummy(ctx, 0, 10) -- Добавление вертикального пространства
			
			ImGuiSelectComboBox("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiFontSizeGlobal", 100)
			reaper.ImGui_SameLine(ctx)
			reaper.ImGui_Text(ctx, "Font Size Global")
			
			ImGuiSelectComboBox("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiFontSize_ItemLengthContent", 100)
			reaper.ImGui_SameLine(ctx)
			reaper.ImGui_Text(ctx, "Item Length")
			
			-- ImGuiSelectComboBox("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiFontSizeContent_1", 100)
			-- reaper.ImGui_SameLine(ctx)
			-- reaper.ImGui_Text(ctx, "Content 1")
			
			-- ImGuiSelectComboBox("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiFontSizeContent_2", 100)
			-- reaper.ImGui_SameLine(ctx)
			-- reaper.ImGui_Text(ctx, "Content 2")
		elseif selected_content == "Alpha_Window_ImGui_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Alpha Window ImGui" )
			local changed, new_alpha = reaper.ImGui_DragDouble(ctx, ' ', alpha_window_ImGui, 0.01, 0.0, 1.0, '%.2f')
			if changed then
				alpha_window_ImGui = new_alpha
				reaper.SetExtState("MaxMusicMax_ImGuiWindow", "kwoh0uz8nm_ImGuiAlphaWindow", tostring(alpha_window_ImGui), true)
			end
		else
			reaper.ImGui_Text(ctx, "Select a menu item to see the content.")
		end
		-- menu_structure___
		-- #######################################
		
		reaper.ImGui_End(ctx)
	end
	reaper.ImGui_PopFont (ctx)
	if open then
		reaper.defer(main_ImGui)
	end
end

reaper.defer(main_ImGui)
-- #######################################
-- #######################################
reaper.PreventUIRefresh(-1);
reaper.TrackList_AdjustWindows(0)  -- Updates the window view
reaper.UpdateArrange();  -- Updates the window view
-- #######################################
-- #######################################