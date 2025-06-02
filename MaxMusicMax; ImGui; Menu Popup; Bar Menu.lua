--@description ImGui; Menu Popup; Bar Menu
--@version 1.0
--@author MaxMusicMax
-- https://forum.cockos.com/showthread.php?p=2059855
-- https://github.com/cfillion/reaimgui/releases
-- #######################################
-- #######################################
-- =======================
-- 11111111111111111111111111111111111
-- menu_structure___
-- library_name_track_item
-- insert_empty_item_chord_library
-- insert_item_chord_library
-- library_grid_main
-- library_spectrogram_main
-- library_timebase_main
-- library_transport_main
-- render_chords_library
-- library_frequent_fx
-- library_insert_midi_program_change
-- library_stretch_marker
-- item_navigation_content_show

-- print_rs
-- console_window_destroy
-- printTable
-- printValue
-- Add_FX
-- HexToColor
-- RunCommandList
-- GetSampleAmplitudeAtEditCursor
-- getChordType
-- get_playing_midi
-- get_name_note_current
-- insert_midi_chord
-- fnc_transpose_value
-- fnc_note_item_length
-- MoveMutedItemsToNewTrack
-- DeleteTakeMarkersSelectItemOrTimeSelection
-- TreeNodeLibraryOutput
-- GetTimeSelectionFormatted
-- GetMouseTimeStartZero
-- GetMouseTimeStartMinus
-- GetEditCursorPositionTimeStartZero
-- GetEditCursorPositionTimeStartMinus
-- SetTakeMarkerAtEditCursor
-- SetSelectedTrackItemName
-- SelectItemsRelativeCursor
-- changeItemRate___
-- ItemReNameEmptyLine
-- InsertEmptyItemWithNameAndColor
-- CreateRegionFromSelectedItem
-- ZoomArrangeToItems
-- SetAllTracksAndEnvelopesHeight
-- SetTopTrackHeight
-- changeItemRateReset
-- changePitchForSelectedItems
-- SelectNearestEnvelopePointsAroundCursor
-- handleRateChange
-- handlePitchChange
-- changeVolumeForSelectedItems
-- handleVolumeChange
-- changeSelectedEnvelopePoints
-- EnableMidiModeOnTheTrack
-- SetGetSelectedTrackID
-- SetGetSelectedItemID
-- DeleteItemsAtEditCursorSelectLeft -- SplitSelectItemsOfEditCursor_Content_Show
-- DeleteItemsAtEditCursorSelectRight -- SplitSelectItemsOfEditCursor_Content_Show
-- DeleteItemsAtTimeSelection -- SplitSelectItemsOfEditCursor_Content_Show
-- move_cursor_to_next_position
-- move_cursor_to_previous_position
-- move_cursor_on_selected_track
-- move_cursor_on_selected_track_reverse
-- moveItemTopBottomTrack
-- DeleteUnselectedItemsOnTrack
-- CreateFolderTrackAndMoveSelectedTracks
-- CreateTrackRelativeToSelected
-- InvertItemSelection
-- delete_or_keep_cc
-- InsertMidiProgramChange
-- DeleteProgramChangeAtCursor
-- InsertMidiInsertCC
-- InsertTempoMarkerUserInputs
-- DetectAndMarkSibilance
-- CreateOrRemoveRegionFromTimeSelection
-- SelectItemsInTimeSelection
-- SetTimeSelectionToRegionAtPlayCursor
-- CreateRadioButtonGroup
-- InsertNewTrackAndAddFX
-- calculateDelayJoinOptions
-- calculateDelay
-- SetSelectedItemToPresetColor
-- DrawColorBoxPresetColor
-- ToggleBypassFXPluginsOnSelectedTrack
-- cboc2 / create_button_one_click2
-- CreateCommandCheckbox
-- HexToImGuiColor
-- HexToBGR
-- RGBToBGR
-- BGRToRGB
-- TrackAndItemColorChanger
-- GetDurationBetweenLocatorsGivenPlayrate
-- GetExactDurationBetweenLocatorsGivenPlayrate
-- CreateProjectMarkerPositionColor
-- DeleteMarkersInTimeSelection
-- GetMarkerPositionByName
-- GetDurationBetweenMarkersGivenPlayrate
-- GetExactDurationBetweenMarkersGivenPlayrate
-- SetTimeSelectionByMarkers
-- formatMilliseconds
-- EditCursorPositionHoursMinutesSecondsMilliseconds
-- GetMasterTrackPlayrate
-- ShowPlayrateInfo
-- ShowMenuItems
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
local ctx = reaper.ImGui_CreateContext('ImGui; Menu Popup; Bar Menu')
-- ##################################################
-- ##################################################
-- Add_FX
local show_fx = false -- Показывать/Не показывать плагин при добавлении -- true/false
local add_fx_to_item = true -- Добавлять FX к элементам -- true/false
local add_fx_to_track = true -- Добавлять FX к трекам -- true/false
local add_fx_to_master_track = true -- Добавлять FX к мастер треку -- true/false

-- Функция для добавления FX
function Add_FX(name, preset_name, plugin_state)
    local fxfloat = reaper.SNM_GetIntConfigVar('fxfloat_focus', 0)
    local change_setting = false
    if fxfloat & 4 == 4 then
        local fxfloat2 = fxfloat & ~(fxfloat & 4)
        reaper.SNM_SetIntConfigVar('fxfloat_focus', fxfloat2)
        change_setting = true
    end

    reaper.PreventUIRefresh(1)

    local cursor = reaper.GetCursorContext2(true)
    local master = reaper.GetMasterTrack(0)
    local add_to_master = false
    local insert_string = ""

    if add_fx_to_master_track then
        if (add_fx_to_item == false and add_fx_to_track == true and reaper.IsTrackSelected(master) == true)
            or (add_fx_to_item == true and add_fx_to_track == true and cursor == 0 and reaper.IsTrackSelected(master) == true)
        then
            local fx_index = reaper.TrackFX_AddByName(master, name, false, -1)
            if fx_index ~= -1 then
                add_to_master = true
                if preset_name then
                    reaper.TrackFX_SetPreset(master, fx_index, preset_name)
                end
                if show_fx and reaper.TrackFX_GetOffline(master, fx_index) == false
                    and reaper.CountSelectedTracks(0) == 0 then
                    reaper.TrackFX_Show(master, fx_index, 3)
                end
            end
            insert_string = "to master track"
        end
    end

    if (add_fx_to_item == false and add_fx_to_track == true)
        or (add_fx_to_item == true and add_fx_to_track == true and cursor == 0)
    then
        if reaper.CountSelectedTracks(0) > 0 then
            for i = 0, reaper.CountSelectedTracks(0) - 1 do
                local track = reaper.GetSelectedTrack(0, i)
                local fx_index = reaper.TrackFX_AddByName(track, name, false, -1)
                if fx_index ~= -1 then
                    if preset_name then
                        reaper.TrackFX_SetPreset(track, fx_index, preset_name)
                    end
				
				plugin_state = plugin_state or 1
				if plugin_state == 1 then
					reaper.TrackFX_SetEnabled(track, fx_index, true) -- Включаем или выключаем bypass
				else
					reaper.TrackFX_SetEnabled(track, fx_index, false) -- Включаем или выключаем bypass
				end
				
                    if show_fx and reaper.CountSelectedTracks(0) == 1
                        and reaper.TrackFX_GetOffline(track, fx_index) == false
                        and add_to_master == false
                    then
                        reaper.TrackFX_Show(track, fx_index, 3)
                    end
                end
            end
            insert_string = "to selected tracks"
        end
    elseif (add_fx_to_track == false and add_fx_to_item == true)
        or (add_fx_to_track == true and add_fx_to_item == true and cursor == 1)
    then
        if reaper.CountSelectedMediaItems(0) > 0 then
            for i = 0, reaper.CountSelectedMediaItems(0) - 1 do
                local item = reaper.GetSelectedMediaItem(0, i)
                local take = reaper.GetActiveTake(item)
                local fx_index = reaper.TakeFX_AddByName(take, name, -1)
                if fx_index ~= -1 then
                    if preset_name then
                        reaper.TakeFX_SetPreset(take, fx_index, preset_name)
                    end
                    if show_fx and reaper.CountSelectedMediaItems(0) == 1
                        and reaper.TakeFX_GetOffline(take, fx_index) == false then
                        reaper.TakeFX_Show(take, fx_index, 3)
                    end
                end
            end
            insert_string = "to selected items"
        end
    end

    if change_setting == true then
        reaper.SNM_SetIntConfigVar('fxfloat_focus', fxfloat)
    end

    reaper.PreventUIRefresh(-1)
end
-- Функция для добавления FX
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
-- RunCommandList
function RunCommandList(commandList)
	-- Разделяем строку на отдельные команды
	for cmd in string.gmatch(commandList, "[^,]+") do
		cmd = cmd:match("^%s*(.-)%s*$") -- Убираем пробелы в начале и конце

		if cmd:match("^_RS") then
			-- Если команда имеет префикс _RS
			local commandId = reaper.NamedCommandLookup(cmd)
			if commandId and commandId > 0 then
				reaper.Main_OnCommand(commandId, 0)
			else
				reaper.ShowConsoleMsg("Команда " .. cmd .. " не найдена\n")
			end
		else
			-- Если команда числовая
			local commandId = tonumber(cmd)
			if commandId then
				reaper.Main_OnCommand(commandId, 0)
			else
				reaper.ShowConsoleMsg("Некорректная команда: " .. cmd .. "\n")
			end
		end
	end
end
-- ##################################################
-- ##################################################
-- GetSampleAmplitudeAtEditCursor
function GetSampleAmplitudeAtEditCursor()
	local item = reaper.GetSelectedMediaItem(0, 0)
	if not item then return end

	local take = reaper.GetActiveTake(item)
	if not take or reaper.TakeIsMIDI(take) then return end

	local source = reaper.GetMediaItemTake_Source(take)
	local samplerate = reaper.GetMediaSourceSampleRate(source)
	if not samplerate or samplerate == 0 then return end

	local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
	local edit_cursor = reaper.GetCursorPosition()

	if edit_cursor < item_start then return end

	local accessor = reaper.CreateTakeAudioAccessor(take)
	local nch = reaper.GetMediaSourceNumChannels(source)

	local buf = reaper.new_array(nch)
	reaper.GetAudioAccessorSamples(accessor, samplerate, nch, edit_cursor - item_start, 1, buf)
	reaper.DestroyAudioAccessor(accessor)

	local amplitude = buf[1] -- левый канал
	return string.format("%.7f", amplitude)
end
-- ##################################################
-- ##################################################
-- getChordType
function getChordType(notes_str, set_of_steps)
-- function getChordType(notes_str)
	-- Если передано nil или пустая строка, значит, нет активных нот
	-- function getChordType(notes_str)
	-- Если передано nil или пустая строка, значит, нет активных нот
	if not notes_str or notes_str == "" then
		return "" -- Select the desired track and start playback
	end
	
	local tonality = { "C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B" }
	
	-- Список известных аккордов (шаблоны интервалов)
	local chordDatabase = {
		-- Major
		["0,4,7"] = "",
		["0,4,7,11"] = "maj7", -- Fø Ao B
		["0,2,4,7,11"] = "maj9",
		["0,2,4,7,9,11"] = "maj(6/9)",
		["0,4,7,9"] = "6",
		
		["0,4,7,10"] = "7",
		["0,4,9,10"] = "7(6)",
		["0,4,7,9,10"] = "7(6)",
		["0,2,4,7,9,10"] = "7(6/9)",
		["0,3,4,8,10"] = "7(#9b13)",
		["0,1,3,4,8,10"] = "7(b9#9b13)",
		["0,1,4,9,10"] = "7(6b9)",
		["0,1,4,7,10"] = "7(b9)",
		["0,2,4,7,10"] = "7(9)",
		["0,2,4,10"] = "7(9)",
		["0,3,4,10"] = "7(#9)",
		["0,2,5,7,9,10"] = "7(9,11,13)",
		["0,2,4,6,7,9,10"] = "7(13#11)",
		
		-- Minor
		["0,3,7"] = "m",
		["0,3,7,10"] = "m7",
		["0,3,6,10"] = "m7b5",
		["0,3,7,9"] = "m6",
		["0,2,3,7,9"] = "m6/9",
		
		-- Увеличенный
		["0,4,8"] = "+", -- Augmented (aug)
		
		-- Sus аккорды
		["0,3,5,10"] = "7sus4", -- Suspended 4th 
		["0,5,7"] = "sus4", -- Suspended 4th 
		["0,2,7"] = "sus2", -- Suspended 2nd 
		
		-- Полностью уменьшённый септаккорд (dim7)
		["0,3,6"] = "o", -- (dim)
		["0,3,6,9"] = "o", -- (dim7)
	}

	local notes = {}
	for num in notes_str:gmatch("%d+") do
		table.insert(notes, tonumber(num))
	end

	if #notes == 0 then
		return "" -- Select the desired track and start playback
	end

	table.sort(notes)
	
	for i = 1, #notes do
		local root = notes[i]
		local intervals = {}

		for j = 1, #notes do
			table.insert(intervals, (notes[j] - root) % 12)
		end

		local uniqueIntervals = {}
		local seen = {}
		for _, v in ipairs(intervals) do
			if not seen[v] then
				table.insert(uniqueIntervals, v)
				seen[v] = true
			end
		end
		
		table.sort(uniqueIntervals)
		local key = table.concat(uniqueIntervals, ",")
		
		-- Если запрошены интервалы, возвращаем их
		if set_of_steps then
			return key
		end
		
		-- Вывод аккорда
		if chordDatabase[key] then
			return tonality[root % 12 + 1] .. "" .. chordDatabase[key]
		end
	end

	return "Unknown"
end
-- getChordType
-- ##################################################
-- ##################################################
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
-- ##################################################
-- ##################################################
function get_name_note_current()
	-- Индекс ноты
	local note_names2 = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}
	local transpose_value = tonumber(reaper.GetExtState("insert_item_chord_ulaYkZjtGm", "transpose_value_ulaYkZjtGm")) or 0
	local note_index2 = (transpose_value % 12 + 12) % 12 + 1
	local note_label_name2 = note_names2[note_index2] -- имя ноты, например, "C" или "C#"
	return note_label_name2
end
-- ##################################################
-- ##################################################
-- insert_midi_chord
function insert_midi_chord(note_length, chord_str, transpose, velocity, item_name)
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
	reaper.SetExtState("insert_item_chord_ulaYkZjtGm", "transpose_value_ulaYkZjtGm", tostring(tr_value), false)
	-- checkbox_MoveEditCursor = reaper.GetExtState("insert_item_chord_ulaYkZjtGm", "transpose_value_ulaYkZjtGm")
	-- print_rs (checkbox_MoveEditCursor)
end
-- ##################################################
-- ##################################################
-- fnc_note_item_length
function fnc_note_item_length (note_item_length)
	reaper.SetExtState("insert_item_chord_ulaYkZjtGm", "note_item_length_value_ulaYkZjtGm", tostring(note_item_length), false)
	-- checkbox_MoveEditCursor = reaper.GetExtState("insert_item_chord_ulaYkZjtGm", "note_item_length_value_ulaYkZjtGm")
	-- print_rs (note_item_length)
end
-- ##################################################
-- ##################################################
-- MoveMutedItemsToNewTrack
function MoveMutedItemsToNewTrack()
	-- Получаем активный проект
	local proj = 0

	-- Получаем первый выделенный трек
	local sel_track = reaper.GetSelectedTrack(proj, 0)
	if not sel_track then return end

	-- Получаем индекс выделенного трека
	local track_idx = reaper.GetMediaTrackInfo_Value(sel_track, "IP_TRACKNUMBER")

	-- Вставляем новый трек под выделенным
	reaper.InsertTrackAtIndex(track_idx, true)
	local new_track = reaper.GetTrack(proj, track_idx)

	-- Начинаем групповую операцию
	reaper.Undo_BeginBlock()

	-- Перебираем все айтемы на выделенном треке
	local i = reaper.CountTrackMediaItems(sel_track) - 1
	while i >= 0 do
		local item = reaper.GetTrackMediaItem(sel_track, i)
		local is_muted = reaper.GetMediaItemInfo_Value(item, "B_MUTE")

		if is_muted == 1 then
			-- Удаляем айтем с исходного трека
			reaper.MoveMediaItemToTrack(item, new_track)
		end

		i = i - 1
	end

	-- Обновляем проект и завершаем операцию
	reaper.UpdateArrange()
	reaper.Undo_EndBlock("Перемещение замьютированных айтемов на новый трек", -1)
end
-- ##################################################
-- ##################################################
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
-- ##################################################
-- ##################################################
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
-- ##################################################
-- ##################################################
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
-- ##################################################
-- ##################################################
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
-- ##################################################
-- ##################################################
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
-- ##################################################
-- ##################################################
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
-- ##################################################
-- ##################################################
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
-- ##################################################
-- ##################################################
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
-- ##################################################
-- ##################################################
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
-- ##################################################
-- ##################################################
-- SetSelectedTrackItemName
-- Функция для задания имени выделенному треку
function SetSelectedTrackItemName(name, mode)
	if mode == "item" then
		-- Переименование выбранных айтемов
		local itemCount = reaper.CountSelectedMediaItems(0)
		if itemCount > 0 then
			for i = 0, itemCount - 1 do
				local item = reaper.GetSelectedMediaItem(0, i)
				local take = reaper.GetActiveTake(item)
				if take then
					reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", name, true)
				end
			end
		else
			-- reaper.ShowMessageBox("Айтем не выбран!", "Ошибка", 0)
			reaper.ClearConsole()
			print_rs ("Айтем не выбран!")
		end
	end
	if mode == "track" then
		-- Переименование выбранных треков
		local trackCount = reaper.CountSelectedTracks(0)
		if trackCount > 0 then
			for i = 0, trackCount - 1 do
				local track = reaper.GetSelectedTrack(0, i)
				reaper.GetSetMediaTrackInfo_String(track, "P_NAME", name, true)
			end
		else
			-- reaper.ShowMessageBox("Трек не выбран!", "Ошибка", 0)
			reaper.ClearConsole()
			print_rs ("Трек не выбран!")
		end
	end
	if mode == "empty_item" then
		-- Установка текста в Empty item
		local itemCount = reaper.CountSelectedMediaItems(0)
		if itemCount > 0 then
			for i = 0, itemCount - 1 do
				local item = reaper.GetSelectedMediaItem(0, i)
				if item then
					reaper.ULT_SetMediaItemNote(item, name)
				end
			end
			reaper.UpdateArrange()
		else
			reaper.ClearConsole()
			print_rs("Empty item не выбран!")
		end
	end
end
-- ##################################################
-- ##################################################
-- SelectItemsRelativeCursor
function SelectItemsRelativeCursor(direction)
	reaper.Main_OnCommand(reaper.NamedCommandLookup("40289"), 0) -- Item: Unselect (clear selection of) all items
    -- Получаем текущее положение курсора в проекте
    local cursorPos = reaper.GetCursorPosition()

    -- Получаем количество треков в проекте
    local numTracks = reaper.CountTracks(0)

    -- Перебираем все треки
    for i = 0, numTracks - 1 do
        local track = reaper.GetTrack(0, i) -- Получаем трек по индексу
        
        -- Перебираем все айтемы на текущем треке
        local numItems = reaper.CountTrackMediaItems(track)
        for j = 0, numItems - 1 do
            local item = reaper.GetTrackMediaItem(track, j) -- Получаем айтем по индексу
            
            -- Получаем позиции начала и конца айтема
            local itemStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
            local itemEnd = itemStart + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
            
            -- Выбираем айтемы в зависимости от направления
            if direction == "Right" then
                -- Выбираем айтемы справа от курсора
                if itemStart >= cursorPos then
                    reaper.SetMediaItemSelected(item, true)
                elseif itemEnd > cursorPos then
                    reaper.SetMediaItemSelected(item, true)
                end
            elseif direction == "Left" then
                -- Выбираем айтемы слева от курсора
               if itemStart <= cursorPos then
                    reaper.SetMediaItemSelected(item, true)
                elseif itemEnd < cursorPos then
                    reaper.SetMediaItemSelected(item, true)
                end
            end
        end
    end

    -- Обновляем отображение
    reaper.UpdateArrange()
end
-- ##################################################
-- ##################################################
-- changeItemRate___
function changeItemRate(rate_change)
  -- Получить активный проект
  project = 0
  -- Получить количество выделенных items
  num_items = reaper.CountSelectedMediaItems(project)
  -- Проверить, есть ли выделенные items
  if num_items > 0 then
    -- Перебрать все выделенные items
    for i = 0, num_items - 1 do
      -- Получить текущий item
      item = reaper.GetSelectedMediaItem(project, i)
      -- Получить take из item
      take = reaper.GetActiveTake(item)
      -- Проверить, существует ли take
      if take ~= nil then
        -- Получить текущий rate
        current_rate = reaper.GetMediaItemTakeInfo_Value(take, "D_PLAYRATE")
        -- Увеличить rate на заданное значение
        new_rate = current_rate + rate_change
        -- Установить новый rate для take
        reaper.SetMediaItemTakeInfo_Value(take, "D_PLAYRATE", new_rate)
        -- Обновить item в проекте
        reaper.UpdateItemInProject(item)
      else
        -- reaper.ShowMessageBox("Один из выделенных items не содержит take", "Ошибка", 0)
		print_rs ("Один из выделенных items не содержит take")
      end
    end
  else
    -- reaper.ShowMessageBox("Нет выделенных items", "Ошибка", 0)
	-- print_rs ("Нет выделенных items")
  end
end
-- ##################################################
-- ##################################################
-- ItemReNameEmptyLine
function ItemReNameEmptyLine ()
	local sel_item = reaper.GetSelectedMediaItem (0, 0)
	if sel_item ~= nil then
		local take = reaper.GetActiveTake ( sel_item )
		reaper.GetSetMediaItemTakeInfo_String ( take, "P_NAME", "", true )
	end
end
-- ##################################################
-- ##################################################
-- InsertEmptyItemWithNameAndColor
function InsertEmptyItemWithNameAndColor(name, hex_color, item_length_3)
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
-- ##################################################
-- ##################################################
-- ZoomArrangeToItems
function ZoomArrangeToItems(left_margin, right_margin)
    -- Получаем общее количество айтемов в проекте
    local itemCount = reaper.CountMediaItems(0)

    if itemCount > 0 then
        local firstPos = math.huge -- начальная позиция
        local lastPos = -math.huge -- конечная позиция

        -- Проходим по всем айтемам, чтобы найти их крайние позиции
        for i = 0, itemCount - 1 do
            local item = reaper.GetMediaItem(0, i)
            local pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
            local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
            firstPos = math.min(firstPos, pos)
            lastPos = math.max(lastPos, pos + length)
        end

        -- Применяем отступы
        firstPos = firstPos - (left_margin or 0)
        lastPos = lastPos + (right_margin or 0)

        -- Устанавливаем горизонтальный зум
        reaper.GetSet_ArrangeView2(0, true, 0, 0, firstPos, lastPos)
    else
        -- reaper.ShowMessageBox("В проекте нет айтемов.", "Ошибка", 0)
    end

    -- Обновляем Arrange View
    reaper.UpdateArrange()
end
-- ##################################################
-- ##################################################
-- SetAllTracksAndEnvelopesHeight
-- MaxMusicMax; Track And Envelope; Set All Tracks And Envelopes Height
function SetAllTracksAndEnvelopesHeight(tr_height, en_height)
	-- Получить количество треков в проекте
	local track_count = reaper.CountTracks(0)
	-- Пройти по всем трекам
	for i = 0, track_count - 1 do
		local track = reaper.GetTrack(0, i)
		-- Установить высоту трека
		reaper.SetMediaTrackInfo_Value(track, "I_HEIGHTOVERRIDE", tr_height)
		-- Пройти по всем огибающим трека
		local envelope_count = reaper.CountTrackEnvelopes(track)
		for j = 0, envelope_count - 1 do
			local envelope = reaper.GetTrackEnvelope(track, j)
			-- Создать объект BR_Env для работы с огибающей
			local BR_env = reaper.BR_EnvAlloc(envelope, false)
			-- Получить текущие свойства огибающей
			local active, visible, armed, inLane, _, defaultShape, _, _, _, faderScaling = reaper.BR_EnvGetProperties(BR_env)
			-- Установить новую высоту огибающей
			reaper.BR_EnvSetProperties(BR_env, active, visible, armed, inLane, en_height, defaultShape, faderScaling)
			-- Освободить объект BR_Env
			reaper.BR_EnvFree(BR_env, true)
		end
	end
	reaper.Main_OnCommand(reaper.NamedCommandLookup("_BR_UNSEL_ENV"), 0) -- SWS/BR: Unselect envelope
	reaper.Main_OnCommand(reaper.NamedCommandLookup("40297"), 0) -- Track: Unselect (clear selection of) all tracks
	reaper.Main_OnCommand(reaper.NamedCommandLookup("40769"), 0) -- Unselect (clear selection of) all tracks/items/envelope points
end
-- ##################################################
-- ##################################################
-- SetTopTrackHeight
function SetTopTrackHeight(height)
	-- Получаем самый верхний трек
	local track = reaper.GetTrack(0, 0)

	if track then
		-- Устанавливаем выбранный трек
		reaper.SetOnlyTrackSelected(track)

		-- Устанавливаем высоту для выбранного трека
		-- reaper.Main_OnCommand(40913, 0) -- Set track height to minimum
		reaper.SetMediaTrackInfo_Value(track, "I_HEIGHTOVERRIDE", height)

		-- Обновляем интерфейс
		reaper.TrackList_AdjustWindows(false)
		reaper.UpdateArrange()
	else
		reaper.ShowMessageBox("В проекте нет треков.", "Ошибка", 0)
	end
	reaper.Main_OnCommand(reaper.NamedCommandLookup("_BR_UNSEL_ENV"), 0) -- SWS/BR: Unselect envelope
	reaper.Main_OnCommand(reaper.NamedCommandLookup("40297"), 0) -- Track: Unselect (clear selection of) all tracks
	reaper.Main_OnCommand(reaper.NamedCommandLookup("40769"), 0) -- Unselect (clear selection of) all tracks/items/envelope points
end
-- ##################################################
-- ##################################################
-- changeItemRateReset
function changeItemRateReset()
  -- Получить активный проект
  project = 0
  -- Получить количество выделенных items
  num_items = reaper.CountSelectedMediaItems(project)
  -- Проверить, есть ли выделенные items
  if num_items > 0 then
    -- Перебрать все выделенные items
    for i = 0, num_items - 1 do
      -- Получить текущий item
      item = reaper.GetSelectedMediaItem(project, i)
      -- Получить take из item
      take = reaper.GetActiveTake(item)
      -- Проверить, существует ли take
      if take ~= nil then
        -- Установить новый rate для take
        reaper.SetMediaItemTakeInfo_Value(take, "D_PLAYRATE", 1)
        -- Обновить item в проекте
        reaper.UpdateItemInProject(item)
      else
        -- reaper.ShowMessageBox("Один из выделенных items не содержит take", "Ошибка", 0)
		print_rs ("Один из выделенных items не содержит take")
      end
    end
  else
    -- reaper.ShowMessageBox("Нет выделенных items", "Ошибка", 0)
	print_rs ("Нет выделенных items")
  end
end
-- ##################################################
-- ##################################################
-- changePitchForSelectedItems
function changePitchForSelectedItems(pitchChange)
    -- количество выделенных айтемов
    local itemCount = reaper.CountSelectedMediaItems(0)
    -- проходим по всем выделенным айтемам
    for i = 0, itemCount - 1 do
        -- получаем айтем
        local item = reaper.GetSelectedMediaItem(0, i)
        -- получаем активный take в айтеме
        local take = reaper.GetActiveTake(item)
        if take then -- проверяем, что take существует
            -- получаем текущий питч
            local currentPitch = reaper.GetMediaItemTakeInfo_Value(take, "D_PITCH")
            -- устанавливаем новый питч, увеличив на заданное значение
            reaper.SetMediaItemTakeInfo_Value(take, "D_PITCH", currentPitch + pitchChange)
        end
    end
    -- обновляем проект и UI
    reaper.UpdateArrange()
end
-- ##################################################
-- ##################################################
-- SelectNearestEnvelopePointsAroundCursor
function SelectNearestEnvelopePointsAroundCursor(direction)
	-- Получаем активную огибающую
	local envelope = reaper.GetSelectedEnvelope(0)

	if envelope then
		-- Получаем позицию Edit Cursor
		local edit_cursor_pos = reaper.GetCursorPosition()

		-- Получаем количество точек на огибающей
		local num_points = reaper.CountEnvelopePoints(envelope)

		-- Переменные для хранения ближайших точек
		local nearest_point_left = -1
		local nearest_point_right = -1
		local nearest_point_left_time = -1
		local nearest_point_right_time = -1

		-- Проходим по всем точкам огибающей
		for i = 0, num_points - 1 do
			-- Получаем информацию о точке
			local retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(envelope, i)

			-- Если точка находится слева от Edit Cursor
			if time < edit_cursor_pos then
				-- Если эта точка ближе всего к Edit Cursor слева, сохраняем её
				if time > nearest_point_left_time then
					nearest_point_left_time = time
					nearest_point_left = i
				end
				-- Если точка находится справа от Edit Cursor
			elseif time > edit_cursor_pos then
				-- Если эта точка ближе всего к Edit Cursor справа, сохраняем её
				if nearest_point_right_time == -1 or time < nearest_point_right_time then
					nearest_point_right_time = time
					nearest_point_right = i
				end
			end
		end

		-- В зависимости от аргумента выделяем точки
		if direction == "left" or direction == "both" then
			if nearest_point_left ~= -1 then
				reaper.SetEnvelopePoint(envelope, nearest_point_left, nil, nil, nil, nil, true, true) -- выделяем точку слева
			else
				reaper.ShowMessageBox("Точка слева от Edit Cursor не найдена.", "Информация", 0)
			end
		end

		if direction == "right" or direction == "both" then
			if nearest_point_right ~= -1 then
				reaper.SetEnvelopePoint(envelope, nearest_point_right, nil, nil, nil, nil, true, true) -- выделяем точку справа
			else
				reaper.ShowMessageBox("Точка справа от Edit Cursor не найдена.", "Информация", 0)
			end
		end

		-- Обновляем огибающую
		reaper.Envelope_SortPoints(envelope)
	else
		reaper.ShowMessageBox("Нет выделенной огибающей.", "Ошибка", 0)
	end

	reaper.UpdateArrange()  -- Обновляем отображение проекта
end

-- Примеры вызова функции:
-- SelectNearestEnvelopePointsAroundCursor("left")  -- выделяет точку слева
-- SelectNearestEnvelopePointsAroundCursor("right") -- выделяет точку справа
-- SelectNearestEnvelopePointsAroundCursor("both")  -- выделяет точки слева и справа
-- ##################################################
-- ##################################################
-- handleRateChange
local rate_change = 1.0
local function handleRateChange(ctx, dragDoubleResult)
    local changed, new_rate_change = table.unpack(dragDoubleResult)

    -- Обновляем список выделенных айтемов и их начальные значения rate
    local num_items = reaper.CountSelectedMediaItems(0)
    local initial_rates = {}

    if num_items > 0 then
        for i = 0, num_items - 1 do
            local item = reaper.GetSelectedMediaItem(0, i)
            local take = reaper.GetActiveTake(item)
            if take then
                local item_id = reaper.BR_GetMediaItemGUID(item)
                initial_rates[item_id] = reaper.GetMediaItemTakeInfo_Value(take, "D_PLAYRATE")
            end
        end
    else
        rate_change = 1.0 -- Сбрасываем значение слайдера до 1.0 (нормальная скорость), если нет выделенных айтемов
    end

    -- Если значение изменилось и есть выделенные айтемы, обновляем их rate
    if changed and num_items > 0 then
        rate_change = new_rate_change -- Обновляем текущий rate_change

        for item_id, original_rate in pairs(initial_rates) do
            local item = reaper.BR_GetMediaItemByGUID(0, item_id)
            local take = reaper.GetActiveTake(item)
            if take then
                reaper.SetMediaItemTakeInfo_Value(take, "D_PLAYRATE", new_rate_change) -- Устанавливаем новое значение rate
            end
        end
        reaper.UpdateArrange()
    end
end
-- ##################################################
-- ##################################################
-- handlePitchChange
local pitch_change = 0.0
-- Функция для обработки изменения pitch
local function handlePitchChange(ctx, dragDoubleResult)
    local changed, new_pitch_change = table.unpack(dragDoubleResult)

    -- Обновляем список выделенных айтемов и их начальные значения pitch
    local num_items = reaper.CountSelectedMediaItems(0)
    local initial_pitches = {}

    if num_items > 0 then
        for i = 0, num_items - 1 do
            local item = reaper.GetSelectedMediaItem(0, i)
            local take = reaper.GetActiveTake(item)
            if take then
                local item_id = reaper.BR_GetMediaItemGUID(item)
                initial_pitches[item_id] = reaper.GetMediaItemTakeInfo_Value(take, "D_PITCH")
            end
        end
    else
        pitch_change = 0.0 -- Сбрасываем значение слайдера до 0.0, если нет выделенных айтемов
    end

    -- Если значение изменилось и есть выделенные айтемы, обновляем их pitch
    if changed and num_items > 0 then
        pitch_change = new_pitch_change -- Обновляем текущий pitch_change

        for item_id, original_pitch in pairs(initial_pitches) do
            local item = reaper.BR_GetMediaItemByGUID(0, item_id)
            local take = reaper.GetActiveTake(item)
            if take then
                reaper.SetMediaItemTakeInfo_Value(take, "D_PITCH", new_pitch_change) -- Устанавливаем новое значение pitch
            end
        end
        reaper.UpdateArrange()
    end
end
-- ##################################################
-- ##################################################
-- changeVolumeForSelectedItems
function changeVolumeForSelectedItems(volumeChangeDB)
    -- количество выделенных айтемов
    local itemCount = reaper.CountSelectedMediaItems(0)
    -- проходим по всем выделенным айтемам
    for i = 0, itemCount - 1 do
        -- получаем айтем
        local item = reaper.GetSelectedMediaItem(0, i)
        -- получаем текущий уровень громкости
        local currentVolume = reaper.GetMediaItemInfo_Value(item, "D_VOL") 
        -- рассчитываем новый уровень громкости
        local newVolume = currentVolume * (10^(volumeChangeDB / 20))
        -- устанавливаем новый уровень громкости
        reaper.SetMediaItemInfo_Value(item, "D_VOL", newVolume)
    end
    -- обновляем проект и UI
    reaper.UpdateArrange()
end
-- ##################################################
-- ##################################################
-- handleVolumeChange
-- Функция для обработки изменения громкости
local volume_db = 0.0
local function handleVolumeChange(ctx, dragDoubleResult)
    local changed, new_volume_db = table.unpack(dragDoubleResult)

    -- Обновляем список выделенных айтемов и их начальные значения громкости
    local num_items = reaper.CountSelectedMediaItems(0)
    local initial_volumes = {}

    if num_items > 0 then
        for i = 0, num_items - 1 do
            local item = reaper.GetSelectedMediaItem(0, i)
            local item_id = reaper.BR_GetMediaItemGUID(item)
            initial_volumes[item_id] = reaper.GetMediaItemInfo_Value(item, "D_VOL")
        end
    else
        volume_db = 0.0 -- Сбрасываем значение слайдера до 0.0 дБ, если нет выделенных айтемов
    end

    -- Если значение изменилось и есть выделенные айтемы, обновляем их громкость
    if changed and num_items > 0 then
        local dB_increment = new_volume_db - volume_db
        volume_db = new_volume_db

        for item_id, original_vol in pairs(initial_volumes) do
            local item = reaper.BR_GetMediaItemByGUID(0, item_id)
            if item then
                local new_vol_db = 20 * math.log(original_vol, 10) + dB_increment
                local new_vol = 10 ^ (new_vol_db / 20)
                reaper.SetMediaItemInfo_Value(item, "D_VOL", new_vol)
            end
        end
        reaper.UpdateArrange()
    end
end
-- Функция для обработки изменения громкости
-- ##################################################
-- ##################################################
-- changeSelectedEnvelopePoints
function changeSelectedEnvelopePoints(valueChangePercent)
    -- Проходим по всем трекам
    local trackCount = reaper.CountSelectedTracks(0)
    for i = 0, trackCount - 1 do
        local track = reaper.GetSelectedTrack(0, i)
        -- Получаем огибающую трека (например, громкость)
        local env = reaper.GetTrackEnvelope(track, 0) -- Индекс 0 обычно для огибающей громкости
        if env then
            local pointsCount = reaper.CountEnvelopePoints(env)
            for j = 0, pointsCount - 1 do
                local retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(env, j) 
                -- Меняем только выбранные точки
                if selected then
                    -- Рассчитываем новое значение
                    local newValue = value * (1 + valueChangePercent / 100)
                    -- Устанавливаем новое значение точки
                    reaper.SetEnvelopePoint(env, j, time, newValue, shape, tension, true, true)
                end
            end
            -- Обновляем и перерисовываем огибающую
            reaper.Envelope_SortPoints(env)
        end
    end
    -- Обновляем проект и UI
    reaper.UpdateArrange()
end
-- ##################################################
-- ##################################################
-- EnableMidiModeOnTheTrack
function EnableMidiModeOnTheTrack ( enable, name_fx, name_preset )

	local track = reaper.GetSelectedTrack (0, 0)
	if track then
		if enable == 1 then
			reaper.SetMediaTrackInfo_Value(track, "I_RECARM", 1) -- 1 включает запись, 0 выключает
			reaper.SetMediaTrackInfo_Value(track, "I_RECMODE", 7) -- 7 означает режим MIDI overdub
			reaper.SetMediaTrackInfo_Value(track, "I_RECINPUT", 4096+0x7E0) -- 4096 указывает на запись MIDI, 0 = все каналы
			reaper.SetMediaTrackInfo_Value(track, "I_RECMON", 1)
		else
			reaper.SetMediaTrackInfo_Value(track, "I_RECARM", 0) -- Выключает запись
			reaper.SetMediaTrackInfo_Value(track, "I_RECMODE", 0) -- Режим по умолчанию
			reaper.SetMediaTrackInfo_Value(track, "I_RECINPUT", 0) -- Вход по умолчанию
			reaper.SetMediaTrackInfo_Value(track, "I_RECMON", 0) -- Выключает мониторинг записи
		end
	end
	
	name_fx = name_fx or ""
    name_preset = name_preset or ""
	
	if name_fx ~= "" then
		Add_FX (name_fx, name_preset)
	end
end
-- ##################################################
-- ##################################################
-- SetGetSelectedTrackID
function SetGetSelectedTrackID(action)
    if action == "remember_selection" then
        -- Запоминаем выделенные треки
        local num_tracks = reaper.CountSelectedTracks(0)
        local track_ids = ""

        for i = 0, num_tracks - 1 do
            local track = reaper.GetSelectedTrack(0, i)
            local track_id = reaper.GetTrackGUID(track)
            track_ids = track_ids .. track_id .. ";"
        end

        reaper.SetExtState("MaxMusicMax_SelectedTrackIDs", "SelectedTrackIDsForStretchMarker", track_ids, false)

    elseif action == "install_selection" then
        -- Восстанавливаем выделенные треки
        local track_ids = reaper.GetExtState("MaxMusicMax_SelectedTrackIDs", "SelectedTrackIDsForStretchMarker")

        if track_ids == "" then
            reaper.ShowMessageBox("Нет сохраненных треков", "Ошибка", 0)
            return
        end

        local track_guid_list = {}
        for guid in string.gmatch(track_ids, "([^;]+)") do
            table.insert(track_guid_list, guid)
        end

        reaper.Main_OnCommand(40297, 0) -- Снять выделение со всех треков

        local num_tracks = reaper.CountTracks(0)
        for i = 0, num_tracks - 1 do
            local track = reaper.GetTrack(0, i)
            local track_guid = reaper.GetTrackGUID(track)

            for _, saved_guid in ipairs(track_guid_list) do
                if track_guid == saved_guid then
                    reaper.SetTrackSelected(track, true)
                end
            end
        end

        reaper.TrackList_AdjustWindows(false)
    elseif action == "clean_selection" then
		reaper.DeleteExtState("MaxMusicMax_SelectedTrackIDs", "SelectedTrackIDsForStretchMarker", false)
    else
        reaper.ShowMessageBox("Неверное действие", "Ошибка", 0)
    end
end
-- ##################################################
-- ##################################################
-- SetGetSelectedItemID
function SetGetSelectedItemID(action)
    if action == "remember_selection" then
        -- Запоминаем выделенные айтемы
        local num_items = reaper.CountSelectedMediaItems(0)
        local item_ids = ""

        for i = 0, num_items - 1 do
            local item = reaper.GetSelectedMediaItem(0, i)
            local item_id = reaper.BR_GetMediaItemGUID(item) -- получаем уникальный GUID айтема
            item_ids = item_ids .. item_id .. ";"
        end

        reaper.SetExtState("MaxMusicMax_SelectedItemIDs", "SelectedItemIDsForStretchMarker", item_ids, false)

    elseif action == "install_selection" then
        -- Восстанавливаем выделенные айтемы
        local item_ids = reaper.GetExtState("MaxMusicMax_SelectedItemIDs", "SelectedItemIDsForStretchMarker")

        if item_ids == "" then
            reaper.ShowMessageBox("Нет сохраненных айтемов", "Ошибка", 0)
            return
        end

        local item_guid_list = {}
        for guid in string.gmatch(item_ids, "([^;]+)") do
            table.insert(item_guid_list, guid)
        end

        reaper.Main_OnCommand(40289, 0) -- Снять выделение со всех айтемов

        local num_items = reaper.CountMediaItems(0)
        for i = 0, num_items - 1 do
            local item = reaper.GetMediaItem(0, i)
            local item_guid = reaper.BR_GetMediaItemGUID(item)

            for _, saved_guid in ipairs(item_guid_list) do
                if item_guid == saved_guid then
                    reaper.SetMediaItemSelected(item, true)
                end
            end
        end

        reaper.UpdateArrange()
    elseif action == "clean_selection" then
		reaper.DeleteExtState("MaxMusicMax_SelectedItemIDs", "SelectedItemIDsForStretchMarker", false)
    else
        reaper.ShowMessageBox("Неверное действие", "Ошибка", 0)
    end
end
-- ##################################################
-- ##################################################
-- DeleteItemsAtEditCursorSelectLeft
function DeleteItemsAtEditCursorSelectLeft ()
	reaper.Main_OnCommand(reaper.NamedCommandLookup("40758"), 0) -- Item: Split items at edit cursor (select left)
	reaper.Main_OnCommand(reaper.NamedCommandLookup("40006"), 0) -- -- Item: Remove items
end
-- DeleteItemsAtEditCursorSelectRight
function DeleteItemsAtEditCursorSelectRight ()
	reaper.Main_OnCommand(reaper.NamedCommandLookup("40759"), 0) -- Item: Split items at edit cursor (select right)
	reaper.Main_OnCommand(reaper.NamedCommandLookup("40006"), 0) -- -- Item: Remove items
end
-- DeleteItemsAtTimeSelection
function DeleteItemsAtTimeSelection ()
	start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)
	if start_time ~= end_time then
		reaper.Main_OnCommand(reaper.NamedCommandLookup("40061"), 0) -- -- Item: Split items at time selection -- 
		reaper.Main_OnCommand(reaper.NamedCommandLookup("40006"), 0) -- -- Item: Remove items
		reaper.Main_OnCommand(reaper.NamedCommandLookup("40635"), 0) -- -- Time selection: Remove (unselect) time selection
	end
end
-- ##################################################
-- ##################################################
-- move_cursor_to_next_position
function move_cursor_to_next_position(mode, select_item)
    local num_items = reaper.CountMediaItems(0)
    local positions = {}
    local items = {}
    
    for i = 0, num_items - 1 do
        local item = reaper.GetMediaItem(0, i)
        local start_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        local end_pos = start_pos + length
        
        if mode == "start" then
            table.insert(positions, {pos = start_pos, item = item})
        elseif mode == "end" then
            table.insert(positions, {pos = end_pos, item = item})
        else
            table.insert(positions, {pos = start_pos, item = item})
            table.insert(positions, {pos = end_pos, item = item})
        end
    end
    
    table.sort(positions, function(a, b) return a.pos < b.pos end)
    
    local cursor_pos = reaper.GetCursorPosition()
    for i = 1, #positions do
        if positions[i].pos > cursor_pos then
            reaper.SetEditCurPos(positions[i].pos, true, false)
            if select_item == "select" then
                -- Снимаем выделение со всех айтемов
                reaper.SelectAllMediaItems(0, false)
                -- Выделяем текущий айтем
                reaper.SetMediaItemSelected(positions[i].item, true)
                reaper.UpdateArrange()
            end
            return
        end
    end
    
    if #positions > 0 then
        reaper.SetEditCurPos(positions[1].pos, true, false)
        if select_item == "select" then
            -- Снимаем выделение со всех айтемов
            reaper.SelectAllMediaItems(0, false)
            -- Выделяем текущий айтем
            reaper.SetMediaItemSelected(positions[1].item, true)
            reaper.UpdateArrange()
        end
    end
end
-- ##################################################
-- ##################################################
-- move_cursor_to_previous_position
function move_cursor_to_previous_position(mode, select_item)
    local num_items = reaper.CountMediaItems(0)
    local positions = {}
    local items = {}
    
    for i = 0, num_items - 1 do
        local item = reaper.GetMediaItem(0, i)
        local start_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        local end_pos = start_pos + length
        
        if mode == "start" then
            table.insert(positions, {pos = start_pos, item = item})
        elseif mode == "end" then
            table.insert(positions, {pos = end_pos, item = item})
        else
            table.insert(positions, {pos = start_pos, item = item})
            table.insert(positions, {pos = end_pos, item = item})
        end
    end
    
    table.sort(positions, function(a, b) return a.pos < b.pos end)
    
    local cursor_pos = reaper.GetCursorPosition()
    for i = #positions, 1, -1 do
        if positions[i].pos < cursor_pos then
            reaper.SetEditCurPos(positions[i].pos, true, false)
            if select_item == "select" then
                -- Снимаем выделение со всех айтемов
                reaper.SelectAllMediaItems(0, false)
                -- Выделяем текущий айтем
                reaper.SetMediaItemSelected(positions[i].item, true)
                reaper.UpdateArrange()
            end
            return
        end
    end
    
    if #positions > 0 then
        reaper.SetEditCurPos(positions[#positions].pos, true, false)
        if select_item == "select" then
            -- Снимаем выделение со всех айтемов
            reaper.SelectAllMediaItems(0, false)
            -- Выделяем текущий айтем
            reaper.SetMediaItemSelected(positions[#positions].item, true)
            reaper.UpdateArrange()
        end
    end
end
-- ##################################################
-- ##################################################
-- move_cursor_on_selected_track
function move_cursor_on_selected_track(mode, select_item)
	console_window_destroy ()
    -- Получаем количество треков
    local num_tracks = reaper.CountSelectedTracks(0)
    if num_tracks == 0 then
        print_rs("Не выделено ни одного трека.")
        return
    end
    
    -- Получаем первый выделенный трек
    local track = reaper.GetSelectedTrack(0, 0)
    
    -- Получаем количество медиа-айтемов на треке
    local num_items = reaper.CountTrackMediaItems(track)
    local positions = {}
    local items = {}
    
    for i = 0, num_items - 1 do
        local item = reaper.GetTrackMediaItem(track, i)
        local start_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        local end_pos = start_pos + length
        
        if mode == "start" then
            table.insert(positions, start_pos)
        elseif mode == "end" then
            table.insert(positions, end_pos)
        end
        
        table.insert(items, item)
    end
    
    table.sort(positions)
    
    local cursor_pos = reaper.GetCursorPosition()
    for i = 1, #positions do
        if positions[i] > cursor_pos then
            reaper.SetEditCurPos(positions[i], true, false)
            if select_item then
                -- Снимаем выделение со всех айтемов
                reaper.SelectAllMediaItems(0, false)
                -- Выделяем текущий айтем
                reaper.SetMediaItemSelected(items[i], true)
                reaper.UpdateArrange()
            end
            return
        end
    end
    
    if #positions > 0 then
        reaper.SetEditCurPos(positions[1], true, false)
        if select_item then
            -- Снимаем выделение со всех айтемов
            reaper.SelectAllMediaItems(0, false)
            -- Выделяем текущий айтем
            reaper.SetMediaItemSelected(items[1], true)
            reaper.UpdateArrange()
        end
    end
end
-- ##################################################
-- ##################################################
-- move_cursor_on_selected_track_reverse
function move_cursor_on_selected_track_reverse(mode, select_item)
	console_window_destroy ()
    -- Получаем количество треков
    local num_tracks = reaper.CountSelectedTracks(0)
    if num_tracks == 0 then
        print_rs("Не выделено ни одного трека.")
        return
    end
    
    -- Получаем первый выделенный трек
    local track = reaper.GetSelectedTrack(0, 0)
    
    -- Получаем количество медиа-айтемов на треке
    local num_items = reaper.CountTrackMediaItems(track)
    local positions = {}
    local items = {}
    
    for i = 0, num_items - 1 do
        local item = reaper.GetTrackMediaItem(track, i)
        local start_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        local end_pos = start_pos + length
        
        if mode == "start" then
            table.insert(positions, start_pos)
        elseif mode == "end" then
            table.insert(positions, end_pos)
        end
        
        table.insert(items, item)
    end
    
    table.sort(positions)
    
    local cursor_pos = reaper.GetCursorPosition()
    for i = #positions, 1, -1 do
        if positions[i] < cursor_pos then
            reaper.SetEditCurPos(positions[i], true, false)
            if select_item then
                -- Снимаем выделение со всех айтемов
                reaper.SelectAllMediaItems(0, false)
                -- Выделяем текущий айтем
                reaper.SetMediaItemSelected(items[i], true)
                reaper.UpdateArrange()
            end
            return
        end
    end
    
    if #positions > 0 then
        reaper.SetEditCurPos(positions[#positions], true, false)
        if select_item then
            -- Снимаем выделение со всех айтемов
            reaper.SelectAllMediaItems(0, false)
            -- Выделяем текущий айтем
            reaper.SetMediaItemSelected(items[#positions], true)
            reaper.UpdateArrange()
        end
    end
end
-- ##################################################
-- ##################################################
-- moveItemTopBottomTrack
function moveItemTopBottomTrack(direction)
	-- Получаем количество выделенных айтемов
	local num_items = reaper.CountSelectedMediaItems(0)

	-- Проходим по каждому выделенному айтему
	for i = 0, num_items - 1 do
		local item = reaper.GetSelectedMediaItem(0, i)
		local track = reaper.GetMediaItemTrack(item)
		local track_num = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")

		-- Определяем трек для перемещения: вверх (top) или вниз (bottom)
		local target_track = nil
		if direction == "top" then
			target_track = reaper.GetTrack(0, track_num - 2)  -- трек выше
		elseif direction == "bottom" then
			target_track = reaper.GetTrack(0, track_num)  -- трек ниже
		end

		-- Если целевой трек существует, перемещаем айтем на него
		if target_track then
			reaper.MoveMediaItemToTrack(item, target_track)
		end
	end

	-- Обновляем интерфейс Reaper
	reaper.UpdateArrange()
end
-- ##################################################
-- ##################################################
-- DeleteUnselectedItemsOnTrack
function DeleteUnselectedItemsOnTrack ()
	-- Начинаем блок для Undo
	reaper.Undo_BeginBlock()

	-- Получаем активный трек
	local track = reaper.GetSelectedTrack(0, 0)
	if track == nil then return end -- Если трек не выбран, прекращаем выполнение скрипта

	-- Проходим по всем айтемам на треке
	local item_count = reaper.CountTrackMediaItems(track)

	for i = item_count - 1, 0, -1 do
		local item = reaper.GetTrackMediaItem(track, i)

		-- Проверяем, выделен айтем или нет
		local is_selected = reaper.IsMediaItemSelected(item)

		-- Если айтем не выделен, удаляем его
		if not is_selected then
			reaper.DeleteTrackMediaItem(track, item)
		end
	end

	-- Завершаем блок для Undo
	reaper.Undo_EndBlock("Удалить все невыделенные айтемы на треке", -1)
	reaper.UpdateArrange()
end
-- ##################################################
-- ##################################################
-- CreateFolderTrackAndMoveSelectedTracks
function CreateFolderTrackAndMoveSelectedTracks ()
	-- Начало действия для отмены (Undo point)
	reaper.Undo_BeginBlock()
	-- Количество выделенных треков
	local selected_tracks_count = reaper.CountSelectedTracks(0)
	-- Проверяем, есть ли выделенные треки
	if selected_tracks_count > 0 then
		-- Инициализируем переменную для хранения индекса самого верхнего выделенного трека
		local topmost_track_index = reaper.GetMediaTrackInfo_Value(reaper.GetSelectedTrack(0, 0), "IP_TRACKNUMBER")
		-- Перебираем все выделенные треки, чтобы найти индекс самого верхнего
		for i = 1, selected_tracks_count - 1 do
			local selected_track = reaper.GetSelectedTrack(0, i)
			local track_index = reaper.GetMediaTrackInfo_Value(selected_track, "IP_TRACKNUMBER")
			if track_index < topmost_track_index then
				topmost_track_index = track_index
			end
		end
		-- Вставляем новый трек над самым верхним выделенным треком
		reaper.InsertTrackAtIndex(topmost_track_index - 1, false)
		-- Получаем новый трек (он добавлен перед верхним выделенным треком, так что индекс тот же)
		local new_parent_track = reaper.GetTrack(0, topmost_track_index - 1)
		-- Устанавливаем для нового трека значение папки (1 - это начало папки)
		reaper.SetMediaTrackInfo_Value(new_parent_track, "I_FOLDERDEPTH", 1)
		-- Делаем все выделенные треки дочерними
		for i = 0, selected_tracks_count - 1 do
			local track = reaper.GetSelectedTrack(0, i)
			reaper.SetMediaTrackInfo_Value(track, "I_FOLDERDEPTH", 0)
		end
		-- Завершаем папку (-1 означает конец папки)
		local last_selected_track = reaper.GetSelectedTrack(0, selected_tracks_count - 1)
		reaper.SetMediaTrackInfo_Value(last_selected_track, "I_FOLDERDEPTH", -1)
	end
	-- Завершаем действие для Undo
	reaper.Undo_EndBlock("Create folder track and move selected tracks into it", -1)
end
-- ##################################################
-- ##################################################
-- CreateTrackRelativeToSelected
function CreateTrackRelativeToSelected(position)
	-- Начало действия для отмены (Undo point)
	reaper.Undo_BeginBlock()
	-- Количество выделенных треков
	local selected_tracks_count = reaper.CountSelectedTracks(0)
	if selected_tracks_count > 0 then
		-- Определяем индекс самого верхнего выделенного трека
		local topmost_track_index = reaper.GetMediaTrackInfo_Value(reaper.GetSelectedTrack(0, 0), "IP_TRACKNUMBER")
		for i = 1, selected_tracks_count - 1 do
			local selected_track = reaper.GetSelectedTrack(0, i)
			local track_index = reaper.GetMediaTrackInfo_Value(selected_track, "IP_TRACKNUMBER")
			if track_index < topmost_track_index then
				topmost_track_index = track_index
			end
		end
		-- Определяем индекс вставки
		local insert_index = (position == "below") and topmost_track_index or (topmost_track_index - 1)
		-- Вставляем новый трек
		reaper.InsertTrackAtIndex(insert_index, false)
	end
	-- Завершаем действие для Undo
	reaper.Undo_EndBlock("Create track " .. position .. " selected", -1)
end

-- Примеры вызова
-- CreateTrackRelativeToSelected("higher") -- создаёт трек выше выделенного
-- CreateTrackRelativeToSelected("below") -- создаёт трек ниже выделенного
-- ##################################################
-- ##################################################
-- InvertItemSelection
function InvertItemSelection ()
	-- Начало группы действий для Undo
	reaper.Undo_BeginBlock()

	-- Получаем количество айтемов в проекте
	local item_count = reaper.CountMediaItems(0)

	-- Проходим по каждому айтему в проекте
	for i = 0, item_count - 1 do
		local item = reaper.GetMediaItem(0, i)

		-- Если айтем выделен, снимаем выделение, если не выделен — выделяем
		local is_selected = reaper.IsMediaItemSelected(item)
		reaper.SetMediaItemSelected(item, not is_selected)
	end

	-- Обновляем интерфейс
	reaper.UpdateArrange()

	-- Завершаем блок Undo
	reaper.Undo_EndBlock("Инвертировать выделение айтемов", -1)
end
-- ##################################################
-- ##################################################
-- delete_or_keep_cc
function delete_or_keep_cc(cc_to_keep)
	reaper.Undo_BeginBlock()
    -- Получить количество выделенных MIDI элементов
    local num_items = reaper.CountSelectedMediaItems(0)
    if num_items > 0 then
        for i = 0, num_items - 1 do
            local item = reaper.GetSelectedMediaItem(0, i)
            local take = reaper.GetActiveTake(item)
            if reaper.TakeIsMIDI(take) then
                -- Включить массовое редактирование, чтобы предотвратить обновление графического интерфейса
                reaper.MIDI_DisableSort(take)

                local retval, notecnt, ccevtcnt, textsyxevtcnt = reaper.MIDI_CountEvts(take)
                for j = ccevtcnt - 1, 0, -1 do
                    local retval, selected, muted, ppqpos, chanmsg, chan, msg2, msg3 = reaper.MIDI_GetCC(take, j)
                    if cc_to_keep == true or msg2 ~= cc_to_keep then -- Удалять все, если cc_to_keep равно true, иначе удалять все, кроме CC с номером cc_to_keep
                        reaper.MIDI_DeleteCC(take, j)
                    end
                end

                -- Включить сортировку после редактирования
                reaper.MIDI_Sort(take)
            end
        end
        if cc_to_keep == true then
            reaper.ShowMessageBox("Все MIDI CC сообщения удалены на выделенных элементах.", "Удаление завершено", 0)
        else
            reaper.ShowMessageBox("Все MIDI CC сообщения, кроме CC номер " .. cc_to_keep .. ", удалены на выделенных элементах.", "Удаление завершено", 0)
        end
    else
        reaper.ShowMessageBox("Нет выделенных MIDI элементов.", "Ошибка", 0)
    end
	reaper.Undo_EndBlock("delete_or_keep_cc", -1)
end
-- Selected Media Items Remove All CC's From MIDI
-- delete_or_keep_cc(true)  -- Удалить все CC сообщения
-- delete_or_keep_cc(64) -- Удалить все CC сообщения, кроме номера 64
-- Удалить MIDI CC
-- ##################################################
-- ##################################################
-- InsertMidiProgramChange
function InsertMidiProgramChange(number)
	reaper.Undo_BeginBlock()
	-- Получаем первый выделенный айтем
	item = reaper.GetSelectedMediaItem(0, 0)
	if item == nil then
		reaper.ShowMessageBox("Нет выделенного айтема", "Ошибка", 0)
		return
	end

	-- Получаем границы айтема
	item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
	item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
	item_end = item_start + item_length

	-- Получаем позицию курсора редактирования
	cursor_pos = reaper.GetCursorPosition()

	-- Проверяем, находится ли курсор над айтемом
	if cursor_pos < item_start or cursor_pos > item_end then
		reaper.ShowMessageBox("Курсор редактирования не находится над айтемом", "Ошибка", 0)
		return
	end

	-- Получаем take из айтема (активный take)
	take = reaper.GetTake(item, 0)
	if take == nil or not reaper.TakeIsMIDI(take) then
		reaper.ShowMessageBox("Не найден MIDI-take", "Ошибка", 0)
		return
	end

	-- Переводим позицию курсора в PPQ
	position_ppq = reaper.MIDI_GetPPQPosFromProjTime(take, cursor_pos)

	-- Номер программы для смены (0-127)
	program_number = number  -- Замените на нужный номер программы

	-- Вставляем Program Change событие
	reaper.MIDI_InsertEvt(take, 
		false,  -- selected (выделено)
		false,  -- muted (выключено)
		position_ppq,  -- позиция в PPQ
		string.char(0xC0, program_number),  -- статус Program Change + номер программы
		nil  -- нет текстового события
	)

	-- Обновляем данные и отображение
	reaper.MIDI_Sort(take)
	reaper.UpdateArrange()

	-- Сообщение об успешной операции
	-- reaper.ShowMessageBox("Program Change установлен на программу " .. program_number, "Готово", 0)
	reaper.Undo_EndBlock("InsertMidiProgramChange", -1)
end
-- ##################################################
-- ##################################################
-- DeleteProgramChangeAtCursor
function DeleteProgramChangeAtCursor(ms_range)
	reaper.Undo_BeginBlock()

	local item = reaper.GetSelectedMediaItem(0, 0)
	if not item then return end

	local take = reaper.GetTake(item, 0)
	if not take or not reaper.TakeIsMIDI(take) then return end

	local cursor_pos = reaper.GetCursorPosition()
	local offset = (ms_range or 100) / 1000  -- миллисекунды в секунды
	local range_start = cursor_pos - offset
	local range_end   = cursor_pos + offset

	reaper.GetSet_LoopTimeRange(true, false, range_start, range_end, false)

	reaper.MIDI_DisableSort(take)

	local _, _, cc_cnt, _ = reaper.MIDI_CountEvts(take)

	for i = cc_cnt - 1, 0, -1 do
		local _, _, _, ppqpos, chanmsg = reaper.MIDI_GetCC(take, i)
		if chanmsg == 0xC0 then
			local qn = reaper.MIDI_GetProjQNFromPPQPos(take, ppqpos)
			local evt_time = reaper.TimeMap_QNToTime(qn)
			if evt_time >= range_start and evt_time <= range_end then
				reaper.MIDI_DeleteCC(take, i)
			end
		end
	end
	
	reaper.Main_OnCommand(40635, 0) -- Time selection: Remove (unselect) time selection
	reaper.MIDI_Sort(take)
	reaper.UpdateArrange()

	reaper.Undo_EndBlock("DeleteProgramChangeAtCursor", -1)
end
-- ##################################################
-- ##################################################
-- InsertMidiInsertCC
function InsertMidiInsertCC(cc_number1, cc_value1)
	reaper.Undo_BeginBlock()
	-- Получаем позицию курсора редактирования
	cursor_pos = reaper.GetCursorPosition()

	-- Получаем первый выделенный айтем
	item = reaper.GetSelectedMediaItem(0, 0)
	if item == nil then
		reaper.ShowMessageBox("Нет выделенного айтема", "Ошибка", 0)
		return
	end

	-- Получаем take из айтема (активный take)
	take = reaper.GetTake(item, 0)
	if take == nil or not reaper.TakeIsMIDI(take) then
		reaper.ShowMessageBox("Не найден MIDI-take", "Ошибка", 0)
		return
	end

	-- Переводим позицию курсора из секунд в PPQ (позиция для вставки MIDI CC)
	position_ppq = reaper.MIDI_GetPPQPosFromProjTime(take, cursor_pos)

	-- Параметры MIDI CC
	cc_number = cc_number1  -- Замените на нужный номер CC (например, CC1 для модуляции)
	cc_value = cc_value1  -- Установите нужное значение CC (0-127)

	-- Вставляем MIDI CC событие в позицию курсора
	reaper.MIDI_InsertCC(take, 
		false,  -- selected (выделено)
		false,  -- muted (выключено)
		position_ppq,  -- позиция в PPQ
		176,  -- статус CC (176 = 0xB0 для канала 1, для других каналов добавьте номер канала)
		0,  -- MIDI-канал (0 = канал 1, 1 = канал 2 и т.д.)
		cc_number,  -- Номер CC (например, CC1 для модуляции)
		cc_value  -- Значение CC (0-127)
	)

	-- Обновляем данные и отображение
	reaper.MIDI_Sort(take)
	reaper.UpdateArrange()

	-- Выводим сообщение о завершении
	reaper.ShowMessageBox("MIDI CC " .. cc_number .. " установлено на " .. cc_value .. " в позицию курсора", "Готово", 0)
	reaper.Undo_EndBlock("InsertMidiInsertCC", -1)
end
-- ##################################################
-- ##################################################
-- InsertTempoMarkerUserInputs
-- Функция для вставки маркера изменения темпа с вводом от пользователя
function InsertTempoMarkerUserInputs()
	-- Получаем текущее положение редактирующего курсора
	local cursor_position = reaper.GetCursorPosition()

	-- Запрашиваем ввод пользователя (темп, размер такта, доля)
	local retval, user_input = reaper.GetUserInputs("Изменение темпа", 3, "Темп,Размер такта,Доля", "120,4,4")

	-- Если ввод пользователя был успешным
	if retval then
		-- Разделяем введенные значения
		local tempo, measure, beats = user_input:match("([^,]+),([^,]+),([^,]+)")

		-- Преобразуем строки в числа
		tempo = tonumber(tempo)
		measure = tonumber(measure)
		beats = tonumber(beats)

		-- Проверяем, что все введенные значения корректны
		if tempo and measure and beats then
			-- Вставляем маркер изменения темпа
			reaper.AddTempoTimeSigMarker(0, cursor_position, tempo, measure, beats, false)
			else
			-- Сообщаем об ошибке, если значения некорректны
			reaper.ShowMessageBox("Некорректные значения. Попробуйте еще раз.", "Ошибка", 0)
		end
	end
end
-- ##################################################
-- ##################################################
-- DetectAndMarkSibilance
function DetectAndMarkSibilance(mode)
	local item_cnt = reaper.CountSelectedMediaItems( 0 )
	if item_cnt == 0 then return end

	local items, it = {}, 0
	local track = reaper.GetMediaItemTrack( reaper.GetSelectedMediaItem( 0, 0 ))

	for i = 0, item_cnt-1 do
		local item = reaper.GetSelectedMediaItem( 0, i )
		if reaper.GetMediaItemTrack( item ) ~= track then
			reaper.MB("All selected items must be on the same track", "Aborting...", 0)
			return
		end
		local take = reaper.GetActiveTake( item )
		if take and not reaper.TakeIsMIDI( take ) then
			it = it + 1
			items[it] = {item, take}
		end
	end

	if it == 0 then return end

	for i = 1, it do
		local item = items[i][1]
		local take = items[i][2]

		-- sibilants 14dB below rms will be discarded
		local threshold = 10^((reaper.NF_GetMediaItemAverageRMS( item ) - 14)/20)

		local item_pos = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
		local item_len = reaper.GetMediaItemInfo_Value( item, "D_LENGTH" )
		local item_end = item_pos + item_len
		local source = reaper.GetMediaItemTake_Source( take )
		local nch = reaper.GetMediaSourceNumChannels( source )
		local samplerate = reaper.GetMediaSourceSampleRate( source )
		local ns = 1024
		local buf = reaper.new_array( ns * 3 * nch )
		local accessor = reaper.CreateTakeAudioAccessor( take )
		local acc_buf_sz = ns * nch
		local acc_buf = reaper.new_array( acc_buf_sz )
		-- window length will be half of the ns block (so that windows overlap 50%)
		local window = (ns / samplerate) / 2

		-- Calculate cuts
		local cuts, c = {}, 0
		local pos = item_pos
		while pos < item_end do
			local rv = reaper.GetMediaItemTake_Peaks( take, 1000, pos, nch, ns, 115, buf )
			if rv & ( 1 << 24 ) and ( rv & 0xfffff ) > 0 then
				local spl = buf[nch*ns*2 + 1]
				local pitch = spl & 0x7fff
				local tonality = ( spl >> 15 ) / 16384
				-- conditions to consider a split:
				if pitch > 1850 or tonality < 0.15 then
					-- RMS must be above threshold
					local ok = reaper.GetAudioAccessorSamples( accessor, samplerate, nch, pos - item_pos , ns, acc_buf )
					if ok == 1 then
						local rms = 0
						for i = 1, acc_buf_sz do
							rms = rms + acc_buf[i]*acc_buf[i]
						end
						rms = (rms/acc_buf_sz)^(1/2)
						if rms >= threshold then
							if not cut_start then cut_start = pos - 0.01 end -- (0.01: cut a bit earlier)
						end
					end
				else
					-- if the resulting item is 50+ ms, register the splits
					if cut_start and pos - cut_start >= 0.05 then
						c = c + 2
						cuts[c-1] = cut_start
						cuts[c] = pos
					end
					cut_start = nil
				end
			end
			pos = pos + window
		end

		reaper.DestroyAudioAccessor( accessor )
		-- Store info to table
		items[i][2] = c
		items[i][3] = cuts
	end
	
	-- Split items
	reaper.Undo_BeginBlock()
	reaper.PreventUIRefresh( 1 )

	-- Enable autocrossfade
	local auto_xfade = reaper.GetToggleCommandState( 40912 ) == 1
	if not auto_xfade then
		reaper.Main_OnCommand(40927, 0) -- Enable auto-crossfade on split
	end

	-- reaper.SelectAllMediaItems( 0, false ) ————————————————————————————————————————
	local split_items, s = {}, 0
	local cuts_values = {}

	for i = 1, it do
		local c = items[i][2]
		if c ~= 0 then
			local cuts = items[i][3]
			local item = items[i][1]
			local splt = 0 -- split counter, makes a new item every two splits

			local next_item = item -- initialize item to split
			local i = 1 -- index for cuts table

			while i <= c do
				local even = splt % 2 == 0

				-- after having done the first split:
				-- if the next split item is too close ( less than 50ms ) then skip the split (merge the splits)
				if even == false and cuts[i+1] and cuts[i+1] - cuts[i] <= 0.05 then
					i = i + 2
					-- continue merging splits if needed
					while true do
						if cuts[i+1] and cuts[i+1] - cuts[i] <= 0.05 then
							i = i + 2
						else
							break
						end
					end
				end

				-- next_item = reaper.SplitMediaItem( next_item, cuts[i] )
				table.insert(cuts_values, cuts[i])
				-- every two splits (even splt) store the resulting sibilance item
				if even then
					s = s + 1
					split_items[s] = next_item
				end

				splt = splt + 1
				i = i + 1

			end
		end
	end

	local selectedItem = reaper.GetSelectedMediaItem(0, 0)

	if mode == "start" then
		for i = 1, #cuts_values, 2 do -- начало сибилянта
			-- for i = 2, #cuts_values, 2 do -- конец сибилянта
			-- for i = 1, #cuts_values do -- начало и конец сибилянта
			local value = cuts_values[i]
			reaper.SetEditCurPos(value,false,false);
			reaper.Main_OnCommand(41842, 0) -- Item: Add stretch marker at cursor — 41842
			-- reaper.SetTakeStretchMarker(selectedItem, -1, value)
		end
	elseif mode == "end" then
		-- for i = 1, #cuts_values, 2 do -- начало сибилянта
		for i = 2, #cuts_values, 2 do -- конец сибилянта
		-- for i = 1, #cuts_values do -- начало и конец сибилянта
			local value = cuts_values[i]
			reaper.SetEditCurPos(value,false,false);
			reaper.Main_OnCommand(41842, 0) -- Item: Add stretch marker at cursor — 41842
			-- reaper.SetTakeStretchMarker(selectedItem, -1, value)
		end
	elseif mode == "start_end" then
		-- for i = 1, #cuts_values, 2 do -- начало сибилянта
		-- for i = 2, #cuts_values, 2 do -- конец сибилянта
		for i = 1, #cuts_values do -- начало и конец сибилянта
			local value = cuts_values[i]
			reaper.SetEditCurPos(value,false,false);
			reaper.Main_OnCommand(41842, 0) -- Item: Add stretch marker at cursor — 41842
			-- reaper.SetTakeStretchMarker(selectedItem, -1, value)
		end
	end

	reaper.Undo_EndBlock( "Set Stretch Marker; Selected Items; Sibilance Start", 4 )
end
-- ##################################################
-- ##################################################
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
-- ##################################################
-- ##################################################
-- SelectItemsInTimeSelection
function SelectItemsInTimeSelection(mode)
	-- mode == 0: снимает выделение со всех элементов, затем выделяет элементы в зоне Time Selection
	-- mode == 1: добавляет элементы в зоне Time Selection к уже выделенным
	-- Начинаем undo блок, чтобы действия можно было отменить одним шагом
	reaper.Undo_BeginBlock()
	if mode == 0 then
		-- Снимаем выделение со всех элементов
		reaper.Main_OnCommand(40289, 0) -- Unselect all items
	end
	-- Получаем информацию о временном выделении
	local time_start, time_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
	-- Получаем количество треков в проекте
	local num_tracks = reaper.CountTracks(0)
	-- Проходим по всем трекам
	for i = 0, num_tracks - 1 do
		-- Получаем трек
		local track = reaper.GetTrack(0, i)
		-- Получаем количество элементов на треке
		local num_items = reaper.CountTrackMediaItems(track)
		-- Проходим по всем элементам на треке
		for j = 0, num_items - 1 do
			-- Получаем элемент
			local item = reaper.GetTrackMediaItem(track, j)
			-- Получаем начало и конец элемента
			local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
			local item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
			local item_end = item_start + item_length
			-- Проверяем, попадает ли элемент в зону временного выделения
			if (item_start < time_end) and (item_end > time_start) then
				-- Выделяем элемент
				reaper.SetMediaItemSelected(item, true)
			end
		end
	end
	-- Обновляем окно проекта для отображения изменений
	reaper.UpdateArrange()
	-- Заканчиваем undo блок
	reaper.Undo_EndBlock("Выделение всех элементов в зоне Time Selection", -1)
end
-- ##################################################
-- ##################################################
-- SetTimeSelectionToRegionAtPlayCursor
function SetTimeSelectionToRegionAtPlayCursor()
    -- Получаем позицию Play Cursor
    local play_pos = reaper.GetPlayPosition()

    -- Считаем количество маркеров и регионов в проекте
    local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)

    -- Перебираем все маркеры и регионы
    for i = 0, retval - 1 do
        local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
        
        -- Если это регион и Play Cursor находится внутри его границ
        if isrgn and play_pos >= pos and play_pos <= rgnend then
            -- Устанавливаем Time Selection на границы региона
            reaper.GetSet_LoopTimeRange(true, false, pos, rgnend, false)
            return
        end
    end

    -- Если регион не найден, ничего не делаем
    -- reaper.ShowMessageBox("Play Cursor не находится в регионе.", "Ошибка", 0)
end
-- ##################################################
-- ##################################################
-- CreateRadioButtonGroup
local current_selections_radio_button = {}

function CreateRadioButtonGroup(ctx, commands, group_id)
	-- Функция для получения числового идентификатора команды
	local function GetCommandID(cmd_id)
		if type(cmd_id) == "string" then
			local numeric_id = reaper.NamedCommandLookup(cmd_id)
			if numeric_id == 0 then
				return nil
			else
				return numeric_id
			end
		else
			return cmd_id
		end
	end

	-- Инициализация состояния текущей выбранной команды
	if current_selections_radio_button[group_id] == nil then
		current_selections_radio_button[group_id] = -1
		for i, cmd in ipairs(commands) do
			local cmd_id = GetCommandID(cmd.id)
			if cmd_id and reaper.GetToggleCommandState(cmd_id) == 1 then
				current_selections_radio_button[group_id] = i
				break
			end
		end
	end

	for i, cmd in ipairs(commands) do
		local cmd_id = GetCommandID(cmd.id)
		if cmd_id then
			if reaper.ImGui_RadioButton(ctx, cmd.name, current_selections_radio_button[group_id] == i) then
				-- Выполняем команду, соответствующую выбранной радиокнопке
				reaper.Main_OnCommand(cmd_id, 0)
				current_selections_radio_button[group_id] = i

				-- Обновляем состояния команд
				for j, other_cmd in ipairs(commands) do
					local other_cmd_id = GetCommandID(other_cmd.id)
					if other_cmd_id and j ~= i then
						reaper.SetToggleCommandState(0, other_cmd_id, 0)
					end
				end
			end
		end
	end
end
-- ##################################################
-- ##################################################
-- InsertNewTrackAndAddFX
function InsertNewTrackAndAddFX(fx_name, preset_name, mode, plugin_state)
	reaper.Undo_BeginBlock()
	plugin_state = plugin_state or 1
	-- mode 0 — Аудио трек
	-- mode 1 — MIDI трек
	mode = mode or 0
	reaper.Main_OnCommand(reaper.NamedCommandLookup("40001"), 0) -- Track: Insert new track 40001
	local track = reaper.GetSelectedTrack (0, 0)
	if mode == 0 then
		Add_FX(fx_name, preset_name)
	elseif	mode == 1 then
		reaper.SetMediaTrackInfo_Value(track, "I_RECARM", 1) -- 1 включает запись, 0 выключает
		reaper.SetMediaTrackInfo_Value(track, "I_RECMODE", 7) -- 7 означает режим MIDI overdub
		reaper.SetMediaTrackInfo_Value(track, "I_RECINPUT", 4096+0x7E0) -- 4096 указывает на запись MIDI, 0 = все каналы
		reaper.SetMediaTrackInfo_Value(track, "I_RECMON", 1)
		Add_FX(fx_name, preset_name, plugin_state)
	end
	reaper.Undo_EndBlock("Вставить трек", -1)
end
-- ##################################################
-- ##################################################
-- calculateDelayJoinOptions
function calculateDelayJoinOptions(options)
    return table.concat(options, "\0") .. "\0"
end

-- calculateDelay
-- Функция для вычисления задержки в миллисекундах относительно BPM и деления
function calculateDelay(bpm, division, mode)
    local divisions = {
        ["1"] = 1, ["1/2"] = 2, ["1/4"] = 4, ["1/8"] = 8, ["1/16"] = 16, ["1/32"] = 32, ["1/64"] = 64, ["1/128"] = 128
    }
    local multiplier = 1
    if mode == "Triplet" then
        multiplier = 2 / 3
    elseif mode == "Dotted" then
        multiplier = 3 / 2
    end
    return (240000 / (bpm * divisions[division])) * multiplier
end
-- ##################################################
-- ##################################################
-- ToggleBypassFXPluginsOnSelectedTrack
local state_section = "TogglePluginsOnSelectedTrack"
local TogglePluginsOnSelectedTrack_key_plugin1 = "TogglePluginName1"
local TogglePluginsOnSelectedTrack_key_plugin2 = "TogglePluginName2"

-- Загружаем сохраненные имена плагинов
local TogglePluginsOnSelectedTrack_plugin_name1 = reaper.GetExtState(state_section, TogglePluginsOnSelectedTrack_key_plugin1) or ""
local TogglePluginsOnSelectedTrack_plugin_name2 = reaper.GetExtState(state_section, TogglePluginsOnSelectedTrack_key_plugin2) or ""

function ToggleBypassFXPluginsOnSelectedTrack(TogglePluginsOnSelectedTrack_plugin_name1, TogglePluginsOnSelectedTrack_plugin_name2)
    -- Получаем количество выделенных треков в проекте
    local num_selected_tracks = reaper.CountSelectedTracks(0)
    
    -- Проходим по всем выделенным трекам
    for i = 0, num_selected_tracks - 1 do
        local track = reaper.GetSelectedTrack(0, i)
        local num_fx = reaper.TrackFX_GetCount(track)
        
        local plugin1_index = -1
        local plugin2_index = -1
        local plugin1_enabled = false
        local plugin2_enabled = false
        
        -- Проходим по всем FX на текущем треке
        for j = 0, num_fx - 1 do
            local retval, fx_name = reaper.TrackFX_GetFXName(track, j, "")
            
            -- Проверяем, совпадает ли имя FX с первым заданным именем плагина
            if fx_name == TogglePluginsOnSelectedTrack_plugin_name1 then
                plugin1_index = j
                plugin1_enabled = reaper.TrackFX_GetEnabled(track, j)
            end
            
            -- Проверяем, совпадает ли имя FX со вторым заданным именем плагина
            if fx_name == TogglePluginsOnSelectedTrack_plugin_name2 then
                plugin2_index = j
                plugin2_enabled = reaper.TrackFX_GetEnabled(track, j)
            end
        end
        
        -- Переключаем состояние плагинов, если они оба найдены
        if plugin1_index ~= -1 and plugin2_index ~= -1 then
            reaper.TrackFX_SetEnabled(track, plugin1_index, not plugin1_enabled)
            reaper.TrackFX_SetEnabled(track, plugin2_index, plugin1_enabled)
        end
    end
end
-- ##################################################
-- ##################################################
-- ##################################################
-- ##################################################
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
-- ##################################################
-- ##################################################
-- CreateCommandCheckbox
-- Функция для создания чекбокса и управления командой
function CreateCommandCheckbox(command_id, checkbox_label)
	-- Проверка текущего состояния команды
	local state = reaper.GetToggleCommandState(command_id) == 1

	-- Отрисовка чекбокса
	local clicked, new_state = reaper.ImGui_Checkbox(ctx, checkbox_label, state)

	-- Если пользователь изменил состояние чекбокса, переключаем команду
	if clicked and (new_state ~= state) then
		reaper.Main_OnCommand(command_id, 0)
	end
end
-- ##################################################
-- ##################################################
-- HexToImGuiColor
-- Конвертер цвета из формата #RRGGBB в формат, ожидаемый ImGui
function HexToImGuiColor(hex_color)
    local r = tonumber(string.sub(hex_color, 2, 3), 16) / 255
    local g = tonumber(string.sub(hex_color, 4, 5), 16) / 255
    local b = tonumber(string.sub(hex_color, 6, 7), 16) / 255
    return reaper.ImGui_ColorConvertDouble4ToU32(r, g, b, 1.0) -- Альфа всегда 1.0
end
-- ##################################################
-- ##################################################
-- HexToBGR
-- Конвертер цвета из формата #RRGGBB в BGR
function HexToBGR(hex_color)
    local r = tonumber(string.sub(hex_color, 2, 3), 16)
    local g = tonumber(string.sub(hex_color, 4, 5), 16)
    local b = tonumber(string.sub(hex_color, 6, 7), 16)
    return (b << 16) | (g << 8) | r
end
-- ##################################################
-- ##################################################
-- SetSelectedItemToPresetColor
-- Переменная для отображения сообщений
local modeTrackAndItemPresetColorChanger = "track" -- Режим по умолчанию -- track -- item
local last_message_for_item_preset_color = ""
-- ##################################################
-- ##################################################
-- SetSelectedItemsColor
-- Установка цвета выбранных айтемов
function SetSelectedItemsColor(hex_color)
	local color_bgr = HexToBGR(hex_color)
	local num_items = reaper.CountSelectedMediaItems(0)
	if num_items > 0 then
		for i = 0, num_items - 1 do
			local item = reaper.GetSelectedMediaItem(0, i)
			local take = reaper.GetActiveTake(item)
			
			-- Применить цвет к айтему (важно для Empty Item)
			reaper.SetMediaItemInfo_Value(item, "I_CUSTOMCOLOR", color_bgr | 0x1000000)

			-- Применить цвет к take (важно для аудио/MIDI)
			if take then
				reaper.SetMediaItemTakeInfo_Value(take, "I_CUSTOMCOLOR", color_bgr | 0x1000000)
			end

			reaper.UpdateItemInProject(item)
		end
		reaper.UpdateArrange()
		return ""
	else
		return "No Selected Items"
	end
end
-- ##################################################
-- ##################################################
-- SetSelectedTracksColor
-- Установка цвета выбранных треков
function SetSelectedTracksColor(hex_color)
    local color_bgr = HexToBGR(hex_color)
    local num_tracks = reaper.CountSelectedTracks(0)
    if num_tracks > 0 then
        for i = 0, num_tracks - 1 do
            local track = reaper.GetSelectedTrack(0, i)
            reaper.SetTrackColor(track, color_bgr)
        end
        reaper.UpdateArrange()
        return ""
    else
        return "No Selected Tracks"
    end
end
-- ##################################################
-- ##################################################
-- DrawColorBoxPresetColor
-- Отображение кнопок цвета
function DrawColorBoxPresetColor(ctx, hex_color, width, height, add_same_line, mode)
    local r, g, b = tonumber(string.sub(hex_color, 2, 3), 16) / 255, tonumber(string.sub(hex_color, 4, 5), 16) / 255, tonumber(string.sub(hex_color, 6, 7), 16) / 255
    local color_u32 = reaper.ImGui_ColorConvertDouble4ToU32(r, g, b, 1.0)

    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Button(), color_u32)
    local message
    if reaper.ImGui_Button(ctx, "##ColorBox_" .. hex_color, width, height) then
        if mode == "item" then
            message = SetSelectedItemsColor(hex_color)
        elseif mode == "track" then
            message = SetSelectedTracksColor(hex_color)
        end
    end
    reaper.ImGui_PopStyleColor(ctx)

    if add_same_line then
        reaper.ImGui_SameLine(ctx)
    end

    return message
end
-- ##################################################
-- ##################################################
function DrawColorBoxPresetColor2(ctx, hex_color, width, height, add_same_line, mode)
	local r, g, b = tonumber(string.sub(hex_color, 2, 3), 16) / 255, tonumber(string.sub(hex_color, 4, 5), 16) / 255, tonumber(string.sub(hex_color, 6, 7), 16) / 255
	local color_u32 = reaper.ImGui_ColorConvertDouble4ToU32(r, g, b, 1.0)

	reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Button(), color_u32)
	reaper.ImGui_Button(ctx, "##ColorBox_" .. hex_color, width, height) 
	reaper.ImGui_PopStyleColor(ctx)

	if add_same_line then
		reaper.ImGui_SameLine(ctx)
	end
end
-- ##################################################
-- ##################################################
-- Функции для конвертации цвета
-- RGBToBGR
local function RGBToBGR(color)
    local r = (color & 0xFF0000) >> 16
    local g = (color & 0x00FF00) >> 8
    local b = (color & 0x0000FF)
    return (b << 16) | (g << 8) | r
end

-- BGRToRGB
local function BGRToRGB(color)
    local b = (color & 0xFF0000) >> 16
    local g = (color & 0x00FF00) >> 8
    local r = (color & 0x0000FF)
    return (r << 16) | (g << 8) | b
end

-- Функция для обновления интерфейса
local modeTrackAndItemColorChanger = 'track'
-- TrackAndItemColorChanger
function TrackAndItemColorChanger()
	-- Кнопки сброса цвета видны всегда
	if reaper.ImGui_Button(ctx, " Reset Track Colors ", 0, 30) then
		reaper.Main_OnCommand(40359, 0) -- Track: Set to default color
	end
	reaper.ImGui_SameLine(ctx)
	if reaper.ImGui_Button(ctx, " Reset Item Colors ", 0, 30) then
		reaper.Main_OnCommand(41333, 0) -- Take: Set active take to default color
		reaper.Main_OnCommand(40707, 0) -- Item: Set to default color
	end
	reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства

	reaper.ImGui_Text(ctx, "Select mode:")
	reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
	if reaper.ImGui_RadioButton(ctx, "Track", modeTrackAndItemColorChanger == 'track') then
		modeTrackAndItemColorChanger = 'track'
	end
	reaper.ImGui_SameLine(ctx)
	if reaper.ImGui_RadioButton(ctx, "Item", modeTrackAndItemColorChanger == 'item') then
		modeTrackAndItemColorChanger = 'item'
	end

	reaper.ImGui_Spacing(ctx)

	if modeTrackAndItemColorChanger == 'track' then
		local track_count = reaper.CountSelectedTracks(0)
		if track_count > 0 then
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			reaper.ImGui_Text(ctx, "Track mode")
			local track = reaper.GetSelectedTrack(0, 0)
			local nativeColor = reaper.GetTrackColor(track)
			color = BGRToRGB(nativeColor)

			-- Tracks Color
			reaper.ImGui_SetNextItemWidth(ctx, 255) -- Установить ширину палитры
			local rv
			rv, color = reaper.ImGui_ColorPicker3(ctx, " ", color, reaper.ImGui_ColorEditFlags_NoSidePreview())
			if rv then
				for i = 0, track_count - 1 do
					local track = reaper.GetSelectedTrack(0, i)
					reaper.SetTrackColor(track, RGBToBGR(color))
				end
			end
		else
			reaper.ImGui_Text(ctx, "No track selected")
		end
	elseif modeTrackAndItemColorChanger == 'item' then
		local item_count = reaper.CountSelectedMediaItems(0)
		if item_count > 0 then
			reaper.ImGui_Dummy(ctx, 0, 5) -- Добавление вертикального пространства
			reaper.ImGui_Text(ctx, "Item mode")

			local item = reaper.GetSelectedMediaItem(0, 0)

			if item then
				local take = reaper.GetActiveTake(item)
				local nativeColor = reaper.GetMediaItemTakeInfo_Value(take, "I_CUSTOMCOLOR")
				local color = BGRToRGB(nativeColor)

				-- Items Color
				reaper.ImGui_SetNextItemWidth(ctx, 255) -- Установить ширину палитры
				local rv
				rv, color = reaper.ImGui_ColorPicker3(ctx, " ", color, reaper.ImGui_ColorEditFlags_NoSidePreview())
				if rv then
					for i = 0, item_count - 1 do
						local item = reaper.GetSelectedMediaItem(0, i)
						local take = reaper.GetActiveTake(item)

						if take then
							reaper.SetMediaItemTakeInfo_Value(take, "I_CUSTOMCOLOR", RGBToBGR(color) | 0x1000000)
							-- reaper.SetMediaItemInfo_Value(item, "I_CUSTOMCOLOR", RGBToBGR(color) | 0x1000000)
							reaper.UpdateItemInProject(item)
						end
					end
				end
			else
				reaper.ImGui_Text(ctx, "No active take found")
			end
		else
			reaper.ImGui_Text(ctx, "No item selected")
		end
	end
end
-- Функция для изменения цвета трека и айтема
-- ##################################################
-- ##################################################
-- GetDurationBetweenLocatorsGivenPlayrate
function GetDurationBetweenLocatorsGivenPlayrate()
    -- Функция для получения значения Playrate из огибающей на мастер-треке
    local function GetMasterTrackPlayrate()
        -- Получаем трек мастер-шины (Track 0 — это мастер-трек)
        local master_track = reaper.GetMasterTrack(0)

        -- Находим огибающую Playrate на мастер-треке
        local playrate_envelope = reaper.GetTrackEnvelopeByName(master_track, "Playrate")

        if playrate_envelope then
            -- Получаем текущее положение курсора (позиция в секундах)
            local cursor_position = reaper.GetCursorPosition()
            
            -- Получаем значение Playrate из огибающей в текущей позиции курсора
            local retval, playrate_value, _, _ = reaper.Envelope_Evaluate(playrate_envelope, cursor_position, 0, 0)
            
            -- Возвращаем значение Playrate
            return playrate_value
        else
            -- Если огибающая не найдена, возвращаем стандартное значение Playrate (1.0)
            return 1.0
        end
    end

    -- Получаем позицию начального и конечного локаторов
    local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)

    -- Рассчитываем длительность между локаторами
    local duration = end_time - start_time

    -- Получаем значение Playrate из огибающей
    local playrate = GetMasterTrackPlayrate()

    -- Учитываем Playrate при расчёте длительности
    local adjusted_duration = duration / playrate

    -- Переводим длительность в пикосекунды (1 секунда = 1 000 000 000 000 пикосекунд)
    local duration_in_picoseconds = adjusted_duration * 1000000000000

    -- Пороговое значение для последней секунды
    local lower_threshold = 959145085969  -- Порог для округления в меньшую сторону
    local upper_threshold = 966551717158  -- Порог для округления в большую сторону

    -- Проверяем длительность в пикосекундах
    local fractional_seconds = adjusted_duration % 1  -- Получаем дробную часть
    local milliseconds = fractional_seconds * 1000  -- Преобразуем в миллисекунды

    -- Округление в зависимости от порога
    if milliseconds < 959 then
        adjusted_duration = math.floor(adjusted_duration)  -- Округляем в меньшую сторону
    elseif milliseconds > 966 then
        adjusted_duration = math.ceil(adjusted_duration)  -- Округляем в большую сторону
    else
        adjusted_duration = math.floor(adjusted_duration)  -- Округляем в меньшую сторону
    end

    -- Переводим в часы, минуты и секунды
    local hours = math.floor(adjusted_duration / 3600)
    local minutes = math.floor((adjusted_duration % 3600) / 60)
    local seconds = math.floor(adjusted_duration % 60) -- Округляем seconds до целого числа

    -- Форматируем вывод в 00:00:02
    local formatted_duration = string.format("%02d:%02d:%02d", hours, minutes, seconds)

    -- Выводим результат
	return formatted_duration
    -- reaper.ShowMessageBox(user_message .. formatted_duration, "Время между " .. object_name, 0)
end
-- ##################################################
-- ##################################################
-- GetExactDurationBetweenLocatorsGivenPlayrate
function GetExactDurationBetweenLocatorsGivenPlayrate()
    -- Функция для получения значения Playrate из огибающей на мастер-треке
    local function GetMasterTrackPlayrate()
        local master_track = reaper.GetMasterTrack(0)
        local playrate_envelope = reaper.GetTrackEnvelopeByName(master_track, "Playrate")

        if playrate_envelope then
            local cursor_position = reaper.GetCursorPosition()
            local retval, playrate_value, _, _ = reaper.Envelope_Evaluate(playrate_envelope, cursor_position, 0, 0)
            return playrate_value
        else
            return 1.0
        end
    end

    -- Получаем позиции начального и конечного локаторов
    local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
    local duration = end_time - start_time
    local playrate = GetMasterTrackPlayrate()

    -- Учитываем Playrate при расчёте длительности
    local adjusted_duration = duration / playrate

    -- Переводим в часы, минуты, секунды и миллисекунды
    local hours = math.floor(adjusted_duration / 3600)
    local minutes = math.floor((adjusted_duration % 3600) / 60)
    local seconds = math.floor(adjusted_duration % 60)
    local milliseconds = math.floor((adjusted_duration * 1000) % 1000)

    -- Форматируем вывод в 05:04:03.002
    local formatted_duration = string.format("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)

    -- Выводим результат
	return formatted_duration
    -- reaper.ShowMessageBox(user_message .. formatted_duration, "Время между " .. object_name, 0)
end
-- ##################################################
-- ##################################################
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
-- ##################################################
-- ##################################################
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
-- ##################################################
-- ##################################################
-- GetMarkerPositionByName
function GetMarkerPositionByName(marker_name)
	local marker_index = 0
	while true do
		local retval, is_region, pos, rgn_end, name, markr_idx = reaper.EnumProjectMarkers(marker_index)

		-- Если маркеры закончились, выходим из функции
		if retval == 0 then
			return nil
		end

		-- Если найден маркер с нужным именем, возвращаем его позицию
		if name == marker_name then
			return pos
		end

		marker_index = marker_index + 1
	end
end
-- ##################################################
-- ##################################################
-- GetDurationBetweenMarkersGivenPlayrate
function GetDurationBetweenMarkersGivenPlayrate ()
	local start_marker_position = GetMarkerPositionByName("=START")
	local end_marker_position = GetMarkerPositionByName("=END")
	
	if start_marker_position and end_marker_position and start_marker_position < end_marker_position then
		-- if start_marker_position < end_marker_position then
			reaper.GetSet_LoopTimeRange(true, false, start_marker_position, end_marker_position, false)
			duration = GetDurationBetweenLocatorsGivenPlayrate()
			reaper.Main_OnCommand(40635, 0) -- Time selection: Remove (unselect) time selection
			return duration
		-- end
	else
		return "00:00:00"
	end
end
-- ##################################################
-- ##################################################
-- GetExactDurationBetweenMarkersGivenPlayrate
function GetExactDurationBetweenMarkersGivenPlayrate ()
	local start_marker_position = GetMarkerPositionByName("=START")
	local end_marker_position = GetMarkerPositionByName("=END")
	
	if start_marker_position and end_marker_position and start_marker_position < end_marker_position then
		-- if start_marker_position < end_marker_position then
			reaper.GetSet_LoopTimeRange(true, false, start_marker_position, end_marker_position, false)
			duration = GetExactDurationBetweenLocatorsGivenPlayrate()
			reaper.Main_OnCommand(40635, 0) -- Time selection: Remove (unselect) time selection
			return duration
		-- end
	else
		return "00:00:00"
	end
end
-- ##################################################
-- ##################################################
-- SetTimeSelectionByMarkers
function SetTimeSelectionByMarkers ()
	local start_marker_position = GetMarkerPositionByName("=START")
	local end_marker_position = GetMarkerPositionByName("=END")
	
	if start_marker_position and end_marker_position and start_marker_position < end_marker_position then
		-- if start_marker_position < end_marker_position then
			reaper.GetSet_LoopTimeRange(true, false, start_marker_position, end_marker_position, false)
			-- duration = GetDurationBetweenLocatorsGivenPlayrate()
			-- reaper.Main_OnCommand(40635, 0) -- Time selection: Remove (unselect) time selection
			-- return duration
		-- end
	else
		-- return "00:00:00"
	end
end
-- ##################################################
-- ##################################################
-- Функция для преобразования времени в миллисекунды
function timeToMilliseconds(timeString)
    local h, m, s, ms = timeString:match("(%d+):(%d+):(%d+)%.(%d+)")
    if h and m and s and ms then
        return (tonumber(h) * 3600 + tonumber(m) * 60 + tonumber(s)) * 1000 + tonumber(ms)
    end
    return 0
end
-- ##################################################
-- ##################################################
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
-- ##################################################
-- ##################################################
-- EditCursorPositionHoursMinutesSecondsMilliseconds
function EditCursorPositionHoursMinutesSecondsMilliseconds()
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
-- ##################################################
-- ##################################################
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
-- ##################################################
-- ##################################################
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
-- ##################################################
-- ##################################################
-- ShowMenuItems
local selected_content = "Frequent_Content_Show" -- Color_Content_Show / Frequent_Content_Show

local current_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiCurrentMenuItem")
local default_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiDefaultMenuItem")
if current_menu_item_imgui == "" then
	reaper.SetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiCurrentMenuItem", selected_content, true)
end
if default_menu_item_imgui == "" then
	reaper.SetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiDefaultMenuItem", selected_content, true)
else
	selected_content = default_menu_item_imgui
end

function ShowMenuItems(items)
	
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
					reaper.Main_OnCommand(reaper.NamedCommandLookup(item.action_id), 0)
				elseif item.action_function then
					item.action_function()
				elseif item.show_content then
					selected_content = item.show_content
					reaper.SetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiCurrentMenuItem", selected_content, true)
				end
					reaper.JS_Window_SetFocus(reaper.GetMainHwnd())
					reaper.JS_Window_SetForeground(reaper.GetMainHwnd())
			end
		end
	end
end
-- ##################################################
-- ##################################################
function SetDefaultMenuItemImGui ()
	current_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiCurrentMenuItem")
	reaper.SetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiDefaultMenuItem", current_menu_item_imgui, true)
	-- print_rs ( current_menu_item_imgui )
end
-- ##################################################
-- ##################################################
-- Загружаем шрифты с разными размерами
local font_size_verdana_18 = reaper.ImGui_CreateFont('verdana', 18)  -- Маленький шрифт
local font_size_verdana_20 = reaper.ImGui_CreateFont('verdana', 20)
local font_size_verdana_22 = reaper.ImGui_CreateFont('verdana', 22)
local font_size_verdana_24 = reaper.ImGui_CreateFont('verdana', 24)
local font_size_verdana_26 = reaper.ImGui_CreateFont('verdana', 26)
local font_size_verdana_28 = reaper.ImGui_CreateFont('verdana', 28)
local font_size_verdana_30 = reaper.ImGui_CreateFont('verdana', 30)
local font_size_verdana_32 = reaper.ImGui_CreateFont('verdana', 32)
local font_size_verdana_chord = reaper.ImGui_CreateFont('verdana', 50)

-- Присоединяем шрифты к контексту
reaper.ImGui_Attach(ctx, font_size_verdana_18)
reaper.ImGui_Attach(ctx, font_size_verdana_20)
reaper.ImGui_Attach(ctx, font_size_verdana_22)
reaper.ImGui_Attach(ctx, font_size_verdana_24)
reaper.ImGui_Attach(ctx, font_size_verdana_26)
reaper.ImGui_Attach(ctx, font_size_verdana_28)
reaper.ImGui_Attach(ctx, font_size_verdana_30)
reaper.ImGui_Attach(ctx, font_size_verdana_32)
reaper.ImGui_Attach(ctx, font_size_verdana_chord)
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
	{label = "Menu", children = {
		{label = "Delay Calculator", show_content = "Delay_Calculator_Content_Show"},
			-- {is_separator = true}, -- Разделитель
			{spacing_vertical = "0"},
			{separator_horizontal = "2", separator_color = "#6B6B7A" },
			{spacing_vertical = "7"},
		{label = "Chord", children = {
			{label = "Chord Detection", show_content = "Chord_Detection_Content_Show"},
			{label = "Insert Item Chord", show_content = "Insert_Item_Chord_Content_Show"},
		}},
		{label = "Color", children = {
			{label = "ImGui Color Picker", show_content = "Color_Picker_Content_Show"},
			{label = "ImGui Color Preset", show_content = "Color_Preset_Content_Show"},
			-- {is_separator = true}, -- Разделитель
			{spacing_vertical = "0"},
			{separator_horizontal = "2", separator_color = "#6B6B7A" },
			{spacing_vertical = "7"},
			{label = "Theme development: Show theme tweak configuration window", action_id = "41930"},
			{label = "View: Show peaks display settings", action_id = "42074"},
			{label = "Options: Show theme adjuster", action_id = "42234"},
			{label = "Options: Show theme color controls", action_id = "42392"},
			{label = "Gui; Color switch", action_id = "_RS251990727759d3dff9cf84df740cd6a87ea0d169"},
		}},
		{label = "Envelope", children = {
			{label = "Envelope Automation", show_content = "Envelope_Automation_Content_Show"},
			{label = "Envelope Points", show_content = "Envelope_Points_Content_Show"},
		}},
		{label = "Grid", show_content = "Grid_Content_Show"},
		{label = "Item", children = {
			{label = "Other", show_content = "Other_Content_Show"},
			-- {is_separator = true}, -- Разделитель
			{spacing_vertical = "0"},
			{separator_horizontal = "2", separator_color = "#6B6B7A" },
			{spacing_vertical = "7"},
			{label = "Automation", show_content = "Item_Automation_Content_Show"},
			{label = "Delete", show_content = "Item_Select_Delete_Content_Show"},
			{label = "Grouping", show_content = "Item_Grouping_Content_Show"},
			{label = "Length", show_content = "Item_Length_Content_Show"},
			{label = "Marker", show_content = "Marker_Content_Show"},
			{label = "Move", show_content = "Item_Move_Content_Show"},
			{label = "Navigation", show_content = "Item_Navigation_Content_Show"},
			{label = "Pitch", show_content = "Item_Pitch_Content_Show"},
			{label = "Quantize", show_content = "Quantize_Content_Show"},
			{label = "Rate", show_content = "Item_Rate_Content_Show"},
			{label = "Sample Amplitude At Edit Cursor", action_function = function() print_rs ( GetSampleAmplitudeAtEditCursor() ) end},
			{label = "Select", show_content = "Select_Items_Content_Show"},
			{label = "Set Channel", show_content = "Item_Set_Channel_Content_Show"},
			{label = "Sibilance", show_content = "Sibilance_Content_Show"},
			{label = "Spectrogram", show_content = "Spectrogram_Content_Show"},
			{label = "Split", show_content = "SplitSelectItemsOfEditCursor_Content_Show"},
			{label = "Stretch Marker", show_content = "Stretch_Marker_Content_Show"},
			{label = "Volume", show_content = "Item_Volume_Content_Show"},
		}},
		{label = "TimeBase", show_content = "TimeBase_Content_Show"},
		{label = "Tempo Envelope", show_content = "Tempo_Envelope_Content_Show"},
		{label = "Track", children = {
			{label = "Automation", show_content = "Track_Automation_Content_Show"},
			{label = "Insert Empty Item Chord", show_content = "Insert_Empty_Item_Chord_Content_Show"},
			{label = "Set track grouping parameters", action_function = function() reaper.Main_OnCommand(40772, 0) end}, -- Track: Set track grouping parameters
			{label = "Set Name", show_content = "Track_Set_Name_Content_Show"},
			{label = "Records", show_content = "Track_Records_Content_Show"},
			{spacing_vertical = "0"},
			{separator_horizontal = "2", separator_color = "#6B6B7A" },
			{spacing_vertical = "7"},
			{label = "Move Muted Items To New Track", action_function = function() MoveMutedItemsToNewTrack () end},
			{label = "Create Folder Track And Move Selected Tracks", action_function = function() CreateFolderTrackAndMoveSelectedTracks () end},
			{label = "Create Track Relative To Selected (higher)", action_function = function() CreateTrackRelativeToSelected ("higher") end},
			{label = "Create Track Relative To Selected (below)", action_function = function() CreateTrackRelativeToSelected ("below") end},
		}},
		{label = "Transport", show_content = "Transport_Content_Show"},
		{label = "Midi", children = {
			{label = "Midi", show_content = "Midi_Content_Show"},
		}},
		{label = "Marker", show_content = "Marker_Content_Show"},
		{label = "Mouse Modifier", show_content = "Mouse_Modifier_Content_Show"},
		{label = "Region", children = {
			{label = "Region Various", show_content = "Region_Various_Content_Show"},
			{label = "Region For PlayBack", show_content = "Region_For_PlayBack_Content_Show"},
		}},
		{label = "Settings Reaper", show_content = "Settings_Reaper_Content_Show"},
		
	}},
	{label = "FX", children = {
		{label = "Frequent", show_content = "Frequent_Content_Show"},
		{label = "Toggle FX Plugins", show_content = "ToggleBypassFXPluginsOnSelectedTrack_Content_Show"},
		-- {is_separator = true}, -- Разделитель
		{spacing_vertical = "0"},
		{separator_horizontal = "2", separator_color = "#6B6B7A" },
		{spacing_vertical = "7"},
		{label = "FX Plugins", children = {
			{label = "FX Plugins", show_content = "FX_Plugins_Content_Show"},
			-- {is_separator = true}, -- Разделитель
			{spacing_vertical = "0"},
			{separator_horizontal = "2", separator_color = "#6B6B7A" },
			{spacing_vertical = "7"},
			{label = "ReaEQ", action_function = function() Add_FX ("ReaEQ (Cockos)", "MaxMusicMax — Default") end },
			{label = "ReaDelay", action_function = function() Add_FX ("ReaDelay (Cockos)", "") end },
			{label = "ReaPitch", action_function = function() Add_FX ("ReaPitch (Cockos)", "") end },
			{label = "ReaGate", action_function = function() Add_FX ("ReaGate (Cockos)", "") end },
			-- {is_separator = true}, -- Разделитель
			{spacing_vertical = "0"},
			{separator_horizontal = "2", separator_color = "#6B6B7A" },
			{spacing_vertical = "7"},
			{label = "Pro-Q 3 (FabFilter)", action_function = function() Add_FX ("Pro-Q 3 (FabFilter)", "") end },
			{label = "Pro-DS (FabFilter)", action_function = function() Add_FX ("Pro-DS (FabFilter)", "") end },
			{label = "Pro-C 2 (FabFilter)", action_function = function() Add_FX ("Pro-C 2 (FabFilter)", "") end },
			{label = "Pro-L 2 (FabFilter)", action_function = function() Add_FX ("Pro-L 2 (FabFilter)", "") end },
			{label = "Pro-MB (FabFilter)", action_function = function() Add_FX ("Pro-MB (FabFilter)", "") end },
			{label = "Pro-R (FabFilter)", action_function = function() Add_FX ("Pro-R (FabFilter)", "") end },
			{label = "Timeless 3 (FabFilter)", action_function = function() Add_FX ("Timeless 3 (FabFilter)", "") end },
			{label = "Saturn 2 (FabFilter)", action_function = function() Add_FX ("Saturn 2 (FabFilter)", "") end },
			-- {is_separator = true}, -- Разделитель
			{spacing_vertical = "0"},
			{separator_horizontal = "2", separator_color = "#6B6B7A" },
			{spacing_vertical = "7"},
			{label = "soothe2 (oeksound)", action_function = function() Add_FX ("soothe2 (oeksound)", "") end },
			{label = "ValhallaVintageVerb", action_function = function() Add_FX ("ValhallaVintageVerb (Valhalla DSP, LLC)", "") end },
			-- {label = "www", action_function = function() Add_FX ("www", "") end },
		}},
		{label = "VST Instruments", children = {
			{label = "VST Instruments", show_content = "VST_Instruments_Content_Show"},
			-- {is_separator = true}, -- Разделитель
			{spacing_vertical = "0"},
			{separator_horizontal = "2", separator_color = "#6B6B7A" },
			{spacing_vertical = "7"},
			{label = "Track For MIDI", action_function = function() EnableMidiModeOnTheTrack (1) end },
			{label = "Track Default", action_function = function() EnableMidiModeOnTheTrack (0) end },
			-- {is_separator = true}, -- Разделитель
			{spacing_vertical = "0"},
			{separator_horizontal = "2", separator_color = "#6B6B7A" },
			{spacing_vertical = "7"},
			{label = "ReaControlMIDI (Cockos)", action_function = function() EnableMidiModeOnTheTrack (1, "ReaControlMIDI (Cockos)", "") end },
			{label = "ReaSamplOmatic5000 (Cockos)", action_function = function() EnableMidiModeOnTheTrack (1, "ReaSamplOmatic5000 (Cockos)", "") end },
			{label = "ReaSynth (Cockos)", action_function = function() EnableMidiModeOnTheTrack (1, "ReaSynth (Cockos)", "") end },
			-- {is_separator = true}, -- Разделитель
			{spacing_vertical = "0"},
			{separator_horizontal = "2", separator_color = "#6B6B7A" },
			{spacing_vertical = "7"},
			{label = "Virtual Sound Canvas", action_function = function() EnableMidiModeOnTheTrack (1, "Virtual Sound Canvas (x86) (EDIROL) (8 out)", "") end },
			{label = "Serum (Xfer Records)", action_function = function() EnableMidiModeOnTheTrack (1, "Serum (Xfer Records)", "") end },
			{label = "Vital (Vital Audio)", action_function = function() EnableMidiModeOnTheTrack (1, "Vital (Vital Audio)", "") end },
			{label = "Phase Plant (Kilohearts)", action_function = function() EnableMidiModeOnTheTrack (1, "Phase Plant (Kilohearts)", "") end },
			{label = "Kontakt 7 (Native Instruments)", action_function = function() EnableMidiModeOnTheTrack (1, "Kontakt 7 (Native Instruments) (64 out)", "") end },
			-- {label = "www", action_function = function() EnableMidiModeOnTheTrack (1, "www", "") end },
		}},
		--[[
		{label = "Example", children = {
			{label = "Color 1", action_function = function() reaper.ShowMessageBox("Color 1 selected", "Information", 0) end},
			{label = "Color 2", action_function = function() reaper.ShowMessageBox("Color 2 selected", "Information", 0) end},
			{label = "Content 1", show_content = "Content_1_Content_Show"},
			{label = "Content 2", show_content = "Content_2_Content_Show"},
			{label = "Options: Preferences", action_id = "40016"},
			{label = "Gui; Color switch", action_id = "_RS251990727759d3dff9cf84df740cd6a87ea0d169"},
		}},
		]]--
	}},
	{label = "Settings", children = {
		{label = "Set Default Tab ImGui", action_function = function() SetDefaultMenuItemImGui () end},
		{label = "Set Alpha Tab ImGui", show_content = "Alpha_Window_ImGui_Content_Show"},
	}},
}
-- ##################################################
-- ##################################################
local modeReNameTrackItem = "track"
-- ##################################################
-- ##################################################
local alpha_window_ImGui = tonumber(reaper.GetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiAlphaWindow")) or 0.6
-- local alpha_window_ImGui = 0.6  -- Прозрачность окна (0.0 - полностью прозрачное, 1.0 - полностью непрозрачное)
-- function main
local name_window = "· · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·"
local function main()
	reaper.ImGui_SetNextWindowBgAlpha(ctx, alpha_window_ImGui) -- Установить прозрачность фона окна
	reaper.ImGui_PushFont (ctx, font_size_verdana_18)
	
	local visible, open = reaper.ImGui_Begin(ctx, name_window, true, reaper.ImGui_WindowFlags_MenuBar())
	
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
		-- menu_structure___
		if selected_content == "" then
		elseif selected_content == "Content_1_Content_Show" then
			reaper.ImGui_Text(ctx, "Content 1")
		elseif selected_content == "Content_2_Content_Show" then
			reaper.ImGui_Text(ctx, "Content 2")
		elseif selected_content == "Color_Preset_Content_Show" then
			reaper.ImGui_SeparatorText(ctx, "ImGui Color Preset")
			
			if reaper.ImGui_Button(ctx, " Reset Colors ", 200, 40) then
				if modeTrackAndItemPresetColorChanger == "item" then
					reaper.Main_OnCommand(41333, 0) -- Take: Set active take to default color
					reaper.Main_OnCommand(40707, 0) -- Item: Set to default color
				elseif modeTrackAndItemPresetColorChanger == "track" then
					reaper.Main_OnCommand(40359, 0) -- Track: Set to default color
					reaper.Main_OnCommand(40297, 0) -- Unselect all tracks
				end
			end
			reaper.ImGui_Dummy(ctx, 0, 5)

			-- Режим работы
			-- reaper.ImGui_SeparatorText(ctx, "Select mode:")
			reaper.ImGui_Text(ctx, "Select mode:")
			reaper.ImGui_Dummy(ctx, 0, 5)
			if reaper.ImGui_RadioButton(ctx, "Track", modeTrackAndItemPresetColorChanger == "track") then
				modeTrackAndItemPresetColorChanger = "track"
			end
			reaper.ImGui_SameLine(ctx)
			if reaper.ImGui_RadioButton(ctx, "Item", modeTrackAndItemPresetColorChanger == "item") then
				modeTrackAndItemPresetColorChanger = "item"
			end
			reaper.ImGui_Dummy(ctx, 0, 10)

			-- Сообщение
			local reserved_height = 20
			if last_message_for_item_preset_color ~= "" then
				reaper.ImGui_TextColored(ctx, HexToImGuiColor("#FF0000"), last_message_for_item_preset_color)
			else
				reaper.ImGui_Text(ctx, "Select items or tracks and apply a color.")
			end
			reaper.ImGui_Dummy(ctx, 0, reserved_height - reaper.ImGui_GetTextLineHeight(ctx))

			-- Цветовые кнопки
			local message
			message = DrawColorBoxPresetColor(ctx, "#3EA8FF", 50, 50, true, modeTrackAndItemPresetColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#FFA74F", 50, 50, true, modeTrackAndItemPresetColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#37E14D", 50, 50, false, modeTrackAndItemPresetColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#0079DD", 50, 50, true, modeTrackAndItemPresetColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#DF7000", 50, 50, true, modeTrackAndItemPresetColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#0B9F1A", 50, 50, false, modeTrackAndItemPresetColorChanger) or message
			reaper.ImGui_Dummy(ctx, 0, 25)

			message = DrawColorBoxPresetColor(ctx, "#7A3B3B", 50, 50, true, modeTrackAndItemPresetColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#483F5F", 50, 50, true, modeTrackAndItemPresetColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#593B61", 50, 50, true, modeTrackAndItemPresetColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#532F40", 50, 50, false, modeTrackAndItemPresetColorChanger) or message

			message = DrawColorBoxPresetColor(ctx, "#6D502C", 50, 50, true, modeTrackAndItemPresetColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#39557A", 50, 50, true, modeTrackAndItemPresetColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#58713D", 50, 50, true, modeTrackAndItemPresetColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#3A6864", 50, 50, false, modeTrackAndItemPresetColorChanger) or message

			if message then last_message_for_item_preset_color = message end
			
		elseif selected_content == "Insert_Item_Chord_Content_Show" then
			reaper.ImGui_SeparatorText(ctx, "Insert Item Chord")
			
			cboc2(" Insert Item Chord ", function()
				selected_content = "Insert_Empty_Item_Chord_Content_Show"
				reaper.SetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiCurrentMenuItem", selected_content, true) 
			end, 0, 25)
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			
			reaper.ImGui_InputText(ctx, '##nameNote',  get_playing_midi(true) or "" )
			
			local transpose_value_ulaYkZjtGm = reaper.GetExtState("insert_item_chord_ulaYkZjtGm", "transpose_value_ulaYkZjtGm")
			transpose_value_ulaYkZjtGm = (transpose_value_ulaYkZjtGm ~= "" and tonumber(transpose_value_ulaYkZjtGm)) or 0

			local note_item_length_value_ulaYkZjtGm = reaper.GetExtState("insert_item_chord_ulaYkZjtGm", "note_item_length_value_ulaYkZjtGm")
			if note_item_length_value_ulaYkZjtGm == "" then note_item_length_value_ulaYkZjtGm = "1/4" end
			
			reaper.ImGui_Dummy(ctx, 0, 2)  -- Добавление вертикального пространства
			-- Слайдер Velocity от 1 до 127 с сохранением во временное хранилище
			local slider_velocity_value = tonumber(reaper.GetExtState("insert_item_chord_ulaYkZjtGm", "slider_velocity_value_ulaYkZjtGm")) or 86  -- Значение по умолчанию 86
			local changed_velocity, new_velocity_value = reaper.ImGui_SliderInt(ctx, ' Velocity', slider_velocity_value, 1, 127)
			if changed_velocity then
				slider_velocity_value = new_velocity_value
				reaper.SetExtState("insert_item_chord_ulaYkZjtGm", "slider_velocity_value_ulaYkZjtGm", tostring(slider_velocity_value), false)  -- Сохраняем значение
			else
				reaper.SetExtState("insert_item_chord_ulaYkZjtGm", "slider_velocity_value_ulaYkZjtGm", tostring(slider_velocity_value), false)  -- Сохраняем значение
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
				reaper.ImGui_Text(ctx, "  " .. transpose_value_ulaYkZjtGm .. " (" .. get_name_note_current() .. ")" )
				reaper.ImGui_PopStyleColor(ctx)
				
				reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
				
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
				
				TreeNodeLibraryOutput(library_transpose_main) -- передаём корневой элемент
				-- Transpose
				reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
				
				-- Length
				reaper.ImGui_TableNextColumn(ctx)
				-- reaper.ImGui_Text(ctx, '22222')
				reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Text(), HexToColor("#FFFF00")) -- Красный цвет (RGBA)
				reaper.ImGui_Text(ctx, "    " .. note_item_length_value_ulaYkZjtGm )
				reaper.ImGui_PopStyleColor(ctx)
				reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
				
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
						{separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 120 },
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
									
									insert_midi_chord(note_item_length_value_ulaYkZjtGm, node.value, transpose_value_ulaYkZjtGm, velocity, get_name_note_current() .. node.key)
									
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
				local note_index = (transpose_value_ulaYkZjtGm % 12 + 12) % 12 + 1
				local note_label_name = note_names[note_index] -- имя ноты, например, "C" или "C#"
				render_chords_library(insert_item_chord_library, slider_velocity_value, transpose_value_ulaYkZjtGm, note_label_name)
				reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
				
			reaper.ImGui_EndTable(ctx) -- Завершаем таблицу
			end
			
		elseif selected_content == "Chord_Detection_Content_Show" then
			
			reaper.ImGui_Text( ctx,  "Select the desired track and start playback" )
			
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			reaper.ImGui_PushFont (ctx, font_size_verdana_chord)
			reaper.ImGui_Text ( ctx, " " .. getChordType(get_playing_midi() or "") )
			reaper.ImGui_PopFont(ctx)
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			
			
			if true then -- true false
				reaper.ImGui_InputText(ctx, '##chord', getChordType(get_playing_midi() or "") )
				-- reaper.ImGui_Text(ctx, getChordType( get_playing_midi() or "", true) )
				reaper.ImGui_InputText(ctx, '##step', getChordType( get_playing_midi() or "", true) )
				-- reaper.ImGui_Text(ctx, get_playing_midi() or "")
				reaper.ImGui_InputText(ctx, '##number',  get_playing_midi() or "" )
				reaper.ImGui_InputText(ctx, '##nameNote',  get_playing_midi(true) or "" )
			
				reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
				reaper.ImGui_Text ( ctx, "0 - prima" )
				reaper.ImGui_Text ( ctx, "1 - b9" )
				reaper.ImGui_Text ( ctx, "2 - 9" )
				reaper.ImGui_Text ( ctx, "3 - #9 minor" )
				reaper.ImGui_Text ( ctx, "4 - major third" )
				reaper.ImGui_Text ( ctx, "5 - quart" )
				reaper.ImGui_Text ( ctx, "6 - triton" )
				reaper.ImGui_Text ( ctx, "7 - quint" )
				reaper.ImGui_Text ( ctx, "8 - b6/b13" )
				reaper.ImGui_Text ( ctx, "9 - 6/13" )
				reaper.ImGui_Text ( ctx, "10 - 7" )
				reaper.ImGui_Text ( ctx, "11 - maj" )
			end
			
		elseif selected_content == "Color_Picker_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "ImGui Color Picker" )
			
			-- Кнопки сброса цвета видны всегда
			if reaper.ImGui_Button(ctx, " Reset Track Colors ", 0, 30) then
				reaper.Main_OnCommand(40359, 0) -- Track: Set to default color
			end
			reaper.ImGui_SameLine(ctx)
			if reaper.ImGui_Button(ctx, " Reset Item Colors ", 0, 30) then
				reaper.Main_OnCommand(41333, 0) -- Take: Set active take to default color
				reaper.Main_OnCommand(40707, 0) -- Item: Set to default color
			end
			
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства

			reaper.ImGui_Text(ctx, "Select mode:")
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			if reaper.ImGui_RadioButton(ctx, "Track", modeTrackAndItemColorChanger == 'track') then
				modeTrackAndItemColorChanger = 'track'
			end
			reaper.ImGui_SameLine(ctx)
			if reaper.ImGui_RadioButton(ctx, "Item", modeTrackAndItemColorChanger == 'item') then
				modeTrackAndItemColorChanger = 'item'
			end
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			reaper.ImGui_SeparatorText( ctx, "Presets" )
			message = DrawColorBoxPresetColor(ctx, "#632929", 50, 50, true, modeTrackAndItemColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#7A3B3B", 50, 50, true, modeTrackAndItemColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#483F5F", 50, 50, true, modeTrackAndItemColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#593B61", 50, 50, true, modeTrackAndItemColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#532F40", 50, 50, false, modeTrackAndItemColorChanger) or message

			message = DrawColorBoxPresetColor(ctx, "#704919", 50, 50, true, modeTrackAndItemColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#6D502C", 50, 50, true, modeTrackAndItemColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#39557A", 50, 50, true, modeTrackAndItemColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#58713D", 50, 50, true, modeTrackAndItemColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#3A6864", 50, 50, false, modeTrackAndItemColorChanger) or message
			
			message = DrawColorBoxPresetColor(ctx, "#7A751F", 50, 50, true, modeTrackAndItemColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#7E701F", 50, 50, true, modeTrackAndItemColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#96761E", 50, 50, true, modeTrackAndItemColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#9A681D", 50, 50, true, modeTrackAndItemColorChanger) or message
			message = DrawColorBoxPresetColor(ctx, "#1D4864", 50, 50, true, modeTrackAndItemColorChanger) or message
			-- message = DrawColorBoxPresetColor(ctx, "#3A6864", 50, 50, false, modeTrackAndItemPresetColorChanger) or message
			
			-- reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			-- TrackAndItemColorChanger()
			
			-- reaper.ImGui_Spacing(ctx)

			if modeTrackAndItemColorChanger == 'track' then
				local track_count = reaper.CountSelectedTracks(0)
				if track_count > 0 then
					reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
					-- reaper.ImGui_Text(ctx, "Track mode")
					reaper.ImGui_SeparatorText( ctx, "Track mode" )
					local track = reaper.GetSelectedTrack(0, 0)
					local nativeColor = reaper.GetTrackColor(track)
					color = BGRToRGB(nativeColor)

					-- Tracks Color
					reaper.ImGui_SetNextItemWidth(ctx, 255) -- Установить ширину палитры
					local rv
					rv, color = reaper.ImGui_ColorPicker3(ctx, " ", color, reaper.ImGui_ColorEditFlags_NoSidePreview())
					if rv then
						for i = 0, track_count - 1 do
							local track = reaper.GetSelectedTrack(0, i)
							reaper.SetTrackColor(track, RGBToBGR(color))
						end
					end
				else
					reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
					reaper.ImGui_Text(ctx, "No track selected")
				end
			elseif modeTrackAndItemColorChanger == 'item' then
				
				if true then -- true false
					local item_count = reaper.CountSelectedMediaItems(0)
					if item_count > 0 then
						reaper.ImGui_Dummy(ctx, 0, 5)
						reaper.ImGui_SeparatorText(ctx, "Item mode")
						
						local item = reaper.GetSelectedMediaItem(0, 0)
						if item then
							local take = reaper.GetActiveTake(item)
							local nativeColor

							if take then
								nativeColor = reaper.GetMediaItemTakeInfo_Value(take, "I_CUSTOMCOLOR")
							else
								nativeColor = reaper.GetMediaItemInfo_Value(item, "I_CUSTOMCOLOR")
							end

							local color = BGRToRGB(nativeColor)

							reaper.ImGui_SetNextItemWidth(ctx, 255)
							local rv
							rv, color = reaper.ImGui_ColorPicker3(ctx, " ", color, reaper.ImGui_ColorEditFlags_NoSidePreview())
							if rv then
								for i = 0, item_count - 1 do
									local item = reaper.GetSelectedMediaItem(0, i)
									local take = reaper.GetActiveTake(item)
									local bgr = RGBToBGR(color) | 0x1000000

									if take then
										reaper.SetMediaItemTakeInfo_Value(take, "I_CUSTOMCOLOR", bgr)
									else
										reaper.SetMediaItemInfo_Value(item, "I_CUSTOMCOLOR", bgr)
									end

									reaper.UpdateItemInProject(item)
								end
							end
						end
					else
						reaper.ImGui_Dummy(ctx, 0, 5)
						reaper.ImGui_Text(ctx, "No item selected")
					end
				end
				
				if false then -- true false
					local item_count = reaper.CountSelectedMediaItems(0)
					if item_count > 0 then
						reaper.ImGui_Dummy(ctx, 0, 5) -- Добавление вертикального пространства
						-- reaper.ImGui_Text(ctx, "Item mode")
						reaper.ImGui_SeparatorText( ctx, "Item mode" )
						local item = reaper.GetSelectedMediaItem(0, 0)

						if item then
							local take = reaper.GetActiveTake(item)
							local nativeColor = reaper.GetMediaItemTakeInfo_Value(take, "I_CUSTOMCOLOR")
							local color = BGRToRGB(nativeColor)

							-- Items Color
							reaper.ImGui_SetNextItemWidth(ctx, 255) -- Установить ширину палитры
							local rv
							rv, color = reaper.ImGui_ColorPicker3(ctx, " ", color, reaper.ImGui_ColorEditFlags_NoSidePreview())
							
							
							if rv then
								for i = 0, item_count - 1 do
									local item = reaper.GetSelectedMediaItem(0, i)
									local take = reaper.GetActiveTake(item)

									if take then
										reaper.SetMediaItemTakeInfo_Value(take, "I_CUSTOMCOLOR", RGBToBGR(color) | 0x1000000)
										-- reaper.SetMediaItemInfo_Value(item, "I_CUSTOMCOLOR", RGBToBGR(color) | 0x1000000)
										reaper.UpdateItemInProject(item)
									end
								end
							end
						else
							reaper.ImGui_Text(ctx, "No active take found")
						end
					else
						reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
						reaper.ImGui_Text(ctx, "No item selected")
					end
				end
				
			end
			
			
			
			
			
			
			
			
		elseif selected_content == "Alpha_Window_ImGui_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Alpha Window ImGui" )
			local changed, new_alpha = reaper.ImGui_DragDouble(ctx, ' ', alpha_window_ImGui, 0.01, 0.0, 1.0, '%.2f')
			if changed then
				alpha_window_ImGui = new_alpha
				-- Сохраняем состояние
				reaper.SetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiAlphaWindow", tostring(alpha_window_ImGui), true)
			end
		elseif selected_content == "Item_Select_Delete_Content_Show" then
			cboc2 ( " Delete UnSelected Item ", function() DeleteUnselectedItemsOnTrack() end, 0, 25 )
			cboc2 ( " Invert Item Selection ", function() InvertItemSelection() end, 0, 25 )
		elseif selected_content == "Item_Length_Content_Show" then
			
			if reaper.ImGui_BeginTabBar(ctx, "Item Length & Insert Marker") then
		
			-- Вкладка — Item Length
			if reaper.ImGui_BeginTabItem(ctx, "Item Length") then
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
			
			
			-- Get Mouse Time Relative To Time Selection
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			reaper.ImGui_SeparatorText( ctx, "Get Mouse Time Relative To Time Selection" )
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
			reaper.ImGui_InputText(ctx, "Mouse Position", cursor_time, reaper.ImGui_InputTextFlags_ReadOnly())
			-- Get Mouse Time Relative To Time Selection
			
			
			-- Edit Cursor Relative To Time Selection
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			reaper.ImGui_SeparatorText( ctx, "Edit Cursor Relative To Time Selection" )
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
			reaper.ImGui_InputText(ctx, "Edit Cursor Position", cursor_time, reaper.ImGui_InputTextFlags_ReadOnly())
			-- Edit Cursor Relative To Time Selection
			
			
			-- Get Mouse Time
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			reaper.ImGui_SeparatorText( ctx, "Get Mouse Time" )
			local cursorMouse_time_StartZero = GetMouseTimeStartZero()
			reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
			reaper.ImGui_InputText(ctx, "Start Zero", cursorMouse_time_StartZero, reaper.ImGui_InputTextFlags_ReadOnly())
			-- Вторая строка: время через reaper.format_timestr_pos()
			local cursorMouse_time_StartMinus = GetMouseTimeStartMinus()
			reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
			reaper.ImGui_InputText(ctx, "Start Minus", cursorMouse_time_StartMinus, reaper.ImGui_InputTextFlags_ReadOnly())
			-- Get Mouse Time
			
			
			-- Edit Cursor Position
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			reaper.ImGui_SeparatorText( ctx, "Edit Cursor Position" )
			-- Получаем позицию курсора и выводим в поле
			local cursor_time_StartZero = GetEditCursorPositionTimeStartZero()
			local cursor_time_StartMinus = GetEditCursorPositionTimeStartMinus()
			reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
			reaper.ImGui_InputText(ctx, "Start Zero ", cursor_time_StartZero, reaper.ImGui_InputTextFlags_ReadOnly())
			reaper.ImGui_SetNextItemWidth(ctx, selected_input_width)
			reaper.ImGui_InputText(ctx, "Start Minus ", cursor_time_StartMinus, reaper.ImGui_InputTextFlags_ReadOnly())
			-- Edit Cursor Position
			
			
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			
			reaper.ImGui_EndTabItem(ctx)
			end
			
			-- Вкладка — Insert Marker
			if reaper.ImGui_BeginTabItem(ctx, "Insert Marker") then
			reaper.ImGui_SeparatorText( ctx, "Insert Marker" )
			
			-- cboc2 ( " Set Take Marker At Edit Cursor ", function() SetTakeMarkerAtEditCursor("#40FF00", "✖") end, 0, 30 ) -- █ ● ▰ ✖
			-- cboc2 ( " Delete Markers Select Item Or Time Selection ", function() DeleteTakeMarkersSelectItemOrTimeSelection() end, 0, 30 )
			
			-- insert_empty_item_chord_library
			local insert_empty_item_chord_library = {
				key = "Insert Empty Item Chord", default_open = true, children = {
				
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
			
			TreeNodeLibraryOutput(insert_empty_item_chord_library) -- передаём корневой элемент
			
			reaper.ImGui_EndTabItem(ctx)
			end
		reaper.ImGui_EndTabBar(ctx)
		end
			
		elseif selected_content == "Marker_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Add/edit take marker" )
			cboc2 ( " Set Take Marker At Edit Cursor ", function() SetTakeMarkerAtEditCursor("#40FF00", "✖") end, 0, 25 ) -- █ ● ▰ ✖ ×
			reaper.ImGui_Dummy(ctx, 0, 15)  -- Добавление вертикального пространства
			cboc2 ( " Item: Add/edit take marker at play position or edit cursor ", function() reaper.Main_OnCommand(42385, 0) end, 0, 25 )
			cboc2 ( " Item: Quick add take marker at play position or edit cursor ", function() reaper.Main_OnCommand(42390, 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 15)  -- Добавление вертикального пространства
			
			cboc2 ( " Item: Set cursor to next take marker in selected items ", function() reaper.Main_OnCommand(42394, 0) end, 0, 25 )
			cboc2 ( " Item: Set cursor to previous take marker in selected items ", function() reaper.Main_OnCommand(42393, 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 15)  -- Добавление вертикального пространства
			
			cboc2 ( " Item: Delete all take markers ", function() reaper.Main_OnCommand(42387, 0) end, 0, 25 )
			cboc2 ( " Delete Take Markers Select Item Or Time Selection ", function() DeleteTakeMarkersSelectItemOrTimeSelection() end, 0, 25 )
		elseif selected_content == "Item_Move_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Item Move" )
			cboc2 ( " Item edit: Move contents of items left ", function() reaper.Main_OnCommand(40123, 0) end, 0, 25 )
			cboc2 ( " Item edit: Move contents of items right ", function() reaper.Main_OnCommand(40124, 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 15)  -- Добавление вертикального пространства
			cboc2 ( " Item edit: Move items left, preserving timing of contents ", function() reaper.Main_OnCommand(40121, 0) end, 0, 25 )
			cboc2 ( " Item edit: Move items right, preserving timing of contents ", function() reaper.Main_OnCommand(40122, 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 15)  -- Добавление вертикального пространства
			
			-- cboc2 ( " Options: Move envelope points with media items ", function() reaper.Main_OnCommand(40070, 0) end, 0, 25 )
			CreateCommandCheckbox (40070, "Options: Move envelope points with media items")
			cboc2 ( " Item edit: Move items/envelope points left ", function() reaper.Main_OnCommand(40120, 0) end, 0, 25 )
			cboc2 ( " Item edit: Move items/envelope points right ", function() reaper.Main_OnCommand(40119, 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 15)  -- Добавление вертикального пространства
			cboc2 ( " Move Item Top Track ", function() moveItemTopBottomTrack("top") end, 0, 25 )
			cboc2 ( " Move Item Bottom Track ", function() moveItemTopBottomTrack("bottom") end, 0, 25 )
		elseif selected_content == "Item_Set_Channel_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Item properties: Set take channel mode" )
			cboc2 ( " Item properties: Set take channel mode to normal ", function() reaper.Main_OnCommand("40176", 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			cboc2 ( " Item properties: Set take channel mode to mono (left) ", function() reaper.Main_OnCommand("40179", 0) end, 0, 25 )
			cboc2 ( " Item properties: Set take channel mode to mono (right) ", function() reaper.Main_OnCommand("40180", 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			cboc2 ( " Item properties: Set take channel mode to mono (downmix) ", function() reaper.Main_OnCommand("40178", 0) end, 0, 25 )
			cboc2 ( " Item properties: Set take channel mode to reverse stereo ", function() reaper.Main_OnCommand("40177", 0) end, 0, 25 )
		elseif selected_content == "SplitSelectItemsOfEditCursor_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Split Item At Edit Cursot And Time Selection" )
			cboc2 ( " Left ", function() DeleteItemsAtEditCursorSelectLeft () end, 300, 30 )
			-- reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			cboc2 ( " Time ", function() DeleteItemsAtTimeSelection () end, 300, 30 )
			-- reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			cboc2 ( " Right ", function() DeleteItemsAtEditCursorSelectRight () end, 300, 30 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			reaper.ImGui_SeparatorText( ctx, "Action Other" )
			cboc2 ( " Item: Split items at play cursor ", function() reaper.Main_OnCommand("40196", 0) end, 0, 25 )
			cboc2 ( " Item: Split items at edit or play cursor ", function() reaper.Main_OnCommand("40012", 0) end, 0, 25 )
			cboc2 ( " Item: Split items at edit cursor (no change selection) ", function() reaper.Main_OnCommand("40757", 0) end, 0, 25 )
			cboc2 ( " Item: Split items at edit cursor (select left) ", function() reaper.Main_OnCommand("40758", 0) end, 0, 25 )
			cboc2 ( " Item: Split items at edit cursor (select right) ", function() reaper.Main_OnCommand("40759", 0) end, 0, 25 )
			cboc2 ( " Item: Split items at time selection ", function() reaper.Main_OnCommand("40061", 0) end, 0, 25 )
		elseif selected_content == "ToggleBypassFXPluginsOnSelectedTrack_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Toggle Bypass FX Plugins On Selected Track" )
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			-- Добавляем текстовые поля для ввода имен плагинов
			reaper.ImGui_Text(ctx, 'Plugin Name 1\n')
			local changed1, new_plugin_name1 = reaper.ImGui_InputTextWithHint(ctx, '##PluginName1', "", TogglePluginsOnSelectedTrack_plugin_name1, 256)
			if changed1 then 
				TogglePluginsOnSelectedTrack_plugin_name1 = new_plugin_name1 
				reaper.SetExtState(state_section, TogglePluginsOnSelectedTrack_key_plugin1, TogglePluginsOnSelectedTrack_plugin_name1, false) -- Сохраняем имя плагина
			end
			
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			reaper.ImGui_Text(ctx, 'Plugin Name 2\n')
			local changed2, new_plugin_name2 = reaper.ImGui_InputTextWithHint(ctx, '##PluginName2', "", TogglePluginsOnSelectedTrack_plugin_name2, 256)
			if changed2 then 
				TogglePluginsOnSelectedTrack_plugin_name2 = new_plugin_name2 
				reaper.SetExtState(state_section, TogglePluginsOnSelectedTrack_key_plugin2, TogglePluginsOnSelectedTrack_plugin_name2, false) -- Сохраняем имя плагина
			end

			-- Добавляем кнопку для переключения плагинов
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			if reaper.ImGui_Button(ctx, ' Toggle Plugins ', 0, 30) then
				ToggleBypassFXPluginsOnSelectedTrack(TogglePluginsOnSelectedTrack_plugin_name1, TogglePluginsOnSelectedTrack_plugin_name2)
			end
		elseif selected_content == "Delay_Calculator_Content_Show" then
			reaper.ImGui_SeparatorText(ctx, "Delay Calculator")

			-- Добавление переключателей
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			local currentMode = reaper.GetExtState('DelayCalculator', 'Mode')
			if currentMode == "" then currentMode = "Note" end
			local isNote = currentMode == "Note"
			local isTriplet = currentMode == "Triplet"
			local isDotted = currentMode == "Dotted"

			if reaper.ImGui_RadioButton(ctx, "Note", isNote) then
				currentMode = "Note"
				reaper.SetExtState('DelayCalculator', 'Mode', currentMode, false)
			end
			reaper.ImGui_SameLine(ctx)
			if reaper.ImGui_RadioButton(ctx, "Triplet", isTriplet) then
				currentMode = "Triplet"
				reaper.SetExtState('DelayCalculator', 'Mode', currentMode, false)
			end
			reaper.ImGui_SameLine(ctx)
			if reaper.ImGui_RadioButton(ctx, "Dotted", isDotted) then
				currentMode = "Dotted"
				reaper.SetExtState('DelayCalculator', 'Mode', currentMode, false)
			end
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства

			local noteOptions = {"1", "1/2", "1/4", "1/8", "1/16", "1/32", "1/64", "1/128"}
			local bpm = tonumber(reaper.GetExtState('DelayCalculator', 'BPM'))
			if not bpm then bpm = 120 end
			local changedBPM, newBPM = reaper.ImGui_InputDouble(ctx, 'BPM', bpm)
			if changedBPM then
				reaper.SetExtState('DelayCalculator', 'BPM', tostring(newBPM), false)
			end

			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			-- Выпадающий список для выбора деления нот
			local currentDivisionIndex = tonumber(reaper.GetExtState('DelayCalculator', 'DivisionIndex'))
			if not currentDivisionIndex then currentDivisionIndex = 2 end -- по умолчанию 1/4
			local joinedOptions = calculateDelayJoinOptions(noteOptions)
			local changedDivision, newDivisionIndex = reaper.ImGui_Combo(ctx, 'Division', currentDivisionIndex, joinedOptions)
			if changedDivision then
				reaper.SetExtState('DelayCalculator', 'DivisionIndex', tostring(newDivisionIndex), false)
			end

			-- Вычисление задержки
			local delay = calculateDelay(newBPM or bpm, noteOptions[newDivisionIndex + 1], currentMode)
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			-- Отображение результата в текстовом поле для копирования
			reaper.ImGui_Text(ctx, 'Delay:')
			local delayStr = string.format('%.2f ms', delay)
			reaper.ImGui_InputText(ctx, '##delay', delayStr, reaper.ImGui_InputTextFlags_ReadOnly())
		elseif selected_content == "Tempo_Envelope_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Tempo Envelope" )
			cboc2 ( " Tempo envelope: Set display range... ", function() reaper.Main_OnCommand("40933", 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			cboc2 ( " Toggle show master tempo envelope ", function() reaper.Main_OnCommand("41046", 0) end, 0, 25 )
			cboc2 ( " View: Toggle master track visible ", function() reaper.Main_OnCommand("40075", 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			cboc2 ( " Insert tempo/time signature change marker at edit cursor... ", function() reaper.Main_OnCommand("42330", 0) end, 0, 25 ) -- Tempo envelope: Insert tempo/time signature change marker at edit cursor...
			cboc2 ( " Insert tempo marker at edit cursor, without opening tempo edit dialog ", function() reaper.Main_OnCommand("40256", 0) end, 0, 25 ) -- Tempo envelope: Insert tempo marker at edit cursor, without opening tempo edit dialog
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			cboc2 ( " Tempo envelope: Increase all tempo markers 01 BPM ", function() reaper.Main_OnCommand("41215", 0) end, 0, 25 ) -- Tempo envelope: Insert tempo marker at edit cursor, without opening tempo edit dialog
			cboc2 ( " Tempo envelope: Decrease all tempo markers 01 BPM ", function() reaper.Main_OnCommand("41216", 0) end, 0, 25 ) -- Tempo envelope: Insert tempo marker at edit cursor, without opening tempo edit dialog
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			cboc2 ( " Insert Tempo Marker User Inputs ", function() InsertTempoMarkerUserInputs() end, 0, 25 ) -- Tempo envelope: Insert tempo marker at edit cursor, without opening tempo edit dialog
		elseif selected_content == "Stretch_Marker_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Stretch Marker" )
			
			if false then
			cboc2 ( " Item: Add stretch marker at cursor ", function() reaper.Main_OnCommand("41842", 0) end, 0, 25 )
			cboc2 ( " Item: Edit stretch marker at cursor ", function() reaper.Main_OnCommand("41988", 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Item: Go to next stretch marker ", function() reaper.Main_OnCommand("41860", 0) end, 0, 25 )
			cboc2 ( " Item: Go to previous stretch marker ", function() reaper.Main_OnCommand("41861", 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Item: Remove all stretch markers ", function() reaper.Main_OnCommand("41844", 0) end, 0, 25 )
			cboc2 ( " Item: Remove all stretch markers in time selection ", function() reaper.Main_OnCommand("41845", 0) end, 0, 25 )
			cboc2 ( " Item: Remove stretch marker at current position ", function() reaper.Main_OnCommand("41859", 0) end, 0, 25 )
			end
			
			-- library_stretch_marker
			local library_stretch_marker = {
				key = "Stretch Marker", default_open = true, children = {
					
					{separator_horizontal = "2", separator_color = "#3F3F48" },
					{spacing_vertical = "3"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					-- {spacing_vertical = "7"},
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},
					-- {separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 148 },
					{key = "Get Sample Amplitude At Edit Cursor", action_function = function() print_rs ( GetSampleAmplitudeAtEditCursor() ) end},
					{separator_horizontal = "2", separator_color = "#3F3F48" },
					{spacing_vertical = "3"},
					
					{key = "Item: Add stretch marker at cursor", action_id = "41842"},
					{key = "Item: Edit stretch marker at cursor", action_id = "41988"},
					{separator_horizontal = "2", separator_color = "#3F3F48" },
					{spacing_vertical = "3"},
					
					{key = "Item: Go to next stretch marker", action_id = "41860"},
					{key = "Item: Go to previous stretch marker", action_id = "41861"},
					{separator_horizontal = "2", separator_color = "#3F3F48" },
					{spacing_vertical = "3"},
					
					{key = "Item: Remove all stretch markers", action_id = "41844"},
					{key = "Item: Remove all stretch markers in time selection", action_id = "41845"},
					{key = "Item: Remove stretch marker at current position", action_id = "41859"},
					
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
			
			TreeNodeLibraryOutput(library_stretch_marker) -- передаём корневой элемент
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
		elseif selected_content == "Mouse_Modifier_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Mouse Modifier" )
			cboc2 ( " Default Preset ", function() RunCommandList ("39835,39784,39282,25196,25165,25128,39801,25096,39129,39167,25480,39407,39368,25321,39448,25033,39321,39673,39289,39705,39487,39641,39417,39961,39545,39033,39065,39896,39864,39736,39097,39513,39001,39929,25071,25257,25001,25225,25289,25420,25353,25385,25448,39609,39233,39577,39205") end, 300, 25 )
			cboc2 ( " Select Time ", function() RunCommandList ("39835,39784,39282,25196,25165,25128,39801,25096,39129,39167,25480,39407,39368,25321,39448,25033,39321,39673,39289,39705,39487,39641,39417,39961,39545,39051,39065,39896,39864,39736,39097,39513,39019,39929,25071,25257,25001,25225,25289,25420,25353,25385,25448,39609,39225,39577,39199") end, 300, 25 )
			cboc2 ( " Main - Draw Empty MIDI Item ", function() RunCommandList ("39835,39784,39282,25196,25165,25128,39801,25096,39129,39167,25480,39407,39368,25321,39448,25033,39321,39673,39289,39705,39487,39641,39417,39961,39545,39033,39065,39896,39864,39736,39097,39513,39001,39929,25071,25257,25001,25225,25289,25420,25353,25385,25448,39609,39233,39577,39197") end, 300, 25 )
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			
			reaper.ImGui_SeparatorText( ctx, "Action Command" )
			cboc2 ( " Remove time selection ", function() reaper.Main_OnCommand("40635", 0) end, 300, 25 ) -- Time selection: Remove (unselect) time selection
		elseif selected_content == "Settings_Reaper_Content_Show" then
			
			local library_settings_reaper = {
				key = "Settings Reaper", default_open = true, children = {
					-- {spacing_vertical = "1"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					-- {spacing_vertical = "7"},
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},
					{key = "View: Show performance meter window", action_id = "40240"},
					{key = "View: Show FX browser window", action_id = "40271"},
					{key = "View: Show big clock window", action_id = "40378"},
					{key = "View: Show peaks display settings", action_id = "42074"},
					{key = "View: Toggle show/hide item labels", action_id = "40651"},
					{key = "View: Show routing matrix window", action_id = "40251"},
					{key = "View: Show undo history window", action_id = "40072"},
					{key = "View: Show virtual MIDI keyboard", action_id = "40377"},
					{key = "View: Toggle master track visible", action_id = "40075"},
					{key = "View: Toggle mixer visible", action_id = "40078"},
					{key = "View: Toggle transport visible", action_id = "40259"},
					{key = "View: Show project bay window", action_id = "41157"},
					{key = "File: Project settings...", action_id = "40021"},
					{key = "View: Show track manager window", action_id = "40906"},
					{key = "View: Show crossfade editor window", action_id = "41827"},
					{key = "Options: Show lock settings", set_focus = true, action_id = "40277"}, -- true false
					
					-- {key = "Options: Show lock settings", action_id = "40277"},
					-- {key = "Options: Show metronome/pre-roll settings", action_id = "40363"},
					-- {key = "Options: Show snap/grid settings", action_id = "40071"},
					-- {key = "www", action_id = "41306"},
					-- {key = "www", action_id = "www"},
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
			
			TreeNodeLibraryOutput(library_settings_reaper) -- передаём корневой элемент
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
		elseif selected_content == "Region_For_PlayBack_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, " Region For PlayBack " )
			
			reaper.ImGui_PushFont(ctx, font_size_verdana_22)
			cboc2 ( " Set Time Selection To Region At Play Cursor ", function() SetTimeSelectionToRegionAtPlayCursor () end, 772, 50 )
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			cboc2 ( "  Remove Time Selection  ", function() reaper.Main_OnCommand("40635", 0) end, 772, 50 ) -- Time selection: Remove (unselect) time selection
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			function GoToRegion_RemoveTimeSelection (region_index)
				reaper.Main_OnCommand(region_index, 0) -- Regions: Go to region 01 after current region finishes playing (smooth seek)
				reaper.Main_OnCommand("40635", 0) -- Time selection: Remove (unselect) time selection
			end
			
			local btn_GoToReg = 70
			
			-- Regions: Go to region 01 after current region finishes playing (smooth seek)
			cboc2 ( "  01  ", function() GoToRegion_RemoveTimeSelection("41761") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  02  ", function() GoToRegion_RemoveTimeSelection("41762") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  03  ", function() GoToRegion_RemoveTimeSelection("41763") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  04  ", function() GoToRegion_RemoveTimeSelection("41764") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  05  ", function() GoToRegion_RemoveTimeSelection("41765") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  06  ", function() GoToRegion_RemoveTimeSelection("41766") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  07  ", function() GoToRegion_RemoveTimeSelection("41767") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  08  ", function() GoToRegion_RemoveTimeSelection("41768") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  09  ", function() GoToRegion_RemoveTimeSelection("41769") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  10  ", function() GoToRegion_RemoveTimeSelection("41770") end, btn_GoToReg, btn_GoToReg )
			
			cboc2 ( "  11  ", function() GoToRegion_RemoveTimeSelection("41771") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  12  ", function() GoToRegion_RemoveTimeSelection("41772") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  13  ", function() GoToRegion_RemoveTimeSelection("41773") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  14  ", function() GoToRegion_RemoveTimeSelection("41774") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  15  ", function() GoToRegion_RemoveTimeSelection("41775") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  16  ", function() GoToRegion_RemoveTimeSelection("41776") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  17  ", function() GoToRegion_RemoveTimeSelection("41777") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  18  ", function() GoToRegion_RemoveTimeSelection("41778") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  19  ", function() GoToRegion_RemoveTimeSelection("41779") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  20  ", function() GoToRegion_RemoveTimeSelection("41780") end, btn_GoToReg, btn_GoToReg )
			
			cboc2 ( "  21  ", function() GoToRegion_RemoveTimeSelection("41781") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  22  ", function() GoToRegion_RemoveTimeSelection("41782") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  23  ", function() GoToRegion_RemoveTimeSelection("41783") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  24  ", function() GoToRegion_RemoveTimeSelection("41784") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  25  ", function() GoToRegion_RemoveTimeSelection("41785") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  26  ", function() GoToRegion_RemoveTimeSelection("41786") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  27  ", function() GoToRegion_RemoveTimeSelection("41787") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  28  ", function() GoToRegion_RemoveTimeSelection("41788") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  29  ", function() GoToRegion_RemoveTimeSelection("41789") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  30  ", function() GoToRegion_RemoveTimeSelection("41790") end, btn_GoToReg, btn_GoToReg )
			
			cboc2 ( "  31  ", function() GoToRegion_RemoveTimeSelection("41791") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  32  ", function() GoToRegion_RemoveTimeSelection("41792") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  33  ", function() GoToRegion_RemoveTimeSelection("41793") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  34  ", function() GoToRegion_RemoveTimeSelection("41794") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  35  ", function() GoToRegion_RemoveTimeSelection("41795") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  36  ", function() GoToRegion_RemoveTimeSelection("41796") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  37  ", function() GoToRegion_RemoveTimeSelection("41797") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  38  ", function() GoToRegion_RemoveTimeSelection("41798") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  39  ", function() GoToRegion_RemoveTimeSelection("41799") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "  40  ", function() GoToRegion_RemoveTimeSelection("41800") end, btn_GoToReg, btn_GoToReg )
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			
			cboc2 ( " Set Top Track Height 110 ", function()
				SetAllTracksAndEnvelopesHeight(58, 58)  -- track_height / envelope_height
				SetTopTrackHeight(110) -- Установить высоту 150 пикселей
				ZoomArrangeToItems(1, 3) -- Отступ 1 секунда слева и 2 секунды справа
				reaper.UpdateArrange()
			end, 772, 50 )
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			cboc2 ( " Set Top Track Height Default ", function()
				reaper.Main_OnCommand("40456", 0) -- Screenset: Load window set #03
				SetAllTracksAndEnvelopesHeight(58, 58)  -- track_height / envelope_height
				ZoomArrangeToItems(1, 3) -- Отступ 1 секунда слева и 2 секунды справа
				reaper.UpdateArrange()
			end, 772, 50 )
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			cboc2 ( "  Midi Off  ", function() reaper.Main_OnCommand("40345", 0) end, 772, 50 ) -- Send all-notes-off and all-sounds-off to all MIDI outputs/plug-ins
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			cboc2 ( " Screenset 01 ", function()
				reaper.Main_OnCommand("40454", 0) -- Screenset: Load window set #01
				SetAllTracksAndEnvelopesHeight(58, 58)  -- track_height / envelope_height
				ZoomArrangeToItems(1, 3) -- Отступ 1 секунда слева и 2 секунды справа
			end, 772, 50 )
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			cboc2 ( " Screenset 02 ", function()
				reaper.Main_OnCommand("40455", 0) -- Screenset: Load window set #02
				SetAllTracksAndEnvelopesHeight(58, 58)  -- track_height / envelope_height
				ZoomArrangeToItems(1, 3) -- Отступ 1 секунда слева и 2 секунды справа
			end, 772, 50 )
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			cboc2 ( " Screenset 03 ", function()
				reaper.Main_OnCommand("40456", 0) -- Screenset: Load window set #03
				SetAllTracksAndEnvelopesHeight(58, 58)  -- track_height / envelope_height
				ZoomArrangeToItems(1, 3) -- Отступ 1 секунда слева и 2 секунды справа
			end, 772, 50 )
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			reaper.ImGui_PopFont(ctx)
		elseif selected_content == "Region_Various_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Region Various" )
			
			local btn_width = 570
			local btn_height = 30
			
			cboc2 ( " View: Show region/marker manager window ", function() reaper.Main_OnCommand("40326", 0) end, btn_width, btn_height )
			cboc2 ( " Ruler: Display region number even if region is named ", function() reaper.Main_OnCommand("42435", 0) end, btn_width, btn_height )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			cboc2 ( " Create Region From Items Selection ", function() CreateOrRemoveRegionFromTimeSelection (2) end, btn_width, btn_height )
			cboc2 ( " Create Region From Time Selection ", function() CreateOrRemoveRegionFromTimeSelection (0) end, btn_width, btn_height ) -- "Куплет", "#FF0000"
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Remove Region From Time Selection ", function() CreateOrRemoveRegionFromTimeSelection (1) end, btn_width, btn_height )
			cboc2 ( " Delete all regions ", function() CreateOrRemoveRegionFromTimeSelection (3) end, btn_width, btn_height )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			cboc2 ( " Markers/Regions: Export markers/regions to file ", function() reaper.Main_OnCommand(41758, 0) end, btn_width, btn_height )
			cboc2 ( " Markers/Regions: Import markers/regions from file (replace all existing) ", function() reaper.Main_OnCommand(41759, 0) end, btn_width, btn_height )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			reaper.ImGui_SeparatorText( ctx, "Create Region" )
			DrawColorBoxPresetColor2(ctx, "#0070CA", 30, 30, true, modeTrackAndItemPresetColorChanger)
			cboc2 ( " Couplet ", function() CreateRegionFromSelectedItem("Куплет", "#0070CA") end, 532, btn_height )
			DrawColorBoxPresetColor2(ctx, "#E87400", 30, 30, true, modeTrackAndItemPresetColorChanger)
			cboc2 ( " Chorus ", function() CreateRegionFromSelectedItem("Припев", "#B05800") end, 532, btn_height )
			DrawColorBoxPresetColor2(ctx, "#0A8B16", 30, 30, true, modeTrackAndItemPresetColorChanger)
			cboc2 ( " Interlude ", function() CreateRegionFromSelectedItem("Проигрыш", "#0A8B16") end, 532, btn_height )
			DrawColorBoxPresetColor2(ctx, "#F24040", 30, 30, true, modeTrackAndItemPresetColorChanger)
			cboc2 ( " Code ", function() CreateRegionFromSelectedItem("Кода", "#F24040") end, 532, btn_height )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			reaper.ImGui_SeparatorText( ctx, "Insert Empty Item" )
			DrawColorBoxPresetColor2(ctx, "#0070CA", 30, 30, true, modeTrackAndItemPresetColorChanger)
			cboc2 ( " Couplet Item ", function() InsertEmptyItemWithNameAndColor("Куплет", "#0070CA") end, 532, btn_height )
			DrawColorBoxPresetColor2(ctx, "#E87400", 30, 30, true, modeTrackAndItemPresetColorChanger)
			cboc2 ( " Chorus Item ", function() InsertEmptyItemWithNameAndColor("Припев", "#E87400") end, 532, btn_height )
			DrawColorBoxPresetColor2(ctx, "#0A8B16", 30, 30, true, modeTrackAndItemPresetColorChanger)
			cboc2 ( " Interlude Item ", function() InsertEmptyItemWithNameAndColor("Проигрыш", "#0A8B16") end, 532, btn_height )
			DrawColorBoxPresetColor2(ctx, "#F24040", 30, 30, true, modeTrackAndItemPresetColorChanger)
			cboc2 ( " Code Item ", function() InsertEmptyItemWithNameAndColor("Кода", "#F24040") end, 532, btn_height )
			
			-- CreateOrRemoveRegionFromTimeSelection
		elseif selected_content == "Marker_Content_Show" then
			
			reaper.ImGui_SeparatorText( ctx, " Marker " )
			cboc2 ( " Markers: Insert marker at current position ", function() reaper.Main_OnCommand(40157, 0) end, 0, 25 )
			cboc2 ( " Markers: Remove all markers from time selection ", function() reaper.Main_OnCommand(40420, 0) end, 0, 25 )

		elseif selected_content == "TimeBase_Content_Show" then
			
			-- library_timebase_main
			local library_timebase_main = {
				key = "TimeBase Project Tracks Items", default_open = true, children = {
					-- {separator_horizontal = "2", separator_color = "#777777" },
					{separator_horizontal = "ImGui_SeparatorText", separator_text = "Set Project TimeBase"},
					{key = "Set project timebase to beats (position only)", action_id = "_SWS_AWTBASEBEATPOS"},
					{key = "Set project timebase to beats (position, length, rate)", action_id = "_SWS_AWTBASEBEATALL"},
					{key = "Set project timebase to time", action_id = "_SWS_AWTBASETIME"},
					{spacing_vertical = "7"},
					
					{separator_horizontal = "ImGui_SeparatorText", separator_text = "Set Tracks TimeBase"},
					{key = "Set selected tracks timebase to beats (position only)", action_id = "_SWS_AWTRACKTBASEBEATPOS"},
					{key = "Set selected tracks timebase to beats (position, length, rate)", action_id = "_SWS_AWTRACKTBASEBEATALL"},
					{key = "Set selected tracks timebase to project default", action_id = "_SWS_AWTRACKTBASEPROJ"},
					{key = "Set selected tracks timebase to time", action_id = "_SWS_AWTRACKTBASETIME"},
					{spacing_vertical = "7"},
					
					{separator_horizontal = "ImGui_SeparatorText", separator_text = "Set Items TimeBase"},
					{key = "Set selected items timebase to beats (auto-stretch at tempo changes)", action_id = "_SWS_AWITEMTBASEBEATSTRETCH"},
					{key = "Set selected items timebase to beats (position only)", action_id = "_SWS_AWITEMTBASEBEATPOS"},
					{key = "Set selected items timebase to beats (position, length, rate)", action_id = "_SWS_AWITEMTBASEBEATALL"},
					{key = "Set selected items timebase to project/track default", action_id = "_SWS_AWITEMTBASEPROJ"},
					{key = "Set selected items timebase to time", action_id = "_SWS_AWITEMTBASETIME"},

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
			
			TreeNodeLibraryOutput(library_timebase_main, "TimeBase Project Tracks Items") -- передаём корневой элемент
			
			if false then
			
			local SetProjectTimebase = {
				{name = "Set project timebase to time", id = "_SWS_AWTBASETIME"},
				{name = "Set project timebase to beats (position only)", id = "_SWS_AWTBASEBEATPOS"},
				{name = "Set project timebase to beats (position, length, rate)", id = "_SWS_AWTBASEBEATALL"},
			}
			local SetTrackTimebase = {
				{name = "Track properties: Set track timebase to project default", id = 40486},
				{name = "Track properties: Set track timebase to time", id = 40487},
				{name = "Track properties: Set track timebase to beats (position only)", id = 40489},
				{name = "Track properties: Set track timebase to beats (position, length, rate)", id = 40488},
			}
			local SetItemTimebase = {
				{name = "Item properties: Set item timebase to project/track default", id = 40380},
				{name = "Item properties: Set item timebase to time", id = 40433},
				{name = "Item properties: Set item timebase to beats (position only)", id = 40485},
				{name = "Item properties: Set item timebase to beats (position, length, rate)", id = 40484},
				{name = "Item properties: Set item timebase to beats (auto-stretch at tempo changes)", id = 42375},
			}
			
			reaper.ImGui_SeparatorText( ctx, " TimeBase " )
			CreateRadioButtonGroup(ctx, SetProjectTimebase, "SetProjectTimebase")
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			CreateRadioButtonGroup(ctx, SetTrackTimebase, "SetTrackTimebase")
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			CreateRadioButtonGroup(ctx, SetItemTimebase, "SetItemTimebase")
			
			
			reaper.ImGui_SeparatorText( ctx, " TimeBase " )
			cboc2 ( " Set project timebase to time ", function() reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_AWTBASETIME"), 0) end, 0, 25 )
			cboc2 ( " Set project timebase to beats (position only) ", function() reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_AWTBASEBEATPOS"), 0) end, 0, 25 )
			cboc2 ( " Set project timebase to beats (position, length, rate) ", function() reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_AWTBASEBEATALL"), 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Track properties: Set track timebase to time ", function() reaper.Main_OnCommand(40487, 0) end, 0, 25 )
			cboc2 ( " Track properties: Set track timebase to beats (position only) ", function() reaper.Main_OnCommand(40489, 0) end, 0, 25 )
			cboc2 ( " Track properties: Set track timebase to beats (position, length, rate) ", function() reaper.Main_OnCommand(40488, 0) end, 0, 25 )
			cboc2 ( " Track properties: Set track timebase to project default ", function() reaper.Main_OnCommand(40486, 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Item properties: Set item timebase to time ", function() reaper.Main_OnCommand(40433, 0) end, 0, 25 )
			cboc2 ( " Item properties: Set item timebase to beats (position only) ", function() reaper.Main_OnCommand(40485, 0) end, 0, 25 )
			cboc2 ( " Item properties: Set item timebase to beats (position, length, rate) ", function() reaper.Main_OnCommand(40484, 0) end, 0, 25 )
			cboc2 ( " Item properties: Set item timebase to project/track default ", function() reaper.Main_OnCommand(40380, 0) end, 0, 25 )
			cboc2 ( " Item properties: Set item timebase to beats (auto-stretch at tempo changes) ", function() reaper.Main_OnCommand(42375, 0) end, 0, 25 )
			
			end
			
		elseif selected_content == "Grid_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, " Grid " )
			
			-- library_grid_main
			local library_grid_main = {
				key = "Grid: Set to", default_open = true, children = {
					
					-- {spacing_vertical = "1"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					-- {spacing_vertical = "7"},
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},
					-- {separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 148 },
					
					{spacing_vertical = "1"},
					{separator_horizontal = "3", separator_color = "#3F3F48" },
					{spacing_vertical = "7"},
					{key = "Grid: Set to 4", action_id = "41211"},
					{key = "Grid: Set to 3", action_id = "42006"},
					{key = "Grid: Set to 2", action_id = "41210"},
					{key = "Grid: Set to 1", action_id = "40781"},
					{key = "Grid: Set to 1/2", action_id = "40780"},
					{key = "Grid: Set to 1/3 (1/2 triplet)", action_id = "42000"},
					{key = "Grid: Set to 1/4", action_id = "40779"},
					{key = "Grid: Set to 1/5 (1/4 quintuplet)", action_id = "42005"},
					{key = "Grid: Set to 1/6 (1/4 triplet)", action_id = "41214"},
					{key = "Grid: Set to 1/7 (1/4 septuplet)", action_id = "42004"},
					{key = "Grid: Set to 1/8", action_id = "40778"},
					{key = "Grid: Set to 1/9", action_id = "42003"},
					{key = "Grid: Set to 1/10 (1/8 quintuplet)", action_id = "42002"},
					{key = "Grid: Set to 1/12 (1/8 triplet)", action_id = "40777"},
					{key = "Grid: Set to 1/16", action_id = "40776"},
					{key = "Grid: Set to 1/18", action_id = "42001"},
					{key = "Grid: Set to 1/24 (1/16 triplet)", action_id = "41213"},
					{key = "Grid: Set to 1/32", action_id = "40775"},
					{key = "Grid: Set to 1/48 (1/32 triplet)", action_id = "41212"},
					{key = "Grid: Set to 1/64", action_id = "40774"},
					{key = "Grid: Set to 1/128", action_id = "41047"},
					{key = "Grid: Set to 2/3 (whole note triplet)", action_id = "42007"},
					{spacing_vertical = "1"},
					{separator_horizontal = "3", separator_color = "#3F3F48" },
					{spacing_vertical = "7"},
					{key = "Grid: Adjust by 1/1.5", action_id = "40782"},
					{key = "Grid: Adjust by 1/2", action_id = "40783"},
					{key = "Grid: Adjust by 1/3", action_id = "40784"},
					{key = "Grid: Adjust by 1.5", action_id = "40785"},
					{key = "Grid: Adjust by 2", action_id = "40786"},
					{key = "Grid: Adjust by 3", action_id = "40787"},
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
			
			TreeNodeLibraryOutput(library_grid_main) -- передаём корневой элемент
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
		elseif selected_content == "Transport_Content_Show" then
		
			-- library_transport_main
			local library_transport_main = {
				key = "Transport", children = {
					{spacing_vertical = "1"},
					{separator_horizontal = "2", separator_color = "#A7A7A7" },
					{spacing_vertical = "7"},
					{key = "Transport: Play", action_id = "1007"},
					{key = "Transport: Pause", action_id = "1008"},
					{key = "Transport: Stop", action_id = "1016"},
					{key = "Transport: Record", action_id = "1013"},
					{key = "Transport: Tap tempo", action_id = "1134"},
					
					{spacing_vertical = "1"},
					{separator_horizontal = "2", separator_color = "#A7A7A7" },
					{spacing_vertical = "7"},
					{key = "Transport: Play/stop", action_id = "40044"},
					{key = "Transport: Play/pause", action_id = "40073"},
					
					{spacing_vertical = "1"},
					{separator_horizontal = "2", separator_color = "#A7A7A7" },
					{spacing_vertical = "7"},
					{key = "Transport: Go to start of project", action_id = "40042"},
					{key = "Transport: Go to end of project", action_id = "40043"},
					{key = "Transport: Toggle repeat", action_id = "1068"},
					
					{spacing_vertical = "1"},
					{separator_horizontal = "2", separator_color = "#A7A7A7" },
					{spacing_vertical = "7"},
					{key = "Transport: Show transport in docker", action_id = "41608"},
					{key = "Transport: Show transport docked above ruler", action_id = "41604"},
					{key = "Transport: Show transport docked below arrange", action_id = "41603"},
					{key = "Transport: Show transport docked to bottom of main window", action_id = "41605"},
					{key = "Transport: Show transport docked to top of main window", action_id = "41606"},


					-- {key = "www", action_id = "www"},
		
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
			
			TreeNodeLibraryOutput(library_transport_main, "Transport", true) -- передаём корневой элемент
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
		elseif selected_content == "Midi_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, " MIDI " )
			cboc2 ( " Send all-notes-off and all-sounds-off to all MIDI outputs/plug-ins ", function() reaper.Main_OnCommand(40345, 0) end, 0, 25 )
			cboc2 ( " Insert Midi CC (11) ", function() InsertMidiInsertCC (11, 65) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Selected Media Items Remove All CC's From MIDI ", function() delete_or_keep_cc (true) end, 0, 25 )
			cboc2 ( " Selected Media Items Remove All CC's From MIDI (11) ", function() delete_or_keep_cc (11) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			if false then
			cboc2 ( " Insert Midi Program Change (3) (Elecric Piano) ", function() InsertMidiProgramChange (3) end, 0, 25 )
			cboc2 ( " Insert Midi Program Change (4) (Elecric Piano) ", function() InsertMidiProgramChange (4) end, 0, 25 )
			cboc2 ( " Insert Midi Program Change (35) (Fretless Bass) ", function() InsertMidiProgramChange (35) end, 0, 25 )
			
			
			end
			
			-- library_insert_midi_program_change
			local library_insert_midi_program_change = {
				key = "Insert Midi Program Change", default_open = true, children = {
					
					-- {spacing_vertical = "1"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					-- {spacing_vertical = "7"},
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},
					-- {separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 148 },
					
					{key = "Delete Program Change At Edit Cursor", action_function = function() DeleteProgramChangeAtCursor (100) end},
					{spacing_vertical = "1"},
					{separator_horizontal = "2", separator_color = "#3F3F48" },
					{spacing_vertical = "5"},
					
					{key = "General MIDI", children = {
						{key = "001. Acoustic Grand Piano", action_function = function() InsertMidiProgramChange (0) end},
						{key = "002. Bright Acoustic Piano", action_function = function() InsertMidiProgramChange (1) end},
						{key = "003. Electric Grand Piano", action_function = function() InsertMidiProgramChange (2) end},
						{key = "004. Honky-Tonk Piano", action_function = function() InsertMidiProgramChange (3) end},
						{key = "005. Electric Piano 1", action_function = function() InsertMidiProgramChange (4) end},
						{key = "006. Electric Piano 2", action_function = function() InsertMidiProgramChange (5) end},
						{key = "007. Harpsichord", action_function = function() InsertMidiProgramChange (6) end},
						{key = "008. Clavi", action_function = function() InsertMidiProgramChange (7) end},
						{key = "009. Celesta", action_function = function() InsertMidiProgramChange (8) end},
						{key = "010. Glockenspiel", action_function = function() InsertMidiProgramChange (9) end},
						{key = "011. Music Box", action_function = function() InsertMidiProgramChange (10) end},
						{key = "012. Vibraphone", action_function = function() InsertMidiProgramChange (11) end},
						{key = "013. Marimba", action_function = function() InsertMidiProgramChange (12) end},
						{key = "014. Xylophone", action_function = function() InsertMidiProgramChange (13) end},
						{key = "015. Tubular Bells", action_function = function() InsertMidiProgramChange (14) end},
						{key = "016. Dulcimer", action_function = function() InsertMidiProgramChange (15) end},
						{key = "017. Drawbar Organ", action_function = function() InsertMidiProgramChange (16) end},
						{key = "018. Percussive Organ", action_function = function() InsertMidiProgramChange (17) end},
						{key = "019. Rock Organ", action_function = function() InsertMidiProgramChange (18) end},
						{key = "020. Church Organ", action_function = function() InsertMidiProgramChange (19) end},
						{key = "021. Reed Organ", action_function = function() InsertMidiProgramChange (20) end},
						{key = "022. Accordion", action_function = function() InsertMidiProgramChange (21) end},
						{key = "023. Harmonica", action_function = function() InsertMidiProgramChange (22) end},
						{key = "024. Tango Accordion", action_function = function() InsertMidiProgramChange (23) end},
						{key = "025. Acoustic Guitar (nylon)", action_function = function() InsertMidiProgramChange (24) end},
						{key = "026. Acoustic Guitar (steel)", action_function = function() InsertMidiProgramChange (25) end},
						{key = "027. Electric Guitar (jazz)", action_function = function() InsertMidiProgramChange (26) end},
						{key = "028. Electric Guitar (clean)", action_function = function() InsertMidiProgramChange (27) end},
						{key = "029. Electric Guitar (muted)", action_function = function() InsertMidiProgramChange (28) end},
						{key = "030. Overdriven Guitar", action_function = function() InsertMidiProgramChange (29) end},
						{key = "031. Distortion Guitar", action_function = function() InsertMidiProgramChange (30) end},
						{key = "032. Guitar Harmonics", action_function = function() InsertMidiProgramChange (31) end},
						{key = "033. Acoustic Bass", action_function = function() InsertMidiProgramChange (32) end},
						{key = "034. Electric Bass (finger)", action_function = function() InsertMidiProgramChange (33) end},
						{key = "035. Electric Bass (pick)", action_function = function() InsertMidiProgramChange (34) end},
						{key = "036. Fretless Bass", action_function = function() InsertMidiProgramChange (35) end},
						{key = "037. Slap Bass 1", action_function = function() InsertMidiProgramChange (36) end},
						{key = "038. Slap Bass 2", action_function = function() InsertMidiProgramChange (37) end},
						{key = "039. Synth Bass 1", action_function = function() InsertMidiProgramChange (38) end},
						{key = "040. Synth Bass 2", action_function = function() InsertMidiProgramChange (39) end},
						{key = "041. Violin", action_function = function() InsertMidiProgramChange (40) end},
						{key = "042. Viola", action_function = function() InsertMidiProgramChange (41) end},
						{key = "043. Cello", action_function = function() InsertMidiProgramChange (42) end},
						{key = "044. Contrabass", action_function = function() InsertMidiProgramChange (43) end},
						{key = "045. Tremolo Strings", action_function = function() InsertMidiProgramChange (44) end},
						{key = "046. Pizzicato Strings", action_function = function() InsertMidiProgramChange (45) end},
						{key = "047. Orchestral Harp", action_function = function() InsertMidiProgramChange (46) end},
						{key = "048. Timpani", action_function = function() InsertMidiProgramChange (47) end},
						{key = "049. String Ensemble 1", action_function = function() InsertMidiProgramChange (48) end},
						{key = "050. String Ensemble 2", action_function = function() InsertMidiProgramChange (49) end},
						{key = "051. Synth Strings 1", action_function = function() InsertMidiProgramChange (50) end},
						{key = "052. Synth Strings 2", action_function = function() InsertMidiProgramChange (51) end},
						{key = "053. Choir Aahs", action_function = function() InsertMidiProgramChange (52) end},
						{key = "054. Voice Oohs", action_function = function() InsertMidiProgramChange (53) end},
						{key = "055. Synth Voice", action_function = function() InsertMidiProgramChange (54) end},
						{key = "056. Orchestra Hit", action_function = function() InsertMidiProgramChange (55) end},
						{key = "057. Trumpet", action_function = function() InsertMidiProgramChange (56) end},
						{key = "058. Trombone", action_function = function() InsertMidiProgramChange (57) end},
						{key = "059. Tuba", action_function = function() InsertMidiProgramChange (58) end},
						{key = "060. Muted Trumpet", action_function = function() InsertMidiProgramChange (59) end},
						{key = "061. French Horn", action_function = function() InsertMidiProgramChange (60) end},
						{key = "062. Brass Section", action_function = function() InsertMidiProgramChange (61) end},
						{key = "063. Synth Brass 1", action_function = function() InsertMidiProgramChange (62) end},
						{key = "064. Synth Brass 2", action_function = function() InsertMidiProgramChange (63) end},
						{key = "065. Soprano Sax", action_function = function() InsertMidiProgramChange (64) end},
						{key = "066. Alto Sax", action_function = function() InsertMidiProgramChange (65) end},
						{key = "067. Tenor Sax", action_function = function() InsertMidiProgramChange (66) end},
						{key = "068. Baritone Sax", action_function = function() InsertMidiProgramChange (67) end},
						{key = "069. Oboe", action_function = function() InsertMidiProgramChange (68) end},
						{key = "070. English Horn", action_function = function() InsertMidiProgramChange (69) end},
						{key = "071. Basson", action_function = function() InsertMidiProgramChange (70) end},
						{key = "072. Clarinet", action_function = function() InsertMidiProgramChange (71) end},
						{key = "073. Piccolo", action_function = function() InsertMidiProgramChange (72) end},
						{key = "074. Flute", action_function = function() InsertMidiProgramChange (73) end},
						{key = "075. Recorder", action_function = function() InsertMidiProgramChange (74) end},
						{key = "076. Pan Flute", action_function = function() InsertMidiProgramChange (75) end},
						{key = "077. Blown Bottle", action_function = function() InsertMidiProgramChange (76) end},
						{key = "078. Shakuhachi", action_function = function() InsertMidiProgramChange (77) end},
						{key = "079. Whistle", action_function = function() InsertMidiProgramChange (78) end},
						{key = "080. Ocarina", action_function = function() InsertMidiProgramChange (79) end},
						{key = "081. Lead 1 (square)", action_function = function() InsertMidiProgramChange (80) end},
						{key = "082. Lead 2 (sawtooth)", action_function = function() InsertMidiProgramChange (81) end},
						{key = "083. Lead 3 (calliope)", action_function = function() InsertMidiProgramChange (82) end},
						{key = "084. Lead 4 (chiff)", action_function = function() InsertMidiProgramChange (83) end},
						{key = "085. Lead 5 (charang)", action_function = function() InsertMidiProgramChange (84) end},
						{key = "086. Lead 6 (voice)", action_function = function() InsertMidiProgramChange (85) end},
						{key = "087. Lead 7 (fifths)", action_function = function() InsertMidiProgramChange (86) end},
						{key = "088. Lead 8 (bass + lead)", action_function = function() InsertMidiProgramChange (87) end},
						{key = "089. Pad 1 (new age)", action_function = function() InsertMidiProgramChange (88) end},
						{key = "090. Pad 2 (warm)", action_function = function() InsertMidiProgramChange (89) end},
						{key = "091. Pad 3 (polysynth)", action_function = function() InsertMidiProgramChange (90) end},
						{key = "092. Pad 4 (choir)", action_function = function() InsertMidiProgramChange (91) end},
						{key = "093. Pad 5 (bowed)", action_function = function() InsertMidiProgramChange (92) end},
						{key = "094. Pad 6 (metallic)", action_function = function() InsertMidiProgramChange (93) end},
						{key = "095. Pad 7 (halo)", action_function = function() InsertMidiProgramChange (94) end},
						{key = "096. Pad 8 (sweep)", action_function = function() InsertMidiProgramChange (95) end},
						{key = "097. FX 1 (rain)", action_function = function() InsertMidiProgramChange (96) end},
						{key = "098. FX 2 (soundtrack)", action_function = function() InsertMidiProgramChange (97) end},
						{key = "099. FX 3 (crystal)", action_function = function() InsertMidiProgramChange (98) end},
						{key = "100. FX 4 (atmosphere)", action_function = function() InsertMidiProgramChange (99) end},
						{key = "101. FX 5 (brightness)", action_function = function() InsertMidiProgramChange (100) end},
						{key = "102. FX 6 (goblins)", action_function = function() InsertMidiProgramChange (101) end},
						{key = "103. FX 7 (echoes)", action_function = function() InsertMidiProgramChange (102) end},
						{key = "104. FX 8 (sci-fi)", action_function = function() InsertMidiProgramChange (103) end},
						{key = "105. Sitar", action_function = function() InsertMidiProgramChange (104) end},
						{key = "106. Banjo", action_function = function() InsertMidiProgramChange (105) end},
						{key = "107. Shamisen", action_function = function() InsertMidiProgramChange (106) end},
						{key = "108. Koto", action_function = function() InsertMidiProgramChange (107) end},
						{key = "109. Kalimba", action_function = function() InsertMidiProgramChange (108) end},
						{key = "110. Bagpipe", action_function = function() InsertMidiProgramChange (109) end},
						{key = "111. Fiddle", action_function = function() InsertMidiProgramChange (110) end},
						{key = "112. Shanai", action_function = function() InsertMidiProgramChange (111) end},
						{key = "113. Tinkle Bell", action_function = function() InsertMidiProgramChange (112) end},
						{key = "114. Agogo", action_function = function() InsertMidiProgramChange (113) end},
						{key = "115. Steel Drums", action_function = function() InsertMidiProgramChange (114) end},
						{key = "116. Woodblock", action_function = function() InsertMidiProgramChange (115) end},
						{key = "117. Taiko Drum", action_function = function() InsertMidiProgramChange (116) end},
						{key = "118. Melodic Tom", action_function = function() InsertMidiProgramChange (117) end},
						{key = "119. Synth Drum", action_function = function() InsertMidiProgramChange (118) end},
						{key = "120. Reverse Cymbal", action_function = function() InsertMidiProgramChange (119) end},
						{key = "121. Guitar Fret Noise", action_function = function() InsertMidiProgramChange (120) end},
						{key = "122. Breath Noise", action_function = function() InsertMidiProgramChange (121) end},
						{key = "123. Seashore", action_function = function() InsertMidiProgramChange (122) end},
						{key = "124. Bird Tweet", action_function = function() InsertMidiProgramChange (123) end},
						{key = "125. Telephone Ring", action_function = function() InsertMidiProgramChange (124) end},
						{key = "126. Helicopter", action_function = function() InsertMidiProgramChange (125) end},
						{key = "127. Applause", action_function = function() InsertMidiProgramChange (126) end},
						{key = "128. Gunshot", action_function = function() InsertMidiProgramChange (127) end},
					}},
					
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
			
			TreeNodeLibraryOutput(library_insert_midi_program_change) -- передаём корневой элемент
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
		elseif selected_content == "Track_Automation_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, " Track Automation " )
			
			-- library_track_automation
			local library_track_automation = {
				key = "Track Automation", default_open = true, children = {
					
					-- {spacing_vertical = "1"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					-- {spacing_vertical = "7"},
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},
					-- {separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 148 },
					
					{key = "Automation: Set track automation mode to trim/read", action_id = "40400"},
					{key = "Automation: Set track automation mode to touch", action_id = "40402"},
					{key = "Automation: Set track automation mode to write", action_id = "40403"},
					{key = "Automation: Toggle track between touch and trim/read modes", action_id = "41109"},
					{spacing_vertical = "8"},
					
					{key = "Track: Set track grouping parameters", action_id = "40772"},
					{key = "Options: Show FX inserts in TCP", action_id = "40302"},
					{key = "Track: Toggle show/hide in TCP", action_id = "40853"},
					{key = "Track: Toggle lock/unlock track controls", action_id = "41314"},
					{spacing_vertical = "8"},
					
					{separator_horizontal = "ImGui_SeparatorText", separator_text = "Envelope: Show/Hide"},
					{key = "Envelope: Toggle show all envelopes for tracks", action_id = "41151"},
					{key = "Envelope: Toggle show all envelopes for all tracks", action_id = "41152"},
					{spacing_vertical = "8"},
					{key = "Envelope: Toggle show all active envelopes for tracks", action_id = "40890"},
					{key = "Envelope: Toggle show all active envelopes for all tracks", action_id = "40926"},
					
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
			
			TreeNodeLibraryOutput(library_track_automation) -- передаём корневой элемент
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
		elseif selected_content == "Insert_Empty_Item_Chord_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, " Insert Empty Item Chord Selected Track " )
			
			cboc2(" Insert Item Chord ", function()
				selected_content = "Insert_Item_Chord_Content_Show"
				reaper.SetExtState("MaxMusicMax_ImGuiAlphaWindow", "ImGuiCurrentMenuItem", selected_content, true) 
			end, 0, 25)
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			
			local color_item = "#333333"
			
			local chord_ulaYkZjtGm = reaper.GetExtState("chord_ulaYkZjtGm", "chord_value_ulaYkZjtGm")
			if chord_ulaYkZjtGm == "" then
				chord_ulaYkZjtGm = "C" -- значение по умолчанию
				reaper.SetExtState("chord_ulaYkZjtGm", "chord_value_ulaYkZjtGm", chord_ulaYkZjtGm, false)
			end
			
			local note_item_length_value_ulaYkZjtGm = reaper.GetExtState("insert_item_chord_ulaYkZjtGm", "note_item_length_value_ulaYkZjtGm")
			if note_item_length_value_ulaYkZjtGm == "" then note_item_length_value_ulaYkZjtGm = "1/4" end

			local library_transpose_main = {
				key = "Transpose", default_open = true, children = {
					{key = "B", action_function = function() reaper.SetExtState("chord_ulaYkZjtGm", "chord_value_ulaYkZjtGm", "B", false) end},
					{key = "A#", action_function = function() reaper.SetExtState("chord_ulaYkZjtGm", "chord_value_ulaYkZjtGm", "A#", false) end},
					{key = "A", action_function = function() reaper.SetExtState("chord_ulaYkZjtGm", "chord_value_ulaYkZjtGm", "A", false) end},
					{key = "G#", action_function = function() reaper.SetExtState("chord_ulaYkZjtGm", "chord_value_ulaYkZjtGm", "G#", false) end},
					{key = "G", action_function = function() reaper.SetExtState("chord_ulaYkZjtGm", "chord_value_ulaYkZjtGm", "G", false) end},
					{key = "F#", action_function = function() reaper.SetExtState("chord_ulaYkZjtGm", "chord_value_ulaYkZjtGm", "F#", false) end},
					{key = "F", action_function = function() reaper.SetExtState("chord_ulaYkZjtGm", "chord_value_ulaYkZjtGm", "F", false) end},
					{key = "E", action_function = function() reaper.SetExtState("chord_ulaYkZjtGm", "chord_value_ulaYkZjtGm", "E", false) end},
					{key = "D#", action_function = function() reaper.SetExtState("chord_ulaYkZjtGm", "chord_value_ulaYkZjtGm", "D#", false) end},
					{key = "D", action_function = function() reaper.SetExtState("chord_ulaYkZjtGm", "chord_value_ulaYkZjtGm", "D", false) end},
					{key = "C#", action_function = function() reaper.SetExtState("chord_ulaYkZjtGm", "chord_value_ulaYkZjtGm", "C#", false) end},
					{key = "C", action_function = function() reaper.SetExtState("chord_ulaYkZjtGm", "chord_value_ulaYkZjtGm", "C", false) end},
				},
			}
			
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
						{key = "Introduction", action_function = function() InsertEmptyItemWithNameAndColor( "Вступление", "#0A8B16", note_item_length_value_ulaYkZjtGm) end},
						{key = "Couplet", action_function = function() InsertEmptyItemWithNameAndColor( "Куплет", "#0070CA", note_item_length_value_ulaYkZjtGm) end},
						{key = "Chorus", action_function = function() InsertEmptyItemWithNameAndColor( "Припев", "#E87400", note_item_length_value_ulaYkZjtGm) end},
						{key = "Interlude", action_function = function() InsertEmptyItemWithNameAndColor( "Проигрыш", "#0A8B16", note_item_length_value_ulaYkZjtGm) end},
						{key = "Code", action_function = function() InsertEmptyItemWithNameAndColor( "Кода", "#F24040", note_item_length_value_ulaYkZjtGm) end},
					},},
				
					{key = "Insert Empty Item Chord", default_open = true, children = {
						{key = chord_ulaYkZjtGm .. "", action_function = function() InsertEmptyItemWithNameAndColor( chord_ulaYkZjtGm .. "", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "6", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "6", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "maj", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "∆", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "maj (6/9)", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "∆ (6/9)", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "maj (13#11)", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "∆ (13#11)", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "maj (7#5)", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "∆ (7#5)", color_item, note_item_length_value_ulaYkZjtGm) end},
						{spacing_vertical = "0"},
						{separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 120 },
						{spacing_vertical = "5"},
						
						{key = chord_ulaYkZjtGm .. "7", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "7", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "7(6b9)", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "7(6b9)", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "7(9,11,13)", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "7(9,11,13)", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "7 (13#11)", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "7 (13#11)", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "7 (#9b13)", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "7 (#9b13)", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "7 (b9#9b13)", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "7 (b9#9b13)", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "9", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "9", color_item, note_item_length_value_ulaYkZjtGm) end},
						{spacing_vertical = "0"},
						{separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 120 },
						{spacing_vertical = "5"},
						
						{key = chord_ulaYkZjtGm .. "sus2", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "sus2", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "sus4", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "sus4", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "7sus4", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "7sus4", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "9sus4", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "9sus4", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "13sus4", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "13sus4", color_item, note_item_length_value_ulaYkZjtGm) end},
						{spacing_vertical = "0"},
						{separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 120 },
						{spacing_vertical = "5"},
						
						{key = chord_ulaYkZjtGm .. "m", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "m", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "m6", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "m6", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "m (6/9)", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "m (6/9)", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "m7", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "m7", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "m9", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "m9", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "m (maj11)", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "m (maj11)", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "m (9b13)", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "m (9b13)", color_item, note_item_length_value_ulaYkZjtGm) end},
						{spacing_vertical = "0"},
						{separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 120 },
						{spacing_vertical = "5"},
						
						{key = chord_ulaYkZjtGm .. "ø", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "ø", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "o", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "o", color_item, note_item_length_value_ulaYkZjtGm) end},
						{key = chord_ulaYkZjtGm .. "+", action_function = function() InsertEmptyItemWithNameAndColor(chord_ulaYkZjtGm .. "+", color_item, note_item_length_value_ulaYkZjtGm) end},
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
				reaper.ImGui_Text(ctx, "  " .. chord_ulaYkZjtGm )
				reaper.ImGui_PopStyleColor(ctx)
				reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
				TreeNodeLibraryOutput(library_transpose_main) -- передаём корневой элемент
				
				-- Col 2 ————————————————————————————————————————
				reaper.ImGui_TableNextColumn(ctx)
				reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Text(), HexToColor("#FFFF00")) -- Красный цвет (RGBA)
				reaper.ImGui_Text(ctx, "    " .. note_item_length_value_ulaYkZjtGm )
				reaper.ImGui_PopStyleColor(ctx)
				reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
				TreeNodeLibraryOutput(library_length_note) -- передаём корневой элемент
				
				-- Col 3 ————————————————————————————————————————
				reaper.ImGui_TableNextColumn(ctx)
				reaper.ImGui_Dummy(ctx, 0, 27)  -- Добавление вертикального пространства
				TreeNodeLibraryOutput(insert_empty_item_chord_library) -- передаём корневой элемент
				

			reaper.ImGui_EndTable(ctx) -- Завершаем таблицу
			end
			
			
		elseif selected_content == "Track_Set_Name_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, " Set Name Selected Track Or Item " )
			
			-- library_name_track_item
			local library_name_track_item = {
				key = "Name Library", children = {
		
					
					{spacing_vertical = "1"},
					{separator_horizontal = "2", separator_color = "#636372" },
					{spacing_vertical = "7"},
					{key = "Empty", value = ""},
					-- {is_separator = true},
					-- {is_separator = true},
					{spacing_vertical = "1"},
					{separator_horizontal = "2", separator_color = "#636372" },
					{spacing_vertical = "7"},
					
					{key = "Vocal", value = "Vocal"},
					{key = "Guitar", value = "Guitar"},
					{key = "Bass", value = "Bass"},
					{spacing_vertical = "1"},
					{separator_horizontal = "2", separator_color = "#636372" },
					{spacing_vertical = "7"},
					{key = "Form Song", children = {
						{key = "Introduction", value = "Вступление"},
						{key = "Couplet", value = "Куплет"},
						{key = "Chorus", value = "Припев"},
						{key = "Interlude", value = "Проигрыш"},
						{key = "Code", value = "Кода"},
					},},
					{key = "FX Effects", children = {
						{key = "Reverb", value = "Reverb"},
						{key = "Delay", value = "Delay"},
					},},
					{key = "Piano", children = {
						{key = "Vibraphone", value = "Vibraphone"},
						{key = "Marimba", value = "Marimba"},
						{key = "Xylophone", value = "Xylophone"},
						{spacing_vertical = "1"},
						{separator_horizontal = "2", separator_color = "#636372" },
						{spacing_vertical = "7"},
						
						{key = "Piano", value = "Piano"},
						{key = "Rhodes", value = "Rhodes"},
						{key = "Organ", value = "Organ"},
						{key = "Clavinet", value = "Clavinet"},
					},},
					{key = "String", children = {
						{key = "Violin", value = "Violin"},
						{key = "Cello", value = "Cello"},
						{key = "Pizzicato", value = "Pizzicato"},
						{key = "Marcato ", value = "Marcato "},
					},},
					{key = "Brass Woodwind", children = {
						{key = "Flute", value = "Flute"},
						{key = "Oboe", value = "Oboe"},
						{key = "Clarinet", value = "Clarinet"},
						{key = "Bassoon", value = "Bassoon"},
					},},
					{key = "Brass Wind", children = {
						{key = "Trumpet", value = "Trumpet"},
						{key = "Trumpet Piccolo", value = "Trumpet Piccolo"},
						{key = "Cornet", value = "Cornet"},
						{key = "Trombone", value = "Trombone"},
						{key = "Horn", value = "Horn"},
						{key = "Alto Horn", value = "Alto Horn"},
						{key = "French Horn", value = "French Horn"},
						{key = "Baritone Horn", value = "Baritone Horn"},
						{key = "Flugel Horn", value = "Flugel Horn"},
						{key = "Tenor Horn", value = "Tenor Horn"},
						{key = "Tuba", value = "Tuba"},
					},},
					{key = "Saxophone", children = {
						{key = "Sax Soprano", value = "Sax Soprano"},
						{key = "Sax Alto", value = "Sax Alto"},
						{key = "Sax Tenor", value = "Sax Tenor"},
						{key = "Sax Baritone", value = "Sax Baritone"},
					},},
					{key = "Percussion", children = {
						{key = "Afoxe", value = "Afoxe"},
						{key = "Cabasa", value = "Cabasa"},
						{key = "Cajon", value = "Cajon"},
						{key = "Guiro", value = "Guiro"},
					},},
					{key = "Drums", children = {
						{key = "Drums", value = "Drums"},
						{key = "Kick", value = "Kick"},
						{key = "Snare", value = "Snare"},
						{key = "Tom", value = "Tom"},
						{key = "Hi-Hat", value = "Hi-Hat"},
						{key = "Cymbal", value = "Cymbal"},
						{key = "Ride", value = "Ride"},
						{key = "Ride Bell", value = "Ride Bell"},
						{key = "Crash", value = "Crash"},
						{key = "Crash Bell", value = "Crash Bell"},
						{key = "Splash", value = "Splash"},
					},},
					{spacing_vertical = "20"},
					-- {is_separator = true}, chord_view label
				},
			}
			
			function render_name_track_item_library(node, modeReNameTrackItem)
				
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

				if node.separator_horizontal or node.separator_color then
					-- Если есть параметры для разделителя, передаем их в ThickSeparator
					ThickSeparator(node.separator_horizontal, node.separator_color)
					return
				end
				
				if node.spacing_vertical then -- Если встречаем spacing_vertical, добавляем вертикальное пространство
					local spacing_vertical = tonumber(node.spacing_vertical) -- Преобразуем значение в число
					if spacing_vertical then
						reaper.ImGui_Dummy(ctx, 0, spacing_vertical) -- Добавление вертикального пространства
					end
					return
				end
			
				if node.is_separator then -- Если это разделитель, выводим его
					reaper.ImGui_Separator(ctx)
					return
				end
				
				if node.key then -- Если у узла есть key
					
					local node_id = node.key
					
					local flags = 0 -- Для корневого узла всегда развернут
					if node.key == "Name Library" then
						-- Теперь корректно вызываем функцию для получения флага
						flags = reaper.ImGui_TreeNodeFlags_DefaultOpen()  -- Флаг для развернутого состояния
					end
					
					if node.children then -- Теперь флаги корректно передаются как число
						if reaper.ImGui_TreeNodeEx(ctx, node_id, node.key, flags) then -- развернутого состояния корневого узла
							for _, child in ipairs(node.children) do -- Рекурсивно отображаем дочерние элементы
								render_name_track_item_library(child, modeReNameTrackItem)
							end
							reaper.ImGui_TreePop(ctx) -- Закрываем текущий узел
						end
					else
						if reaper.ImGui_Selectable(ctx, node.key) then -- Листовой узел
							if node.value then -- Если кликнули, выводим value
								reaper.Undo_BeginBlock()
								SetSelectedTrackItemName(node.value, modeReNameTrackItem)
								reaper.Undo_EndBlock("Insert Name Track Item", -1)
								-- print_rs ( node.value )
							end
						end
					end
				end
			end -- render_name_track_item_library
			
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			if reaper.ImGui_RadioButton(ctx, 'Track', modeReNameTrackItem == "track") then modeReNameTrackItem = "track" end
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			if reaper.ImGui_RadioButton(ctx, 'Item', modeReNameTrackItem == "item") then modeReNameTrackItem = "item" end
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			if reaper.ImGui_RadioButton(ctx, 'Empty Item', modeReNameTrackItem == "empty_item") then modeReNameTrackItem = "empty_item" end
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			
			render_name_track_item_library(library_name_track_item, modeReNameTrackItem)
			
		elseif selected_content == "Track_Records_Content_Show" then
			-- library_track_automation
			local library_track_automation = {
				key = "Track Automation", default_open = true, children = {
					-- {spacing_vertical = "1"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					-- {spacing_vertical = "7"},
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},
					-- {separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 148 },
					
					{key = "Options: New recording splits existing items and creates new takes (default)", action_id = "41330"},
					{key = "Options: New recording trims existing items behind new recording (tape mode)", action_id = "41186"},
					{key = "Options: New recording creates new media items", action_id = "41329"},
					{spacing_vertical = "8"},
					
					{key = "Options: Trim content behind automation items when editing or writing automation", action_id = "42206"},
					{key = "Options: Trim content behind media items when editing", action_id = "41117"},
					{spacing_vertical = "8"},
					{key = "Item: Remove content (trim) behind items", action_id = "40930"},
					-- {key = "www", action_id = "www"},
					-- {spacing_vertical = "8"},
					
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
			
			TreeNodeLibraryOutput(library_track_automation) -- передаём корневой элемент
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
		elseif selected_content == "Item_Navigation_Content_Show" then
			
			-- item_navigation_content_show
			local item_navigation_content_show = {
				key = "Item Navigation", default_open = true, children = {
					-- {spacing_vertical = "1"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					-- {spacing_vertical = "7"},
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},

					
					{key = "Select Items On Selected Track", children = {
						-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Select Items On Selected Track"},
						{key = "Move Cursor To Next Item Start On Selected Track (select item)", action_function = function() move_cursor_on_selected_track ("start", "select") end},
						{key = "Move Cursor To Previous Item Start On Selected Track (select item)", action_function = function() move_cursor_on_selected_track_reverse ("start", "select") end},
						{spacing_vertical = "10"},
						{key = "Move Cursor To Next Item End On Selected Track (select item)", action_function = function() move_cursor_on_selected_track ("end", "select") end},
						{key = "Move Cursor To Previous Item End On Selected Track (select item)", action_function = function() move_cursor_on_selected_track_reverse ("end", "select") end},
						{spacing_vertical = "5"},
					}},
					
					{key = "Select All Items", children = {
						-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Select All Items"},
						{key = "Move Cursor To All Items Next Position Start", action_function = function() move_cursor_to_next_position ("start", "select") end},
						{key = "Move Cursor To All Items Previous Position Start", action_function = function() move_cursor_to_previous_position ("start", "select") end},
						{spacing_vertical = "10"},
						{key = "Move Cursor To All Items Next Position End", action_function = function() move_cursor_to_next_position ("end", "select") end},
						{key = "Move Cursor To All Items Previous Position End", action_function = function() move_cursor_to_previous_position ("end", "select") end},
						{spacing_vertical = "5"},
					}},
					
					{key = "No Select Item On Selected Track", children = {
						-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "No Select Item On Selected Track"},
						{key = "Move Cursor To Next Item Start On Selected Track", action_function = function() move_cursor_on_selected_track ("start") end},
						{key = "Move Cursor To Previous Item Start On Selected Track", action_function = function() move_cursor_on_selected_track_reverse ("start") end},
						{spacing_vertical = "10"},
						{key = "Move Cursor To Next Item End On Selected Track", action_function = function() move_cursor_on_selected_track ("end") end},
						{key = "Move Cursor To Previous Item End On Selected Track", action_function = function() move_cursor_on_selected_track_reverse ("end") end},
						{spacing_vertical = "5"},
					}},
					
					{key = "Move Cursor To All Items All Position", children = {
						-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Move Cursor To All Items All Position"},
						{key = "Move Cursor To Next Position", action_function = function() move_cursor_to_next_position () end},
						{key = "Move Cursor To Previous Position", action_function = function() move_cursor_to_previous_position () end},
						{spacing_vertical = "5"},
					}},
					
					{key = "Move Cursor To All Items Position Start", children = {
						-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Move Cursor To All Items Position Start"},
						{key = "Move Cursor To Next Item Position Start", action_function = function() move_cursor_to_next_position ("start") end},
						{key = "Move Cursor To Previous Item Position Start", action_function = function() move_cursor_to_previous_position ("start") end},
						{spacing_vertical = "5"},
					}},
					
					{key = "Move Cursor To All Items Position End", children = {
						-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Move Cursor To All Items Position End"},
						{key = "Move Cursor To Next Item Position End", action_function = function() move_cursor_to_next_position ("end") end},
						{key = "Move Cursor To Previous Item Position End", action_function = function() move_cursor_to_previous_position ("end") end},
						{spacing_vertical = "5"},
					}},
					
					{key = "Item navigation", children = {
						-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Item navigation"},
						{key = "Item navigation: Select and move to next item", action_function = function() reaper.Main_OnCommand(40417, 0) end},
						{key = "Item navigation: Select and move to previous item", action_function = function() reaper.Main_OnCommand(40416, 0) end},
						{spacing_vertical = "10"},
						{key = "Item navigation: Move cursor to start of items", action_function = function() reaper.Main_OnCommand(41173, 0) end},
						{key = "Item navigation: Move cursor to end of items", action_function = function() reaper.Main_OnCommand(41174, 0) end},
					}},
				},
			}
			
			TreeNodeLibraryOutput(item_navigation_content_show, "Item Navigation") -- передаём корневой элемент
			reaper.ImGui_Dummy(ctx, 0, 50)  -- Добавление вертикального пространства
			
			
			if false then
			reaper.ImGui_SeparatorText( ctx, "Select Items On Selected Track" )
			cboc2 ( " Move Cursor To Next Item Start On Selected Track (select item) ", function() move_cursor_on_selected_track ("start", "select") end, 0, 25 )
			cboc2 ( " Move Cursor To Previous Item Start On Selected Track (select item) ", function() move_cursor_on_selected_track_reverse ("start", "select") end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Move Cursor To Next Item End On Selected Track (select item) ", function() move_cursor_on_selected_track ("end", "select") end, 0, 25 )
			cboc2 ( " Move Cursor To Previous Item End On Selected Track (select item) ", function() move_cursor_on_selected_track_reverse ("end", "select") end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			reaper.ImGui_SeparatorText( ctx, "Select All Items" )
			cboc2 ( " Move Cursor To All Items Next Position Start ", function() move_cursor_to_next_position ("start", "select") end, 0, 25 )
			cboc2 ( " Move Cursor To All Items Previous Position Start ", function() move_cursor_to_previous_position ("start", "select") end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Move Cursor To All Items Next Position End ", function() move_cursor_to_next_position ("end", "select") end, 0, 25 )
			cboc2 ( " Move Cursor To All Items Previous Position End ", function() move_cursor_to_previous_position ("end", "select") end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			reaper.ImGui_SeparatorText( ctx, "No Select Item On Selected Track" )
			cboc2 ( " Move Cursor To Next Item Start On Selected Track ", function() move_cursor_on_selected_track ("start") end, 0, 25 )
			cboc2 ( " Move Cursor To Previous Item Start On Selected Track ", function() move_cursor_on_selected_track_reverse ("start") end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Move Cursor To Next Item End On Selected Track ", function() move_cursor_on_selected_track ("end") end, 0, 25 )
			cboc2 ( " Move Cursor To Previous Item End On Selected Track ", function() move_cursor_on_selected_track_reverse ("end") end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			reaper.ImGui_SeparatorText( ctx, " Move Cursor To All Items All Position " )
			cboc2 ( " Move Cursor To Next Position ", function() move_cursor_to_next_position () end, 0, 25 )
			cboc2 ( " Move Cursor To Previous Position ", function() move_cursor_to_previous_position () end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			-- reaper.ImGui_SeparatorText( ctx, " Move Cursor To All Items Position Start " )
			cboc2 ( " Move Cursor To Next Item Position Start ", function() move_cursor_to_next_position ("start") end, 0, 25 )
			cboc2 ( " Move Cursor To Previous Item Position Start ", function() move_cursor_to_previous_position ("start") end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			-- reaper.ImGui_SeparatorText( ctx, " Move Cursor To All Items Position End " )
			cboc2 ( " Move Cursor To Next Item Position End ", function() move_cursor_to_next_position ("end") end, 0, 25 )
			cboc2 ( " Move Cursor To Previous Item Position End ", function() move_cursor_to_previous_position ("end") end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			reaper.ImGui_SeparatorText( ctx, " Item navigation " )
			cboc2 ( " Item navigation: Select and move to next item ", function() reaper.Main_OnCommand(40417, 0) end, 0, 25 )
			cboc2 ( " Item navigation: Select and move to previous item ", function() reaper.Main_OnCommand(40416, 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Item navigation: Move cursor to start of items ", function() reaper.Main_OnCommand(41173, 0) end, 0, 25 )
			cboc2 ( " Item navigation: Move cursor to end of items ", function() reaper.Main_OnCommand(41174, 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			end
			
			
		elseif selected_content == "Frequent_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Frequent" )
			
			-- library_frequent_fx
			local library_frequent_fx = {
				key = "Frequent", default_open = true, children = {
					
					{separator_horizontal = "ImGui_SeparatorText", separator_text = "Track Mode"},
					{key = "Track Default", action_function = function() EnableMidiModeOnTheTrack(0) end},		
					{key = "Track MIDI", action_function = function() EnableMidiModeOnTheTrack(1) end},
					{spacing_vertical = "1"},
					{separator_horizontal = "3", separator_color = "#3F3F48" },
					{spacing_vertical = "7"},
					-- {key = "Track Mode", children = {
					-- }},
					
					{key = "Insert Midi Track", children = {
						{key = "Insert Default Midi Track", action_function = function() 
							InsertNewTrackAndAddFX ("ReaControlMIDI (Cockos)", "", 1, 0) 
							Add_FX ("Piano Display (by Geraint Luff) [Geraint's JSFX/Utility/Piano-Display/piano-display.jsfx]", "", 0)
							Add_FX ("midiKeyboard (Insert Piz Here)", "", 0)
							Add_FX ("BassMidiVsti (x86) (Falcosoft)", "", 0)
							Add_FX ("midiChords (Insert Piz Here)", "", 0)
							Add_FX ("midiChordAnalyzer (Insert Piz Here)", "", 0)
							Add_FX ("Virtual Sound Canvas (x86) (EDIROL) (8 out)", "", 1)
							Add_FX ("Purity (x86) (LUXONIX) (4 out)", "", 0)
							Add_FX ("Pro-L 2 (FabFilter)", "", 0)
						end},
						{key = "MONSTER Drum v3-2022.07 (AgusHardiman.TV) (32 out)", action_function = function() InsertNewTrackAndAddFX ("MONSTER Drum v3-2022.07 (AgusHardiman.TV) (32 out)", "", 1) end},
						{key = "Kick 2 (Sonic Academy)", action_function = function() InsertNewTrackAndAddFX ("Kick 2 (Sonic Academy)", "", 1) end},
						{key = "ReaSamplOmatic5000 (Cockos)", action_function = function() InsertNewTrackAndAddFX ("ReaSamplOmatic5000 (Cockos)", "", 1) end},
					}},
					
					{key = "Insert FX in Track", children = {	
						-- {spacing_vertical = "1"},
						-- {separator_horizontal = "3", separator_color = "#3F3F48" },
						-- {spacing_vertical = "7"},
						{separator_horizontal = "ImGui_SeparatorText", separator_text = "Equalizer"},
						{key = "ReaEQ (Cockos)", action_function = function() Add_FX("ReaEQ (Cockos)", "MaxMusicMax — Default") end},
						{key = "Pro-Q 3 (FabFilter)", action_function = function() Add_FX ("Pro-Q 3 (FabFilter)", "") end},
						{key = "KirchhoffEQ (TBTECH)", action_function = function() Add_FX ("KirchhoffEQ (TBTECH)", "") end},
						
						{separator_horizontal = "ImGui_SeparatorText", separator_text = "Delay"},
						{key = "ReaDelay (Cockos)", action_function = function() Add_FX("ReaDelay (Cockos)", "") end},
						{key = "Timeless 3 (FabFilter)", action_function = function() Add_FX ("Timeless 3 (FabFilter)", "") end},
						{key = "ValhallaDelay", action_function = function() Add_FX ("ValhallaDelay (Valhalla DSP, LLC)", "") end},
						{key = "Doubler4 Stereo (Waves)", action_function = function() Add_FX ("Doubler4 Stereo (Waves)", "") end},
						
						{separator_horizontal = "ImGui_SeparatorText", separator_text = "Reverb"},
						{key = "Pro-R (FabFilter)", action_function = function() Add_FX ("Pro-R (FabFilter)", "") end},
						{key = "ValhallaVintageVerb", action_function = function() Add_FX ("ValhallaVintageVerb (Valhalla DSP, LLC)", "") end},
						
						{separator_horizontal = "ImGui_SeparatorText", separator_text = "Compressor"},
						{key = "ReaComp (Cockos)", action_function = function() Add_FX("ReaComp (Cockos)", "") end},
						{key = "Pro-C 2 (FabFilter)", action_function = function() Add_FX ("Pro-C 2 (FabFilter)", "") end},
						{key = "Pro-MB (FabFilter)", action_function = function() Add_FX ("Pro-MB (FabFilter)", "") end},
						{key = "Pro-L 2 (FabFilter)", action_function = function() Add_FX ("Pro-L 2 (FabFilter)", "") end},
						{spacing_vertical = "1"},
						{separator_horizontal = "3", separator_color = "#3F3F48" },
						{spacing_vertical = "7"},
						
						{key = "ReaPitch (Cockos)", action_function = function() Add_FX("ReaPitch (Cockos)", "") end},
						{key = "Pro-DS (FabFilter)", action_function = function() Add_FX ("Pro-DS (FabFilter)", "") end},
						{key = "Saturn 2 (FabFilter)", action_function = function() Add_FX ("Saturn 2 (FabFilter)", "") end},
						{key = "soothe2 (oeksound)", action_function = function() Add_FX ("soothe2 (oeksound)", "") end},
						{key = "spiff (oeksound)", action_function = function() Add_FX ("spiff (oeksound)", "") end},
						{spacing_vertical = "1"},
						{separator_horizontal = "3", separator_color = "#3F3F48" },
						{spacing_vertical = "7"},
						
						{key = "ReaSamplOmatic5000 (Cockos)", action_function = function() Add_FX("ReaSamplOmatic5000 (Cockos)", "") end},
						{key = "ReaControlMIDI (Cockos)", action_function = function() Add_FX("ReaControlMIDI (Cockos)", "") end},
						{spacing_vertical = "1"},
						{separator_horizontal = "3", separator_color = "#3F3F48" },
						{spacing_vertical = "7"},
				
					}},
					
					{key = "Insert VST in Track", default_open = true, children = {
						{spacing_vertical = "1"},
						{separator_horizontal = "3", separator_color = "#3F3F48" },
						{spacing_vertical = "7"},
						{key = "Vital (Vital Audio)", action_function = function() Add_FX("Vital (Vital Audio)", "") end},
						{key = "Phase Plant (Kilohearts)", action_function = function() Add_FX("Phase Plant (Kilohearts)", "") end},
						{key = "Serum (Xfer Records)", action_function = function() Add_FX("Serum (Xfer Records)", "") end},
						{spacing_vertical = "1"},
						{separator_horizontal = "3", separator_color = "#3F3F48" },
						{spacing_vertical = "7"},
						
						{key = "KickDrum (Audija)", action_function = function() Add_FX("KickDrum (Audija)", "") end},
						{key = "Kick 2 (Sonic Academy)", action_function = function() Add_FX("Kick 2 (Sonic Academy)", "") end},
						{spacing_vertical = "1"},
						{separator_horizontal = "3", separator_color = "#3F3F48" },
						{spacing_vertical = "7"},
						
						{key = "Kontakt 7 (Native Instruments)", action_function = function() Add_FX("Kontakt 7 (Native Instruments) (64 out)", "") end},
						{key = "UVI Falcon", action_function = function() Add_FX("Falcon (UVI) (34 out)", "") end},
						{key = "UVI Workstation", action_function = function() Add_FX("UVIWorkstation (UVI) (34 out)", "") end},
						{spacing_vertical = "1"},
						{separator_horizontal = "3", separator_color = "#3F3F48" },
						{spacing_vertical = "7"},
						
						{key = "Virtual Sound Canvas (EDIROL)", action_function = function() Add_FX("Virtual Sound Canvas (x86) (EDIROL) (8 out)", "") end},
						{key = "Purity (SonicCat)", action_function = function() Add_FX("Purity (SonicCat) (4 out)", "") end},
						{key = "Purity (LUXONIX)", action_function = function() Add_FX("Purity (x86) (LUXONIX) (4 out)", "") end},
						{key = "BassMidiVsti (Falcosoft)", action_function = function() Add_FX("BassMidiVsti (x86) (Falcosoft)", "") end},
						{key = "ReaControlMIDI (Cockos)", action_function = function() Add_FX("ReaControlMIDI (Cockos)", "") end},
						-- {key = "www", action_function = function() Add_FX("www", "") end},
					}},
					
					-- {key = "www", action_function = function() www end},
					-- {key = "www", action_function = function() www end},

					-- {key = "www", action_id = "www"},
		
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
			
			TreeNodeLibraryOutput(library_frequent_fx, "Frequent", true) -- передаём корневой элемент
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			if false then
			cboc2 ( " Track For MIDI ", function() EnableMidiModeOnTheTrack (1) end, 0, 25 )
			cboc2 ( " Track Default ", function() EnableMidiModeOnTheTrack (0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " ReaEQ (Cockos) ", function() Add_FX ("ReaEQ (Cockos)", "MaxMusicMax — Default") end, 0, 25 )
			cboc2 ( " ReaDelay (Cockos) ", function() Add_FX ("ReaDelay (Cockos)", "") end, 0, 25 )
			cboc2 ( " ReaPitch (Cockos) ", function() Add_FX ("ReaPitch (Cockos)", "") end, 0, 25 )
			cboc2 ( " ReaComp (Cockos) ", function() Add_FX ("ReaComp (Cockos)", "") end, 0, 25 )
			cboc2 ( " ReaSamplOmatic5000 (Cockos) ", function() Add_FX ("ReaSamplOmatic5000 (Cockos)", "") end, 0, 25 )
			cboc2 ( " ReaControlMIDI (Cockos) ", function() Add_FX ("ReaControlMIDI (Cockos)", "") end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Virtual Sound Canvas (EDIROL) ", function() Add_FX ("Virtual Sound Canvas (x86) (EDIROL) (8 out)", "") end, 0, 25 )
			cboc2 ( " Serum (Xfer Records) ", function() Add_FX ("Serum (Xfer Records)", "") end, 0, 25 )
			cboc2 ( " Vital (Vital Audio) ", function() Add_FX ("Vital (Vital Audio)", "") end, 0, 25 )
			cboc2 ( " Phase Plant (Kilohearts) ", function() Add_FX ("Phase Plant (Kilohearts)", "") end, 0, 25 )
			cboc2 ( " Kontakt 7 (Native Instruments) ", function() Add_FX ("Kontakt 7 (Native Instruments) (64 out)", "") end, 0, 25 )
			end
		elseif selected_content == "FX_Plugins_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "FX Plugins" )
			cboc2 ( " ReaEQ (Cockos) ", function() Add_FX ("ReaEQ (Cockos)", "MaxMusicMax — Default") end, 0, 25 )
			cboc2 ( " ReaDelay (Cockos) ", function() Add_FX ("ReaDelay (Cockos)", "") end, 0, 25 )
			cboc2 ( " ReaPitch (Cockos) ", function() Add_FX ("ReaPitch (Cockos)", "") end, 0, 25 )
			cboc2 ( " ReaComp (Cockos) ", function() Add_FX ("ReaComp (Cockos)", "") end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Doubler4 Stereo (Waves) ", function() Add_FX ("Doubler4 Stereo (Waves)", "") end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Pro-L 2 (FabFilter) ", function() Add_FX ("Pro-L 2 (FabFilter)", "") end, 0, 25 )
			cboc2 ( " Pro-Q 3 (FabFilter) ", function() Add_FX ("Pro-Q 3 (FabFilter)", "") end, 0, 25 )
			cboc2 ( " Pro-R (FabFilter) ", function() Add_FX ("Pro-R (FabFilter)", "") end, 0, 25 )
			cboc2 ( " Pro-MB (FabFilter) ", function() Add_FX ("Pro-MB (FabFilter)", "") end, 0, 25 )
			cboc2 ( " Saturn 2 (FabFilter) ", function() Add_FX ("Saturn 2 (FabFilter)", "") end, 0, 25 )
			cboc2 ( " Timeless 3 (FabFilter) ", function() Add_FX ("Timeless 3 (FabFilter)", "") end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
		elseif selected_content == "VST_Instruments_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Create Track" )
			cboc2 ( " Insert Midi Track ", 
			function() 
				InsertNewTrackAndAddFX ("ReaControlMIDI (Cockos)", "", 1, 0) 
				Add_FX ("Piano Display (by Geraint Luff) [Geraint's JSFX/Utility/Piano-Display/piano-display.jsfx]", "", 0)
				Add_FX ("midiKeyboard (Insert Piz Here)", "", 0)
				Add_FX ("BassMidiVsti (x86) (Falcosoft)", "", 0)
				Add_FX ("midiChords (Insert Piz Here)", "", 0)
				Add_FX ("midiChordAnalyzer (Insert Piz Here)", "", 0)
				Add_FX ("Virtual Sound Canvas (x86) (EDIROL) (8 out)", "", 1)
				Add_FX ("Purity (x86) (LUXONIX) (4 out)", "", 0)
				Add_FX ("Pro-L 2 (FabFilter)", "", 0)
			end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			cboc2 ( " Virtual Sound Canvas ", function() InsertNewTrackAndAddFX ("Virtual Sound Canvas (x86) (EDIROL) (8 out)", "", 1) end, 0, 25 )
			cboc2 ( " Vital (Vital Audio) ", function() InsertNewTrackAndAddFX ("Vital (Vital Audio)", "", 1) end, 0, 25 )
			cboc2 ( " Serum (Xfer Records) ", function() InsertNewTrackAndAddFX ("Serum (Xfer Records)", "", 1) end, 0, 25 )
			cboc2 ( " Phase Plant (Kilohearts) ", function() InsertNewTrackAndAddFX ("Phase Plant (Kilohearts)", "", 1) end, 0, 25 )
			cboc2 ( " Kontakt 7 (Native Instruments) ", function() InsertNewTrackAndAddFX ("Kontakt 7 (Native Instruments) (64 out)", "", 1) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " MONSTER Drum v3-2022.07 (AgusHardiman.TV) (32 out) ", function() InsertNewTrackAndAddFX ("MONSTER Drum v3-2022.07 (AgusHardiman.TV) (32 out)", "", 1) end, 0, 25 )
			cboc2 ( " Kick 2 (Sonic Academy) ", function() InsertNewTrackAndAddFX ("Kick 2 (Sonic Academy)", "", 1) end, 0, 25 )
			cboc2 ( " ReaSamplOmatic5000 (Cockos) ", function() InsertNewTrackAndAddFX ("ReaSamplOmatic5000 (Cockos)", "", 1) end, 0, 25 )
			
			-- cboc2 ( " www ", function() InsertNewTrackAndAddFX ("www", "", 1) end, 0, 25 )
			
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			reaper.ImGui_SeparatorText( ctx, "Insert VST Instruments" )
			cboc2 ( " Virtual Sound Canvas (EDIROL) ", function() Add_FX ("Virtual Sound Canvas (x86) (EDIROL) (8 out)", "") end, 0, 25 )
			cboc2 ( " Serum (Xfer Records) ", function() Add_FX ("Serum (Xfer Records)", "") end, 0, 25 )
			cboc2 ( " Vital (Vital Audio) ", function() Add_FX ("Vital (Vital Audio)", "") end, 0, 25 )
			cboc2 ( " Phase Plant (Kilohearts) ", function() Add_FX ("Phase Plant (Kilohearts)", "") end, 0, 25 )
			cboc2 ( " Kontakt 7 (Native Instruments) ", function() Add_FX ("Kontakt 7 (Native Instruments) (64 out)", "") end, 0, 25 )
			cboc2 ( " ReaControlMIDI (Cockos) ", function() Add_FX ("ReaControlMIDI (Cockos)", "") end, 0, 25 )
			cboc2 ( " ReaSamplOmatic5000 (Cockos) ", function() Add_FX ("ReaSamplOmatic5000 (Cockos)", "") end, 0, 25 )
			reaper.ImGui_Text(ctx, '\n')
		elseif selected_content == "Other_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Item Other Settings" )
			cboc2 ( " Item ReName Empty Line ", function() ItemReNameEmptyLine() end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Item navigation: Move cursor to start of items ", function() reaper.Main_OnCommand(41173, 0) end, 0, 25 )
			cboc2 ( " Item navigation: Move cursor to end of items ", function() reaper.Main_OnCommand(41174, 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Track properties: Free item positioning ", function() reaper.Main_OnCommand(40641, 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Item properties: Toggle take reverse ", function() reaper.Main_OnCommand(41051, 0) end, 0, 25 )
			cboc2 ( " Item: Delete all take markers ", function() reaper.Main_OnCommand(42387, 0) end, 0, 25 )
			cboc2 ( " Item properties: Set item rate to 1.0 ", function() reaper.Main_OnCommand(40652, 0) end, 0, 25 )
			cboc2 ( " Item: Reset items volume to +0dB ", function() reaper.Main_OnCommand(41923, 0) end, 0, 25 )
			cboc2 ( " Item properties: Display item time ruler ", function() reaper.Main_OnCommand(42312, 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			CreateCommandCheckbox (40070, "Options: Move envelope points with media items")
			-- cboc2 ( " Options: Move envelope points with media items ", function() reaper.Main_OnCommand(40070, 0) end, 0, 25 )
			cboc2 ( " Options: Auto-crossfade media items when editing ", function() reaper.Main_OnCommand(40041, 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " View: Toggle show/hide item labels ", function() reaper.Main_OnCommand(40651, 0) end, 0, 25 )
		elseif selected_content == "Item_Grouping_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Item Grouping" )
			
			CreateCommandCheckbox (1156, "Options: Toggle item grouping override")
			CreateCommandCheckbox (41156, "Options: Selecting one grouped item selects group")
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			local library_grouping_items = {
				key = "Item Grouping", default_open = true, children = {
					
					-- {spacing_vertical = "1"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					-- {spacing_vertical = "7"},
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},
					-- {separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 148 },
					
					-- {key = "Options: Toggle item grouping override", action_id = "1156"},
					-- {key = "Options: Selecting one grouped item selects group", action_id = "41156"},
					-- {spacing_vertical = "12"},
					
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Item Grouping"},
					{key = "Item grouping: Group items", action_id = "40032"},
					{key = "Item grouping: Remove items from group", action_id = "40033"},
					{key = "Item grouping: Select all items in groups", action_id = "40034"},
		
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
			
			TreeNodeLibraryOutput(library_grouping_items) -- передаём корневой элемент
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			-- reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			-- cboc2 ( " Item grouping: Group items ", function() reaper.Main_OnCommand(40032, 0) end, 0, 25 )
			-- cboc2 ( " Item grouping: Remove items from group ", function() reaper.Main_OnCommand(40033, 0) end, 0, 25 )
			-- cboc2 ( " Item grouping: Select all items in groups ", function() reaper.Main_OnCommand(40034, 0) end, 0, 25 )
			
		elseif selected_content == "Spectrogram_Content_Show" then
			
			-- library_spectrogram_main
			local library_spectrogram_main = {
				key = "Spectrogram", default_open = true, children = {
					
					-- {spacing_vertical = "1"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					-- {spacing_vertical = "7"},
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},
					-- {separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 148 },
					
					{spacing_vertical = "1"},
					{separator_horizontal = "3", separator_color = "#3F3F48" },
					{spacing_vertical = "7"},
					{key = "View: Show peaks display settings", action_id = "42074"},
					{key = "Spectrogram: Add spectral edit to item", action_id = "42302"},
					{key = "Spectrogram: Toggle show spectrogram for selected items", action_id = "42303"},
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
			
			TreeNodeLibraryOutput(library_spectrogram_main) -- передаём корневой элемент
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
		elseif selected_content == "Sibilance_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Sibilance" )
			
			-- library_sibilance
			local library_sibilance = {
				key = "Sibilance", default_open = true,  children = {
					-- {spacing_vertical = "1"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					-- {spacing_vertical = "7"},
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},
					{key = "Set Stretch Marker; Selected Items; Sibilance Start And End", action_function = function() DetectAndMarkSibilance("start_end") end},
					{key = "Set Stretch Marker; Selected Items; Sibilance Start", action_function = function() DetectAndMarkSibilance("start") end},
					{key = "Set Stretch Marker; Selected Items; Sibilance End", action_function = function() DetectAndMarkSibilance("end") end},
					{key = "Item: Dynamic split items", action_id = "40760"},
					{spacing_vertical = "8"},
					
					{separator_horizontal = "ImGui_SeparatorText", separator_text = "Remove Markers"},
					{key = "Item: Remove All Stretch Markers In Selected Item", action_id = "41844"},
					{key = "Item: Remove All Stretch Markers In Time Selection", action_id = "41845"},
					
					{key = "Markers: Remove All Markers From Time Selection", action_id = "40420"},
					{key = "Item: Reset items volume to +0dB", action_id = "41923"},
					{spacing_vertical = "8"},
					
					{separator_horizontal = "ImGui_SeparatorText", separator_text = "Set Get Selected Track Item"},
					{key = "Remember Selection Track ID", action_function = function() SetGetSelectedTrackID("remember_selection") end},
					{key = "Install Selection Track ID", action_function = function() SetGetSelectedTrackID("install_selection") end},
					{key = "Clean Selection Track ID", action_function = function() SetGetSelectedTrackID("clean_selection") end},
					{spacing_vertical = "8"},
					{key = "Remember Selection Item ID", action_function = function() SetGetSelectedItemID("remember_selection") end},
					{key = "Install Selection Item ID", action_function = function() SetGetSelectedItemID("install_selection") end},
					{key = "Clean Selection Item ID", action_function = function() SetGetSelectedItemID("clean_selection") end},

					-- {key = "www", action_id = "www"},
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
			
			TreeNodeLibraryOutput(library_sibilance) -- передаём корневой элемент
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			if false then
				cboc2 ( " Set Stretch Marker; Selected Items; Sibilance Start And End ", function() DetectAndMarkSibilance("start_end") end, 0, 25 )
				cboc2 ( " Set Stretch Marker; Selected Items; Sibilance Start ", function() DetectAndMarkSibilance("start") end, 0, 25 )
				cboc2 ( " Set Stretch Marker; Selected Items; Sibilance End ", function() DetectAndMarkSibilance("end") end, 0, 25 )
				reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
				cboc2 ( " Item: Remove All Stretch Markers In Selected Item ", function() reaper.Main_OnCommand(41844, 0) end, 0, 25 )
				cboc2 ( " Item: Remove All Stretch Markers In Time Selection ", function() reaper.Main_OnCommand(41845, 0) end, 0, 25 )
				reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
				cboc2 ( " Markers: Remove All Markers From Time Selection ", function() reaper.Main_OnCommand(40420, 0) end, 0, 25 )
				cboc2 ( " Item: Reset items volume to +0dB ", function() reaper.Main_OnCommand(41923, 0) end, 0, 25 )
				reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
				reaper.ImGui_SeparatorText( ctx, "Set Get Selected Track Item" )
				cboc2 ( " Remember Selection Track ID ", function() SetGetSelectedTrackID("remember_selection") end, 0, 25 )
				cboc2 ( " Install Selection Track ID ", function() SetGetSelectedTrackID("install_selection") end, 0, 25 )
				cboc2 ( " Clean Selection Track ID ", function() SetGetSelectedTrackID("clean_selection") end, 0, 25 )
				reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
				cboc2 ( " Remember Selection Item ID ", function() SetGetSelectedItemID("remember_selection") end, 0, 25 )
				cboc2 ( " Install Selection Item ID ", function() SetGetSelectedItemID("install_selection") end, 0, 25 )
				cboc2 ( " Clean Selection Item ID ", function() SetGetSelectedItemID("clean_selection") end, 0, 25 )
			end
			
		elseif selected_content == "Envelope_Points_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Envelope Points" )
			-- reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			if reaper.ImGui_CollapsingHeader(ctx, 'Select points') then
				reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
				cboc2 ( " Select points on both sides of cursor ", function() SelectNearestEnvelopePointsAroundCursor("both") end, 0, 30 )
				cboc2 ( " Select points on left sides of cursor ", function() SelectNearestEnvelopePointsAroundCursor("left") end, 0, 30 )
				cboc2 ( " Select points on right sides of cursor ", function() SelectNearestEnvelopePointsAroundCursor("right") end, 0, 30 )
				reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			end
			
			if reaper.ImGui_CollapsingHeader(ctx, 'Set Envelope Points Value') then
				reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
				cboc2 ( " Points Reset ", function() reaper.Main_OnCommand(40415, 0) end, 229, 25 )
				
				cboc2 ( " Points -30 ", function() changeSelectedEnvelopePoints (-30) end, 110, 25 )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " Points +30 ", function() changeSelectedEnvelopePoints (30) end, 110, 25 )
				
				cboc2 ( " Points -20 ", function() changeSelectedEnvelopePoints (-20) end, 110, 25 )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " Points +20 ", function() changeSelectedEnvelopePoints (20) end, 110, 25 )
				
				cboc2 ( " Points -15 ", function() changeSelectedEnvelopePoints (-15) end, 110, 25 )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " Points +15 ", function() changeSelectedEnvelopePoints (15) end, 110, 25 )
				
				cboc2 ( " Points -10 ", function() changeSelectedEnvelopePoints (-10) end, 110, 25 )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " Points +10 ", function() changeSelectedEnvelopePoints (10) end, 110, 25 )
				
				cboc2 ( " Points -5.0 ", function() changeSelectedEnvelopePoints (-5) end, 110, 25 )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " Points +5.0 ", function() changeSelectedEnvelopePoints (5) end, 110, 25 )
				
				cboc2 ( " Points -2.0 ", function() changeSelectedEnvelopePoints (-2) end, 110, 25 )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " Points +2.0 ", function() changeSelectedEnvelopePoints (2) end, 110, 25 )
				
				cboc2 ( " Points -1.0 ", function() changeSelectedEnvelopePoints (-1) end, 110, 25 )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " Points +1.0 ", function() changeSelectedEnvelopePoints (1) end, 110, 25 )
				
				cboc2 ( " Points -0.5 ", function() changeSelectedEnvelopePoints (-0.5) end, 110, 25 )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " Points +0.5 ", function() changeSelectedEnvelopePoints (0.5) end, 110, 25 )
				
				cboc2 ( " Points -0.1 ", function() changeSelectedEnvelopePoints (-0.1) end, 110, 25 )
				reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
				cboc2 ( " Points +0.1 ", function() changeSelectedEnvelopePoints (0.1) end, 110, 25 )
				reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			end
			
			if reaper.ImGui_CollapsingHeader(ctx, 'Set shape of selected points') then
				reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
				cboc2 ( " Envelope: Set shape of selected points to linear ", function() reaper.Main_OnCommand(40189, 0) end, 0, 25 )
				cboc2 ( " Envelope: Set shape of selected points to bezier ", function() reaper.Main_OnCommand(40683, 0) end, 0, 25 )
				cboc2 ( " Envelope: Set shape of selected points to fast end ", function() reaper.Main_OnCommand(40429, 0) end, 0, 25 )
				cboc2 ( " Envelope: Set shape of selected points to fast start ", function() reaper.Main_OnCommand(40428, 0) end, 0, 25 )
				cboc2 ( " Envelope: Set shape of selected points to slow start/end ", function() reaper.Main_OnCommand(40424, 0) end, 0, 25 )
				cboc2 ( " Envelope: Set shape of selected points to square ", function() reaper.Main_OnCommand(40190, 0) end, 0, 25 )
				reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			end
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
				
		elseif selected_content == "Envelope_Automation_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Envelope Automation" )
			
			local library_EnvelopeAutomation = {
				key = "Envelope Automation", default_open = true, children = {
					{spacing_vertical = "1"},
					{separator_horizontal = "3", separator_color = "#3F3F48" },
					{spacing_vertical = "7"},
					{key = "Envelope: Show all envelopes for track", action_id = "41148"},
					{key = "Envelope: Hide all envelopes for track", action_id = "40889"},
					{spacing_vertical = "1"},
					{separator_horizontal = "3", separator_color = "#3F3F48" },
					{spacing_vertical = "7"},
					{key = "Envelope: Show all envelopes for all tracks", action_id = "41149"},
					{key = "Envelope: Hide all envelopes for all tracks", action_id = "41150"},
					{spacing_vertical = "1"},
					{separator_horizontal = "3", separator_color = "#3F3F48" },
					{spacing_vertical = "7"},
					{key = "Envelope: Insert automation item", action_id = "42082"},
					{key = "Envelope: Duplicate automation items", action_id = "42083"},
					{key = "Envelope: Duplicate and pool automation items", action_id = "42085"},
					{spacing_vertical = "1"},
					{separator_horizontal = "3", separator_color = "#3F3F48" },
					{spacing_vertical = "7"},
					{key = "Envelope: Toggle show all envelopes for tracks", action_id = "41151"},
					{key = "Envelope: Toggle show all envelopes for all tracks", action_id = "41152"},
					{key = "Envelope: Toggle show all active envelopes for tracks", action_id = "40890"},
					{key = "Envelope: Toggle show all active envelopes for all tracks", action_id = "40926"},
					{spacing_vertical = "1"},
					{separator_horizontal = "3", separator_color = "#3F3F48" },
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
			
			TreeNodeLibraryOutput(library_EnvelopeAutomation, "Envelope Automation", true) -- передаём корневой элемент
			reaper.ImGui_Dummy(ctx, 0, 200)  -- Добавление вертикального пространства

		elseif selected_content == "Item_Volume_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Select Item Volume" )
			reaper.ImGui_Text(ctx, '\n')
			handleVolumeChange(ctx, {reaper.ImGui_DragDouble(ctx, "  ", volume_db, 0.05, -180.0, 48.0, "%.3f dB")})
			
			reaper.ImGui_Text(ctx, '\n')
			cboc2 ( " Volume Reset ", function() reaper.Main_OnCommand(41923, 0) end, 229, 25 )
			
			cboc2 ( " Volume -5.0 ", function() changeVolumeForSelectedItems (-5) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " Volume +5.0 ", function() changeVolumeForSelectedItems (5) end, 110, 25 )
			
			cboc2 ( " Volume -3.0 ", function() changeVolumeForSelectedItems (-3) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " Volume +3.0 ", function() changeVolumeForSelectedItems (3) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			cboc2 ( " Volume -2.0 ", function() changeVolumeForSelectedItems (-2) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " Volume +2.0 ", function() changeVolumeForSelectedItems (2) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			cboc2 ( " Volume -1.0 ", function() changeVolumeForSelectedItems (-1) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " Volume +1.0 ", function() changeVolumeForSelectedItems (1) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			cboc2 ( " Volume -0.5 ", function() changeVolumeForSelectedItems (-0.5) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " Volume +0.5 ", function() changeVolumeForSelectedItems (0.5) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			cboc2 ( " Volume -0.25 ", function() changeVolumeForSelectedItems (-0.25) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " Volume +0.25 ", function() changeVolumeForSelectedItems (0.25) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			cboc2 ( " Volume -0.10 ", function() changeVolumeForSelectedItems (-0.10) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " Volume +0.10 ", function() changeVolumeForSelectedItems (0.10) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			cboc2 ( " Volume -0.01 ", function() changeVolumeForSelectedItems (-0.01) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " Volume +0.01 ", function() changeVolumeForSelectedItems (0.01) end, 110, 25 )
			
			reaper.ImGui_Text(ctx, '\n')
		elseif selected_content == "Item_Pitch_Content_Show" then
			-- reaper.ImGui_Text(ctx, "Item Pitch")
			reaper.ImGui_SeparatorText( ctx, "Select Item Pitch" )
			
			reaper.ImGui_Text(ctx, '\n')
			handlePitchChange(ctx, {reaper.ImGui_DragDouble(ctx, " ", pitch_change, 0.01, -24.0, 24.0, "%.3f")})
			
			reaper.ImGui_Text(ctx, '\n')
			cboc2 ( " Pitch Reset ", function() reaper.Main_OnCommand(40653, 0) end, 229, 25 )
			
			cboc2 ( " Pitch -3.0 ", function() changePitchForSelectedItems (-3) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " Pitch +3.0 ", function() changePitchForSelectedItems (3) end, 110, 25 )
			
			cboc2 ( " Pitch -2.0 ", function() changePitchForSelectedItems (-2) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " Pitch +2.0 ", function() changePitchForSelectedItems (2) end, 110, 25 )
			
			cboc2 ( " Pitch -1.0 ", function() changePitchForSelectedItems (-1) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " Pitch +1.0 ", function() changePitchForSelectedItems (1) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			cboc2 ( " Pitch -0.5 ", function() changePitchForSelectedItems (-0.5) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " Pitch +0.5 ", function() changePitchForSelectedItems (0.5) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			cboc2 ( " Pitch -0.1 ", function() changePitchForSelectedItems (-0.1) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " Pitch +0.1 ", function() changePitchForSelectedItems (0.1) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			cboc2 ( " Pitch -0.01 ", function() changePitchForSelectedItems (-0.01) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( " Pitch +0.01 ", function() changePitchForSelectedItems (0.01) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			reaper.ImGui_Text(ctx, '\n')
			
		elseif selected_content == "Quantize_Content_Show" then
			-- library_grid_main
			local library_quantize_item = {
				key = "Quantize Item", default_open = true,  children = {
					-- {spacing_vertical = "1"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					-- {spacing_vertical = "7"},
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},
					{key = "Item edit: Move left edge of item to edit cursor", action_id = "41306"},
					{key = "SWS: Quantize item's edges to grid (change length)", action_id = "_SWS_QUANTITEEDGES"},
					-- {key = "www", action_id = "www"},
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
			
			TreeNodeLibraryOutput(library_quantize_item, "Quantize Item", true) -- передаём корневой элемент
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
		elseif selected_content == "Item_Rate_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Select Item Rate" )
			reaper.ImGui_Dummy(ctx, 0, 10)  -- Добавление вертикального пространства
			
			-- handleRateChange(ctx, {reaper.ImGui_DragDouble(ctx, " ", rate_change, 0.01, -24.0, 24.0, "%.5f")})
			
			local itemCount = reaper.CountSelectedMediaItems(0)
			if itemCount > 0 then
				-- Получаем Rate первого выделенного айтема для отображения
				local firstItem = reaper.GetSelectedMediaItem(0, 0)
				local firstTake = reaper.GetActiveTake(firstItem)
				local rate_display = firstTake and reaper.GetMediaItemTakeInfo_Value(firstTake, 'D_PLAYRATE') or 1.0

				-- Ползунок для изменения Rate
				local changed, rate_delta = reaper.ImGui_DragDouble(ctx, " ", 0.0, 0.001, -24.0, 24.0, '%.5f')

				if changed and rate_delta ~= 0.0 then
					reaper.Undo_BeginBlock()
					for i = 0, itemCount - 1 do
						local item = reaper.GetSelectedMediaItem(0, i)
						local take = reaper.GetActiveTake(item)
						if take then
							local current_rate = reaper.GetMediaItemTakeInfo_Value(take, 'D_PLAYRATE')
							reaper.SetMediaItemTakeInfo_Value(take, 'D_PLAYRATE', current_rate + rate_delta)
						end
					end
					reaper.UpdateArrange()
					reaper.Undo_EndBlock('Изменение Rate выделенных айтемов', -1)
				end
			else
				-- reaper.ImGui_Text(ctx, "No items selected")
				reaper.ImGui_TextColored(ctx, HexToImGuiColor("#FF0000"), "No items selected")
			end
			
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Rate Reset ", function() changeItemRateReset() end, 229, 25 )
			
			cboc2 ( "Rate -0.500", function() changeItemRate(-0.500) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "Rate +0.500", function() changeItemRate(0.500) end, 110, 25 )
			
			cboc2 ( "Rate -0.250", function() changeItemRate(-0.250) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "Rate +0.250", function() changeItemRate(0.250) end, 110, 25 )
			
			cboc2 ( "Rate -0.100", function() changeItemRate(-0.100) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "Rate +0.100", function() changeItemRate(0.100) end, 110, 25 )
			
			cboc2 ( "Rate -0.050", function() changeItemRate(-0.050) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "Rate +0.050", function() changeItemRate(0.050) end, 110, 25 )
			
			cboc2 ( "Rate -0.010", function() changeItemRate(-0.010) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "Rate +0.010", function() changeItemRate(0.010) end, 110, 25 )
			
			cboc2 ( "Rate -0.005", function() changeItemRate(-0.005) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "Rate +0.005", function() changeItemRate(0.005) end, 110, 25 )
			
			cboc2 ( "Rate -0.001", function() changeItemRate(-0.001) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			cboc2 ( "Rate +0.001", function() changeItemRate(0.001) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, "--------")
		elseif selected_content == "Select_Items_Content_Show" then
			
			if false then -- true false
			reaper.ImGui_SeparatorText( ctx, "Select Items Right/Left Of Edit Cursor" )
			cboc2 ( " Select Items Right of Edit Cursor ", function() SelectItemsRelativeCursor("Right") end, 0, 25 )
			cboc2 ( " Select Items Left of Edit Cursor ", function() SelectItemsRelativeCursor("Left") end, 0, 25 )
			reaper.ImGui_Text(ctx, '\n')
			reaper.ImGui_SeparatorText( ctx, "Select Items In Time Selection" )
			cboc2 ( " Select Items In Time Selection ", function() SelectItemsInTimeSelection(0) end, 0, 25 )
			cboc2 ( " Add Select Items In Time Selection ", function() SelectItemsInTimeSelection(1) end, 0, 25 )
			reaper.ImGui_Text(ctx, '\n')
			reaper.ImGui_SeparatorText( ctx, "Item Grouping" )
			cboc2 ( " Item grouping: Options: Toggle item grouping override ", function() reaper.Main_OnCommand(1156, 0) end, 0, 25 )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Item grouping: Group items ", function() reaper.Main_OnCommand(40032, 0) end, 0, 25 )
			cboc2 ( " Item grouping: Remove items from group ", function() reaper.Main_OnCommand(40033, 0) end, 0, 25 )
			cboc2 ( " Item grouping: Select all items in groups ", function() reaper.Main_OnCommand(40034, 0) end, 0, 25 )
			end
			
			
			
			
			local library_select_items = {
				key = "Select Items", default_open = true, children = {
					
					-- {spacing_vertical = "1"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					-- {spacing_vertical = "7"},
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},
					-- {separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 148 },
					
					{separator_horizontal = "ImGui_SeparatorText", separator_text = "Select Items Right/Left Of Edit Cursor"},
					{key = "Select Items Right of Edit Cursor", action_function = function() SelectItemsRelativeCursor("Right") end},
					{key = "Select Items Left of Edit Cursor", action_function = function() SelectItemsRelativeCursor("Left") end},
					{spacing_vertical = "12"},
					
					{separator_horizontal = "ImGui_SeparatorText", separator_text = "Select Items In Time Selection"},
					{key = "Select Items In Time Selection", action_function = function() SelectItemsInTimeSelection(0) end},
					{key = "Add Select Items In Time Selection", action_function = function() SelectItemsInTimeSelection(1) end},
					{key = "Item: Select all items in current time selection", action_id = "40717"},
					{key = "Item: Select all items on selected tracks in current time selection", action_id = "40718"},
					{spacing_vertical = "12"},
					{key = "Item: Select all items", action_id = "40182"},
					{key = "Item: Select all items in track", action_id = "40421"},
					{key = "Item: Unselect (clear selection of) all items", action_id = "40289"},
					{spacing_vertical = "12"},
					
					
					{separator_horizontal = "ImGui_SeparatorText", separator_text = "Item Grouping"},
					{key = "Item grouping: Options: Toggle item grouping override", action_id = "1156"},
					{key = "Item grouping: Group items", action_id = "40032"},
					{key = "Item grouping: Remove items from group", action_id = "40033"},
					{key = "Item grouping: Select all items in groups", action_id = "40034"},
		
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
			
			TreeNodeLibraryOutput(library_select_items) -- передаём корневой элемент
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			
			
		elseif selected_content == "Item_Automation_Content_Show" then
			-- reaper.ImGui_Text(ctx, '\n')
			reaper.ImGui_SeparatorText( ctx, "Item Automation" )
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			CreateCommandCheckbox (40070, "Options: Move envelope points with media items")
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			-- library_item_automation
			local library_item_automation = {
				key = "Item Automation", default_open = true, children = {
					
					-- {spacing_vertical = "1"},
					-- {separator_horizontal = "2", separator_color = "#EBEBEB" },
					-- {spacing_vertical = "7"},
					-- {separator_horizontal = "ImGui_SeparatorText", separator_text = "Text"},
					-- {separator_horizontal = "3", separator_color = "#3F3F48", separator_length = 148 },
					
					{key = "Envelope: Automation item properties", action_id = "42090"},
					{key = "Envelope: Insert automation item", action_id = "42082"},
					{spacing_vertical = "8"},
					
					{key = "Envelope: Duplicate automation items", action_id = "42083"},
					{key = "Envelope: Duplicate and pool automation items", action_id = "42085"},
					{spacing_vertical = "8"},
					
					{key = "Envelope: Delete automation items", action_id = "42086"},
					{key = "Envelope: Delete automation items, preserve points", action_id = "42088"},
					{spacing_vertical = "8"},
					
					{key = "Envelope: Glue automation items", action_id = "42089"},
					{key = "Envelope: Mute automation items", action_id = "42211"},
					{key = "Envelope: Rename automation item", action_id = "42091"},
					{key = "Envelope: Split automation items", action_id = "42087"},
					{spacing_vertical = "8"},
					
					{key = "Envelope: Set time selection to automation item", action_id = "42197"},
					
					{spacing_vertical = "8"},
					{separator_horizontal = "ImGui_SeparatorText", separator_text = "Envelope: Show/Hide"},
					{key = "Envelope: Show all envelopes for tracks", action_id = "41148"},
					{key = "Envelope: Hide all envelopes for tracks", action_id = "40889"},
					{spacing_vertical = "8"},
					{key = "Envelope: Show all envelopes for all tracks", action_id = "41149"},
					{key = "Envelope: Hide all envelopes for all tracks", action_id = "41150"},
					
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
			
			TreeNodeLibraryOutput(library_item_automation) -- передаём корневой элемент
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
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