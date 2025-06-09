--@description ImGui; Main; Insert Chord
--@version 1.0
--@author MaxMusicMax
-- toggle-test
-- https://forum.cockos.com/showthread.php?p=2059855
-- https://github.com/cfillion/reaimgui/releases
-- #######################################
-- #######################################
-- Цвет пустых айтемов (заметок)
local color_item_empty = "#000000"
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
-- 111111111111111111111111111111111
-- menu_structure
-- insert_item_chord_library
-- library_length_note
-- library_transpose_main
-- insert_empty_item_chord_library
-- library_length_note

-- HexToColor
-- TreeNodeLibraryOutput
-- ImGuiSelectComboBox
-- get_font_size
-- LoadSavedFonts
-- cboc2 / create_button_one_click2
-- get_playing_midi
-- get_name_note_current
-- insert_midi_chord
-- fnc_transpose_value
-- fnc_note_item_length
-- InsertEmptyItemWithNameAndColor
-- CreateRegionFromSelectedItem
-- CreateOrRemoveRegionFromTimeSelection
-- CreateProjectMarkerPositionColor
-- SetTakeMarkerAtEditCursor
-- DeleteTakeMarkersSelectItemOrTimeSelection
-- DeleteMarkersInTimeSelection

-- ShowMenuMain
-- SetDefaultMenuItemImGui
-- main_ImGui
-- #######################################
-- #######################################
-- menu_structure
local menu_structure = {
	{key = "Menu", children = {
		-- {key = "Content 1", show_content = "Content_1_Show"},
		-- {key = "Content 2", show_content = "Content_2_Show"},
		{key = "Insert Item Chord", show_content = "Insert_Item_Chord_Content_Show"},
		{key = "Insert Empty Item Chord", show_content = "Insert_Empty_Item_Chord_Content_Show"},
	}},

	{key = "Settings", children = {
		{key = "Set Default Tab ImGui", action_function = function() SetDefaultMenuItemImGui () end},
		{key = "Set Font Size", show_content = "Set_Font_Size_Content_Show"},
		{key = "Set Alpha Tab ImGui", show_content = "Alpha_Window_ImGui_Content_Show"},
	}},
	
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
-- #######################################
-- #######################################
local ctx = reaper.ImGui_CreateContext("x8koqhdze8_") -- Пример: x8koqhdze8_
-- Любой Уникальный Идентификатор, Пример: x8koqhdze8_
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

local font_verdana = LoadSavedFonts("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiFontSize")
-- local font_verdana = LoadSavedFonts()
-- LoadSavedFonts()
-- Загружаем шрифты при запуске
-- local font_size_verdana_18 = reaper.ImGui_CreateFont('verdana', 18)
-- reaper.ImGui_Attach(ctx, font_size_verdana_18)
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
-- get_playing_midi
function get_playing_midi(get_name_note)
	local play_state = reaper.GetPlayState()
	local track = reaper.GetSelectedTrack(0, 0) -- Получаем выделенный трек
	
	if not track then
		return
	end
	-- Очистка, если воспроизведение остановлено или трек изменился
	if play_state == 0 or track ~= last_track then
		active_notes = {}
		last_track = track
		return
	end

	local play_pos = reaper.GetPlayPosition()
	local item_count = reaper.CountTrackMediaItems(track)
	
	new_active_notes = {}

	for j = 0, item_count - 1 do
		local item = reaper.GetTrackMediaItem(track, j)
		local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
		local item_end = item_start + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
		
		if play_pos >= item_start and play_pos <= item_end then
			local take = reaper.GetActiveTake(item)
			if take and reaper.TakeIsMIDI(take) then
				local _, note_count = reaper.MIDI_CountEvts(take)

				for k = 0, note_count - 1 do
					local retval, selected, muted, startppqpos, endppqpos, chan, pitch = reaper.MIDI_GetNote(take, k)
					local start_sec = reaper.MIDI_GetProjTimeFromPPQPos(take, startppqpos)
					local end_sec = reaper.MIDI_GetProjTimeFromPPQPos(take, endppqpos)

					if play_pos >= start_sec and play_pos <= end_sec then
						new_active_notes[pitch] = true -- Запоминаем только номера нот
					end
				end
			end
		end
		
		if next(new_active_notes) then
			active_notes = new_active_notes
		end
	end
	-- Формируем строку с номерами нот
	local note_list = {}
	for note in pairs(active_notes) do
		table.insert(note_list, note)
	end
	-- Сортируем ноты по возрастанию
	-- table.sort(note_list)
	table.sort(note_list, function(a, b) return tonumber(a) < tonumber(b) end)
	
	-- Если get_name_note передан, преобразуем номера нот в названия
	if get_name_note then
		local note_names = { "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B" }
		local named_notes = {}

		for note in pairs(active_notes) do
			local octave = math.floor(note / 12) - 1
			local note_name = note_names[(note % 12) + 1] .. octave
			table.insert(named_notes, { name = note_name, pitch = note }) -- Сохраняем высоту для сортировки
		end

		-- Сортируем по высоте (pitch)
		table.sort(named_notes, function(a, b) return a.pitch < b.pitch end)

		-- Извлекаем только имена нот
		local sorted_names = {}
		for _, note in ipairs(named_notes) do
			table.insert(sorted_names, note.name)
		end

		return table.concat(sorted_names, ", ")
	end
	
	-- Возвращаем строку формата "51, 87, 45, 56"
	return table.concat(note_list, ", ")
end
-- #######################################
-- #######################################
-- get_name_note_current
function get_name_note_current()
	-- Индекс ноты
	local note_names2 = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}
	local transpose_value = tonumber(reaper.GetExtState("insert_item_chord_qzzmsbnelc", "transpose_value_qzzmsbnelc")) or 0
	local note_index2 = (transpose_value % 12 + 12) % 12 + 1
	local note_label_name2 = note_names2[note_index2] -- имя ноты, например, "C" или "C#"
	return note_label_name2
end
-- #######################################
-- #######################################
-- insert_midi_chord
function insert_midi_chord(note_length, chord_str, transpose, velocity, item_name)
	-- Ограничение значений
	if not velocity or velocity < 1 then velocity = 1 end
	if velocity > 127 then velocity = 127 end
	if not transpose or transpose < -24 then transpose = -24 end
	if transpose > 24 then transpose = 24 end

	-- Получаем выделенный трек
	local track = reaper.GetSelectedTrack(0, 0)
	if not track then return end

	-- Получаем позицию курсора
	local start_pos = reaper.GetCursorPosition()

	-- Парсим длительность
	local qn_length
	if note_length:match("^(%d+)/(%d+)$") then
		-- Формат "N/M" (например, "1/2", "1/4") — доля такта
		local numerator, denominator = note_length:match("^(%d+)/(%d+)$")
		numerator, denominator = tonumber(numerator), tonumber(denominator)
		if numerator and denominator and denominator > 0 then
			qn_length = (numerator / denominator) * 4 -- Доля такта * 4 четвертные ноты
		end
	elseif note_length:match("^%d+$") then
		-- Целое число — количество тактов (например, "64", "8")
		local bars = tonumber(note_length)
		if bars and bars > 0 then
			qn_length = bars * 4 -- 1 такт = 4 четвертные ноты
		end
	end

	-- Проверяем корректность длины
	if not qn_length or qn_length <= 0 then return end

	-- Вычисляем длительность в секундах через TimeMap
	local start_qn = reaper.TimeMap2_timeToQN(0, start_pos)
	local end_qn = start_qn + qn_length
	local end_time = reaper.TimeMap2_QNToTime(0, end_qn)
	local length_sec = end_time - start_pos

	-- Создаём MIDI-айтем
	local item = reaper.CreateNewMIDIItemInProj(track, start_pos, start_pos + length_sec)
	if not item then return end
	reaper.SetMediaItemSelected(item, true)

	-- Получаем MIDI-тейк
	local take = reaper.GetMediaItemTake(item, 0)
	if not take then return end
	
	-- Устанавливаем имя тейка, если передано
	if item_name and item_name ~= "1" then
		reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", item_name, true)
	end

	-- Конвертируем длину айтема в PPQ (MIDI-разрешение)
	local ppq_start = reaper.MIDI_GetPPQPosFromProjTime(take, start_pos)
	local ppq_end = reaper.MIDI_GetPPQPosFromProjTime(take, start_pos + length_sec)
	local note_length_ppq = ppq_end - ppq_start
	
	-- Таблица для перевода нот в MIDI-номера
	local notes = { ["C"] = 0, ["C#"] = 1, ["D"] = 2, ["D#"] = 3, ["E"] = 4, 
		["F"] = 5, ["F#"] = 6, ["G"] = 7, ["G#"] = 8, ["A"] = 9, ["A#"] = 10, ["B"] = 11 }

	-- Разбираем аккорд в MIDI-ноты
	local chord_notes = {}
	for note in chord_str:gmatch("[^, ]+") do
		local name, octave = note:match("([A-G]#?)(%d)")
		if name and octave then
			local midi_note = notes[name] + (tonumber(octave) * 12) + transpose + 12
			if midi_note >= 0 and midi_note <= 127 then
				table.insert(chord_notes, midi_note)
			end
		end
	end

	-- Вставляем ноты с корректной длиной и громкостью
	for _, pitch in ipairs(chord_notes) do
		reaper.MIDI_InsertNote(take, false, false, ppq_start, ppq_start + note_length_ppq, 0, pitch, velocity, false)
	end

	-- Обновляем MIDI
	reaper.MIDI_Sort(take)
	reaper.UpdateArrange()
end

function insert_midi_chord_v1(note_length, chord_str, transpose, velocity, item_name)
	-- Ограничение значений
	if not velocity or velocity < 1 then velocity = 1 end
	if velocity > 127 then velocity = 127 end
	
	-- if not transpose or transpose < -12 then transpose = -12 end
	-- if transpose > 12 then transpose = 12 end
	if not transpose or transpose < -24 then transpose = -24 end
	if transpose > 24 then transpose = 24 end

	-- Получаем выделенный трек
	local track = reaper.GetSelectedTrack(0, 0)
	if not track then return end

	-- Получаем позицию курсора
	local start_pos = reaper.GetCursorPosition()

	-- Получаем размер такта и темп
	local _, num, denom = reaper.TimeMap_GetTimeSigAtTime(0, start_pos)
	if not num or num == 0 then num = 4 end -- Если не получен, используем 4/4
	local _, _, _, bpm = reaper.GetProjectTimeSignature2(0)
	if not bpm or bpm == 0 then bpm = 120 end -- Если BPM не получен, используем 120

	-- Определяем коэффициент деления (целые числа или дроби)
	local division
	if note_length:match("/") then
		division = tonumber(note_length:match("1/(%d+)"))
	else
		division = 1 / tonumber(note_length)
	end
	if not division or division <= 0 then return end

	-- Переводим длину в секунды
	local quarter_sec = 60 / bpm -- Длина четверти в секундах
	local length_sec = quarter_sec / division * 4 -- Перевод из QN в секунды
	
	-- Создаём MIDI-айтем
	local item = reaper.CreateNewMIDIItemInProj(track, start_pos, start_pos + length_sec)
	if not item then return end
	reaper.SetMediaItemSelected(item, true)

	-- Получаем MIDI-тейк
	local take = reaper.GetMediaItemTake(item, 0)
	if not take then return end
	
	-- Устанавливаем имя тейка, если передано
	if item_name and item_name ~= "1" then
		reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", item_name, true)
	end

	-- Конвертируем длину айтема в PPQ (MIDI-разрешение)
	local ppq_start = reaper.MIDI_GetPPQPosFromProjTime(take, start_pos)
	local ppq_end = reaper.MIDI_GetPPQPosFromProjTime(take, start_pos + length_sec)
	local note_length_ppq = ppq_end - ppq_start
	
	-- Таблица для перевода нот в MIDI-номера
	local notes = { ["C"] = 0, ["C#"] = 1, ["D"] = 2, ["D#"] = 3, ["E"] = 4, 
		["F"] = 5, ["F#"] = 6, ["G"] = 7, ["G#"] = 8, ["A"] = 9, ["A#"] = 10, ["B"] = 11 }

	-- Разбираем аккорд в MIDI-ноты
	local chord_notes = {}
	for note in chord_str:gmatch("[^, ]+") do
		local name, octave = note:match("([A-G]#?)(%d)")
		if name and octave then
			-- local midi_note = notes[name] + (tonumber(octave) + 1) * 12 + transpose -- Транспонирование
			local midi_note = notes[name] + (tonumber(octave) * 12) + transpose + 12
			if midi_note >= 0 and midi_note <= 127 then
				table.insert(chord_notes, midi_note)
			end
		end
	end

	-- Вставляем ноты с корректной длиной и громкостью
	for _, pitch in ipairs(chord_notes) do
		reaper.MIDI_InsertNote(take, false, false, ppq_start, ppq_start + note_length_ppq, 0, pitch, velocity, false)
	end

	-- Обновляем MIDI
	reaper.MIDI_Sort(take)
	reaper.UpdateArrange()
end
-- ##################################################
-- ##################################################
-- fnc_transpose_value
function fnc_transpose_value (tr_value)
	reaper.SetExtState("insert_item_chord_qzzmsbnelc", "transpose_value_qzzmsbnelc", tostring(tr_value), false)
	-- checkbox_MoveEditCursor = reaper.GetExtState("insert_item_chord_qzzmsbnelc", "transpose_value_qzzmsbnelc")
	-- print_rs (checkbox_MoveEditCursor)
end
-- ##################################################
-- ##################################################
-- fnc_note_item_length
function fnc_note_item_length (note_item_length)
	reaper.SetExtState("insert_item_chord_qzzmsbnelc", "note_item_length_value_qzzmsbnelc", tostring(note_item_length), false)
	-- checkbox_MoveEditCursor = reaper.GetExtState("insert_item_chord_qzzmsbnelc", "note_item_length_value_qzzmsbnelc")
	-- print_rs (note_item_length)
end
-- #######################################
-- #######################################
-- InsertEmptyItemWithNameAndColor
function InsertEmptyItemWithNameAndColor(name, hex_color, item_length_3)
	-- Начало блока отмены
	reaper.Undo_BeginBlock()
	-- Получаем позицию курсора редактирования
	local cursor_pos = reaper.GetCursorPosition()
	-- Получаем первый выделенный трек
	local track = reaper.GetSelectedTrack(0, 0)
	if track then
		-- Создаём новый медиа-айтем
		local item = reaper.AddMediaItemToTrack(track)
		if item then
			-- Устанавливаем позицию айтема на курсор
			reaper.SetMediaItemInfo_Value(item, "D_POSITION", cursor_pos)
			
			local length
			if item_length_3 then
				-- Парсим длительность
				local qn_length
				if item_length_3:match("^(%d+)/(%d+)$") then
					-- Формат "N/M" (например, "1/2", "1/4") — доля такта
					local numerator, denominator = item_length_3:match("^(%d+)/(%d+)$")
					numerator, denominator = tonumber(numerator), tonumber(denominator)
					if numerator and denominator and denominator > 0 then
						qn_length = (numerator / denominator) * 4 -- Доля такта * 4 четвертные ноты
					end
				elseif item_length_3:match("^%d+$") then
					-- Целое число — количество тактов (например, "64", "8")
					local bars = tonumber(item_length_3)
					if bars and bars > 0 then
						qn_length = bars * 4 -- 1 такт = 4 четвертные ноты
					end
				end
				
				if qn_length and qn_length > 0 then
					-- Вычисляем длительность в секундах через TimeMap
					local start_qn = reaper.TimeMap2_timeToQN(0, cursor_pos)
					local end_qn = start_qn + qn_length
					local end_time = reaper.TimeMap2_QNToTime(0, end_qn)
					length = end_time - cursor_pos
				else
					-- Некорректный формат, возвращаем
					return
				end
			else
				-- Длина по умолчанию — один такт
				local beat_length = reaper.TimeMap2_QNToTime(0, 4) - reaper.TimeMap2_QNToTime(0, 0)
				length = beat_length
			end
			
			-- Устанавливаем длину айтема
			reaper.SetMediaItemInfo_Value(item, "D_LENGTH", length)
			
			-- Добавляем имя (текстовую заметку)
			reaper.ULT_SetMediaItemNote(item, name)
			
			-- Преобразуем HEX-цвет в десятичный формат
			if hex_color then
				local r = tonumber(string.sub(hex_color, 2, 3), 16)
				local g = tonumber(string.sub(hex_color, 4, 5), 16)
				local b = tonumber(string.sub(hex_color, 6, 7), 16)
				local color = reaper.ColorToNative(r, g, b) | 0x1000000
				-- Устанавливаем цвет айтема
				reaper.SetMediaItemInfo_Value(item, "I_CUSTOMCOLOR", color)
			end
			
			-- Выделяем новый айтем
			reaper.SetMediaItemSelected(item, true)
			-- Перемещаем курсор к концу айтема
			reaper.Main_OnCommand(reaper.NamedCommandLookup("41174"), 0) -- Item navigation: Move cursor to end of items
			-- Снимаем выделение со всех айтемов
			reaper.Main_OnCommand(reaper.NamedCommandLookup("40289"), 0) -- Item: Unselect (clear selection of) all items
			
			-- Обновляем проект
			reaper.UpdateArrange()
		end
	end
	reaper.Undo_EndBlock("Insert Empty Item with Name and Color", -1)
end

function InsertEmptyItemWithNameAndColor_v1(name, hex_color, item_length_3)
	-- Начало блока отмены
	reaper.Undo_BeginBlock()
	-- Получаем позицию курсора редактирования
	local cursor_pos = reaper.GetCursorPosition()
	-- Получаем первый выделенный трек
	local track = reaper.GetSelectedTrack(0, 0)
	if track then
		-- Получаем длительность одного такта в секундах
		local beat_length = reaper.TimeMap2_QNToTime(0, 4) - reaper.TimeMap2_QNToTime(0, 0)
		-- Создаём новый медиа-айтем
		local item = reaper.AddMediaItemToTrack(track)
		if item then
			-- Устанавливаем позицию айтема на курсор
			reaper.SetMediaItemInfo_Value(item, "D_POSITION", cursor_pos)
			
			local length
			if item_length_3 then
				local _, _, _, bpm = reaper.GetProjectTimeSignature2(0)
				if not bpm or bpm == 0 then bpm = 120 end

				local division
				if item_length_3:match("/") then
					division = tonumber(item_length_3:match("1/(%d+)"))
				else
					division = 1 / tonumber(item_length_3)
				end
				if not division or division <= 0 then return end

				local quarter_sec = 60 / bpm
				length = quarter_sec / division * 4
			else
				length = beat_length
			end
			
			reaper.SetMediaItemInfo_Value(item, "D_LENGTH", length)
			
			-- Добавляем имя (текстовую заметку)
			reaper.ULT_SetMediaItemNote(item, name)
			
			-- Преобразуем HEX-цвет в десятичный формат
			if hex_color then
				local r = tonumber(string.sub(hex_color, 2, 3), 16)
				local g = tonumber(string.sub(hex_color, 4, 5), 16)
				local b = tonumber(string.sub(hex_color, 6, 7), 16)
				local color = reaper.ColorToNative(r, g, b) | 0x1000000
				-- Устанавливаем цвет айтема
				reaper.SetMediaItemInfo_Value(item, "I_CUSTOMCOLOR", color)
			end
			
			reaper.SetMediaItemSelected(item, true)
			reaper.Main_OnCommand(reaper.NamedCommandLookup("41174"), 0) -- Item navigation: Move cursor to end of items
			reaper.Main_OnCommand(reaper.NamedCommandLookup("40289 "), 0) -- Item: Unselect (clear selection of) all items
			
			-- Обновляем проект
			reaper.UpdateArrange()
		end
	end
	reaper.Undo_EndBlock("Insert Empty Item with Name and Color", -1)
end
-- ##################################################
-- ##################################################
-- CreateRegionFromSelectedItem
-- Функция для создания региона по выделенному айтему
function CreateRegionFromSelectedItem(region_name, hex_color)
	local project = 0 -- Активный проект
	local selected_item_count = reaper.CountSelectedMediaItems(project)

	if selected_item_count > 0 then
		-- Преобразование цвета из формата #RRGGBB в формат Reaper
		if not (hex_color:match("^#%x%x%x%x%x%x$")) then
			reaper.ShowMessageBox("Неверный формат цвета. Используйте #RRGGBB.", "Ошибка", 0)
			return
		end

		local r = tonumber(string.sub(hex_color, 2, 3), 16)
		local g = tonumber(string.sub(hex_color, 4, 5), 16)
		local b = tonumber(string.sub(hex_color, 6, 7), 16)
		local color = reaper.ColorToNative(r, g, b) | 0x1000000

		-- Получение первого выделенного айтема
		local item = reaper.GetSelectedMediaItem(project, 0)

		-- Получение позиции и длины айтема
		local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
		local item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
		local item_end = item_start + item_length
		
		reaper.Undo_BeginBlock()
		-- Создание региона
		reaper.AddProjectMarker2(project, true, item_start, item_end, region_name, -1, color)
		reaper.Undo_EndBlock("Создание региона", -1)

		-- Обновление интерфейса
		reaper.UpdateArrange()
	else
		reaper.ShowMessageBox("Нет выделенных айтемов!", "Ошибка", 0)
	end
end
-- #######################################
-- #######################################
-- CreateOrRemoveRegionFromTimeSelection
function CreateOrRemoveRegionFromTimeSelection(mode, region_name, hex_color)
    -- mode == 0: Создать регион из Time Selection
    -- mode == 1: Удалить регионы в зоне Time Selection
    -- mode == 2: Создать регион по выделенным айтемам
    -- mode == 3: Удалить все регионы

	local color
	local region_name2

	if hex_color ~= nil then
		local r = tonumber(string.sub(hex_color, 2, 3), 16)
		local g = tonumber(string.sub(hex_color, 4, 5), 16)
		local b = tonumber(string.sub(hex_color, 6, 7), 16)
		color = reaper.ColorToNative(r, g, b) | 0x1000000
	else
		color = 0
	end
	
	if region_name ~= nil then
		region_name2 = region_name
	else
		region_name2 = ""
	end
	
    -- Начинаем undo блок, чтобы действия можно было отменить одним шагом
    reaper.Undo_BeginBlock()

    -- Получаем текущий проект
    local project = 0

    if mode == 0 then
        -- Получаем информацию о временном выделении
        local time_start, time_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
        -- Проверяем, существует ли временное выделение
        if time_start ~= time_end then
            -- Создаем регион
            reaper.AddProjectMarker2(project, true, time_start, time_end, region_name2, -1, color)
		
		-- reaper.AddProjectMarker2(project, true, item_start, item_end, region_name, -1, color)
        end

    elseif mode == 1 then
        -- Получаем информацию о временном выделении
        local time_start, time_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
        -- Проверяем, существует ли временное выделение
        if time_start ~= time_end then
            -- Удаляем все регионы в зоне Time Selection
            local num_markers, num_regions = reaper.CountProjectMarkers(project)
            local marker_idx = 0
            while marker_idx < num_markers + num_regions do
                local ret, is_region, pos, rgn_end, name, marker_id = reaper.EnumProjectMarkers(marker_idx)
                if is_region and rgn_end > time_start and pos < time_end then
                    reaper.DeleteProjectMarker(project, marker_id, is_region)
                else
                    marker_idx = marker_idx + 1
                end
            end
        end

    elseif mode == 2 then
        -- Создаем регион по выделенным айтемам
        local num_selected_items = reaper.CountSelectedMediaItems(project)
        if num_selected_items > 0 then
            local item_start = math.huge
            local item_end = -math.huge

            for i = 0, num_selected_items - 1 do
                local item = reaper.GetSelectedMediaItem(project, i)
                local item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
                local item_len = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
                local item_end_pos = item_pos + item_len

                if item_pos < item_start then item_start = item_pos end
                if item_end_pos > item_end then item_end = item_end_pos end
            end

            reaper.AddProjectMarker2(project, true, item_start, item_end, "", -1, 0)
        end

    elseif mode == 3 then
        -- Удаляем все регионы
        local num_markers, num_regions = reaper.CountProjectMarkers(project)
        local marker_idx = 0
        while marker_idx < num_markers + num_regions do
            local ret, is_region, pos, rgn_end, name, marker_id = reaper.EnumProjectMarkers(marker_idx)
            if is_region then
                reaper.DeleteProjectMarker(project, marker_id, is_region)
            else
                marker_idx = marker_idx + 1
            end
        end
    end

    -- Обновляем окно проекта для отображения изменений
    reaper.UpdateArrange()
    -- Заканчиваем undo блок
    reaper.Undo_EndBlock("Создание или удаление региона в зоне Time Selection, по выделенным айтемам или удаление всех регионов", -1)
end
-- #######################################
-- #######################################
-- CreateProjectMarkerPositionColor
function CreateProjectMarkerPositionColor (marker_name, marker_color, marker_position)
	local marker_color = marker_color:gsub("#","");
	local R = tonumber("0x"..marker_color:sub(1,2));
	local G = tonumber("0x"..marker_color:sub(3,4));
	local B = tonumber("0x"..marker_color:sub(5,6));

	local time_position = marker_position  -- 6589 миллисекунд = 6.589 секунд
	local time_position = marker_position or reaper.GetCursorPosition()
	reaper.AddProjectMarker2(0, false, time_position, 0, marker_name, -1, reaper.ColorToNative( R, G, B ) | 0x1000000 )
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
local alpha_window_ImGui = tonumber(reaper.GetExtState("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiAlphaWindow")) or 0.5
local x8koqhdze8_name_window = "· · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·"
-- #######################################
-- #######################################
-- Пункт меню по умолчанию
local selected_content = "Frequent_Content_Show" -- Color_Content_Show / Frequent_Content_Show
local current_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiCurrentMenuItem")
local default_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiDefaultMenuItem")

if current_menu_item_imgui == "" then
	reaper.SetExtState("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiCurrentMenuItem", selected_content, true)
end

if default_menu_item_imgui == "" then
	reaper.SetExtState("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiDefaultMenuItem", selected_content, true)
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
					reaper.SetExtState("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiCurrentMenuItem", selected_content, true)
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
	current_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiCurrentMenuItem")
	reaper.SetExtState("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiDefaultMenuItem", current_menu_item_imgui, true) -- MaxMusicMax_ImGuiWindow
end
-- ##################################################
-- ##################################################
-- main_ImGui
function main_ImGui()
	reaper.ImGui_SetNextWindowBgAlpha(ctx, alpha_window_ImGui) -- Установить прозрачность фона окна
	reaper.ImGui_PushFont (ctx, font_verdana[get_font_size ("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiFontSizeGlobal")])
	-- reaper.ImGui_SetNextWindowSize(ctx, 500, 300, reaper.ImGui_Cond_FirstUseEver())

	local visible, open = reaper.ImGui_Begin(ctx, x8koqhdze8_name_window, true, reaper.ImGui_WindowFlags_MenuBar())
	if visible then
		if reaper.ImGui_BeginMenuBar(ctx) then
			ShowMenuMain(menu_structure)
			reaper.ImGui_EndMenuBar(ctx)
		end
		
		-- #######################################
		-- menu_structure___
		if selected_content == "" then
		elseif selected_content == "Insert_Empty_Item_Chord_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, " Insert Empty Item Chord Selected Track " )
			
			cboc2(" Insert Item Chord ", function()
				selected_content = "Insert_Item_Chord_Content_Show" -- Insert_Item_Chord_Content_Show
				reaper.SetExtState("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiCurrentMenuItem", selected_content, true) -- x8koqhdze8_ImGuiCurrentMenuItem
			end, 0, 25)
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			
			local chord_qzzmsbnelc = reaper.GetExtState("chord_qzzmsbnelc", "chord_value_qzzmsbnelc")
			if chord_qzzmsbnelc == "" then
				chord_qzzmsbnelc = "C" -- значение по умолчанию
				reaper.SetExtState("chord_qzzmsbnelc", "chord_value_qzzmsbnelc", chord_qzzmsbnelc, false)
			end
			
			local note_item_length_value_qzzmsbnelc = reaper.GetExtState("insert_item_chord_qzzmsbnelc", "note_item_length_value_qzzmsbnelc")
			if note_item_length_value_qzzmsbnelc == "" then note_item_length_value_qzzmsbnelc = "1/4" end

			local library_transpose_main = {
				key = "Transpose", default_open = true, children = {
					{key = "B", action_function = function() reaper.SetExtState("chord_qzzmsbnelc", "chord_value_qzzmsbnelc", "B", false) end},
					{key = "A#", action_function = function() reaper.SetExtState("chord_qzzmsbnelc", "chord_value_qzzmsbnelc", "A#", false) end},
					{key = "A", action_function = function() reaper.SetExtState("chord_qzzmsbnelc", "chord_value_qzzmsbnelc", "A", false) end},
					{key = "G#", action_function = function() reaper.SetExtState("chord_qzzmsbnelc", "chord_value_qzzmsbnelc", "G#", false) end},
					{key = "G", action_function = function() reaper.SetExtState("chord_qzzmsbnelc", "chord_value_qzzmsbnelc", "G", false) end},
					{key = "F#", action_function = function() reaper.SetExtState("chord_qzzmsbnelc", "chord_value_qzzmsbnelc", "F#", false) end},
					{key = "F", action_function = function() reaper.SetExtState("chord_qzzmsbnelc", "chord_value_qzzmsbnelc", "F", false) end},
					{key = "E", action_function = function() reaper.SetExtState("chord_qzzmsbnelc", "chord_value_qzzmsbnelc", "E", false) end},
					{key = "D#", action_function = function() reaper.SetExtState("chord_qzzmsbnelc", "chord_value_qzzmsbnelc", "D#", false) end},
					{key = "D", action_function = function() reaper.SetExtState("chord_qzzmsbnelc", "chord_value_qzzmsbnelc", "D", false) end},
					{key = "C#", action_function = function() reaper.SetExtState("chord_qzzmsbnelc", "chord_value_qzzmsbnelc", "C#", false) end},
					{key = "C", action_function = function() reaper.SetExtState("chord_qzzmsbnelc", "chord_value_qzzmsbnelc", "C", false) end},
				},
			}
			
			-- library_length_note
			local library_length_note = {
				key = "Length", default_open = true, children = {
					{spacing_vertical = "0"},
					{separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 70 },
					{spacing_vertical = "7"},
					{key = "64", action_function = function() fnc_note_item_length ("64") end},
					{key = "32", action_function = function() fnc_note_item_length ("32") end},
					{key = "16", action_function = function() fnc_note_item_length ("16") end},
					{key = "8", action_function = function() fnc_note_item_length ("8") end},
					{key = "4", action_function = function() fnc_note_item_length ("4") end},
					{key = "3", action_function = function() fnc_note_item_length ("3") end},
					{key = "2", action_function = function() fnc_note_item_length ("2") end},

					{separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 70 },
					{spacing_vertical = "4"},
					{key = "1", action_function = function() fnc_note_item_length ("1") end},
					{key = "1/2", action_function = function() fnc_note_item_length ("1/2") end},
					{key = "1/3", action_function = function() fnc_note_item_length ("1/3") end},
					{key = "1/4", action_function = function() fnc_note_item_length ("1/4") end},
					{key = "1/5", action_function = function() fnc_note_item_length ("1/5") end},
					{key = "1/6", action_function = function() fnc_note_item_length ("1/6") end},
					{key = "1/7", action_function = function() fnc_note_item_length ("1/7") end},
					{key = "1/8", action_function = function() fnc_note_item_length ("1/8") end},
				},
			}
			
			-- insert_empty_item_chord_library
			local insert_empty_item_chord_library = {
				key = "Insert Empty Item Chord", default_open = true, children = {
					
					{key = "Set Item Marker At Edit Cursor", children = {
						{key = "Introduction", action_function = function() SetTakeMarkerAtEditCursor ( "#40FF00", "Вступление" ) end}, -- █ ● ▰ ✖ ×
						{key = "Couplet", action_function = function() SetTakeMarkerAtEditCursor ( "#40FF00", "Куплет" ) end}, -- █ ● ▰ ✖ ×
						{key = "Chorus", action_function = function() SetTakeMarkerAtEditCursor ( "#40FF00", "Припев" ) end}, -- █ ● ▰ ✖ ×
						{spacing_vertical = "8"},
						{key = "Delete Take Markers SelectItem Or Time Selection", action_function = function() DeleteTakeMarkersSelectItemOrTimeSelection() end}, -- █ ● ▰ ✖ ×
					},},
					
					{key = "Set Marker At Edit Cursor", children = {
						{key = "=START", action_function = function() CreateProjectMarkerPositionColor ( "=START", "#FF0000" ) end},
						{key = "=END", action_function = function() CreateProjectMarkerPositionColor ( "=END", "#FF0000" ) end},
						{spacing_vertical = "8"},
						
						{key = "Introduction", action_function = function() CreateProjectMarkerPositionColor ( "Вступление", "#0A8B16" ) end},
						{key = "Couplet", action_function = function() CreateProjectMarkerPositionColor ( "Куплет", "#0070CA" ) end},
						{key = "Chorus", action_function = function() CreateProjectMarkerPositionColor ( "Припев", "#E87400" ) end},
						{key = "Interlude", action_function = function() CreateProjectMarkerPositionColor ( "Проигрыш", "#0A8B16" ) end},
						{key = "Code", action_function = function() CreateProjectMarkerPositionColor ( "Кода", "#F24040" ) end},
						{spacing_vertical = "8"},
						
						{key = "× Delete Markers In Time Selection", action_function = function() DeleteMarkersInTimeSelection () end},
					},},
					
					{key = "Remove Region", children = {
						{key = "Remove Region From Time Selection", action_function = function() CreateOrRemoveRegionFromTimeSelection (1) end},
						{key = "Delete all regions", action_function = function() CreateOrRemoveRegionFromTimeSelection (3) end},
					},},
					
					{key = "Create Region From", children = {
						{key = "Time Selection", children = {
							{key = "Introduction", action_function = function() CreateOrRemoveRegionFromTimeSelection( 0, "Вступление", "#0A8B16") end},
							{key = "Couplet", action_function = function() CreateOrRemoveRegionFromTimeSelection( 0, "Куплет", "#0070CA") end},
							{key = "Chorus", action_function = function() CreateOrRemoveRegionFromTimeSelection( 0, "Припев", "#E87400") end},
							{key = "Interlude", action_function = function() CreateOrRemoveRegionFromTimeSelection( 0, "Проигрыш", "#0A8B16") end},
							{key = "Code", action_function = function() CreateOrRemoveRegionFromTimeSelection( 0, "Кода", "#F24040") end},
						},},
						{key = "Item Selection", children = {
							{key = "Introduction", action_function = function() CreateRegionFromSelectedItem( "Вступление", "#0A8B16") end},
							{key = "Couplet", action_function = function() CreateRegionFromSelectedItem( "Куплет", "#0070CA") end},
							{key = "Chorus", action_function = function() CreateRegionFromSelectedItem( "Припев", "#E87400") end},
							{key = "Interlude", action_function = function() CreateRegionFromSelectedItem( "Проигрыш", "#0A8B16") end},
							{key = "Code", action_function = function() CreateRegionFromSelectedItem( "Кода", "#F24040") end},
						},},
					},},
					
					{key = "Insert Empty Item Form", children = {
						{key = "Introduction", action_function = function() InsertEmptyItemWithNameAndColor( "Вступление", "#0A8B16", note_item_length_value_qzzmsbnelc) end},
						{key = "Couplet", action_function = function() InsertEmptyItemWithNameAndColor( "Куплет", "#0070CA", note_item_length_value_qzzmsbnelc) end},
						{key = "Chorus", action_function = function() InsertEmptyItemWithNameAndColor( "Припев", "#E87400", note_item_length_value_qzzmsbnelc) end},
						{key = "Interlude", action_function = function() InsertEmptyItemWithNameAndColor( "Проигрыш", "#0A8B16", note_item_length_value_qzzmsbnelc) end},
						{key = "Code", action_function = function() InsertEmptyItemWithNameAndColor( "Кода", "#F24040", note_item_length_value_qzzmsbnelc) end},
					},},
				
					{key = "Insert Empty Item Chord", default_open = true, children = {
						{key = chord_qzzmsbnelc .. "", action_function = function() InsertEmptyItemWithNameAndColor( chord_qzzmsbnelc .. "", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "6", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "6", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "maj", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "∆", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "maj (6/9)", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "∆ (6/9)", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "maj (13#11)", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "∆ (13#11)", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "maj (7#5)", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "∆ (7#5)", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{spacing_vertical = "0"},
						{separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 120 },
						{spacing_vertical = "5"},
						
						{key = chord_qzzmsbnelc .. "7", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "7", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "7(6b9)", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "7(6b9)", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "7(9,11,13)", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "7(9,11,13)", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "7 (13#11)", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "7 (13#11)", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "7 (#9b13)", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "7 (#9b13)", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "7 (b9#9b13)", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "7 (b9#9b13)", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "9", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "9", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{spacing_vertical = "0"},
						{separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 120 },
						{spacing_vertical = "5"},
						
						{key = chord_qzzmsbnelc .. "sus2", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "sus2", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "sus4", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "sus4", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "7sus4", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "7sus4", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "9sus4", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "9sus4", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "13sus4", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "13sus4", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{spacing_vertical = "0"},
						{separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 120 },
						{spacing_vertical = "5"},
						
						{key = chord_qzzmsbnelc .. "m", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "m", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "m6", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "m6", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "m (6/9)", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "m (6/9)", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "m7", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "m7", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "m9", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "m9", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "m (maj11)", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "m (maj11)", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "m (9b13)", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "m (9b13)", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{spacing_vertical = "0"},
						{separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 120 },
						{spacing_vertical = "5"},
						
						{key = chord_qzzmsbnelc .. "ø", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "ø", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "o", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "o", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{key = chord_qzzmsbnelc .. "+", action_function = function() InsertEmptyItemWithNameAndColor(chord_qzzmsbnelc .. "+", color_item_empty, note_item_length_value_qzzmsbnelc) end},
						{spacing_vertical = "10"},
					},},
				},
			}
			
			
			if reaper.ImGui_BeginTable(ctx, "Table", 3) then -- Создаём таблицу с 2 колонками

				reaper.ImGui_TableSetupColumn(ctx, "Col 1", reaper.ImGui_TableColumnFlags_WidthFixed(), 100)
				reaper.ImGui_TableSetupColumn(ctx, "Col 2", reaper.ImGui_TableColumnFlags_WidthFixed(), 90)
				reaper.ImGui_TableSetupColumn(ctx, "Col 3", reaper.ImGui_TableColumnFlags_WidthFixed(), 320)

				reaper.ImGui_TableNextRow(ctx)
				
				-- Col 1 ————————————————————————————————————————
				reaper.ImGui_TableNextColumn(ctx)
				reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Text(), HexToColor("#FFFF00")) -- Красный цвет (RGBA)
				reaper.ImGui_Text(ctx, "  " .. chord_qzzmsbnelc )
				reaper.ImGui_PopStyleColor(ctx)
				reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
				TreeNodeLibraryOutput(library_transpose_main) -- передаём корневой элемент
				
				-- Col 2 ————————————————————————————————————————
				reaper.ImGui_TableNextColumn(ctx)
				reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Text(), HexToColor("#FFFF00")) -- Красный цвет (RGBA)
				reaper.ImGui_Text(ctx, "    " .. note_item_length_value_qzzmsbnelc )
				reaper.ImGui_PopStyleColor(ctx)
				reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
				TreeNodeLibraryOutput(library_length_note) -- передаём корневой элемент
				
				-- Col 3 ————————————————————————————————————————
				reaper.ImGui_TableNextColumn(ctx)
				reaper.ImGui_Dummy(ctx, 0, 27)  -- Добавление вертикального пространства
				TreeNodeLibraryOutput(insert_empty_item_chord_library) -- передаём корневой элемент
				

			reaper.ImGui_EndTable(ctx) -- Завершаем таблицу
			end
			
			
		elseif selected_content == "Insert_Item_Chord_Content_Show" then
			reaper.ImGui_SeparatorText(ctx, "Insert Item Chord")
			
			cboc2(" Insert Empty Item Chord ", function()
				selected_content = "Insert_Empty_Item_Chord_Content_Show" -- Insert_Empty_Item_Chord_Content_Show
				reaper.SetExtState("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiCurrentMenuItem", selected_content, true) -- x8koqhdze8_ImGuiCurrentMenuItem
			end, 0, 25)
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			
			reaper.ImGui_InputText(ctx, '##nameNote',  get_playing_midi(true) or "" )
			
			local transpose_value_qzzmsbnelc = reaper.GetExtState("insert_item_chord_qzzmsbnelc", "transpose_value_qzzmsbnelc")
			transpose_value_qzzmsbnelc = (transpose_value_qzzmsbnelc ~= "" and tonumber(transpose_value_qzzmsbnelc)) or 0

			local note_item_length_value_qzzmsbnelc = reaper.GetExtState("insert_item_chord_qzzmsbnelc", "note_item_length_value_qzzmsbnelc")
			if note_item_length_value_qzzmsbnelc == "" then note_item_length_value_qzzmsbnelc = "1/4" end
			
			reaper.ImGui_Dummy(ctx, 0, 2)  -- Добавление вертикального пространства
			-- Слайдер Velocity от 1 до 127 с сохранением во временное хранилище
			local slider_velocity_value = tonumber(reaper.GetExtState("insert_item_chord_qzzmsbnelc", "slider_velocity_value_qzzmsbnelc")) or 86  -- Значение по умолчанию 86
			local changed_velocity, new_velocity_value = reaper.ImGui_SliderInt(ctx, ' Velocity', slider_velocity_value, 1, 127)
			if changed_velocity then
				slider_velocity_value = new_velocity_value
				reaper.SetExtState("insert_item_chord_qzzmsbnelc", "slider_velocity_value_qzzmsbnelc", tostring(slider_velocity_value), false)  -- Сохраняем значение
			else
				reaper.SetExtState("insert_item_chord_qzzmsbnelc", "slider_velocity_value_qzzmsbnelc", tostring(slider_velocity_value), false)  -- Сохраняем значение
			end
			-- Слайдер Velocity от 1 до 127 с сохранением во временное хранилище
			reaper.ImGui_Dummy(ctx, 0, 2)  -- Добавление вертикального пространства
			
			if reaper.ImGui_BeginTable(ctx, "Table", 3) then -- Создаём таблицу с 2 колонками
				-- Первая колонка с фиксированной шириной 50px
				reaper.ImGui_TableSetupColumn(ctx, "Col 1", reaper.ImGui_TableColumnFlags_WidthFixed(), 150)
				reaper.ImGui_TableSetupColumn(ctx, "Col 2", reaper.ImGui_TableColumnFlags_WidthFixed(), 72)
				reaper.ImGui_TableSetupColumn(ctx, "Col 3", reaper.ImGui_TableColumnFlags_WidthFixed(), 190)
				
				reaper.ImGui_TableNextRow(ctx)
				
				-- Transpose
				reaper.ImGui_TableNextColumn(ctx)
				-- reaper.ImGui_Text(ctx, '11111')
				
				reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Text(), HexToColor("#FFFF00")) -- Красный цвет (RGBA)
				reaper.ImGui_Text(ctx, "  " .. transpose_value_qzzmsbnelc .. " (" .. get_name_note_current() .. ")" )
				reaper.ImGui_PopStyleColor(ctx)
				
				reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
				
				-- library_transpose_main
				local library_transpose_main = {
					key = "Transpose", default_open = true, children = {
						{spacing_vertical = "0"},
						{separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 148 },
						{spacing_vertical = "7"},
						
						{key = "+ Two Octave", children = {
							{key = "+24 (C)", action_function = function() fnc_transpose_value (24) end},
							{key = "+23 (B)", action_function = function() fnc_transpose_value (23) end},
							{key = "+22 (A#)", action_function = function() fnc_transpose_value (22) end},
							{key = "+21 (A)", action_function = function() fnc_transpose_value (21) end},
							{key = "+20 (G#)", action_function = function() fnc_transpose_value (20) end},
							{key = "+19 (G)", action_function = function() fnc_transpose_value (19) end},
							{key = "+18 (F#)", action_function = function() fnc_transpose_value (18) end},
							{key = "+17 (F)", action_function = function() fnc_transpose_value (17) end},
							{key = "+16 (E)", action_function = function() fnc_transpose_value (16) end},
							{key = "+15 (D#)", action_function = function() fnc_transpose_value (15) end},
							{key = "+14 (D)", action_function = function() fnc_transpose_value (14) end},
							{key = "+13 (C#)", action_function = function() fnc_transpose_value (13) end},
						},},
						
						{key = "+ One Octave", default_open = true, children = {
							{key = "+12 (C)", action_function = function() fnc_transpose_value (12) end},
							{key = "+11 (B)", action_function = function() fnc_transpose_value (11) end},
							{key = "+10 (A#)", action_function = function() fnc_transpose_value (10) end},
							{key = "+09 (A)", action_function = function() fnc_transpose_value (9) end},
							{key = "+08 (G#)", action_function = function() fnc_transpose_value (8) end},
							{key = "+07 (G)", action_function = function() fnc_transpose_value (7) end},
							{key = "+06 (F#)", action_function = function() fnc_transpose_value (6) end},
							{key = "+05 (F)", action_function = function() fnc_transpose_value (5) end},
							{key = "+04 (E)", action_function = function() fnc_transpose_value (4) end},
							{key = "+03 (D#)", action_function = function() fnc_transpose_value (3) end},
							{key = "+02 (D)", action_function = function() fnc_transpose_value (2) end},
							{key = "+01 (C#)", action_function = function() fnc_transpose_value (1) end},
						},},
						
						{separator_horizontal = "2", separator_color = "#888888", separator_length = 85 },
						{spacing_vertical = "1"},
						{key = "0 (C)", action_function = function() fnc_transpose_value (0) end},
						{separator_horizontal = "2", separator_color = "#888888", separator_length = 85 },
						{spacing_vertical = "1"},
						
						{key = "- One Octave", children = {
							{key = "-01 (B)", action_function = function() fnc_transpose_value (-1) end},
							{key = "-02 (A#)", action_function = function() fnc_transpose_value (-2) end},
							{key = "-03 (A)", action_function = function() fnc_transpose_value (-3) end},
							{key = "-04 (G#)", action_function = function() fnc_transpose_value (-4) end},
							{key = "-05 (G)", action_function = function() fnc_transpose_value (-5) end},
							{key = "-06 (F#)", action_function = function() fnc_transpose_value (-6) end},
							{key = "-07 (F)", action_function = function() fnc_transpose_value (-7) end},
							{key = "-08 (E)", action_function = function() fnc_transpose_value (-8) end},
							{key = "-09 (D#)", action_function = function() fnc_transpose_value (-9) end},
							{key = "-10 (D)", action_function = function() fnc_transpose_value (-10) end},
							{key = "-11 (C#)", action_function = function() fnc_transpose_value (-11) end},
							{key = "-12 (C)", action_function = function() fnc_transpose_value (-12) end},
						},},
						
						{key = "- Two Octave", children = {
							{key = "-1 (B)", action_function = function() fnc_transpose_value (-13) end},
							{key = "-2 (A#)", action_function = function() fnc_transpose_value (-14) end},
							{key = "-3 (A)", action_function = function() fnc_transpose_value (-15) end},
							{key = "-4 (G#)", action_function = function() fnc_transpose_value (-16) end},
							{key = "-5 (G)", action_function = function() fnc_transpose_value (-17) end},
							{key = "-6 (F#)", action_function = function() fnc_transpose_value (-18) end},
							{key = "-7 (F)", action_function = function() fnc_transpose_value (-19) end},
							{key = "-8 (E)", action_function = function() fnc_transpose_value (-20) end},
							{key = "-9 (D#)", action_function = function() fnc_transpose_value (-21) end},
							{key = "-10 (D)", action_function = function() fnc_transpose_value (-22) end},
							{key = "-11 (C#)", action_function = function() fnc_transpose_value (-23) end},
							{key = "-12 (C)", action_function = function() fnc_transpose_value (-24) end},
						},},
					},
				}
				
				TreeNodeLibraryOutput(library_transpose_main, "Transpose", true) -- передаём корневой элемент
				-- Transpose
				reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
				
				-- Length
				reaper.ImGui_TableNextColumn(ctx)
				-- reaper.ImGui_Text(ctx, '22222')
				reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Text(), HexToColor("#FFFF00")) -- Красный цвет (RGBA)
				reaper.ImGui_Text(ctx, "    " .. note_item_length_value_qzzmsbnelc )
				reaper.ImGui_PopStyleColor(ctx)
				reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
				
				-- library_length_note
				local library_length_note = {
					key = "Length", default_open = true, children = {
						{spacing_vertical = "0"},
						{separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 70 },
						{spacing_vertical = "7"},
						{key = "4", action_function = function() fnc_note_item_length ("4") end},
						{key = "3", action_function = function() fnc_note_item_length ("3") end},
						{key = "2", action_function = function() fnc_note_item_length ("2") end},
						{key = "1", action_function = function() fnc_note_item_length ("1") end},
						{key = "1/2", action_function = function() fnc_note_item_length ("1/2") end},
						{key = "1/3", action_function = function() fnc_note_item_length ("1/3") end},
						{key = "1/4", action_function = function() fnc_note_item_length ("1/4") end},
						{key = "1/5", action_function = function() fnc_note_item_length ("1/5") end},
						{key = "1/6", action_function = function() fnc_note_item_length ("1/6") end},
						{key = "1/7", action_function = function() fnc_note_item_length ("1/7") end},
						{key = "1/8", action_function = function() fnc_note_item_length ("1/8") end},
						{key = "1/9", action_function = function() fnc_note_item_length ("1/9") end},
						{key = "1/10", action_function = function() fnc_note_item_length ("1/10") end},
						{key = "1/12", action_function = function() fnc_note_item_length ("1/12") end},
						{key = "1/16", action_function = function() fnc_note_item_length ("1/16") end},
						{key = "1/18", action_function = function() fnc_note_item_length ("1/18") end},
						{key = "1/24", action_function = function() fnc_note_item_length ("1/24") end},
						{key = "1/32", action_function = function() fnc_note_item_length ("1/32") end},
						{key = "1/48", action_function = function() fnc_note_item_length ("1/48") end},
						{key = "1/64", action_function = function() fnc_note_item_length ("1/64") end},
						{key = "1/128", action_function = function() fnc_note_item_length ("1/128") end},
					},
				}
				
				TreeNodeLibraryOutput(library_length_note) -- передаём корневой элемент
				-- Length
				
				-- Chords Library
				reaper.ImGui_TableNextColumn(ctx)
				reaper.ImGui_Text(ctx, '  ')
				reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
				
				-- insert_item_chord_library
				local insert_item_chord_library = {
					key = "Chords", default_open = true, children = {
						{spacing_vertical = "0"},
						{separator_horizontal = "3", separator_color = "#3F3F48",separator_length = 120 },
						{spacing_vertical = "5"},
						{key = " (one note)", value = "C2"},
						{key = " ", children = {
							{key = " (triad bass 1)", value = "C3, E3, G3"},
							{key = " (triad bass 3)", value = "E3, G3, C4"},
							{key = " (triad bass 5)", value = "G3, C4, E4"},
							{key = " (spread bass 1)", value = "C3, G3, E4"},
							{key = " (spread bass 3)", value = "G3, E4, C5"},
							{key = " (spread bass 5)", value = "E4, C5, G5"},
						},},
						{key = "maj", children = {
							{key = "maj v1", value = "C3, B3, E4, G4"},
							{key = "maj v2", value = "C3, E3, G3, B3, E4, G4, B4, E5, G5"},
							{key = "maj (6/9)", value = "C3, B3, E4, A4, D5, G5"},
							{key = "maj (13#11)", value = "C3, E3, A3, D4, F#4, B4, D5, E5, F#5, A5"},
							{key = "maj (7#5)", value = "C3, E3, G#3, B3, E4, G#4, B4, E5, G#5"},
						},},
						{key = "7", children = {
							{key = "7 v1", value = "C3, E3, A#3, G4, C5"},
							{key = "7 v2", value = "C3, E3, G3, A#3, C4, E4, G4, A#4, C5, E5, G5"},
							{key = "7 (6)", value = "C3, G3, A#3, E4, A4, C5"},
							{key = "7 (6/9) v1", value = "C3, A#3, E4, A4, D5, G5, C6"},
							{key = "7 (6/9) v2", value = "C3, E4, A4, A#4, D5"},
							{key = "7(6b9) v1", value = "C3, E3, A#3, C#4, E4, A4"},
							{key = "7(6b9) v2", value = "C3, A#3, E4, A4, C#5"},
							{key = "7(9,11,13)", value = "C3, G3, A#3, D4, F4, A4, C5"},
							{key = "7 (13#11)", value = "C3, E3, G3, A#3, E4, F#4, A4, D5, E5, F#5, A5"},
							{key = "7 (#9b13) v1", value = "C3, E4, G#4, A#4, D#5"},
							{key = "7 (#9b13) v2", value = "C3, A#3, E4, G#4, C5, D#5"},
							{key = "7 (#9b13) v3", value = "C3, E3, A#3, D#4, G#4, C5, D#5, G#5"},
							{key = "7 (b9#9b13)", value = "C3, E3, A#3, D#4, G#4, C#5"},
						},},
						{key = "o", children = {
							{key = "o", value = "C3, F#3, C4, D#4, A4"},
						},},
						{key = "ø", children = {
							{key = "ø", value = "C3, F#3, A#3, C4, F4"},
							{key = "m (7b5)", value = "C3, D#3, F#3, A#3, C4, D#4, A#4, D#5, F#5, A#5"},
						},},
						{key = "m", children = {
							{key = "m (triad bass 1)", value = "C3, D#3, G3"},
							{key = "m (triad bass 3)", value = "D#3, G3, C4"},
							{key = "m (triad bass 5)", value = "G3, C4, D#4"},
							{key = "m (spread bass 1)", value = "C3, G3, D#4"},
							{key = "m (spread bass 3)", value = "D#3, C4, G4"},
							{key = "m (spread bass 5)", value = "G3, D#4, C5"},
							{key = "m7", value = "C3, G3, A#3, D#4, G4"},
							{key = "m (6/9)", value = "C3, D#3, A3, D4, G4, C5"},
							{key = "m9 v1", value = "C3, A#3, D4, D#4, G4"},
							{key = "m9 v2", value = "C3, G3, A#3, D4, D#4"},
							{key = "m9 v3", value = "C3, D#3, G3, A#3, D4, G4, A#4, D5, D#5, G5"},
							{key = "m (maj11)", value = "C3, D#3, G3, B3, D4, D#4, F4, G4, B4, D5, F5"},
							{key = "m (9b13)", value = "C3, G#3, A#3, D4, D#4, G4, A#4, C5, D5, D#5, G#5"},
						},},
					},
				}
				-- Chords Library
				
				-- render_chords_library
				function render_chords_library(node, velocity, transpose, key_name_note)
					
					local function ThickSeparator(separator_horizontal, separator_color, separator_length)
						local drawList = reaper.ImGui_GetWindowDrawList(ctx) -- Передаём ctx
						local x1, y1 = reaper.ImGui_GetCursorScreenPos(ctx)

						-- Если указан separator_length, используем его, иначе на всю ширину окна
						local x2 = x1 + (separator_length or reaper.ImGui_GetWindowWidth(ctx))

						-- Толщина разделителя
						local thickness = tonumber(separator_horizontal) or 1

						-- Преобразуем цвет из #RRGGBB в формат 0xAARRGGBB
						local color = HexToColor(separator_color or "#FF7373")

						-- Рисуем горизонтальную линию
						reaper.ImGui_DrawList_AddLine(drawList, x1, y1 + thickness, x2, y1 + thickness, color, thickness)
					end
					
					if node.is_separator then -- Если это разделитель, выводим его
						reaper.ImGui_Separator(ctx)
						return
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
					
					if node.spacing_vertical then -- Если встречаем spacing_vertical, добавляем вертикальное пространство
						local spacing_vertical = tonumber(node.spacing_vertical) -- Преобразуем значение в число
						if spacing_vertical then
							reaper.ImGui_Dummy(ctx, 0, spacing_vertical) -- Добавление вертикального пространства
						end
						return
					end
					
					if node.key then -- Если у узла есть key
						-- Для корневого узла (где key = "Chords Library") key_name не добавляем
						local node_key = (node.key == "Chords") and node.key or key_name_note .. "" .. node.key
						-- Создаём уникальный идентификатор для узла (например, через node.key)
						local node_id = node.key
						
						local flags = 0 -- Для корневого узла всегда развернут
						-- if node.key == "Chords" then
						if node.default_open then
							-- Теперь корректно вызываем функцию для получения флага
							flags = reaper.ImGui_TreeNodeFlags_DefaultOpen()  -- Флаг для развернутого состояния
						end
						
						if node.children then -- Теперь флаги корректно передаются как число
							if reaper.ImGui_TreeNodeEx(ctx, node_id, node_key, flags) then -- развернутого состояния корневого узла
								for _, child in ipairs(node.children) do -- Рекурсивно отображаем дочерние элементы
									render_chords_library(child, velocity, transpose, key_name_note)
								end
								reaper.ImGui_TreePop(ctx) -- Закрываем текущий узел
							end
						else
							if reaper.ImGui_Selectable(ctx, node_key) then -- Листовой узел
								if node.value then -- Если кликнули, выводим value
									reaper.Undo_BeginBlock()
									
									insert_midi_chord(note_item_length_value_qzzmsbnelc, node.value, transpose_value_qzzmsbnelc, velocity, get_name_note_current() .. node.key)
									
									reaper.Main_OnCommand(reaper.NamedCommandLookup("41174"), 0) -- Item navigation: Move cursor to end of items
									reaper.Main_OnCommand(reaper.NamedCommandLookup("40289 "), 0) -- Item: Unselect (clear selection of) all items
									
									reaper.Undo_EndBlock("Insert Item And Chord", -1)
								end
							end
						end
					end
				end
				-- render_chords_library
				
				local note_names = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}
				-- Индекс ноты
				local note_index = (transpose_value_qzzmsbnelc % 12 + 12) % 12 + 1
				local note_label_name = note_names[note_index] -- имя ноты, например, "C" или "C#"
				render_chords_library(insert_item_chord_library, slider_velocity_value, transpose_value_qzzmsbnelc, note_label_name)
				reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
				
			reaper.ImGui_EndTable(ctx) -- Завершаем таблицу
			end
			
			
		elseif selected_content == "Content_1_Show" then
			reaper.ImGui_SeparatorText( ctx, "Content 1" )
			
			reaper.ImGui_PushFont (ctx, font_verdana[get_font_size ("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiFontSizeContent_1")])
			reaper.ImGui_Text(ctx, "Content 1 - " .. get_font_size ("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiFontSizeContent_1"))
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
			
			reaper.ImGui_PushFont (ctx, font_verdana[get_font_size ("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiFontSizeContent_2")])
			reaper.ImGui_Text(ctx, "Content 2 - " .. get_font_size ("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiFontSizeContent_2"))
			reaper.ImGui_PopFont(ctx)
			
			
			reaper.ImGui_TextWrapped(ctx, "MaxMusicMax MaxMusicMax MaxMusicMax MaxMusicMax MaxMusicMax MaxMusicMax MaxMusicMax MaxMusicMax MaxMusicMax MaxMusicMax MaxMusicMax MaxMusicMax ")
			
			
		elseif selected_content == "Set_Font_Size_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Set Font Size" )
			reaper.ImGui_Text(ctx, "Restart the script for some settings to take effect")
			reaper.ImGui_Dummy(ctx, 0, 10) -- Добавление вертикального пространства
			
			ImGuiSelectComboBox("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiFontSizeGlobal", 100)
			reaper.ImGui_SameLine(ctx)
			reaper.ImGui_Text(ctx, "Font Size Global")
			
			-- ImGuiSelectComboBox("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiFontSizeContent_1", 100)
			-- reaper.ImGui_SameLine(ctx)
			-- reaper.ImGui_Text(ctx, "Content 1")
			
			-- ImGuiSelectComboBox("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiFontSizeContent_2", 100)
			-- reaper.ImGui_SameLine(ctx)
			-- reaper.ImGui_Text(ctx, "Content 2")
		elseif selected_content == "Alpha_Window_ImGui_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Alpha Window ImGui" )
			local changed, new_alpha = reaper.ImGui_DragDouble(ctx, ' ', alpha_window_ImGui, 0.01, 0.0, 1.0, '%.2f')
			if changed then
				alpha_window_ImGui = new_alpha
				reaper.SetExtState("MaxMusicMax_ImGuiWindow", "x8koqhdze8_ImGuiAlphaWindow", tostring(alpha_window_ImGui), true)
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