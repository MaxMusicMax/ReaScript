--@description ImGui; Item; Length Item Given Playrate On The Master Channel
--@version 1.0
--@author MaxMusicMax
-- https://forum.cockos.com/showthread.php?p=2059855
-- #######################################
-- #######################################
-- 1111111111111111111111111111
-- menu_structure___

-- cboc2 / create_button_one_click2
-- TreeNodeLibraryOutput
-- DeleteMarkersInTimeSelection
-- SetTakeMarkerAtEditCursor
-- CreateProjectMarkerPositionColor
-- DeleteTakeMarkersSelectItemOrTimeSelection
-- GetEditCursorPositionTimeStartZero
-- GetEditCursorPositionTimeStartMinus
-- timeToMilliseconds
-- formatMilliseconds
-- GetMasterTrackPlayrate
-- ShowPlayrateInfo
-- GetEditCursorTimeStartZero
-- GetMouseTimeStartZero
-- GetMouseTimeStartMinus
-- GetTimeSelectionFormatted
-- GetMarkerStartEndFormatted

-- ShowMenuItems
-- SetDefaultMenuItemImGui
-- function main
-- reaper.defer(main)
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
-- print_rs (track)

--[[

]]--
-- reaper.Main_OnCommand(40726, 0) -- Envelope: Insert 4 envelope points at time selection 40726
-- commandID = reaper.NamedCommandLookup("_RSd0e03fb8cf39d47509ddbf616a11d2b7e4afa29c")
-- reaper.Main_OnCommand(commandID, 0)
-- reaper.Main_OnCommand(reaper.NamedCommandLookup(39214), 0)
-- reaper.Main_OnCommand(reaper.NamedCommandLookup("_RSd0e03fb8cf39d47509ddbf616a11d2b7e4afa29c"), 0)
-- #######################################
-- #######################################
local ctx = reaper.ImGui_CreateContext('ImGui; ItemLength; Menu Popup; Bar Menu')
-- #######################################
-- #######################################
-- cboc2 / create_button_one_click2
function cboc2(label, callback_function, button_width, button_height, window_focus ) -- window_focus — true или false
	if reaper.ImGui_Button( ctx, label, button_width, button_height ) then
		callback_function()
		if window_focus then -- true или false
			reaper.Main_OnCommand(reaper.NamedCommandLookup("_BR_FOCUS_ARRANGE_WND"), 0)
        end
		-- print_rs("create_button_one_click: " .. label)
	end
end
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
-- #######################################
-- #######################################
-- GetEditCursorPositionTimeStartZero
function GetEditCursorPositionTimeStartZero()
    local time = reaper.GetCursorPosition()
    if time and time >= 0 then
        local hours = math.floor(time / 3600)
        local minutes = math.floor((time % 3600) / 60)
        local seconds = math.floor(time % 60)
        local milliseconds = math.floor((time % 1) * 1000)
        return string.format("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)
    end
    return "00:00:00.000" -- Если время недоступно
end
-- #######################################
-- #######################################
-- GetEditCursorPositionTimeStartMinus
function GetEditCursorPositionTimeStartMinus()
	-- Получаем позицию Edit Cursor
	local cursor_pos = reaper.GetCursorPosition()

	-- Получаем время в секундах с флагом 3 (точный формат в секундах)
	local formatted_time = reaper.format_timestr_pos(cursor_pos, "", 3)

	-- Конвертируем строку времени в число
	local time_in_seconds = tonumber(formatted_time)

	-- Проверка знака
	local sign = ""
	if time_in_seconds < 0 then
		sign = "-"
		time_in_seconds = math.abs(time_in_seconds)
	end

	-- Перевод в формат ЧЧ:ММ:СС.ммм
	local hours = math.floor(time_in_seconds / 3600)
	local minutes = math.floor((time_in_seconds % 3600) / 60)
	local seconds = math.floor(time_in_seconds % 60)
	local milliseconds = math.floor((time_in_seconds % 1) * 1000)

	-- Форматируем строку с учётом знака
	local result = string.format("%s%02d:%02d:%02d.%03d", sign, hours, minutes, seconds, milliseconds)

	return result
end
-- #######################################
-- #######################################
-- timeToMilliseconds
-- Функция для преобразования времени в миллисекунды
function timeToMilliseconds(timeString)
    local h, m, s, ms = timeString:match("(%d+):(%d+):(%d+)%.(%d+)")
    if h and m and s and ms then
        return (tonumber(h) * 3600 + tonumber(m) * 60 + tonumber(s)) * 1000 + tonumber(ms)
    end
    return 0
end
-- #######################################
-- #######################################
-- formatMilliseconds
-- Функция форматирования миллисекунд в формат ЧЧ:ММ:СС.ммм
function formatMilliseconds(ms)
    local totalSeconds = math.floor(ms) -- Отделяем целые секунды
    local milliseconds = math.floor((ms % 1) * 1000) -- Оставляем дробную часть как миллисекунды
    local hours = math.floor(totalSeconds / 3600)
    local minutes = math.floor((totalSeconds % 3600) / 60)
    local seconds = totalSeconds % 60

    return string.format("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)
end
-- #######################################
-- #######################################
-- GetMasterTrackPlayrate
-- Функция получения Playrate с мастер-трека
function GetMasterTrackPlayrate()
    local master_track = reaper.GetMasterTrack(0)
    local playrate_envelope = reaper.GetTrackEnvelopeByName(master_track, "Playrate")

    if playrate_envelope then
        local cursor_position = reaper.GetCursorPosition()
        local retval, playrate_value, _, _ = reaper.Envelope_Evaluate(playrate_envelope, cursor_position, 0, 0)
        return playrate_value
    else
        return 1.0 -- Если Playrate не найден, возвращаем 1.0
    end
end
-- #######################################
-- #######################################
-- ShowPlayrateInfo
function ShowPlayrateInfo(new_length_ms)
	local item = reaper.GetSelectedMediaItem(0, 0) -- Получаем первый выделенный айтем
	if item then
		local playrate = GetMasterTrackPlayrate() -- Получаем текущий Playrate с мастер-трека

		-- Если указана новая длина, обновляем её
		if new_length_ms then
			local new_length_sec = new_length_ms / 1000 -- Переводим миллисекунды в секунды
			reaper.SetMediaItemInfo_Value(item, "D_LENGTH", new_length_sec * playrate)
		end

		-- Получаем текущую длину айтема и корректируем с учётом Playrate
		local item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH") -- Длина в секундах
		local corrected_length = item_length / playrate -- Учитываем Playrate
		local timeString = formatMilliseconds(corrected_length) -- Форматируем в строку
		return timeString, corrected_length * 1000 -- Возвращаем строку и миллисекунды
	else
		return "No item selected.", 0
	end
end
-- #######################################
-- #######################################
-- GetEditCursorTimeStartZero
function GetEditCursorTimeStartZero()
	local time = reaper.GetCursorPosition()
	if time and time >= 0 then
		local hours = math.floor(time / 3600)
		local minutes = math.floor((time % 3600) / 60)
		local seconds = math.floor(time % 60)
		local milliseconds = math.floor((time % 1) * 1000)
		return string.format("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)
	end
	return "00:00:00.000" -- Если время недоступно
end
-- #######################################
-- #######################################
-- GetMouseTimeStartZero
function GetMouseTimeStartZero()
	local context = reaper.BR_GetMouseCursorContext()
	if context == "arrange" or context == "ruler" then
		local time = reaper.BR_GetMouseCursorContext_Position()
		if time and time >= 0 then
			local hours = math.floor(time / 3600)
			local minutes = math.floor((time % 3600) / 60)
			local seconds = math.floor(time % 60)
			local milliseconds = math.floor((time % 1) * 1000)
			return string.format("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)
		end
	end
	return "00:00:00.000" -- Если курсор вне области
end
-- #######################################
-- #######################################
-- GetMouseTimeStartMinus
function GetMouseTimeStartMinus()
	local context = reaper.BR_GetMouseCursorContext()
	if context == "arrange" or context == "ruler" then
		local time = reaper.BR_GetMouseCursorContext_Position()
		if time and time >= 0 then
			local formatted_time = reaper.format_timestr_pos(time, "", 3)
			local time_in_seconds = tonumber(formatted_time) or 0

			local sign = ""
			if time_in_seconds < 0 then
				sign = "-"
				time_in_seconds = math.abs(time_in_seconds)
			end

			local hours = math.floor(time_in_seconds / 3600)
			local minutes = math.floor((time_in_seconds % 3600) / 60)
			local seconds = math.floor(time_in_seconds % 60)
			local milliseconds = math.floor((time_in_seconds % 1) * 1000)

			return string.format("%s%02d:%02d:%02d.%03d", sign, hours, minutes, seconds, milliseconds)
		end
	end
	return "00:00:00.000" -- Если курсор вне области
end
-- #######################################
-- #######################################
-- GetTimeSelectionFormatted
function GetTimeSelectionFormatted()
	local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
	local duration = end_time - start_time
	if duration <= 0 then return "No Time Selection" end

	local master_track = reaper.GetMasterTrack(0)
	local playrate_env = reaper.GetTrackEnvelopeByName(master_track, "Playrate")

	if not playrate_env then
		local total_ms = math.floor(duration * 1000 + 0.5)
		local hours = math.floor(total_ms / 3600000)
		local minutes = math.floor((total_ms % 3600000) / 60000)
		local seconds = math.floor((total_ms % 60000) / 1000)
		local milliseconds = total_ms % 1000
		return string.format("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)
	end

	local steps = 100
	local step_size = duration / steps
	local corrected_duration = 0

	for i = 0, steps - 1 do
		local t = start_time + i * step_size
		local _, playrate = reaper.Envelope_Evaluate(playrate_env, t, 0, 0)
		corrected_duration = corrected_duration + (step_size / playrate)
	end

	local total_ms = math.floor(corrected_duration * 1000 + 0.5)
	local hours = math.floor(total_ms / 3600000)
	local minutes = math.floor((total_ms % 3600000) / 60000)
	local seconds = math.floor((total_ms % 60000) / 1000)
	local milliseconds = total_ms % 1000

	return string.format("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)
end
-- #######################################
-- #######################################
-- GetMarkerStartEndFormatted
function GetMarkerStartEndFormatted()
	local start_pos, end_pos = nil, nil
	local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
	for i = 0, num_markers + num_regions - 1 do
		local retval, isrgn, pos, rgnend, name, idx = reaper.EnumProjectMarkers(i)
		if not isrgn then
			if name == "=START" then start_pos = pos end
			if name == "=END" then end_pos = pos end
		end
	end

	if not (start_pos and end_pos and end_pos > start_pos) then
		return "No Marker Start End"
	end

	local master_track = reaper.GetMasterTrack(0)
	local playrate_env = reaper.GetTrackEnvelopeByName(master_track, "Playrate")

	if not playrate_env then
		local total_ms = math.floor((end_pos - start_pos) * 1000 + 0.5)
		local hours = math.floor(total_ms / 3600000)
		local minutes = math.floor((total_ms % 3600000) / 60000)
		local seconds = math.floor((total_ms % 60000) / 1000)
		local milliseconds = total_ms % 1000
		return string.format("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)
	end

	local steps = 100
	local step_size = (end_pos - start_pos) / steps
	local corrected_duration = 0

	for i = 0, steps - 1 do
		local t = start_pos + i * step_size
		local _, playrate = reaper.Envelope_Evaluate(playrate_env, t, 0, 0)
		corrected_duration = corrected_duration + (step_size / playrate)
	end

	local total_ms = math.floor(corrected_duration * 1000 + 0.5)
	local hours = math.floor(total_ms / 3600000)
	local minutes = math.floor((total_ms % 3600000) / 60000)
	local seconds = math.floor((total_ms % 60000) / 1000)
	local milliseconds = total_ms % 1000

	return string.format("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)
end
-- #######################################
-- #######################################
-- ShowMenuItems
local selected_content = "Alpha_Window_ImGui_Content_Show" -- Color_Content_Show / Frequent_Content_Show

local current_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiCurrentMenuItemItemLength")
local default_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiDefaultMenuItemLength")
if current_menu_item_imgui == "" then
	reaper.SetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiCurrentMenuItemItemLength", selected_content, true)
end
if default_menu_item_imgui == "" then
	reaper.SetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiDefaultMenuItemLength", selected_content, true)
else
	selected_content = default_menu_item_imgui
end

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
					reaper.SetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiCurrentMenuItemItemLength", selected_content, true)
				end
			end
		end
	end
end
-- ##################################################
-- ##################################################
-- SetDefaultMenuItemImGui
function SetDefaultMenuItemImGui ()
	current_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiCurrentMenuItemItemLength")
	reaper.SetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiDefaultMenuItemLength", current_menu_item_imgui, true)
	-- print_rs ( current_menu_item_imgui )
end
-- ##################################################
-- ##################################################
local font_verdana = reaper.ImGui_CreateFont('verdana', 20) 
reaper.ImGui_Attach(ctx, font_verdana)
-- ##################################################
-- ##################################################
-- menu_structure___
local menu_structure = {
	{label = "Menu", children = {
		{label = "Item Length", show_content = "Item_Length_Content_Show"},
		{label = "Set Alpha Tab ImGui", show_content = "Alpha_Window_ImGui_Content_Show"},
		{label = "Set Default Tab ImGui", action_function = function() SetDefaultMenuItemImGui () end},
	}},
}
-- ##################################################
-- ##################################################
local alpha_window_ImGui = tonumber(reaper.GetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiAlphaWindowItemLength")) or 0.6
local name_window = "Item Length"
-- function main
local function main()
	reaper.ImGui_SetNextWindowBgAlpha(ctx, alpha_window_ImGui) -- Установить прозрачность фона окна
	reaper.ImGui_PushFont (ctx, font_verdana)
	
	local visible, open = reaper.ImGui_Begin(ctx, name_window, true, reaper.ImGui_WindowFlags_MenuBar())
	
	-- visible
	if visible then
		if reaper.ImGui_BeginMenuBar(ctx) then
			ShowMenuItems(menu_structure)
			reaper.ImGui_EndMenuBar(ctx)
		end
		-- ##################################################
		-- menu_structure___
		if selected_content == "" then
		elseif selected_content == "Item_Length_Content_Show" then
		
		if reaper.ImGui_BeginTabBar(ctx, "Item Length & Insert Marker") then
		
			-- Вкладка — Item Length
			if reaper.ImGui_BeginTabItem(ctx, "Length") then
			reaper.ImGui_SeparatorText( ctx, "Item Length" )
			
			local selected_input_width = 200
			
			-- Item Length
			local presets = {
				"00:00:00.000",
				"00:01:00.950",
				"00:01:02.950",
				"00:01:30.950",
				"00:01:32.950",
				"00:02:00.950",
				"00:02:02.950",
				"00:02:30.950",
				"00:02:32.950"
			}
			
			-- Создаём строку с элементами выпадающего списка, разделёнными нулевым символом
			local items = table.concat(presets, "\0") .. "\0" -- добавляем завершающий нулевой символ
			-- Начальный индекс для выпадающего списка
			local selected_preset = 1 -- Например, первый элемент по умолчанию (индексация с 1)
			-- Выпадающий список для выбора предустановки
			reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
			local changed, selected_index = reaper.ImGui_Combo(ctx, "Preset", selected_preset - 1, items)
			if changed then
				-- Получаем длину выбранной предустановки в миллисекундах и обновляем длину айтема
				local preset_value = timeToMilliseconds(presets[selected_index + 1]) -- Индексация с 1
				ShowPlayrateInfo(preset_value) -- Обновляем длину айтема с учётом Playrate
			end
			-- Буфер для редактирования длины в формате времени
			local timeString, corrected_length_ms = ShowPlayrateInfo()
			local input_buffer = timeString
			reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
			local changed, new_input = reaper.ImGui_InputText(ctx, "Enter time", input_buffer)
			
			if changed then
				-- Используем существующую логику для преобразования строки обратно в миллисекунды
				local h, m, s, ms = new_input:match("(%d+):(%d+):(%d+)%.(%d+)")
				if h and m and s and ms then
					local new_length_ms = (tonumber(h) * 3600 + tonumber(m) * 60 + tonumber(s)) * 1000 + tonumber(ms)
					ShowPlayrateInfo(new_length_ms) -- Обновляем длину айтема
				end
			end
			-- Item Length
			
			
			-- Time Selection
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			reaper.ImGui_SeparatorText( ctx, "Time Selection" )
			local input_text = "No Time Selection"
			input_text = GetTimeSelectionFormatted()
			reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
			reaper.ImGui_InputText(ctx, "##Duration", input_text, reaper.ImGui_InputTextFlags_ReadOnly())
			-- Time Selection
			
			
			-- Marker Start End
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			reaper.ImGui_SeparatorText( ctx, "Marker Start End" )
			local input_text_marker = "No Marker Start End"
			input_text_marker = GetMarkerStartEndFormatted()
			reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
			reaper.ImGui_InputText(ctx, "##Duration", input_text_marker, reaper.ImGui_InputTextFlags_ReadOnly())
			-- Marker Start End
			
			
			-- Mouse Position Project
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			reaper.ImGui_SeparatorText( ctx, "Mouse Position Project" )
			local cursorMouse_time_StartZero = GetMouseTimeStartZero()
			reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
			reaper.ImGui_InputText(ctx, "Start Zero", cursorMouse_time_StartZero, reaper.ImGui_InputTextFlags_ReadOnly())
			-- Вторая строка: время через reaper.format_timestr_pos()
			local cursorMouse_time_StartMinus = GetMouseTimeStartMinus()
			reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
			reaper.ImGui_InputText(ctx, "Start Minus", cursorMouse_time_StartMinus, reaper.ImGui_InputTextFlags_ReadOnly())
			-- Mouse Position Project
			
			
			-- Mouse Relative Time Selection
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			reaper.ImGui_SeparatorText( ctx, "Mouse Relative Time Selection" )
			local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
			-- Получение позиции курсора мыши
			local context = reaper.BR_GetMouseCursorContext()
			local cursor_time = ""

			if context == "arrange" or context == "ruler" then
				local mouse_pos = reaper.BR_GetMouseCursorContext_Position()
				-- Вычисление положения курсора мыши относительно Time Selection
				if mouse_pos >= start_time and mouse_pos <= end_time then
					local relative_pos = mouse_pos - start_time
					cursor_time = formatMilliseconds(relative_pos)
				else
					cursor_time = "Out Of Time Selection"
				end
			end
			reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
			reaper.ImGui_InputText(ctx, "##Mouse Relative Time Selection", cursor_time, reaper.ImGui_InputTextFlags_ReadOnly())
			-- Mouse Relative Time Selection
			
			
			-- Edit Cursor Position Project
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			reaper.ImGui_SeparatorText( ctx, "Edit Cursor Position Project" )
			-- Получаем позицию курсора и выводим в поле
			local cursor_time_StartZero = GetEditCursorPositionTimeStartZero()
			local cursor_time_StartMinus = GetEditCursorPositionTimeStartMinus()
			reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
			reaper.ImGui_InputText(ctx, "Start Zero ", cursor_time_StartZero, reaper.ImGui_InputTextFlags_ReadOnly())
			reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
			reaper.ImGui_InputText(ctx, "Start Minus ", cursor_time_StartMinus, reaper.ImGui_InputTextFlags_ReadOnly())
			-- Edit Cursor Position Project
			
			
			-- Edit Cursor Relative Time Selection
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			reaper.ImGui_SeparatorText( ctx, "Edit Cursor Relative Time Selection" )
			-- Получение начала и конца Time Selection
			local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
			-- Получение позиции Edit Cursor
			local edit_cursor_pos = reaper.GetCursorPosition()
			-- Вычисление положения Edit Cursor относительно Time Selection
			local cursor_time = ""
			if edit_cursor_pos >= start_time and edit_cursor_pos <= end_time then
				local relative_pos = edit_cursor_pos - start_time
				cursor_time = formatMilliseconds(relative_pos)
			else
				cursor_time = "Out Of Time Selection"
			end
			-- Отображение времени в ReadOnly поле
			reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
			reaper.ImGui_InputText(ctx, "##Edit Cursor Relative Time Selection", cursor_time, reaper.ImGui_InputTextFlags_ReadOnly())
			-- Edit Cursor Relative Time Selection
			
			
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			
			
			reaper.ImGui_EndTabItem(ctx)
			end
			
			-- Вкладка — Insert Marker
			if reaper.ImGui_BeginTabItem(ctx, "Marker") then
			reaper.ImGui_SeparatorText( ctx, "Insert Marker" )
			
			-- cboc2 ( " Set Take Marker At Edit Cursor ", function() SetTakeMarkerAtEditCursor("#40FF00", "✖") end, 0, 30 ) -- █ ● ▰ ✖
			-- cboc2 ( " Delete Markers Select Item Or Time Selection ", function() DeleteTakeMarkersSelectItemOrTimeSelection() end, 0, 30 )
			
			-- insert_empty_item_library
			local insert_empty_item_library = {
				key = "Insert", default_open = true, children = {
				
					{key = "Set Item Marker At Edit Cursor", default_open = true, children = {
						{key = "Empty", action_function = function() SetTakeMarkerAtEditCursor ( "#40FF00", "" ) end}, -- █ ● ▰ ✖ ×
						{key = "Introduction", action_function = function() SetTakeMarkerAtEditCursor ( "#40FF00", "Вступление" ) end}, -- █ ● ▰ ✖ ×
						{key = "Couplet", action_function = function() SetTakeMarkerAtEditCursor ( "#40FF00", "Куплет" ) end}, -- █ ● ▰ ✖ ×
						{key = "Chorus", action_function = function() SetTakeMarkerAtEditCursor ( "#40FF00", "Припев" ) end}, -- █ ● ▰ ✖ ×
						{spacing_vertical = "8"},
						{key = "× Delete Item Markers Select Item Or Time Selection", action_function = function() DeleteTakeMarkersSelectItemOrTimeSelection() end}, -- █ ● ▰ ✖ ×
						{key = "× Item: Delete all take markers", action_id = "42387"},
					},},
					
					{key = "Set Marker At Edit Cursor", default_open = true, children = {
						{key = "=START", action_function = function() CreateProjectMarkerPositionColor ( "=START", "#FF0000" ) end},
						{key = "=END", action_function = function() CreateProjectMarkerPositionColor ( "=END", "#FF0000" ) end},
						{spacing_vertical = "8"},
						
						{key = "× Delete Markers In Time Selection", action_function = function() DeleteMarkersInTimeSelection () end},
						{key = "× Markers: Remove all markers from time selection", action_id = "40420"},
					},},
				},
			}
			
			TreeNodeLibraryOutput(insert_empty_item_library)
			
			reaper.ImGui_EndTabItem(ctx)
			end
		reaper.ImGui_EndTabBar(ctx)
		end
		
		
		elseif selected_content == "Alpha_Window_ImGui_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Alpha Window ImGui" )
			local changed, new_alpha = reaper.ImGui_DragDouble(ctx, ' ', alpha_window_ImGui, 0.01, 0.0, 1.0, '%.2f')
			if changed then
				alpha_window_ImGui = new_alpha
				-- Сохраняем состояние
				reaper.SetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiAlphaWindowItemLength", tostring(alpha_window_ImGui), true)
			end
		else
			reaper.ImGui_Text(ctx, 'Select a menu item to see the content.')
		end
		-- menu_structure___
		-- ##################################################
		reaper.ImGui_End(ctx)
	end
	-- visible
	
	reaper.ImGui_PopFont (ctx)
	if open then
		reaper.defer(main)
	end
end
-- reaper.defer(main)
reaper.defer(main)
-- #######################################
-- #######################################
reaper.PreventUIRefresh(-1);
reaper.TrackList_AdjustWindows(0)  -- Updates the window view
reaper.UpdateArrange();  -- Updates the window view
-- #######################################
-- #######################################