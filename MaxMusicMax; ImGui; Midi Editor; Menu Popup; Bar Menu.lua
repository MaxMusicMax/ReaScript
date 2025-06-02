--@description ImGui; Menu Popup; Bar Menu
--@version 1.0
--@author MaxMusicMax
-- https://forum.cockos.com/showthread.php?p=2059855
-- https://github.com/cfillion/reaimgui/releases
-- #######################################
-- #######################################
-- 111111111111111111111111111
-- menu_structure___

-- library_note_length_main
-- library_note_transpose_main
-- library_set_events_to_channel
-- library_note_select

-- chords_library
-- render_chords_library
-- chords_progressions_library
-- render_chords_progressions_library

-- print_rs
-- console_window_destroy
-- printTable
-- printValue
-- TreeNodeLibraryOutput
-- executeWithMidiFocus
-- set_selected_notes_velocity
-- SetSelectedNoteEndsToCursor
-- SetSelectedNotesStartToCursor
-- SelectNotesFromCursor
-- SelectNotesWithinDistance
-- insert_chord
-- midi_to_note_name
-- get_selected_notes_to_str
-- get_chords_and_notes_in_selection
-- TransposeSelectedNotes
-- SetMidiEditorSize

-- cboc2 / create_button_one_click2
-- ShowMenuItems
-- SetDefaultMenuItemImGui
-- function main
-- #######################################
-- #######################################
-- print_rs
function print_rs (param)
	reaper.ShowConsoleMsg (tostring (param) .. "\n");
end
-- #######################################
-- #######################################
-- console_window_destroy
function console_window_destroy()
	local title = reaper.JS_Localize('ReaScript console output', "common")  -- Локализация заголовка окна консоли ReaScript
	local hwnd = reaper.JS_Window_Find(title, true)  -- Поиск окна с заданным заголовком
	if hwnd then reaper.JS_Window_Destroy(hwnd) end  -- Уничтожение окна, если оно найдено
end
-- #######################################
-- #######################################
-- printTable
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
-- printValue
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
--[[]]--
-- reaper.Main_OnCommand(40726, 0) -- Envelope: Insert 4 envelope points at time selection 40726
-- commandID = reaper.NamedCommandLookup("_RSd0e03fb8cf39d47509ddbf616a11d2b7e4afa29c")
-- reaper.Main_OnCommand(commandID, 0)
-- reaper.Main_OnCommand(reaper.NamedCommandLookup(39214), 0)
-- reaper.Main_OnCommand(reaper.NamedCommandLookup("_RSd0e03fb8cf39d47509ddbf616a11d2b7e4afa29c"), 0)
-- #######################################
-- #######################################
if true then -- true false
local ctx = reaper.ImGui_CreateContext('ImGui; Midi Editor; Menu Popup; Bar Menu')
-- ##################################################
-- ##################################################
-- executeWithMidiFocus
function executeWithMidiFocus()
	-- Получаем активный MIDI-редактор
	local midi_editor = reaper.MIDIEditor_GetActive()
	if not midi_editor then return end
	reaper.JS_Window_SetFocus(midi_editor)
end
-- ##################################################
-- ##################################################
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
-- ##################################################
-- ##################################################
-- set_selected_notes_velocity
function set_selected_notes_velocity(new_velocity)
    -- Получаем активный MIDI-элемент
    local take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
    if take == nil then return end
    -- Обходим все выделенные ноты
    local note_index = -1
    while true do
        note_index = reaper.MIDI_EnumSelNotes(take, note_index)
        if note_index == -1 then break end

        local retval, selected, muted, startppqpos, endppqpos, chan, pitch, velocity = reaper.MIDI_GetNote(take, note_index)
        if retval then
            reaper.MIDI_SetNote(take, note_index, selected, muted, startppqpos, endppqpos, chan, pitch, new_velocity, true)
        end
    end
    -- Включаем режим сортировки обратно
    reaper.MIDI_Sort(take)
end
-- ##################################################
-- ##################################################
-- SetSelectedNoteEndsToCursor
function SetSelectedNoteEndsToCursor(enable)
	-- Начало блока для отмены
	reaper.Undo_BeginBlock()

	-- Включение или выключение команды 40728 (Quantize events to grid)
	if enable == 1 then
		reaper.MIDIEditor_LastFocused_OnCommand(40728, 0) -- Включить команду -- Quantize events to grid
	elseif enable == 0 then
		reaper.MIDIEditor_LastFocused_OnCommand(40728, 1) -- Выключить команду -- Quantize events to grid
	end
	
	-- Получение активного MIDI-тейка
	local take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
	if not take then 
		reaper.Undo_EndBlock("Adjust Selected Note Ends to Cursor", -1)
		return 
	end

	-- Получение позиции курсора редактирования
	local cursor_pos = reaper.GetCursorPosition()
	local cursor_ppq = reaper.MIDI_GetPPQPosFromProjTime(take, cursor_pos)

	-- Обход всех событий MIDI в тейке
	local _, note_count = reaper.MIDI_CountEvts(take)
	for i = 0, note_count - 1 do
		local _, selected, muted, startppq, endppq, chan, pitch, vel = reaper.MIDI_GetNote(take, i)

		if selected then -- Изменяем только выделенные ноты
			reaper.MIDI_SetNote(take, i, selected, muted, startppq, cursor_ppq, chan, pitch, vel, false)
		end
	end

	-- Обновление MIDI
	reaper.MIDI_Sort(take)

	-- Конец блока для отмены
	reaper.Undo_EndBlock("Adjust Selected Note Ends to Cursor", -1)
end
-- ##################################################
-- ##################################################
-- SetSelectedNotesStartToCursor
function SetSelectedNotesStartToCursor(arp_delay)
    -- Получаем активный MIDI-редактор
    local midi_editor = reaper.MIDIEditor_GetActive()
    if not midi_editor then return end

    -- Получаем активный MIDI-тейк
    local take = reaper.MIDIEditor_GetTake(midi_editor)
    if not take or not reaper.TakeIsMIDI(take) then return end

    -- Получаем позицию Edit Cursor в PPQ
    local cursor_pos = reaper.MIDI_GetPPQPosFromProjTime(take, reaper.GetCursorPosition())

    -- Начало изменений
    reaper.Undo_BeginBlock()
    reaper.MIDI_DisableSort(take)

    -- Сбор всех выделенных нот
    local notes = {}
    local _, note_count, _, _ = reaper.MIDI_CountEvts(take)
    for i = 0, note_count - 1 do
        local _, selected, _, startppqpos, endppqpos, _, pitch, _ = reaper.MIDI_GetNote(take, i)
        if selected then
            table.insert(notes, {index = i, endppqpos = endppqpos, pitch = pitch})
        end
    end

    -- Сортировка по высоте (для арпеджио снизу вверх)
    table.sort(notes, function(a, b) return a.pitch < b.pitch end)

    -- Изменение начала нот с арпеджио или без
    for i, note in ipairs(notes) do
        local delay = 0
        if arp_delay and arp_delay > 0 then
            delay = (i - 1) * arp_delay  -- Добавляем задержку для арпеджио
        end

        local new_start = cursor_pos + delay

        -- Если новая позиция меньше конца ноты, корректируем начало
        if new_start < note.endppqpos then
            reaper.MIDI_SetNote(take, note.index, nil, nil, new_start, note.endppqpos, nil, nil, nil)
        else
            -- Если новая позиция за концом ноты, устанавливаем минимальную длину
            reaper.MIDI_SetNote(take, note.index, nil, nil, new_start, new_start + 1, nil, nil, nil)
        end
    end

    -- Завершение изменений
    reaper.MIDI_Sort(take)
    reaper.Undo_EndBlock("Изменить начало выделенных нот с арпеджио", -1)
end
-- ##################################################
-- ##################################################
-- SelectNotesFromCursor
function SelectNotesFromCursor(direction)
	local editor = reaper.MIDIEditor_GetActive()
	if not editor then return end

	local cursor_pos = reaper.GetCursorPosition()
	local take = reaper.MIDIEditor_GetTake(editor)
	if not take then return end

	local _, num_notes = reaper.MIDI_CountEvts(take)
	local cursor_ppq = reaper.MIDI_GetPPQPosFromProjTime(take, cursor_pos)

	for i = 0, num_notes - 1 do
		local ok, selected, muted, startppqpos, endppqpos, chan, pitch, vel = reaper.MIDI_GetNote(take, i)
		if ok then
			if (direction == "Right" and startppqpos > cursor_ppq)
			or (direction == "Left" and startppqpos < cursor_ppq) then
				reaper.MIDI_SetNote(take, i, true, muted, startppqpos, endppqpos, chan, pitch, vel, true)
			end
		end
	end

	reaper.MIDI_Sort(take)
end
-- ##################################################
-- ##################################################
-- SelectNotesWithinDistance
function SelectNotesWithinDistance(direction, duration)
	local editor = reaper.MIDIEditor_GetActive()
	if not editor then return end

	local take = reaper.MIDIEditor_GetTake(editor)
	if not take then return end

	local function duration_to_ppq(d)
		local quarter_note_ppq = 960
		local durations = {
			["32"] = quarter_note_ppq * 4 * 32,
			["30"] = quarter_note_ppq * 4 * 30,
			["28"] = quarter_note_ppq * 4 * 28,
			["26"] = quarter_note_ppq * 4 * 26,
			["24"] = quarter_note_ppq * 4 * 24,
			["22"] = quarter_note_ppq * 4 * 22,
			["20"] = quarter_note_ppq * 4 * 20,
			["18"] = quarter_note_ppq * 4 * 18,
			["16"] = quarter_note_ppq * 4 * 16,
			["14"] = quarter_note_ppq * 4 * 14,
			["12"] = quarter_note_ppq * 4 * 12,
			["10"] = quarter_note_ppq * 4 * 10,
			["10"] = quarter_note_ppq * 4 * 10,
			["8"] = quarter_note_ppq * 4 * 8,
			["6"]  = quarter_note_ppq * 4 * 6,
			["4"] = quarter_note_ppq * 16,
			["3"] = quarter_note_ppq * 12,
			["2"] = quarter_note_ppq * 8,
			["1"] = quarter_note_ppq * 4,
			["1/2"] = quarter_note_ppq * 2,
			["1/4"] = quarter_note_ppq,
			["1/8"] = quarter_note_ppq / 2,
			["1/16"] = quarter_note_ppq / 4,
			["1/32"] = quarter_note_ppq / 8,
			["1/64"] = quarter_note_ppq / 16,
			["1/128"] = quarter_note_ppq / 32,
		}
		return durations[d]
	end

	local len_ppq = duration_to_ppq(duration)
	if not len_ppq then return end

	local cursor_pos = reaper.GetCursorPosition()
	local cursor_ppq = reaper.MIDI_GetPPQPosFromProjTime(take, cursor_pos)

	local start_ppq, end_ppq
	if direction == "Right" then
		start_ppq = cursor_ppq
		end_ppq = cursor_ppq + len_ppq
	elseif direction == "Left" then
		start_ppq = cursor_ppq - len_ppq
		end_ppq = cursor_ppq
	else
		return
	end

	local _, note_count = reaper.MIDI_CountEvts(take)

	for i = 0, note_count - 1 do
		local ok, selected, muted, startppqpos, endppqpos, chan, pitch, vel = reaper.MIDI_GetNote(take, i)
		if ok and startppqpos >= start_ppq and startppqpos < end_ppq then
			reaper.MIDI_SetNote(take, i, true, muted, startppqpos, endppqpos, chan, pitch, vel, true)
		end
	end

	reaper.MIDI_Sort(take)
end
-- ##################################################
-- ##################################################
-- insert_chord
function insert_chord (param1, param2, param3)
	-- Функция для преобразования значения сетки в формат "1/4", "1/8" и т.д.
	local function gridToNoteDivision(grid)
		local quarter_note_ppq = 960
		-- Таблица стандартных длительностей
		local durations = {
			["2"] = quarter_note_ppq * 8,
			["3"] = quarter_note_ppq * 12,
			["4"] = quarter_note_ppq * 16,
			["1"] = quarter_note_ppq * 4,
			["1/2"] = quarter_note_ppq * 2,
			["1/3"] = quarter_note_ppq * 4 / 3,
			["1/4"] = quarter_note_ppq,
			["1/5"] = quarter_note_ppq * 4 / 5,
			["1/6"] = quarter_note_ppq * 4 / 6,
			["1/7"] = quarter_note_ppq * 4 / 7,
			["1/8"] = quarter_note_ppq / 2,
			["1/9"] = quarter_note_ppq * 4 / 9,
			["1/10"] = quarter_note_ppq * 4 / 10,
			["1/11"] = quarter_note_ppq * 4 / 11,
			["1/12"] = quarter_note_ppq * 4 / 12,
			["1/13"] = quarter_note_ppq * 4 / 13,
			["1/14"] = quarter_note_ppq * 4 / 14,
			["1/15"] = quarter_note_ppq * 4 / 15,
			["1/16"] = quarter_note_ppq / 4,
			["1/17"] = quarter_note_ppq * 4 / 17,
			["1/18"] = quarter_note_ppq * 4 / 18,
			["1/19"] = quarter_note_ppq * 4 / 19,
			["1/20"] = quarter_note_ppq * 4 / 20,
			["1/24"] = quarter_note_ppq * 4 / 24,
			["1/32"] = quarter_note_ppq / 8,
			["1/48"] = quarter_note_ppq * 4 / 48,
			["1/64"] = quarter_note_ppq / 16,
			["1/128"] = quarter_note_ppq / 32,
		}

		-- Поиск ближайшего совпадения
		local closest_label = nil
		local min_difference = math.huge

		for label, ppq in pairs(durations) do
			local division_value = ppq / quarter_note_ppq
			local difference = math.abs(grid - division_value)
			if difference < min_difference then
				min_difference = difference
				closest_label = label
			end
		end

		return closest_label or ("Нестандартная сетка: " .. grid)
	end

	-- Функция для конвертации ноты в MIDI-значение
	local function note_to_midi(note)
		local notes = {C = 0, ["C#"] = 1, D = 2, ["D#"] = 3, E = 4, F = 5, ["F#"] = 6, G = 7, ["G#"] = 8, A = 9, ["A#"] = 10, B = 11}
		local octave = tonumber(note:sub(-1))
		local key = note:sub(1, -2)
		return (octave + 1) * 12 + notes[key]
	end

	-- Функция для конвертации длительности в PPQ
	local function duration_to_ppq(duration)
		local quarter_note_ppq = 960
		local durations = {
			["2"] = quarter_note_ppq * 8,
			["3"] = quarter_note_ppq * 12,
			["4"] = quarter_note_ppq * 16,
			["1"] = quarter_note_ppq * 4,
			["1/2"] = quarter_note_ppq * 2,
			["1/3"] = quarter_note_ppq * 4 / 3,
			["1/4"] = quarter_note_ppq,
			["1/5"] = quarter_note_ppq * 4 / 5,
			["1/6"] = quarter_note_ppq * 4 / 6,
			["1/7"] = quarter_note_ppq * 4 / 7,
			["1/8"] = quarter_note_ppq / 2,
			["1/9"] = quarter_note_ppq * 4 / 9,
			["1/10"] = quarter_note_ppq * 4 / 10,
			["1/11"] = quarter_note_ppq * 4 / 11,
			["1/12"] = quarter_note_ppq * 4 / 12,
			["1/13"] = quarter_note_ppq * 4 / 13,
			["1/14"] = quarter_note_ppq * 4 / 14,
			["1/15"] = quarter_note_ppq * 4 / 15,
			["1/16"] = quarter_note_ppq / 4,
			["1/17"] = quarter_note_ppq * 4 / 17,
			["1/18"] = quarter_note_ppq * 4 / 18,
			["1/19"] = quarter_note_ppq * 4 / 19,
			["1/20"] = quarter_note_ppq * 4 / 20,
			["1/24"] = quarter_note_ppq * 4 / 24,
			["1/32"] = quarter_note_ppq / 8,
			["1/48"] = quarter_note_ppq * 4 / 48,
			["1/64"] = quarter_note_ppq / 16,
			["1/128"] = quarter_note_ppq / 32,
		}
		return durations[duration]
	end


	local function insert_chord_local(chord_str, nv, tk)
		
		local take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
		if take == nil then return end

		reaper.MIDI_DisableSort(take)
		local cursor_pos = reaper.GetCursorPosition()

		local grid = reaper.MIDI_GetGrid(take)
		local division = gridToNoteDivision(grid)

		local default_duration = division or "1/4"
		local global_duration = default_duration

		local transpose = tk or 0
		local notes_velocity = nv or 96

		local gnl_match = string.match(chord_str, "%[gnl=([%d/]+)%]")
		if gnl_match then
			global_duration = gnl_match
			chord_str = string.gsub(chord_str, "%[gnl=[%d/]+%]", "")
		end

		reaper.Undo_OnStateChange_Item(0, "MIDI Editor Block Start", reaper.GetMediaItemTake_Item(take))
		for part in string.gmatch(chord_str, "[^|]+") do
			local combined_durations = 0
			for duration_part in string.gmatch(part, "nl=([%d/]+)") do
				combined_durations = combined_durations + (duration_to_ppq(duration_part) or 0)
			end

			local duration = (combined_durations > 0 and combined_durations) or duration_to_ppq(global_duration) -- attempt to call a nil value (global 'duration_to_ppq')
			part = string.gsub(part, "nl=[%d/]+,", "")

			local chord_notes = {}
			for note in string.gmatch(part, "[A-G]#?%d") do
				table.insert(chord_notes, note)
			end

			if #chord_notes > 0 then
				local start_ppqpos = reaper.MIDI_GetPPQPosFromProjTime(take, cursor_pos)
				local end_ppqpos = start_ppqpos + duration
				for i = 1, #chord_notes do
					local midi_note = note_to_midi(chord_notes[i]) + transpose
					reaper.MIDI_InsertNote(take, true, false, start_ppqpos, end_ppqpos, 0, midi_note, notes_velocity, true)
				end
				cursor_pos = reaper.MIDI_GetProjTimeFromPPQPos(take, end_ppqpos)
			else
				local pause_duration = duration
				cursor_pos = cursor_pos + reaper.TimeMap2_QNToTime(0, pause_duration / reaper.SNM_GetIntConfigVar("miditicksperbeat", 480))
			end
		end
		reaper.Undo_OnStateChange_Item(0, "MIDI Editor Block End", reaper.GetMediaItemTake_Item(take))

		reaper.MIDI_Sort(take)
		reaper.UpdateArrange()
		
	end
	
	insert_chord_local (param1, param2, param3)
	
end
-- ##################################################
-- ##################################################
-- midi_to_note_name
-- Функция для конвертации MIDI номера в ноту
function midi_to_note_name(midi_num)
	local notes = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}
	local note = notes[(midi_num % 12) + 1]
	local octave = math.floor(midi_num / 12) - 1
	return note .. octave
end
-- ##################################################
-- ##################################################
-- get_selected_notes_to_str
-- Функция для получения выделенных нот
function get_selected_notes_to_str()
	-- Получаем активный MIDI-тейк
	local take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
	if not take then return "" end

	-- Получаем количество всех событий и выделенных нот
	local _, num_notes, _, _ = reaper.MIDI_CountEvts(take)

	local notes = {}

	-- Перебираем все ноты и выбираем только выделенные
	for i = 0, num_notes - 1 do
		local _, selected, _, startppqpos, endppqpos, chan, pitch, vel = reaper.MIDI_GetNote(take, i)
		if selected then
			table.insert(notes, pitch)
		end
	end

	-- Сортируем ноты по высоте (от низкой к высокой)
	table.sort(notes)

	-- Преобразуем ноты в строковый формат
	local note_names = {}
	for _, pitch in ipairs(notes) do
		table.insert(note_names, midi_to_note_name(pitch))
	end

	-- Формируем строку для вывода
	local output = table.concat(note_names, ", ")

	return output
end
-- ##################################################
-- ##################################################
-- get_chords_and_notes_in_selection
function get_chords_and_notes_in_selection()
    -- Функция для конвертации PPQ в длительность
    local function ppq_to_duration(ppq)
        local quarter_note_ppq = 960
        local durations = {
            [quarter_note_ppq * 8] = "2",
            [quarter_note_ppq * 12] = "3",
            [quarter_note_ppq * 16] = "4",
            [quarter_note_ppq * 4] = "1",
            [quarter_note_ppq * 2] = "1/2",
            [quarter_note_ppq * 4 / 3] = "1/3",
            [quarter_note_ppq] = "1/4",
            [quarter_note_ppq * 4 / 5] = "1/5",
            [quarter_note_ppq * 4 / 6] = "1/6",
            [quarter_note_ppq * 4 / 7] = "1/7",
            [quarter_note_ppq / 2] = "1/8",
            [quarter_note_ppq * 4 / 9] = "1/9",
            [quarter_note_ppq * 4 / 10] = "1/10",
            [quarter_note_ppq * 4 / 11] = "1/11",
            [quarter_note_ppq * 4 / 12] = "1/12",
            [quarter_note_ppq * 4 / 13] = "1/13",
            [quarter_note_ppq * 4 / 14] = "1/14",
            [quarter_note_ppq * 4 / 15] = "1/15",
            [quarter_note_ppq / 4] = "1/16",
            [quarter_note_ppq * 4 / 17] = "1/17",
            [quarter_note_ppq * 4 / 18] = "1/18",
            [quarter_note_ppq * 4 / 19] = "1/19",
            [quarter_note_ppq * 4 / 20] = "1/20",
            [quarter_note_ppq * 4 / 24] = "1/24",
            [quarter_note_ppq / 8] = "1/32",
            [quarter_note_ppq * 4 / 48] = "1/48",
            [quarter_note_ppq / 16] = "1/64",
            [quarter_note_ppq / 32] = "1/128",
            [quarter_note_ppq / 48] = "1/128T"
        }
        return durations[ppq] or tostring(ppq)
    end

    -- Функция для разбивки длительности на стандартные длительности
    local function split_duration(ppq)
        local quarter_note_ppq = 960
        local durations = {
            quarter_note_ppq * 4,
            quarter_note_ppq * 2,
            quarter_note_ppq,
            quarter_note_ppq * 2 / 3,
            quarter_note_ppq / 2,
            quarter_note_ppq / 3,
            quarter_note_ppq / 4,
            quarter_note_ppq / 6,
            quarter_note_ppq / 8,
            quarter_note_ppq / 12,
            quarter_note_ppq / 16,
            quarter_note_ppq / 24,
            quarter_note_ppq / 32,
            quarter_note_ppq / 48,
            quarter_note_ppq / 64,
            quarter_note_ppq / 96,
            quarter_note_ppq / 128,
            quarter_note_ppq / 192 -- для триольных 128-х
        }
        local result = {}

        while ppq > 0 do
            local found = false
            for _, d in ipairs(durations) do
                if ppq >= d then
                    table.insert(result, ppq_to_duration(d))
                    ppq = ppq - d
                    found = true
                    break
                end
            end
            if not found then
                table.insert(result, tostring(ppq))
                ppq = 0
            end
        end

        return result
    end

    -- Функция для конвертации MIDI номера в ноту
    local function midi_to_note_name(midi_num)
        local notes = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}
        local note = notes[(midi_num % 12) + 1]
        local octave = math.floor(midi_num / 12) - 1
        return note .. octave
    end

    -- Получаем активный MIDI-элемент
    local take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
    if not take then 
        reaper.ShowConsoleMsg("No active MIDI take found.\n")
        return "" 
    end

    -- Проверка наличия выделенных нот
    local retval, note_count, _, _ = reaper.MIDI_CountEvts(take)
    local has_selected_notes = false
    if retval and note_count > 0 then
        for i = 0, note_count - 1 do
            local _, selected, _, _, _, _, _, _ = reaper.MIDI_GetNote(take, i)
            if selected then
                has_selected_notes = true
                break
            end
        end
    end

    -- Получаем начальную и конечную позицию выделенного временного интервала
    local time_start, time_end = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)
    
    -- Если есть выделенные ноты, обрабатываем их, иначе - обрабатываем time selection
    local ppq_start, ppq_end
    if has_selected_notes then
        ppq_start, ppq_end = math.huge, -math.huge
        for i = 0, note_count - 1 do
            local _, selected, _, startppqpos, endppqpos, _, _, _ = reaper.MIDI_GetNote(take, i)
            if selected then
                ppq_start = math.min(ppq_start, startppqpos)
                ppq_end = math.max(ppq_end, endppqpos)
            end
        end
    else
        if time_start == time_end then 
            reaper.ShowConsoleMsg("No time selection or selected notes found.\n")
            return "" 
        end
        ppq_start = reaper.MIDI_GetPPQPosFromProjTime(take, time_start)
        ppq_end = reaper.MIDI_GetPPQPosFromProjTime(take, time_end)
    end

    -- Таблица для хранения нот по их начальной позиции
    local notes_by_start_pos = {}

    -- Перебираем все ноты и собираем их в таблицу
    if retval and note_count > 0 then
        for i = 0, note_count - 1 do
            local _, selected, _, startppqpos, endppqpos, _, pitch, _ = reaper.MIDI_GetNote(take, i)
            if startppqpos >= ppq_start and startppqpos <= ppq_end then
                if has_selected_notes and not selected then
                    goto continue
                end
                if not notes_by_start_pos[startppqpos] then
                    notes_by_start_pos[startppqpos] = {}
                end
                table.insert(notes_by_start_pos[startppqpos], {pitch=pitch, startppqpos=startppqpos, endppqpos=endppqpos})
            end
            ::continue::
        end
    end

    if next(notes_by_start_pos) == nil then
        reaper.ShowConsoleMsg("No notes found in the selected range.\n")
        return ""
    end

    -- Формируем строку результата
    local result = ""
    local sorted_positions = {}
    for pos in pairs(notes_by_start_pos) do
        table.insert(sorted_positions, pos)
    end
    table.sort(sorted_positions)

    local last_endppqpos = ppq_start
    local first_note = true

    for _, startppqpos in ipairs(sorted_positions) do
        if startppqpos > last_endppqpos then
            local pause_duration = startppqpos - last_endppqpos
            local pause_parts = split_duration(pause_duration)
            for _, part in ipairs(pause_parts) do
                if result ~= "" or not first_note then
                    result = result .. " | "
                end
                result = result .. "nl=" .. part
                first_note = false
            end
        end

        local notes = notes_by_start_pos[startppqpos]
        table.sort(notes, function(a, b) return a.pitch < b.pitch end)
        local note_duration = notes[1].endppqpos - startppqpos
        local duration_parts = split_duration(note_duration)
        local note_names = {}
        for _, note in ipairs(notes) do
            table.insert(note_names, midi_to_note_name(note.pitch))
        end
        if #duration_parts > 1 then
            if result ~= "" or not first_note then
                result = result .. " | "
            end
            result = result .. "nl=" .. table.concat(duration_parts, " + nl=") .. ", " .. table.concat(note_names, ", ")
        else
            if result ~= "" or not first_note then
                result = result .. " | "
            end
            result = result .. "nl=" .. duration_parts[1] .. ", " .. table.concat(note_names, ", ")
        end

        last_endppqpos = math.max(last_endppqpos, notes[#notes].endppqpos)
        first_note = false
    end

    if last_endppqpos < ppq_end then
        local pause_duration = ppq_end - last_endppqpos
        local pause_parts = split_duration(pause_duration)
        for _, part in ipairs(pause_parts) do
            result = result .. " | nl=" .. part
        end
    end

    return result
end
-- ##################################################
-- ##################################################
-- TransposeSelectedNotes
function TransposeSelectedNotes(interval)
	local midi_editor = reaper.MIDIEditor_GetActive()
	if not midi_editor then return end

	local take = reaper.MIDIEditor_GetTake(midi_editor)
	if not take or not reaper.ValidatePtr(take, "MediaItem_Take*") then return end

	local _, notecnt, _, _ = reaper.MIDI_CountEvts(take)
	if notecnt == 0 then return end

	reaper.Undo_BeginBlock()
	reaper.MIDI_DisableSort(take)

	for i = 0, notecnt - 1 do
		local _, selected, muted, startppq, endppq, chan, pitch, vel = reaper.MIDI_GetNote(take, i)
		if selected then
			reaper.MIDI_SetNote(take, i, nil, nil, nil, nil, nil, pitch + interval, nil, false)
		end
	end

	reaper.MIDI_Sort(take)
	reaper.Undo_EndBlock("Transpose selected notes", -1)
end
-- ##################################################
-- ##################################################
-- SetMidiEditorSize
function SetMidiEditorSize(x, y, w, h)
	local hwnd = reaper.MIDIEditor_GetActive()
	if hwnd then
		reaper.JS_Window_SetPosition(hwnd, x, y, w, h)
		-- executeWithMidiFocus()
	end
end
-- ##################################################
-- ##################################################
-- cboc2 / create_button_one_click2
function cboc2(label, callback_function, button_width, button_height )
	if reaper.ImGui_Button( ctx, label, button_width, button_height ) then
		callback_function()
		-- print_rs("create_button_one_click: " .. label)
		executeWithMidiFocus()
	end
end
-- ##################################################
-- ##################################################
-- TreeNodeLibraryOutput
function TreeNodeLibraryOutput(node, rootKey)
	
	local function HexToColor(hex)
		-- Убираем символ '#' в начале строки, если он есть
		hex = hex:gsub("#", "")
		-- Получаем компоненты цвета (красный, зелёный, синий)
		local r = tonumber(hex:sub(1, 2), 16)
		local g = tonumber(hex:sub(3, 4), 16)
		local b = tonumber(hex:sub(5, 6), 16)
		-- Возвращаем цвет в формате 0xAARRGGBB (с альфа-каналом FF)
		return 0xFF + (b * 0x100) + (g * 0x10000) + (r * 0x1000000)
	end


	local function ThickSeparator(separator_horizontal, separator_color)
		local drawList = reaper.ImGui_GetWindowDrawList(ctx)
		local x1, y1 = reaper.ImGui_GetCursorScreenPos(ctx)
		local x2 = x1 + reaper.ImGui_GetWindowWidth(ctx)
		-- Толщина разделителя, по умолчанию 1
		local thickness = tonumber(separator_horizontal) or 1
		-- Преобразуем цвет из #RRGGBB в формат 0xAARRGGBB
		local color = HexToColor(separator_color or "#FF0000")  -- Если не передан цвет, то по умолчанию белый
		-- Рисуем горизонтальную линию с заданной толщиной
		reaper.ImGui_DrawList_AddLine(drawList, x1, y1 + thickness, x2, y1 + thickness, color, thickness)
	end

	-- if node.separator_horizontal or node.separator_color then
		-- Если есть параметры для разделителя, передаем их в ThickSeparator
		-- ThickSeparator(node.separator_horizontal, node.separator_color)
		-- return
	-- end
	
	if node.separator_horizontal then
		if node.separator_horizontal == "ImGui_SeparatorText" then
			local separator_text = node.separator_text or "" -- Используем переданный текст или пустую строку
			reaper.ImGui_SeparatorText(ctx, separator_text)
		else
			ThickSeparator(node.separator_horizontal, node.separator_color)
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
	
	if node.key then -- Если у узла есть key
		local flags = node.default_open and reaper.ImGui_TreeNodeFlags_DefaultOpen() or 0
		
		if node.children then -- Теперь флаги корректно передаются как число
			if reaper.ImGui_TreeNodeEx(ctx, node.key, node.key, flags) then -- развернутого состояния корневого узла
				for _, child in ipairs(node.children) do -- Рекурсивно отображаем дочерние элементы
					TreeNodeLibraryOutput(child)
				end
				reaper.ImGui_TreePop(ctx) -- Закрываем текущий узел
			end
		else
			local command_id = node.action_id and reaper.NamedCommandLookup(node.action_id)
			local is_active = command_id and reaper.GetToggleCommandStateEx(32060, command_id) == 1 or false

			if reaper.ImGui_Selectable(ctx, node.key, is_active) then
				if command_id then
					-- reaper.MIDIEditor_LastFocused_OnCommand(reaper.NamedCommandLookup("_BR_ME_SET_CC_LANES_HEIGHT_0"), 0)
					reaper.MIDIEditor_LastFocused_OnCommand(command_id, 0)
					executeWithMidiFocus()
				elseif node.action_function then
					node.action_function()
					executeWithMidiFocus()
				end
			end
		end
	end

end
-- ##################################################
-- ##################################################
-- ShowMenuItems
local selected_content = "Alpha_Window_ImGui_Content_Show" -- Alpha_Window_ImGui_Content_Show

local current_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiCurrentMenuItemMidiEditor")
local default_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiDefaultMenuItemMidiEditor")
if current_menu_item_imgui == "" then
	reaper.SetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiCurrentMenuItemMidiEditor", selected_content, true)
end
if default_menu_item_imgui == "" then
	reaper.SetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiDefaultMenuItemMidiEditor", selected_content, true)
else
	selected_content = default_menu_item_imgui
end

local function ShowMenuItems(items)
	
	local function ThickSeparator(separator_horizontal, separator_color)
		local drawList = reaper.ImGui_GetWindowDrawList(ctx)
		local x1, y1 = reaper.ImGui_GetCursorScreenPos(ctx)
		local x2 = x1 + reaper.ImGui_GetWindowWidth(ctx)
		-- Толщина разделителя, по умолчанию 1
		local thickness = tonumber(separator_horizontal) or 1
		-- Преобразуем цвет из #RRGGBB в формат 0xAARRGGBB
		local color = HexToColor(separator_color or "#FF0000")  -- Если не передан цвет, то по умолчанию белый
		-- Рисуем горизонтальную линию с заданной толщиной
		reaper.ImGui_DrawList_AddLine(drawList, x1, y1 + thickness, x2, y1 + thickness, color, thickness)
	end
	
	for _, item in ipairs(items) do
		if item.is_separator then
			reaper.ImGui_Separator(ctx)
		elseif item.spacing_vertical then
			local spacing_vertical = tonumber(item.spacing_vertical) -- Преобразуем значение в число
			if spacing_vertical then
				reaper.ImGui_Dummy(ctx, 0, spacing_vertical) -- Добавление вертикального пространства
			end
		elseif item.separator_horizontal or item.separator_color then
			-- print_rs ("---------")
			ThickSeparator(item.separator_horizontal, item.separator_color)
		elseif item.children then
			if reaper.ImGui_BeginMenu(ctx, item.label) then
				ShowMenuItems(item.children)
				reaper.ImGui_EndMenu(ctx)
			end
		else
			if reaper.ImGui_MenuItem(ctx, item.label) then
				if item.action_id then
					-- reaper.MIDIEditor_LastFocused_OnCommand(reaper.NamedCommandLookup("_BR_ME_SET_CC_LANES_HEIGHT_0"), 0)
					reaper.MIDIEditor_LastFocused_OnCommand(item.action_id, 0)
				elseif item.action_function then
					item.action_function()
					executeWithMidiFocus()
				elseif item.show_content then
					selected_content = item.show_content
					reaper.SetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiCurrentMenuItemMidiEditor", selected_content, true)
					executeWithMidiFocus()
				end
			end
		end
	end
end
-- ##################################################
-- ##################################################
-- SetDefaultMenuItemImGui
function SetDefaultMenuItemImGui ()
	current_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiCurrentMenuItemMidiEditor") -- ImGuiCurrentMenuItem
	reaper.SetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiDefaultMenuItemMidiEditor", current_menu_item_imgui, true) -- ImGuiDefaultMenuItem
	-- print_rs ( current_menu_item_imgui )
end
-- ##################################################
-- ##################################################
local font_verdana = reaper.ImGui_CreateFont('verdana', 16) 
reaper.ImGui_Attach(ctx, font_verdana)
-- ##################################################
-- ##################################################
-- menu_structure___
-- {label = "Item", children = {}},
--[[
action_id
action_function
show_content
]]--

local menu_structure = {
	-- ##################################################
	-- ##################################################
	{label = "Menu", children = {
		-- {is_separator = true}, -- Разделитель
		{label = "Insert Chord", show_content = "Insert_Chord_Content_Show"},
		{label = "Insert Chord Progressions", show_content = "Insert_Chord_Progressions_Content_Show"},
		{label = "Note Velocity", show_content = "Set_Note_Velocity_Content_Show"},
		{label = "Note Length", show_content = "Set_Note_Length_Content_Show"},
		{label = "Note Select", show_content = "Set_Note_Select_Content_Show"},
		{label = "Note Transpose", show_content = "Set_Note_Transpose_Content_Show"},
		{label = "View: Show", show_content = "View_Show_Content_Show"},
		{label = "Set Events To Channel", show_content = "Set_Events_To_Channel_Content_Show"},
	}},
	{label = "Actions", children = {
		{label = "Insert bank/program select event", action_id = "40950"},
	}},
	-- ##################################################
	-- ##################################################
	{label = "Settings", children = {
		{label = "Set Default Tab ImGui", action_function = function() SetDefaultMenuItemImGui () end},
		{label = "Set Midi Editor Size", children = {
			{label = "Set Midi Editor Size", show_content = "Set_Midi_Editor_Size_Content_Show"},
			{spacing_vertical = "1"},
			{separator_horizontal = "2", separator_color = "#6B6B7A" },
			{spacing_vertical = "5"},
			{label = "1490, 974", action_function = function() SetMidiEditorSize(431, 76, 1490, 974) end},
			{label = "1300, 974", action_function = function() SetMidiEditorSize(621, 76, 1300, 974) end},
		}},
		{label = "Set Alpha Tab ImGui", show_content = "Alpha_Window_ImGui_Content_Show"},
		
		--[[
		{spacing_vertical = "7"},
		{separator_horizontal = "2", separator_color = "#EBEBEB" },
		{separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},
		reaper.MIDIEditor_LastFocused_OnCommand(40237, 0)
		reaper.MIDIEditor_LastFocused_OnCommand(reaper.NamedCommandLookup("_BR_ME_SET_CC_LANES_HEIGHT_200"), 0)
		]]--
		
	}},
	-- ##################################################
	-- ##################################################
}
-- ##################################################
-- ##################################################
local alpha_window_ImGui = tonumber(reaper.GetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiAlphaWindowMidiEditor")) or 0.6
-- local alpha_window_ImGui = 0.6  -- Прозрачность окна (0.0 - полностью прозрачное, 1.0 - полностью непрозрачное)
-- function main
local name_window = "· · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·"
local function main()
	reaper.ImGui_SetNextWindowBgAlpha(ctx, alpha_window_ImGui) -- Установить прозрачность фона окна
	reaper.ImGui_PushFont (ctx, font_verdana)
	
	local visible, open = reaper.ImGui_Begin(ctx, name_window, true, reaper.ImGui_WindowFlags_MenuBar() )
	
	-- visible
	if visible then
		if reaper.ImGui_BeginMenuBar(ctx) then
			ShowMenuItems(menu_structure)
			reaper.ImGui_EndMenuBar(ctx)
		end
		
		-- ##################################################
		-- ##################################################
		-- reaper.ImGui_SeparatorText( ctx, "Select" )
		-- reaper.ImGui_Text(ctx, '\n')
		-- ##################################################
		-- ##################################################
		if selected_content == "" then
		
		elseif selected_content == "Set_Events_To_Channel_Content_Show" then
			-- reaper.ImGui_SeparatorText(ctx, "Set Events To Channel")
			
			-- library_set_events_to_channel
			local library_set_events_to_channel = {
				key = "Set Events To Channel", default_open = true, children = {
					
					-- {spacing_vertical = "1"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					-- {spacing_vertical = "7"},
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},
					
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Set Selected Note To Cursor"},
					{key = "01", action_id = "40020"},
					{key = "02", action_id = "40021"},
					{key = "03", action_id = "40022"},
					{key = "04", action_id = "40023"},
					{key = "05", action_id = "40024"},
					{key = "06", action_id = "40025"},
					{key = "07", action_id = "40026"},
					{key = "08", action_id = "40027"},
					{key = "09", action_id = "40028"},
					{key = "10", action_id = "40029"},
					{key = "11", action_id = "40030"},
					{key = "12", action_id = "40031"},
					{key = "13", action_id = "40032"},
					{key = "14", action_id = "40033"},
					{key = "15", action_id = "40034"},
					{key = "16", action_id = "40035"},
					
					--[[
					{key = "User Functions", children = {
						{key = "Command ID 1", action_id = "41930"},
						{key = "Command ID 2", action_id = "_RS251990727759d3dff9cf84df740cd6a87ea0d169"},
						{key = "User Function 2", action_function = function() reaper.Main_OnCommand(40772, 0) end},
						{key = "User Function 3", action_function = function() us_fn1() end},
					}},
					]]--
				},
			}
			
			TreeNodeLibraryOutput (library_set_events_to_channel)
			
			if false then
				local btn_width = 60
				local btn_height = 60
				
				cboc2 ( " 01 ", function() reaper.MIDIEditor_LastFocused_OnCommand(40020, 0) end, btn_width, btn_height )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				
				cboc2 ( " 02 ", function() reaper.MIDIEditor_LastFocused_OnCommand(40021, 0) end, btn_width, btn_height )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " 03 ", function() reaper.MIDIEditor_LastFocused_OnCommand(40022, 0) end, btn_width, btn_height )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " 04 ", function() reaper.MIDIEditor_LastFocused_OnCommand(40023, 0) end, btn_width, btn_height )
				
				cboc2 ( " 05 ", function() reaper.MIDIEditor_LastFocused_OnCommand(40024, 0) end, btn_width, btn_height )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " 06 ", function() reaper.MIDIEditor_LastFocused_OnCommand(40025, 0) end, btn_width, btn_height )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " 07 ", function() reaper.MIDIEditor_LastFocused_OnCommand(40026, 0) end, btn_width, btn_height )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " 08 ", function() reaper.MIDIEditor_LastFocused_OnCommand(40027, 0) end, btn_width, btn_height )
				
				cboc2 ( " 09 ", function() reaper.MIDIEditor_LastFocused_OnCommand(40028, 0) end, btn_width, btn_height )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " 10 ", function() reaper.MIDIEditor_LastFocused_OnCommand(40029, 0) end, btn_width, btn_height )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии<b></b>
				cboc2 ( " 11 ", function() reaper.MIDIEditor_LastFocused_OnCommand(40030, 0) end, btn_width, btn_height )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " 12 ", function() reaper.MIDIEditor_LastFocused_OnCommand(40031, 0) end, btn_width, btn_height )
				
				cboc2 ( " 13 ", function() reaper.MIDIEditor_LastFocused_OnCommand(40032, 0) end, btn_width, btn_height )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " 14 ", function() reaper.MIDIEditor_LastFocused_OnCommand(40033, 0) end, btn_width, btn_height )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " 15 ", function() reaper.MIDIEditor_LastFocused_OnCommand(40034, 0) end, btn_width, btn_height )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " 16 ", function() reaper.MIDIEditor_LastFocused_OnCommand(40035, 0) end, btn_width, btn_height )
			end

		elseif selected_content == "View_Show_Content_Show" then
			reaper.ImGui_SeparatorText(ctx, "View: Show")
			
			cboc2 ( " Edit: Event properties ", function() reaper.MIDIEditor_LastFocused_OnCommand(40004, 0) end, 0, 25 )
			cboc2 ( " Filter: Show/hide filter window... ", function() reaper.MIDIEditor_LastFocused_OnCommand(40762, 0) end, 0, 25 )
			cboc2 ( " Quantize... ", function() reaper.MIDIEditor_LastFocused_OnCommand(40009, 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " View: Show all note rows ", function() reaper.MIDIEditor_LastFocused_OnCommand(40452, 0) end, 0, 25 )
			cboc2 ( " View: Show custom note row view ", function() reaper.MIDIEditor_LastFocused_OnCommand(40143, 0) end, 0, 25 )
			cboc2 ( " View: Piano Roll & Notation ", function() reaper.MIDIEditor_LastFocused_OnCommand(reaper.NamedCommandLookup("_S&M_ME_PIANO_CYCLACTION1"), 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			cboc2 ( " View: Show note names ", function() reaper.MIDIEditor_LastFocused_OnCommand(40045, 0) end, 0, 25 )
			cboc2 ( " View: Show velocity handles on notes ", function() reaper.MIDIEditor_LastFocused_OnCommand(40040, 0) end, 0, 25 )
			cboc2 ( " View: Show velocity numbers on notes ", function() reaper.MIDIEditor_LastFocused_OnCommand(40632, 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			cboc2 ( " View: Show events as rectangles (normal mode) ", function() reaper.MIDIEditor_LastFocused_OnCommand(40449, 0) end, 0, 25 )
			cboc2 ( " View: Show events as diamonds (drum mode) ", function() reaper.MIDIEditor_LastFocused_OnCommand(40450, 0) end, 0, 25 )
			cboc2 ( " View: Show events as triangles (drum mode) ", function() reaper.MIDIEditor_LastFocused_OnCommand(40448, 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
		elseif selected_content == "Set_Note_Transpose_Content_Show" then
			reaper.ImGui_SeparatorText(ctx, "Note Transpose")
			
			-- library_note_transpose_main
			local library_note_transpose_main = {
				key = "Note Transpose", default_open = true, children = {
					-- {spacing_vertical = "1"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					-- {spacing_vertical = "7"},
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},
					{spacing_vertical = "1"},
					{separator_horizontal = "2", separator_color = "#FFFF99" },
					{spacing_vertical = "7"},
					{key = "Humanize notes... ", action_id = "40457"},
					{key = "Transpose notes... ", action_id = "40759"},
					
					
					{spacing_vertical = "1"},
					{separator_horizontal = "2", separator_color = "#FFFF99" },
					{spacing_vertical = "7"},
					
					{key = "+ 12", action_function = function() TransposeSelectedNotes(12) end},
					{key = "+ 11", action_function = function() TransposeSelectedNotes(11) end},
					{key = "+ 10", action_function = function() TransposeSelectedNotes(10) end},
					{key = "+ 09", action_function = function() TransposeSelectedNotes(9) end},
					{key = "+ 08", action_function = function() TransposeSelectedNotes(8) end},
					{key = "+ 07", action_function = function() TransposeSelectedNotes(7) end},
					{key = "+ 06", action_function = function() TransposeSelectedNotes(6) end},
					{key = "+ 05", action_function = function() TransposeSelectedNotes(5) end},
					{key = "+ 04", action_function = function() TransposeSelectedNotes(4) end},
					{key = "+ 03", action_function = function() TransposeSelectedNotes(3) end},
					{key = "+ 02", action_function = function() TransposeSelectedNotes(2) end},
					{key = "+ 01", action_function = function() TransposeSelectedNotes(1) end},
					{spacing_vertical = "1"},
					{separator_horizontal = "2", separator_color = "#FFFF99" },
					{spacing_vertical = "7"},
			
					{key = "- 01", action_function = function() TransposeSelectedNotes(-1) end},
					{key = "- 02", action_function = function() TransposeSelectedNotes(-2) end},
					{key = "- 03", action_function = function() TransposeSelectedNotes(-3) end},
					{key = "- 04", action_function = function() TransposeSelectedNotes(-4) end},
					{key = "- 05", action_function = function() TransposeSelectedNotes(-5) end},
					{key = "- 06", action_function = function() TransposeSelectedNotes(-6) end},
					{key = "- 07", action_function = function() TransposeSelectedNotes(-7) end},
					{key = "- 08", action_function = function() TransposeSelectedNotes(-8) end},
					{key = "- 09", action_function = function() TransposeSelectedNotes(-9) end},
					{key = "- 10", action_function = function() TransposeSelectedNotes(-10) end},
					{key = "- 11", action_function = function() TransposeSelectedNotes(-11) end},
					{key = "- 12", action_function = function() TransposeSelectedNotes(-12) end},
					{spacing_vertical = "1"},
					{separator_horizontal = "2", separator_color = "#FFFF99" },
					{spacing_vertical = "7"},
					
					--[[
					{key = "User Functions", children = {
						{key = "Command ID 1", action_id = "41930"},
						{key = "Command ID 2", action_id = "_RS251990727759d3dff9cf84df740cd6a87ea0d169"},
						{key = "User Function 2", action_function = function() reaper.Main_OnCommand(40772, 0) end},
						{key = "User Function 3", action_function = function() us_fn1() end},
					}},
					]]--
				},
			}
			
			TreeNodeLibraryOutput (library_note_transpose_main, "Note Transpose")
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			
			
			
			if false then
			
			cboc2 ( " Humanize notes... ", function() reaper.MIDIEditor_LastFocused_OnCommand(40457, 0) end, 0, 25 )
			
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Transpose notes... ", function() reaper.MIDIEditor_LastFocused_OnCommand(40759, 0) end, 0, 25 )
			cboc2 ( " Edit: Move notes up one octave ", function() reaper.MIDIEditor_LastFocused_OnCommand(40179, 0) end, 0, 25 )
			cboc2 ( " Edit: Move notes down one octave ", function() reaper.MIDIEditor_LastFocused_OnCommand(40180, 0) end, 0, 25 )
			cboc2 ( " Edit: Move notes up one semitone ", function() reaper.MIDIEditor_LastFocused_OnCommand(40177, 0) end, 0, 25 )
			cboc2 ( " Edit: Move notes down one semitone ", function() reaper.MIDIEditor_LastFocused_OnCommand(40178, 0) end, 0, 25 )
			-- cboc2 ( " www ", function() reaper.MIDIEditor_LastFocused_OnCommand(40759, 0) end, 0, 25 )
			end
			
		elseif selected_content == "Set_Note_Select_Content_Show" then
			-- cboc2 ( " Select Notes Right Of Cursor ", function() SelectNotesFromCursor ("Right") end, 0, 25 )
			-- cboc2 ( " Select Notes Left Of Cursor ", function() SelectNotesFromCursor ("Left") end, 0, 25 )
			
			-- library_note_select
			local library_note_select = {
				key = "Note Select", default_open = true, children = {
					
					-- {spacing_vertical = "1"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					-- {spacing_vertical = "7"},
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},
					
					{spacing_vertical = "1"},
					{separator_horizontal = "3", separator_color = "#3F3F48" },
					{spacing_vertical = "7"},
					
					-- {spacing_vertical = "1"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					{spacing_vertical = "7"},
					
					{separator_horizontal = "ImGui_SeparatorText", separator_text = "Set Selected Note To Cursor"},
					{key = "Select Notes Right Of Cursor", action_function = function() SelectNotesFromCursor ("Right") end},
					{key = "Select Notes Left Of Cursor", action_function = function() SelectNotesFromCursor ("Left") end},
					{spacing_vertical = "10"},
					
					{separator_horizontal = "ImGui_SeparatorText", separator_text = "Set Selected Note To Cursor Within Distance"},
					{key = "Select Notes Left Of Cursor (1/4)", action_function = function() SelectNotesWithinDistance("Left", "1/4") end},
					{key = "Select Notes Left Of Cursor (1/2)", action_function = function() SelectNotesWithinDistance("Left", "1/2") end},
					{key = "Select Notes Left Of Cursor (1)", action_function = function() SelectNotesWithinDistance("Left", "1") end},
					{key = "Select Notes Left Of Cursor (2)", action_function = function() SelectNotesWithinDistance("Left", "2") end},
					{key = "Select Notes Left Of Cursor (3)", action_function = function() SelectNotesWithinDistance("Left", "3") end},
					{key = "Select Notes Left Of Cursor (4)", action_function = function() SelectNotesWithinDistance("Left", "4") end},
					{key = "Select Notes Left Of Cursor (6)", action_function = function() SelectNotesWithinDistance("Left", "6") end},
					{key = "Select Notes Left Of Cursor (8)", action_function = function() SelectNotesWithinDistance("Left", "8") end},
					{key = "Select Notes Left Of Cursor (12)", action_function = function() SelectNotesWithinDistance("Left", "12") end},
					{key = "Select Notes Left Of Cursor (16)", action_function = function() SelectNotesWithinDistance("Left", "16") end},
					{key = "Select Notes Left Of Cursor (32)", action_function = function() SelectNotesWithinDistance("Left", "32") end},
					{spacing_vertical = "10"},
					
					{key = "Select Notes Right Of Cursor (1/4)", action_function = function() SelectNotesWithinDistance("Right", "1/4") end},
					{key = "Select Notes Right Of Cursor (1/2)", action_function = function() SelectNotesWithinDistance("Right", "1/2") end},
					{key = "Select Notes Right Of Cursor (1)", action_function = function() SelectNotesWithinDistance("Right", "1") end},
					{key = "Select Notes Right Of Cursor (2)", action_function = function() SelectNotesWithinDistance("Right", "2") end},
					{key = "Select Notes Right Of Cursor (3)", action_function = function() SelectNotesWithinDistance("Right", "3") end},
					{key = "Select Notes Right Of Cursor (4)", action_function = function() SelectNotesWithinDistance("Right", "4") end},
					{key = "Select Notes Right Of Cursor (6)", action_function = function() SelectNotesWithinDistance("Right", "6") end},
					{key = "Select Notes Right Of Cursor (8)", action_function = function() SelectNotesWithinDistance("Right", "8") end},
					{key = "Select Notes Right Of Cursor (12)", action_function = function() SelectNotesWithinDistance("Right", "12") end},
					{key = "Select Notes Right Of Cursor (16)", action_function = function() SelectNotesWithinDistance("Right", "16") end},
					{key = "Select Notes Right Of Cursor (32)", action_function = function() SelectNotesWithinDistance("Right", "32") end},
					
					--[[
					{key = "User Functions", children = {
						{key = "Command ID 1", action_id = "41930"},
						{key = "Command ID 2", action_id = "_RS251990727759d3dff9cf84df740cd6a87ea0d169"},
						{key = "User Function 2", action_function = function() reaper.Main_OnCommand(40772, 0) end},
						{key = "User Function 3", action_function = function() us_fn1() end},
					}},
					]]--
				},
			}
			
			TreeNodeLibraryOutput (library_note_select)
			
		elseif selected_content == "Set_Note_Length_Content_Show" then
			reaper.ImGui_SeparatorText(ctx, "Edit: Set note length to")
			
			-- library_note_length_main
			local library_note_length_main = {
				key = "Note Length", default_open = true, children = {
					
					-- {spacing_vertical = "1"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					-- {spacing_vertical = "7"},
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},
					
					{spacing_vertical = "1"},
					{separator_horizontal = "2", separator_color = "#EBEBEB" },
					{spacing_vertical = "7"},
					{key = "1", action_id = "41637"},
					{key = "1/2", action_id = "41635"},
					{key = "1/4", action_id = "41632"},
					{key = "1/8", action_id = "41629"},
					{key = "1/16", action_id = "41626"},
					{key = "1/32", action_id = "41623"},
					{key = "1/64", action_id = "41620"},
					{key = "1/128", action_id = "41618"},
					{spacing_vertical = "1"},
					{separator_horizontal = "2", separator_color = "#EBEBEB" },
					{spacing_vertical = "7"},
					
					{key = "1/2T", action_id = "41634"},
					{key = "1/4T", action_id = "41631"},
					{key = "1/8T", action_id = "41628"},
					{key = "1/16T", action_id = "41625"},
					{key = "1/32T", action_id = "41622"},
					{spacing_vertical = "1"},
					{separator_horizontal = "2", separator_color = "#EBEBEB" },
					{spacing_vertical = "7"},
					
					{key = "1/2.", action_id = "41636"},
					{key = "1/4.", action_id = "41633"},
					{key = "1/8.", action_id = "41630"},
					{key = "1/16.", action_id = "41627"},
					{key = "1/32.", action_id = "41624"},
					{key = "1/64.", action_id = "41621"},
					{key = "1/128.", action_id = "41619"},
					{spacing_vertical = "1"},
					{separator_horizontal = "2", separator_color = "#EBEBEB" },
					{spacing_vertical = "7"},
					
					{key = "Set note lengths to grid size", action_id = "40633"},
					{key = "Set note length to double", action_id = "40773"},
					{key = "Set note length to half", action_id = "40774"},
					{spacing_vertical = "10"},

					{key = "Edit: Join notes", action_id = "40456"},
					{key = "Split notes on grid", action_id = "40641"},
					{key = "Set note ends to start of next note (legato)", action_id = "40405"},
					-- {spacing_vertical = "1"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					{spacing_vertical = "7"},
					
					{separator_horizontal = "ImGui_SeparatorText", separator_text = "Set Selected Note To Cursor"},
					{key = "Select Notes Right Of Cursor", action_function = function() SelectNotesFromCursor ("Right") end},
					{key = "Select Notes Left Of Cursor", action_function = function() SelectNotesFromCursor ("Left") end},
					{key = "Set Selected Note Start To Cursor", action_function = function() SetSelectedNotesStartToCursor(0) end},
					{key = "Set Selected Note Ends To Cursor", action_function = function() SetSelectedNoteEndsToCursor(0) end},
					{key = "Set Selected Note Ends To Cursor (Quantize)", action_function = function() SetSelectedNoteEndsToCursor(1) end},
					{spacing_vertical = "7"},
					
					{key = "Edit: Fit notes to time selection", action_id = "40754"},
					{key = "Select All Notes And Fit In Time Selection", action_function = function() 
						reaper.MIDIEditor_LastFocused_OnCommand(reaper.NamedCommandLookup(40746), 0) -- Edit: Select all notes in time selection
						reaper.MIDIEditor_LastFocused_OnCommand(reaper.NamedCommandLookup(40754), 0) -- Edit: Fit notes to time selection
					end},
					
					{spacing_vertical = "7"},
					{separator_horizontal = "ImGui_SeparatorText", separator_text = "Arpeggio"},
					{key = "Set Selected Note Start To Cursor (Arpeggio 30)", action_function = function() SetSelectedNotesStartToCursor(30) end},
					{key = "Set Selected Note Start To Cursor (Arpeggio 50)", action_function = function() SetSelectedNotesStartToCursor(50) end},
					{key = "Set Selected Note Start To Cursor (Arpeggio 70)", action_function = function() SetSelectedNotesStartToCursor(70) end},
					{key = "Set Selected Note Start To Cursor (Arpeggio 100)", action_function = function() SetSelectedNotesStartToCursor(100) end},
					{key = "Set Selected Note Start To Cursor (Arpeggio 150)", action_function = function() SetSelectedNotesStartToCursor(150) end},
					{key = "Set Selected Note Start To Cursor (Arpeggio 200)", action_function = function() SetSelectedNotesStartToCursor(200) end},
					{spacing_vertical = "30"},
					--[[
					{key = "User Functions", children = {
						{key = "Command ID 1", action_id = "41930"},
						{key = "Command ID 2", action_id = "_RS251990727759d3dff9cf84df740cd6a87ea0d169"},
						{key = "User Function 2", action_function = function() reaper.Main_OnCommand(40772, 0) end},
						{key = "User Function 3", action_function = function() us_fn1() end},
					}},
					]]--
				},
			}
			
			TreeNodeLibraryOutput (library_note_length_main)
			
			if false then
			cboc2 ( " 1 ", function() reaper.MIDIEditor_LastFocused_OnCommand(41637, 0) end, 60, 25 )
			cboc2 ( " 1/2T ", function() reaper.MIDIEditor_LastFocused_OnCommand(41634, 0) end, 60, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 1/2 ", function() reaper.MIDIEditor_LastFocused_OnCommand(41635, 0) end, 60, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 1/2. ", function() reaper.MIDIEditor_LastFocused_OnCommand(41636, 0) end, 60, 25 )
			
			cboc2 ( " 1/4T ", function() reaper.MIDIEditor_LastFocused_OnCommand(41631, 0) end, 60, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 1/4 ", function() reaper.MIDIEditor_LastFocused_OnCommand(41632, 0) end, 60, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 1/4. ", function() reaper.MIDIEditor_LastFocused_OnCommand(41633, 0) end, 60, 25 )
			
			cboc2 ( " 1/8T ", function() reaper.MIDIEditor_LastFocused_OnCommand(41628, 0) end, 60, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 1/8 ", function() reaper.MIDIEditor_LastFocused_OnCommand(41629, 0) end, 60, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 1/8. ", function() reaper.MIDIEditor_LastFocused_OnCommand(41630, 0) end, 60, 25 )
			
			cboc2 ( " 1/16T ", function() reaper.MIDIEditor_LastFocused_OnCommand(41625, 0) end, 60, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 1/16 ", function() reaper.MIDIEditor_LastFocused_OnCommand(41626, 0) end, 60, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 1/16. ", function() reaper.MIDIEditor_LastFocused_OnCommand(41627, 0) end, 60, 25 )
			
			cboc2 ( " 1/32T ", function() reaper.MIDIEditor_LastFocused_OnCommand(41622, 0) end, 60, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 1/32 ", function() reaper.MIDIEditor_LastFocused_OnCommand(41623, 0) end, 60, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 1/32. ", function() reaper.MIDIEditor_LastFocused_OnCommand(41624, 0) end, 60, 25 )
			
			cboc2 ( " 1/64 ", function() reaper.MIDIEditor_LastFocused_OnCommand(41620, 0) end, 60, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 1/64. ", function() reaper.MIDIEditor_LastFocused_OnCommand(41621, 0) end, 60, 25 )
			
			cboc2 ( " 1/128 ", function() reaper.MIDIEditor_LastFocused_OnCommand(41618, 0) end, 60, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 1/128. ", function() reaper.MIDIEditor_LastFocused_OnCommand(41619, 0) end, 60, 25 )
			
			
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Set note lengths to grid size ", function() reaper.MIDIEditor_LastFocused_OnCommand(40633, 0) end, 0, 25 )
			cboc2 ( " Set note length to double ", function() reaper.MIDIEditor_LastFocused_OnCommand(40773, 0) end, 0, 25 )
			cboc2 ( " Set note length to half ", function() reaper.MIDIEditor_LastFocused_OnCommand(40774, 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			cboc2 ( " Edit: Join notes ", function() reaper.MIDIEditor_LastFocused_OnCommand(40456, 0) end, 0, 25 )
			cboc2 ( " Split notes on grid ", function() reaper.MIDIEditor_LastFocused_OnCommand(40641, 0) end, 0, 25 )
			cboc2 ( " Set note ends to start of next note (legato) ", function() reaper.MIDIEditor_LastFocused_OnCommand(40405, 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			cboc2 ( " Set Selected Note Ends To Cursor (Quantize) ", function() SetSelectedNoteEndsToCursor(1) end, 0, 25 )
			cboc2 ( " Set Selected Note Ends To Cursor ", function() SetSelectedNoteEndsToCursor(0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			cboc2 ( " Set Selected Note Start To Cursor ", function() SetSelectedNotesStartToCursor(0) end, 0, 25 )
			cboc2 ( " Set Selected Note Start To Cursor (Arpeggio 30) ", function() SetSelectedNotesStartToCursor(30) end, 0, 25 )
			cboc2 ( " Set Selected Note Start To Cursor (Arpeggio 50) ", function() SetSelectedNotesStartToCursor(50) end, 0, 25 )
			cboc2 ( " Set Selected Note Start To Cursor (Arpeggio 70) ", function() SetSelectedNotesStartToCursor(70) end, 0, 25 )
			cboc2 ( " Set Selected Note Start To Cursor (Arpeggio 100) ", function() SetSelectedNotesStartToCursor(100) end, 0, 25 )
			cboc2 ( " Set Selected Note Start To Cursor (Arpeggio 150) ", function() SetSelectedNotesStartToCursor(150) end, 0, 25 )
			cboc2 ( " Set Selected Note Start To Cursor (Arpeggio 200) ", function() SetSelectedNotesStartToCursor(200) end, 0, 25 )
			end
			
		elseif selected_content == "Insert_Chord_Content_Show" then
			reaper.ImGui_SeparatorText(ctx, "Insert Chord")
			
			-- chords_library
			local chords_library = {
				key = "Chords Library", children = {
					{is_separator = true},
					{key = " ", children = {
						{key = " v1", value = "C4, E4, G4"},
						{key = " v2", value = "E4, G4, C5"},
						{key = " v3", value = "G4, C5, E5"},
						{key = " v4", value = "C3, G3, E4"},
						{key = " v5", value = "G3, E4, C5"},
						{key = " v6", value = "E4, C5, G5"},
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
						{key = "m", value = "C3, G3, D#4, G4"},
						{key = "m7", value = "C3, G3, A#3, D#4, G4"},
						{key = "m (6/9)", value = "C3, D#3, A3, D4, G4, C5"},
						{key = "m9 v1", value = "C3, A#3, D4, D#4, G4"},
						{key = "m9 v2", value = "C3, D#3, G3, A#3, D4, G4, A#4, D5, D#5, G5"},
						{key = "m (maj11)", value = "C3, D#3, G3, B3, D4, D#4, F4, G4, B4, D5, F5"},
						{key = "m (9b13)", value = "C3, G#3, A#3, D4, D#4, G4, A#4, C5, D5, D#5, G#5"},
					},},
					-- {is_separator = true}, chord_view label
				},
			}
			
			-- ####################################################
			-- ####################################################
			-- render_chords_library
			function render_chords_library(node, velocity, transpose, key_name_note)
				if node.is_separator then -- Если это разделитель, выводим его
					reaper.ImGui_Separator(ctx)
					return
				end
				
				if node.key then -- Если у узла есть key
					-- Для корневого узла (где key = "Chords Library") key_name не добавляем
					local node_key = (node.key == "Chords Library") and node.key or key_name_note .. "" .. node.key
					-- Создаём уникальный идентификатор для узла (например, через node.key)
					local node_id = node.key
					
					local flags = 0 -- Для корневого узла всегда развернут
					if node.key == "Chords Library" then
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
								insert_chord(node.value, velocity, transpose)
								
								-- Установить курсор в начало или конец ноты — Чтение состояния
								local CursorStartOrEnd = reaper.GetExtState("checkboxMoveEditCursor", "checkboxMoveEditCursor_value")
								local SelectUnselectAllNotes = reaper.GetExtState("checkboxSelectUnselectAllNotes", "checkboxSelectUnselectAllNotes_value")

								if CursorStartOrEnd == "true" then
									reaper.MIDIEditor_LastFocused_OnCommand(reaper.NamedCommandLookup(40639), 0) -- Navigate: Move edit cursor to end of selected events
								else
									reaper.MIDIEditor_LastFocused_OnCommand(reaper.NamedCommandLookup(40440), 0) -- Navigate: Move edit cursor to start of selected events
								end
								
								if SelectUnselectAllNotes == "true" then
									reaper.MIDIEditor_LastFocused_OnCommand(reaper.NamedCommandLookup(40214), 0) -- Edit: Unselect all
								end
								reaper.Undo_EndBlock("Insert Chord", -1)
								executeWithMidiFocus()
								-- print_rs ( node.value )
							end
						end
					end
				end
			end -- render_chords_library
				
			-- Парсер аккордов
			cboc2 ( " Get Notes To String ", function() print_rs ( get_selected_notes_to_str() ) end, 310, 30 )
			-- reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			-- cboc2 ( " Get Chords And Notes ", function() print_rs ( get_chords_and_notes_in_selection() ) end, 310, 30 )
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			-- Парсер аккордов
			
			-- Move edit cursor to end of selected events
			local checkbox_MoveEditCursor = reaper.GetExtState("checkboxMoveEditCursor", "checkboxMoveEditCursor_value") == "true"
			local checkbox_changed_1, checkbox_new_state_1 = reaper.ImGui_Checkbox(ctx, " Move edit cursor to end of selected events", checkbox_MoveEditCursor)
			if checkbox_changed_1 then
				checkbox_MoveEditCursor = checkbox_new_state_1
				reaper.SetExtState("checkboxMoveEditCursor", "checkboxMoveEditCursor_value", tostring(checkbox_MoveEditCursor), true)
			end
			-- Move edit cursor to end of selected events
			reaper.ImGui_Dummy(ctx, 0, 0)  -- Добавление вертикального пространства
			
			-- Select/Unselect all notes
			local checkbox_SelectUnselectAllNotes = reaper.GetExtState("checkboxSelectUnselectAllNotes", "checkboxSelectUnselectAllNotes_value") == "true"
			local checkbox_changed_2, checkbox_new_state_2 = reaper.ImGui_Checkbox(ctx, " Unselect all notes", checkbox_SelectUnselectAllNotes)
			if checkbox_changed_2 then
				checkbox_SelectUnselectAllNotes = checkbox_new_state_2
				reaper.SetExtState("checkboxSelectUnselectAllNotes", "checkboxSelectUnselectAllNotes_value", tostring(checkbox_SelectUnselectAllNotes), true)
			end
			-- Select/Unselect all notes
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			
			-- Выпадающий список ————————————————————————————————————————
			local slider_transpose_value = tonumber(reaper.GetExtState("NoteSliderTranspose_xA098kjVaw", "NoteSliderTransposeValue_xA098kjVaw")) or 0
			-- Ограничиваем значение в пределах -12 до 12
			if slider_transpose_value < -12 or slider_transpose_value > 12 then
				slider_transpose_value = 0 -- Устанавливаем значение по умолчанию
			end

			local note_names = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}
			local transpose_options = {}
			-- Формируем список: сначала положительные значения, затем 0, затем отрицательные
			for i = 12, 1, -1 do
				local note_index = (i % 12 + 12) % 12 + 1
				transpose_options[#transpose_options + 1] = string.format("+%d (%s)", i, note_names[note_index])
			end
			transpose_options[#transpose_options + 1] = "0 (C)" -- Добавляем ноль
			for i = -1, -12, -1 do
				local note_index = (i % 12 + 12) % 12 + 1
				transpose_options[#transpose_options + 1] = string.format("%d (%s)", i, note_names[note_index])
			end
			-- Преобразуем список в строку с разделением \0 и завершающим \0
			local combo_items = table.concat(transpose_options, "\0") .. "\0"
			-- Индекс для Combo. Чтобы 0 (C) было по умолчанию, устанавливаем индекс как 13
			local current_option_index = 12 - slider_transpose_value

			-- Рисуем интерфейс
			reaper.ImGui_Text(ctx, "      - Transpose -  ")

			-- Устанавливаем ширину для выпадающего списка (например, 200 пикселей)
			reaper.ImGui_SetNextItemWidth(ctx, 300)
			local changed, new_option_index = reaper.ImGui_Combo(ctx, "##NotesTransposeCombo", current_option_index, combo_items)

			if changed then
				-- Преобразуем индекс обратно в значение транспозиции
				if new_option_index == 12 then
					slider_transpose_value = 0 -- Если выбран 0
				elseif new_option_index <= 12 then
					slider_transpose_value = 12 - new_option_index -- Положительные значения (перерасчёт)
				else
					slider_transpose_value = -(new_option_index - 12) -- Отрицательные значения
				end
				-- Сохраняем новое значение в ExtState
				reaper.SetExtState("NoteSliderTranspose_xA098kjVaw", "NoteSliderTransposeValue_xA098kjVaw", tostring(slider_transpose_value), false)
			end
			-- Вычисляем имя ноты и значение транспозиции
			local note_index = (slider_transpose_value % 12 + 12) % 12 + 1
			local note_label_name = note_names[note_index]
			local note_label_index = slider_transpose_value == 0 and "0" or string.format("%+d", slider_transpose_value)
			-- Выводим текущую ноту
			reaper.ImGui_Text(ctx, "           " .. note_label_index .. " (" .. note_label_name .. ")") -- note_label_index -- note_label_name
			-- Выпадающий список ————————————————————————————————————————

			if reaper.ImGui_BeginTable(ctx, "Table_Transpose_Velocity", 2) then -- Создаём таблицу с 2 колонками
			
				-- Первый ряд
				reaper.ImGui_TableNextRow(ctx)
				reaper.ImGui_TableNextColumn(ctx)

				-- Transpose — Вертикальный слайдер
				local slider_transpose_value = tonumber(reaper.GetExtState("NoteSliderTranspose_xA098kjVaw", "NoteSliderTransposeValue_xA098kjVaw")) or 0
				local note_names = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}
				-- Индекс ноты
				local note_index = (slider_transpose_value % 12 + 12) % 12 + 1
				local note_label_name = note_names[note_index] -- имя ноты, например, "C" или "C#"
				reaper.SetExtState("NoteNameSliderTranspose_xA098kjVaw", "NoteNameSliderTransposeValue_xA098kjVaw", tostring(note_label_name), false)
				
				local note_label_index = slider_transpose_value == 0 and "0" or string.format("%+d", slider_transpose_value) -- значение транспозиции от "-12" до "+12"
				reaper.ImGui_Text(ctx, "      - Transpose -  ")
				local changed1, new_slider_transpose_value = reaper.ImGui_VSliderInt(ctx, "##NotesTranspose", 150, 100, slider_transpose_value, -12, 12)
				if changed1 then
					slider_transpose_value = new_slider_transpose_value
					reaper.SetExtState("NoteSliderTranspose_xA098kjVaw", "NoteSliderTransposeValue_xA098kjVaw", tostring(slider_transpose_value), false)
				else
					reaper.SetExtState("NoteSliderTranspose_xA098kjVaw", "NoteSliderTransposeValue_xA098kjVaw", tostring(slider_transpose_value), false)
				end
				reaper.ImGui_Text(ctx, "		   " .. note_label_index .. " (" .. note_label_name .. ")" ) -- note_label_name -- note_label_index
				-- Transpose — Вертикальный слайдер

				reaper.ImGui_TableNextColumn(ctx)
				-- Velocity — Вертикальный слайдер
				local slider_velocity_value = tonumber( reaper.GetExtState("ChordsSliderVelocity_qBAW58adRK", "ChordsSliderVelocityValue_qBAW58adRK") ) or 86  -- по умолчанию 86
				reaper.ImGui_Text(ctx, "        - Velocity -  ")
				local changed2, new_velocity_value = reaper.ImGui_VSliderInt(ctx, "##NotesVelocity", 150, 100, slider_velocity_value, 1, 127)
				if changed2 then
					slider_velocity_value = new_velocity_value
					reaper.SetExtState("ChordsSliderVelocity_qBAW58adRK", "ChordsSliderVelocityValue_qBAW58adRK", tostring(slider_velocity_value), false)  -- Сохраняем значение
				else
					reaper.SetExtState("ChordsSliderVelocity_qBAW58adRK", "ChordsSliderVelocityValue_qBAW58adRK", tostring(slider_velocity_value), false)  -- Сохраняем значение
				end
				-- Velocity — Вертикальный слайдер

			reaper.ImGui_EndTable(ctx) -- Завершаем таблицу
			end
			
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			note_label_name = reaper.GetExtState("NoteNameSliderTranspose_xA098kjVaw", "NoteNameSliderTransposeValue_xA098kjVaw")
			slider_velocity_value = reaper.GetExtState("ChordsSliderVelocity_qBAW58adRK", "ChordsSliderVelocityValue_qBAW58adRK")
			slider_transpose_value = reaper.GetExtState("NoteSliderTranspose_xA098kjVaw", "NoteSliderTransposeValue_xA098kjVaw")
			render_chords_library(chords_library, slider_velocity_value, slider_transpose_value, note_label_name)
		
		elseif selected_content == "Insert_Chord_Progressions_Content_Show" then
			reaper.ImGui_SeparatorText(ctx, "Insert Chord Progressions")
			
			-- chords_progressions_library
			local chords_progressions_library = {
				label = "Chords Progressions Library", children = {
					{label = "McCoy Tyner", chord_view = "nl=1/4, C2, G2 | nl=1/4, C3, F3, A#3, D#4 | nl=1/4, D3, G3, C4, F4 | nl=1/4, C3, F3, A#3, D#4, G4 | nl=1/4, D3, G3, C4, F4, A4 | nl=1/4, D#3, A3, D4, G4, C5 | nl=1/4, G3, C4, F4, A#4, D5 | nl=1/4, D#3, A3, D4, G4, C5"},
					{label = "1-6-2-5 - Donna Lee (Aebersold)", chord_view = "nl=1/2, C4, G4, B4, E5 | nl=1/2, C#4, G4, E5, A5 | nl=1/2, C4, F4, A4, E5, G5 | nl=1/2, B3, F4, G#4, A#4, E5 | nl=1/2, C4, E4, A4, C5, G5 | nl=1/2, G4, B4, F5, A#5 | nl=1/2, C4, F4, A4, E5, A5 | nl=1/2, B3, F4, A#4, D#5, G#5 | nl=1/2, C4, E4, A4, C5 | nl=1/2, C4, E4, A4, C5 | nl=1/2, C4, E4, F4, A4, G5 | nl=1/2, B3, F4, G#4, B4, E5 | nl=1/2, C4, E4, B4, D5, G5 | nl=1/2, C#4, G4, F5, C6 | nl=1/2, A3, C4, F4, A4, E5, A5 | nl=1/2, B3, F4, A#4, D#5, G#5 | nl=1/2, E4, A4, D5, G5 | nl=1/2, C#4, G4, F5, A5 | nl=1/2, C4, F4, A4, E5 | nl=1/2, B3, F4, G#4, B4, E5 | nl=1/2, E4, A4, C5, G5 | nl=1/2, A3, C#4, G4, B4, E5 | nl=1/2, D3, C4, D4, F4, A4, E5 | nl=1/2, B3, F4, G#4, B4, E5"},
					{label = "Cm9-Ab69-Ebmaj-D7", chord_view = "nl=1, C3, A#3, D4, D#4, G4 | nl=1, G#2, G#3, A#3, C4, D#4, F4, A#4 | nl=1, D#3, A#3, D4, D#4, G4 | nl=1, D3, A3, C4, E4, G4"},
					{label = "TST", chord_view = "nl=1/4, C3, E3, G3, C4 | nl=1/4, F2, F3, A3, C4 | nl=1/2, C3, E3, G3, C4 | nl=1/4, C3, G3, C4, E4 | nl=1/4, F3, A3, C4, F4 | nl=1/2, C3, G3, C4, E4 | nl=1/4, C3, C4, E4, G4 | nl=1/4, F3, C4, F4, A4 | nl=1/2, C3, C4, E4, G4 | nl=1/4, C3, G3, E4, C5 | nl=1/4, F3, A3, F4, C5 | nl=1/2, C3, G3, E4, C5 | nl=1/4, C3, C4, G4, E5 | nl=1/4, F3, C4, A4, F5 | nl=1/2, C3, C4, G4, E5 | nl=1/4, C3, E3, C4, G4 | nl=1/4, F2, F3, C4, A4 | nl=1/2, C3, E3, C4, G4"},
					{label = "Maj Chord", chord_view = "nl=1/2, G3, F#4, B4, D5 | nl=1/2, A#3, A4, D5, F5 | nl=1, D4, C#5, F#5, A5 | nl=1/2, G3, F#4, B4, D5 | nl=1/2, A#3, A4, D5, F5 | nl=1, D3, C#4, F#4, A4"},
					-- {is_separator = true},
					-- {label = "www", chord_view = "www"},
					-- {label = "www", children = {},},
				},
			}
			
			
			
			-- render_chords_progressions_library
			function render_chords_progressions_library(node, velocity, transpose)
				if node.is_separator then
					reaper.ImGui_Separator(ctx)
					return
				end
				
				if node.label then
					-- Для корневого узла, если label = "Chords Progressions"
					local node_label = node.label

					-- Создаём уникальный идентификатор для узла (например, через node.label)
					local node_id = node.label
					
					local flags2 = 0 -- Для корневого узла всегда развернут
					if node.label == "Chords Progressions Library" then
						-- Теперь корректно вызываем функцию для получения флага
						flags2 = reaper.ImGui_TreeNodeFlags_DefaultOpen()  -- Флаг для развернутого состояния
					end
				
					if node.children then
						-- Узел с потомками
						-- if reaper.ImGui_TreeNode(ctx, node.label) then
						if reaper.ImGui_TreeNodeEx(ctx, node_id, node_label, flags2) then -- развернутого состояния корневого узла
							for _, child in ipairs(node.children) do
								render_chords_progressions_library(child, velocity, transpose)
							end
							reaper.ImGui_TreePop(ctx)
						end
					else
						-- Листовой узел
						if reaper.ImGui_Selectable(ctx, node.label) then
						-- if reaper.ImGui_Selectable(ctx, node_label) then
							-- Если кликнули, выводим chord_view
							if node.chord_view then
								reaper.Undo_BeginBlock()
								insert_chord(node.chord_view, velocity, transpose)
								
								-- Установить курсор в начало или конец ноты — Чтение состояния
								local CursorStartOrEnd = reaper.GetExtState("checkboxMoveEditCursor", "checkboxMoveEditCursor_value")
								local SelectUnselectAllNotes = reaper.GetExtState("checkboxSelectUnselectAllNotes", "checkboxSelectUnselectAllNotes_value")
								
								if CursorStartOrEnd == "true" then
									reaper.MIDIEditor_LastFocused_OnCommand(reaper.NamedCommandLookup(40639), 0) -- Navigate: Move edit cursor to end of selected events
								else
									reaper.MIDIEditor_LastFocused_OnCommand(reaper.NamedCommandLookup(40440), 0) -- Navigate: Move edit cursor to start of selected events
								end
								
								if SelectUnselectAllNotes == "true" then
									reaper.MIDIEditor_LastFocused_OnCommand(reaper.NamedCommandLookup(40214), 0) -- Edit: Unselect all
								end
								reaper.Undo_EndBlock("Chords Progressions Library", -1)
								executeWithMidiFocus()
							end
						end
					end
				end
			end
			
			-- Парсер аккордов
			-- cboc2 ( " Get Notes To String ", function() print_rs ( get_selected_notes_to_str() ) end, 310, 30 )
			-- reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " Get Chords And Notes ", function() print_rs ( get_chords_and_notes_in_selection() ) end, 310, 30 )
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			-- Парсер аккордов
			
			-- Move edit cursor to end of selected events
			local checkbox_MoveEditCursor = reaper.GetExtState("checkboxMoveEditCursor", "checkboxMoveEditCursor_value") == "true"
			local checkbox_changed_1, checkbox_new_state_1 = reaper.ImGui_Checkbox(ctx, " Move edit cursor to end of selected events", checkbox_MoveEditCursor)
			if checkbox_changed_1 then
				checkbox_MoveEditCursor = checkbox_new_state_1
				reaper.SetExtState("checkboxMoveEditCursor", "checkboxMoveEditCursor_value", tostring(checkbox_MoveEditCursor), true)
			end
			-- Move edit cursor to end of selected events
			reaper.ImGui_Dummy(ctx, 0, 0)  -- Добавление вертикального пространства
			
			-- Select/Unselect all notes
			local checkbox_SelectUnselectAllNotes = reaper.GetExtState("checkboxSelectUnselectAllNotes", "checkboxSelectUnselectAllNotes_value") == "true"
			local checkbox_changed_2, checkbox_new_state_2 = reaper.ImGui_Checkbox(ctx, " Unselect all notes", checkbox_SelectUnselectAllNotes)
			if checkbox_changed_2 then
				checkbox_SelectUnselectAllNotes = checkbox_new_state_2
				reaper.SetExtState("checkboxSelectUnselectAllNotes", "checkboxSelectUnselectAllNotes_value", tostring(checkbox_SelectUnselectAllNotes), true)
			end
			-- Select/Unselect all notes
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			
			-- Слайдер Velocity от 1 до 127 с сохранением во временное хранилище
			local slider_velocity_value = tonumber(reaper.GetExtState("chords_slider_velocity_value", "slider_velocity_value")) or 86  -- Значение по умолчанию 86
			local changed_velocity, new_velocity_value = reaper.ImGui_SliderInt(ctx, 'Velocity', slider_velocity_value, 1, 127)
			if changed_velocity then
				slider_velocity_value = new_velocity_value
				reaper.SetExtState("chords_slider_velocity_value", "slider_velocity_value", tostring(slider_velocity_value), false)  -- Сохраняем значение
			else
				reaper.SetExtState("chords_slider_velocity_value", "slider_velocity_value", tostring(slider_velocity_value), false)  -- Сохраняем значение
			end
			local stored_velocity_value = reaper.GetExtState("chords_slider_velocity_value", "slider_velocity_value")
			local velocity_value = stored_velocity_value
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			-- Слайдер от 1 до 127 с сохранением во временное хранилище
			
			-- Слайдер Transpose от -12 до +12 с сохранением во временное хранилище
			local slider_transpose_value = tonumber(reaper.GetExtState("chords_slider_transpose_value", "slider_transpose_value")) or 0  -- Значение по умолчанию 86
			local changed_transpose, new_transpose_value = reaper.ImGui_SliderInt(ctx, 'Transpose', slider_transpose_value, -12, 12)
			if changed_transpose then
				slider_transpose_value = new_transpose_value
				reaper.SetExtState("chords_slider_transpose_value", "slider_transpose_value", tostring(slider_transpose_value), false)  -- Сохраняем значение
			else
				reaper.SetExtState("chords_slider_transpose_value", "slider_transpose_value", tostring(slider_transpose_value), false)  -- Сохраняем значение
			end
			local stored_transpose_value = reaper.GetExtState("chords_slider_transpose_value", "slider_transpose_value")
			local transpose_key = stored_transpose_value
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			-- Слайдер от 1 до 127 с сохранением во временное хранилище
			
			render_chords_progressions_library(chords_progressions_library, velocity_value, transpose_key)
			
		elseif selected_content == "Set_Note_Velocity_Content_Show" then
			reaper.ImGui_SeparatorText(ctx, "Set Selected Notes Velocity")
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			
			-- Слайдер Velocity от 1 до 127 с сохранением во временное хранилище
			local slider_velocity_value = tonumber(reaper.GetExtState("slider_velocity_zJkDiwhuOp", "slider_velocity_value_zJkDiwhuOp")) or 86  -- Значение по умолчанию 86
			local changed_velocity, new_velocity_value = reaper.ImGui_SliderInt(ctx, 'Velocity', slider_velocity_value, 1, 127)
			if changed_velocity then
				slider_velocity_value = new_velocity_value
				reaper.SetExtState("slider_velocity_zJkDiwhuOp", "slider_velocity_value_zJkDiwhuOp", tostring(slider_velocity_value), false)  -- Сохраняем значение
				set_selected_notes_velocity(slider_velocity_value)
			else
				reaper.SetExtState("slider_velocity_zJkDiwhuOp", "slider_velocity_value_zJkDiwhuOp", tostring(slider_velocity_value), false)  -- Сохраняем значение
			end
			local stored_velocity_value = reaper.GetExtState("slider_velocity_zJkDiwhuOp", "slider_velocity_value_zJkDiwhuOp")
			local velocity_value = stored_velocity_value
			reaper.ImGui_Dummy(ctx, 0, 15)  -- Добавление вертикального пространства
			-- Слайдер от 1 до 127 с сохранением во временное хранилище
			
			cboc2 ( " 10 ", function() set_selected_notes_velocity(10) end, 40, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 20 ", function() set_selected_notes_velocity(20) end, 40, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 30 ", function() set_selected_notes_velocity(30) end, 40, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 40 ", function() set_selected_notes_velocity(40) end, 40, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 50 ", function() set_selected_notes_velocity(50) end, 40, 25 )
			
			cboc2 ( " 60 ", function() set_selected_notes_velocity(60) end, 40, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 70 ", function() set_selected_notes_velocity(70) end, 40, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 80 ", function() set_selected_notes_velocity(80) end, 40, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 90 ", function() set_selected_notes_velocity(90) end, 40, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 100 ", function() set_selected_notes_velocity(100) end, 40, 25 )
			
			cboc2 ( " 110 ", function() set_selected_notes_velocity(110) end, 40, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 120 ", function() set_selected_notes_velocity(120) end, 40, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " 127 ", function() set_selected_notes_velocity(127) end, 40, 25 )
			reaper.ImGui_Dummy(ctx, 0, 30)  -- Добавление вертикального пространства
			
		elseif selected_content == "Set_Midi_Editor_Size_Content_Show" then
			
			local library_set_midi_editor_size = {
				key = "Set Midi Editor Size", default_open = true, children = {
					
					{separator_horizontal = "ImGui_SeparatorText", separator_text = "Midi Editor Size"},
					{key = "1300 - 974", action_function = function() SetMidiEditorSize(621, 76, 1300, 974)	end},
					{key = "1490 - 974", action_function = function() 	SetMidiEditorSize(431, 76, 1490, 974)end},
					
					{spacing_vertical = "10"},
					{separator_horizontal = "ImGui_SeparatorText", separator_text = "Set CC lanes' height"},
					{key = "0 pixel", action_id = "_BR_ME_SET_CC_LANES_HEIGHT_0"}, -- SWS/BR: Set all CC lanes' height to 0 pixel
					{key = "200 pixel", action_id = "_BR_ME_SET_CC_LANES_HEIGHT_200"}, -- SWS/BR: Set all CC lanes' height to 200 pixel
					
					{spacing_vertical = "10"},
					{separator_horizontal = "ImGui_SeparatorText", separator_text = "Set CC lane"},
					{key = "CC: Set CC lane to Velocity", action_id = "40237"},
					{key = "CC: Set CC lane to 011 Expression MSB", action_id = "40249"},
					{key = "CC: Set CC lane to 064 Hold Pedal (on/off)", action_id = "40302"},
					--[[
					{key = "User Functions", children = {
						{key = "Command ID 1", action_id = "41930"},
						{key = "Command ID 2", action_id = "_RS251990727759d3dff9cf84df740cd6a87ea0d169"},
						{key = "User Function 2", action_function = function() reaper.Main_OnCommand(40772, 0) end},
						{key = "User Function 3", action_function = function() us_fn1() end},
						reaper.MIDIEditor_LastFocused_OnCommand(reaper.NamedCommandLookup("_BR_ME_SET_CC_LANES_HEIGHT_0"), 0)
						
						{spacing_vertical = "30"},
						{separator_horizontal = "2", separator_color = "#EBEBEB" },
						{separator_horizontal = "ImGui_SeparatorText", separator_text = "Arpeggio"},
						
					}},
					]]--
				},
			}
			
			TreeNodeLibraryOutput (library_set_midi_editor_size)
			
		elseif selected_content == "Alpha_Window_ImGui_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Alpha Window ImGui" )
			local changed, new_alpha = reaper.ImGui_DragDouble(ctx, ' ', alpha_window_ImGui, 0.01, 0.0, 1.0, '%.2f')
			if changed then
				alpha_window_ImGui = new_alpha
				-- Сохраняем состояние
				reaper.SetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiAlphaWindowMidiEditor", tostring(alpha_window_ImGui), true)
			end
		else
			reaper.ImGui_Text(ctx, 'Select a menu item to see the content.')
		end
		-- ##################################################
		-- ##################################################
		reaper.ImGui_End(ctx)
	end
	-- visible
	
	reaper.ImGui_PopFont (ctx)
	if open then
		reaper.defer(main)
	end
end

reaper.defer(main)
end
-- #######################################
-- #######################################
reaper.PreventUIRefresh(-1);
reaper.TrackList_AdjustWindows(0)  -- Updates the window view
reaper.UpdateArrange();  -- Updates the window view
-- #######################################
-- #######################################