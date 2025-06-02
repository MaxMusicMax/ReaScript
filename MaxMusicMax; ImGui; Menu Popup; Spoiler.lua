--@description Item; ImGui; Pitch Rate Volume
--@version 1.0
--@author MaxMusicMax
-- https://forum.cockos.com/showthread.php?p=2059855
-- #######################################
-- #######################################
-- function main
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
local ctx = reaper.ImGui_CreateContext('My script')

local function loop()
  local visible, open = reaper.ImGui_Begin(ctx, 'My window', true)
  if visible then
    reaper.ImGui_Text(ctx, 'Hello World!')
    reaper.ImGui_End(ctx)
  end
  if open then
    reaper.defer(loop)
  end
end

reaper.defer(loop)
]]--
-- reaper.Main_OnCommand(40726, 0) -- Envelope: Insert 4 envelope points at time selection 40726
-- commandID = reaper.NamedCommandLookup("_RSd0e03fb8cf39d47509ddbf616a11d2b7e4afa29c")
-- reaper.Main_OnCommand(commandID, 0)
-- reaper.Main_OnCommand(reaper.NamedCommandLookup(39214), 0)
-- reaper.Main_OnCommand(reaper.NamedCommandLookup("_RSd0e03fb8cf39d47509ddbf616a11d2b7e4afa29c"), 0)
-- #######################################
-- #######################################
-- https://forum.cockos.com/showthread.php?t=250419

-- Импортируем библиотеку reaper_imgui
local ctx = reaper.ImGui_CreateContext('ImGui; Menu Popup')
-- print_rs (last_press_time)
-- ################################################
-- ################################################
function create_button_one_click(label, callback_function)
    if reaper.ImGui_Button(ctx, label) then
        callback_function()
        -- print_rs("create_button_one_click: " .. label)
    end
end
-- ################################################
-- ################################################
function create_button_one_click2(label, callback_function, button_width, button_height )
    if reaper.ImGui_Button( ctx, label, button_width, button_height ) then
        callback_function()
        -- print_rs("create_button_one_click: " .. label)
    end
end
-- ################################################
-- ################################################
local show_fx = false -- Показывать/Не показывать плагин при добавлении -- true/false
local add_fx_to_item = true -- Добавлять FX к элементам -- true/false
local add_fx_to_track = true -- Добавлять FX к трекам -- true/false
local add_fx_to_master_track = true -- Добавлять FX к мастер треку -- true/false
-- Функция для добавления FX
function Add_FX(name, preset_name)
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
-- ################################################
-- ################################################
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
-- ################################################
-- ################################################
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
-- ################################################
-- ################################################
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
-- ################################################
-- ################################################
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
-- ################################################
-- ################################################
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
-- ################################################
-- ################################################
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
-- ################################################
-- ################################################
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
-- ################################################
-- ################################################
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
-- ################################################
-- ################################################
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
-- ################################################
-- ################################################
local imgui_headers_state = false -- true / false
local imgui_headers = {
	{ title = 'Item Volume', open = imgui_headers_state },
	{ title = 'Item Pitch', open = imgui_headers_state },
	{ title = 'Item Rate', open = imgui_headers_state },
	{ title = 'Items Automation', open = imgui_headers_state },
	{ title = 'Items Select', open = imgui_headers_state },
	{ title = 'Envelope Points', open = imgui_headers_state },
	{ title = 'Sibilance', open = imgui_headers_state },
	{ title = 'FX Plugins', open = imgui_headers_state },
	{ title = 'VST Instruments', open = imgui_headers_state },
}
-- ################################################
-- ################################################
-- Функция для переключения состояния всех заголовков
local function toggleAllHeaders(state)
    for _, header in ipairs(imgui_headers) do
        header.open = state
    end
end
-- ################################################
-- ################################################
local function ShowMenuBar()
	if reaper.ImGui_BeginMenu(ctx, 'Headers') then
		if reaper.ImGui_MenuItem(ctx, 'Open All Headers') then
			toggleAllHeaders(true)
		end
		if reaper.ImGui_MenuItem(ctx, 'Close All Headers') then
			toggleAllHeaders(false)
		end
	reaper.ImGui_EndMenu(ctx)
	end
end
-- ################################################
-- ################################################
local font_verdana = reaper.ImGui_CreateFont('verdana', 15) 
reaper.ImGui_Attach(ctx, font_verdana)
-- ################################################
-- ################################################
function main()
	reaper.ImGui_PushFont (ctx, font_verdana)
    -- Начинаем новый фрейм ImGui
    local visible, open = reaper.ImGui_Begin(ctx, 'ImGui; Menu Popup', true, reaper.ImGui_WindowFlags_MenuBar())
	
    if visible then
		-- Создаем кнопку и передаем функцию, которая будет выполняться при нажатии
		-- reaper.ImGui_SeparatorText( ctx, "sdfgsdfg" )
		
		-- if reaper.ImGui_TreeNode(ctx, 'Borders, background') then
		-- reaper.ImGui_TreePop(ctx)
		-- end
		
		if reaper.ImGui_BeginMenuBar(ctx) then
		ShowMenuBar()
		reaper.ImGui_EndMenuBar(ctx)
		end
		
		if false then -- true / false
		-- Кнопка для открытия всех заголовков
		if reaper.ImGui_Button(ctx, ' Open All Headers ') then
			toggleAllHeaders(true)
		end
		
		reaper.ImGui_SameLine(ctx)
		
		-- Кнопка для закрытия всех заголовков
		if reaper.ImGui_Button(ctx, ' Close All Headers ') then
			toggleAllHeaders(false)
		end
		
		end
		
		-- Отображение заголовков
		for i, header in ipairs(imgui_headers) do
			if header then
				reaper.ImGui_SetNextItemOpen(ctx, header.open)
				if reaper.ImGui_CollapsingHeader(ctx, header.title) then
					header.open = true -- true false

					if header.title == 'Item Volume' then
					
						reaper.ImGui_Text(ctx, '\n')
						handleVolumeChange(ctx, {reaper.ImGui_DragDouble(ctx, " Volume", volume_db, 0.05, -180.0, 48.0, "%.3f dB")})
						
						reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Volume Reset ", function() reaper.Main_OnCommand(41923, 0) end, 229, 25 )
						
						create_button_one_click2 ( " Volume -5.0 ", function() changeVolumeForSelectedItems (-5) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Volume +5.0 ", function() changeVolumeForSelectedItems (5) end, 110, 25 )
						
						create_button_one_click2 ( " Volume -3.0 ", function() changeVolumeForSelectedItems (-3) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Volume +3.0 ", function() changeVolumeForSelectedItems (3) end, 110, 25 )
						
						-- reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Volume -2.0 ", function() changeVolumeForSelectedItems (-2) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Volume +2.0 ", function() changeVolumeForSelectedItems (2) end, 110, 25 )
						
						-- reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Volume -1.0 ", function() changeVolumeForSelectedItems (-1) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Volume +1.0 ", function() changeVolumeForSelectedItems (1) end, 110, 25 )
						
						-- reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Volume -0.5 ", function() changeVolumeForSelectedItems (-0.5) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Volume +0.5 ", function() changeVolumeForSelectedItems (0.5) end, 110, 25 )
						
						-- reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Volume -0.25 ", function() changeVolumeForSelectedItems (-0.25) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Volume +0.25 ", function() changeVolumeForSelectedItems (0.25) end, 110, 25 )
						
						-- reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Volume -0.10 ", function() changeVolumeForSelectedItems (-0.10) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Volume +0.10 ", function() changeVolumeForSelectedItems (0.10) end, 110, 25 )
						
						-- reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Volume -0.01 ", function() changeVolumeForSelectedItems (-0.01) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Volume +0.01 ", function() changeVolumeForSelectedItems (0.01) end, 110, 25 )
						
						reaper.ImGui_Text(ctx, '\n')
					elseif header.title == 'Item Pitch' then
						reaper.ImGui_Text(ctx, '\n')
						handlePitchChange(ctx, {reaper.ImGui_DragDouble(ctx, " Pitch", pitch_change, 0.01, -24.0, 24.0, "%.3f")})
						
						reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Pitch Reset ", function() reaper.Main_OnCommand(40653, 0) end, 229, 25 )
						
						create_button_one_click2 ( " Pitch -3.0 ", function() changePitchForSelectedItems (-3) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Pitch +3.0 ", function() changePitchForSelectedItems (3) end, 110, 25 )
						
						create_button_one_click2 ( " Pitch -2.0 ", function() changePitchForSelectedItems (-2) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Pitch +2.0 ", function() changePitchForSelectedItems (2) end, 110, 25 )
						
						create_button_one_click2 ( " Pitch -1.0 ", function() changePitchForSelectedItems (-1) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Pitch +1.0 ", function() changePitchForSelectedItems (1) end, 110, 25 )
						
						-- reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Pitch -0.5 ", function() changePitchForSelectedItems (-0.5) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Pitch +0.5 ", function() changePitchForSelectedItems (0.5) end, 110, 25 )
						
						-- reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Pitch -0.1 ", function() changePitchForSelectedItems (-0.1) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Pitch +0.1 ", function() changePitchForSelectedItems (0.1) end, 110, 25 )
						
						-- reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Pitch -0.01 ", function() changePitchForSelectedItems (-0.01) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Pitch +0.01 ", function() changePitchForSelectedItems (0.01) end, 110, 25 )
						
						-- reaper.ImGui_Text(ctx, '\n')
						reaper.ImGui_Text(ctx, '\n')
					elseif header.title == 'Item Rate' then
						reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Rate Reset ", function() changeItemRateReset() end, 229, 25 )
						
						create_button_one_click2 ( "Rate -0.500", function() changeItemRate(-0.500) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( "Rate +0.500", function() changeItemRate(0.500) end, 110, 25 )
						
						-- reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( "Rate -0.250", function() changeItemRate(-0.250) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( "Rate +0.250", function() changeItemRate(0.250) end, 110, 25 )
						
						-- reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( "Rate -0.100", function() changeItemRate(-0.100) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( "Rate +0.100", function() changeItemRate(0.100) end, 110, 25 )
						
						-- reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( "Rate -0.050", function() changeItemRate(-0.050) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( "Rate +0.050", function() changeItemRate(0.050) end, 110, 25 )
						
						-- reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( "Rate -0.010", function() changeItemRate(-0.010) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( "Rate +0.010", function() changeItemRate(0.010) end, 110, 25 )
						
						-- reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( "Rate -0.005", function() changeItemRate(-0.005) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( "Rate +0.005", function() changeItemRate(0.005) end, 110, 25 )
						
						-- reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( "Rate -0.001", function() changeItemRate(-0.001) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( "Rate +0.001", function() changeItemRate(0.001) end, 110, 25 )
						
						-- reaper.ImGui_Text(ctx, '\n')
						reaper.ImGui_Text(ctx, '\n')
					elseif header.title == 'Items Automation' then
						reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Options: Move envelope points with media items ", function() reaper.Main_OnCommand(40070, 0) end, 0, 25 )
						reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Envelope: Automation item properties ", function() reaper.Main_OnCommand(42090, 0) end, 0, 25 )
						create_button_one_click2 ( " Envelope: Insert automation item ", function() reaper.Main_OnCommand(42082, 0) end, 0, 25 )
						reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Envelope: Duplicate automation items ", function() reaper.Main_OnCommand(42083, 0) end, 0, 25 )
						create_button_one_click2 ( " Envelope: Duplicate and pool automation items ", function() reaper.Main_OnCommand(42085, 0) end, 0, 25 )
						reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Envelope: Delete automation items ", function() reaper.Main_OnCommand(42086, 0) end, 0, 25 )
						create_button_one_click2 ( " Envelope: Delete automation items, preserve points ", function() reaper.Main_OnCommand(42088, 0) end, 0, 25 )
						reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Envelope: Glue automation items ", function() reaper.Main_OnCommand(42089, 0) end, 0, 25 )
						create_button_one_click2 ( " Envelope: Mute automation items ", function() reaper.Main_OnCommand(42211, 0) end, 0, 25 )
						create_button_one_click2 ( " Envelope: Rename automation item ", function() reaper.Main_OnCommand(42091, 0) end, 0, 25 )
						create_button_one_click2 ( " Envelope: Split automation items ", function() reaper.Main_OnCommand(42087, 0) end, 0, 25 )
						reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Envelope: Set time selection to automation item ", function() reaper.Main_OnCommand(42197, 0) end, 0, 25 )
						create_button_one_click2 ( " Envelope: Toggle show all active envelopes for all tracks ", function() reaper.Main_OnCommand(40926, 0) end, 0, 25 )
						reaper.ImGui_Text(ctx, '\n')
						
					elseif header.title == 'Items Select' then
						reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Select Items Right of Edit Cursor ", function() SelectItemsRelativeCursor("Right") end, 0, 25 )
						create_button_one_click2 ( " Select Items Left of Edit Cursor ", function() SelectItemsRelativeCursor("Left") end, 229, 25 )
						reaper.ImGui_Text(ctx, '\n')
						
					elseif header.title == 'Envelope Points' then
						reaper.ImGui_Text(ctx, '\n')
						
						create_button_one_click2 ( " Points Reset ", function() reaper.Main_OnCommand(40415, 0) end, 229, 25 )
						
						create_button_one_click2 ( " Points -30 ", function() changeSelectedEnvelopePoints (-30) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Points +30 ", function() changeSelectedEnvelopePoints (30) end, 110, 25 )
						
						create_button_one_click2 ( " Points -20 ", function() changeSelectedEnvelopePoints (-20) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Points +20 ", function() changeSelectedEnvelopePoints (20) end, 110, 25 )
						
						create_button_one_click2 ( " Points -15 ", function() changeSelectedEnvelopePoints (-15) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Points +15 ", function() changeSelectedEnvelopePoints (15) end, 110, 25 )
						
						create_button_one_click2 ( " Points -10 ", function() changeSelectedEnvelopePoints (-10) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Points +10 ", function() changeSelectedEnvelopePoints (10) end, 110, 25 )
						
						create_button_one_click2 ( " Points -5.0 ", function() changeSelectedEnvelopePoints (-5) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Points +5.0 ", function() changeSelectedEnvelopePoints (5) end, 110, 25 )
						
						create_button_one_click2 ( " Points -2.0 ", function() changeSelectedEnvelopePoints (-2) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Points +2.0 ", function() changeSelectedEnvelopePoints (2) end, 110, 25 )
						
						create_button_one_click2 ( " Points -1.0 ", function() changeSelectedEnvelopePoints (-1) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Points +1.0 ", function() changeSelectedEnvelopePoints (1) end, 110, 25 )
						
						create_button_one_click2 ( " Points -0.5 ", function() changeSelectedEnvelopePoints (-0.5) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Points +0.5 ", function() changeSelectedEnvelopePoints (0.5) end, 110, 25 )
						
						create_button_one_click2 ( " Points -0.1 ", function() changeSelectedEnvelopePoints (-0.1) end, 110, 25 )
						reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
						create_button_one_click2 ( " Points +0.1 ", function() changeSelectedEnvelopePoints (0.1) end, 110, 25 )
						reaper.ImGui_Text(ctx, '\n')
					elseif header.title == 'Sibilance' then
						reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Set Stretch Marker; Selected Items; Sibilance Start And End ", function() DetectAndMarkSibilance("start_end") end, 0, 25 )
						create_button_one_click2 ( " Set Stretch Marker; Selected Items; Sibilance Start ", function() DetectAndMarkSibilance("start") end, 0, 25 )
						create_button_one_click2 ( " Set Stretch Marker; Selected Items; Sibilance End ", function() DetectAndMarkSibilance("end") end, 0, 25 )
						reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Item: Remove All Stretch Markers In Time Selection ", function() reaper.Main_OnCommand(41845, 0) end, 0, 25 )
						create_button_one_click2 ( " Item: Remove All Stretch Markers In Selected Item ", function() reaper.Main_OnCommand(41844, 0) end, 0, 25 )
						reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Markers: Remove All Markers From Time Selection ", function() reaper.Main_OnCommand(40420, 0) end, 0, 25 )
						create_button_one_click2 ( " Item: Reset items volume to +0dB ", function() reaper.Main_OnCommand(41923, 0) end, 0, 25 )
						reaper.ImGui_Text(ctx, '\n')
					elseif header.title == 'FX Plugins' then
						reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " ReaEQ (Cockos) ", function() Add_FX ("ReaEQ (Cockos)", "MaxMusicMax — Default") end, 0, 25 )
						create_button_one_click2 ( " ReaDelay (Cockos) ", function() Add_FX ("ReaDelay (Cockos)", "") end, 0, 25 )
						create_button_one_click2 ( " ReaPitch (Cockos) ", function() Add_FX ("ReaPitch (Cockos)", "") end, 0, 25 )
						create_button_one_click2 ( " ReaComp (Cockos) ", function() Add_FX ("ReaComp (Cockos)", "") end, 0, 25 )
						reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Doubler4 Stereo (Waves) ", function() Add_FX ("Doubler4 Stereo (Waves)", "") end, 0, 25 )
						reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Pro-L 2 (FabFilter) ", function() Add_FX ("Pro-L 2 (FabFilter)", "") end, 0, 25 )
						create_button_one_click2 ( " Pro-Q 3 (FabFilter) ", function() Add_FX ("Pro-Q 3 (FabFilter)", "") end, 0, 25 )
						create_button_one_click2 ( " Pro-R (FabFilter) ", function() Add_FX ("Pro-R (FabFilter)", "") end, 0, 25 )
						create_button_one_click2 ( " Pro-MB (FabFilter) ", function() Add_FX ("Pro-MB (FabFilter)", "") end, 0, 25 )
						create_button_one_click2 ( " Saturn 2 (FabFilter) ", function() Add_FX ("Saturn 2 (FabFilter)", "") end, 0, 25 )
						create_button_one_click2 ( " Timeless 3 (FabFilter) ", function() Add_FX ("Timeless 3 (FabFilter)", "") end, 0, 25 )
						reaper.ImGui_Text(ctx, '\n')
					elseif header.title == 'VST Instruments' then
						reaper.ImGui_Text(ctx, '\n')
						create_button_one_click2 ( " Serum (Xfer Records) ", function() Add_FX ("Serum (Xfer Records)", "") end, 0, 25 )
						create_button_one_click2 ( " Vital (Vital Audio) ", function() Add_FX ("Vital (Vital Audio)", "") end, 0, 25 )
						create_button_one_click2 ( " Virtual Sound Canvas (EDIROL) ", function() Add_FX ("Virtual Sound Canvas (x86) (EDIROL) (8 out)", "") end, 0, 25 )
						create_button_one_click2 ( " ReaControlMIDI (Cockos) ", function() Add_FX ("ReaControlMIDI (Cockos)", "") end, 0, 25 )
						reaper.ImGui_Text(ctx, '\n')
					end
					
				else
					header.open = false -- true false
				end
			end
		end
		
		
		
		if false then -- true false
		 
		 if reaper.ImGui_CollapsingHeader(ctx, 'Item Volume') then
			
			reaper.ImGui_Text(ctx, '\n')
			handleVolumeChange(ctx, {reaper.ImGui_DragDouble(ctx, " Volume", volume_db, 0.05, -180.0, 48.0, "%.3f dB")})
			
			reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Volume Reset ", function() reaper.Main_OnCommand(41923, 0) end, 229, 25 )
			
			create_button_one_click2 ( " Volume -5.0 ", function() changeVolumeForSelectedItems (-5) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Volume +5.0 ", function() changeVolumeForSelectedItems (5) end, 110, 25 )
			
			create_button_one_click2 ( " Volume -3.0 ", function() changeVolumeForSelectedItems (-3) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Volume +3.0 ", function() changeVolumeForSelectedItems (3) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Volume -2.0 ", function() changeVolumeForSelectedItems (-2) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Volume +2.0 ", function() changeVolumeForSelectedItems (2) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Volume -1.0 ", function() changeVolumeForSelectedItems (-1) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Volume +1.0 ", function() changeVolumeForSelectedItems (1) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Volume -0.5 ", function() changeVolumeForSelectedItems (-0.5) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Volume +0.5 ", function() changeVolumeForSelectedItems (0.5) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Volume -0.25 ", function() changeVolumeForSelectedItems (-0.25) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Volume +0.25 ", function() changeVolumeForSelectedItems (0.25) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Volume -0.10 ", function() changeVolumeForSelectedItems (-0.10) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Volume +0.10 ", function() changeVolumeForSelectedItems (0.10) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Volume -0.01 ", function() changeVolumeForSelectedItems (-0.01) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Volume +0.01 ", function() changeVolumeForSelectedItems (0.01) end, 110, 25 )
			
			reaper.ImGui_Text(ctx, '\n')
		end
		 
		if reaper.ImGui_CollapsingHeader(ctx, 'Item Pitch') then
			
			reaper.ImGui_Text(ctx, '\n')
			handlePitchChange(ctx, {reaper.ImGui_DragDouble(ctx, " Pitch", pitch_change, 0.01, -24.0, 24.0, "%.3f")})
			
			reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Pitch Reset ", function() reaper.Main_OnCommand(40653, 0) end, 229, 25 )
			
			create_button_one_click2 ( " Pitch -2.0 ", function() changePitchForSelectedItems (-2) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Pitch +2.0 ", function() changePitchForSelectedItems (2) end, 110, 25 )
			
			create_button_one_click2 ( " Pitch -1.0 ", function() changePitchForSelectedItems (-1) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Pitch +1.0 ", function() changePitchForSelectedItems (1) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Pitch -0.5 ", function() changePitchForSelectedItems (-0.5) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Pitch +0.5 ", function() changePitchForSelectedItems (0.5) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Pitch -0.1 ", function() changePitchForSelectedItems (-0.1) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Pitch +0.1 ", function() changePitchForSelectedItems (0.1) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Pitch -0.01 ", function() changePitchForSelectedItems (-0.01) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Pitch +0.01 ", function() changePitchForSelectedItems (0.01) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			reaper.ImGui_Text(ctx, '\n')
		end
		
		if reaper.ImGui_CollapsingHeader(ctx, 'Item Rate') then
		-- Добавляем элементы внутри заголовка "Track"
			
			reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Rate Reset ", function() changeItemRateReset() end, 229, 25 )
			
			create_button_one_click2 ( "Rate -0.500", function() changeItemRate(-0.500) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( "Rate +0.500", function() changeItemRate(0.500) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( "Rate -0.250", function() changeItemRate(-0.250) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( "Rate +0.250", function() changeItemRate(0.250) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( "Rate -0.100", function() changeItemRate(-0.100) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( "Rate +0.100", function() changeItemRate(0.100) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( "Rate -0.050", function() changeItemRate(-0.050) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( "Rate +0.050", function() changeItemRate(0.050) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( "Rate -0.010", function() changeItemRate(-0.010) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( "Rate +0.010", function() changeItemRate(0.010) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( "Rate -0.005", function() changeItemRate(-0.005) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( "Rate +0.005", function() changeItemRate(0.005) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( "Rate -0.001", function() changeItemRate(-0.001) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( "Rate +0.001", function() changeItemRate(0.001) end, 110, 25 )
			
			-- reaper.ImGui_Text(ctx, '\n')
			reaper.ImGui_Text(ctx, '\n')
		end
		
		if reaper.ImGui_CollapsingHeader(ctx, 'Envelope Points') then
			reaper.ImGui_Text(ctx, '\n')
			
			create_button_one_click2 ( " Points Reset ", function() reaper.Main_OnCommand(40415, 0) end, 229, 25 )
			
			create_button_one_click2 ( " Points -30 ", function() changeSelectedEnvelopePoints (-30) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Points +30 ", function() changeSelectedEnvelopePoints (30) end, 110, 25 )
			
			create_button_one_click2 ( " Points -20 ", function() changeSelectedEnvelopePoints (-20) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Points +20 ", function() changeSelectedEnvelopePoints (20) end, 110, 25 )
			
			create_button_one_click2 ( " Points -15 ", function() changeSelectedEnvelopePoints (-15) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Points +15 ", function() changeSelectedEnvelopePoints (15) end, 110, 25 )
			
			create_button_one_click2 ( " Points -10 ", function() changeSelectedEnvelopePoints (-10) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Points +10 ", function() changeSelectedEnvelopePoints (10) end, 110, 25 )
			
			create_button_one_click2 ( " Points -5.0 ", function() changeSelectedEnvelopePoints (-5) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Points +5.0 ", function() changeSelectedEnvelopePoints (5) end, 110, 25 )
			
			create_button_one_click2 ( " Points -2.0 ", function() changeSelectedEnvelopePoints (-2) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Points +2.0 ", function() changeSelectedEnvelopePoints (2) end, 110, 25 )
			
			create_button_one_click2 ( " Points -1.0 ", function() changeSelectedEnvelopePoints (-1) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Points +1.0 ", function() changeSelectedEnvelopePoints (1) end, 110, 25 )
			
			create_button_one_click2 ( " Points -0.5 ", function() changeSelectedEnvelopePoints (-0.5) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Points +0.5 ", function() changeSelectedEnvelopePoints (0.5) end, 110, 25 )
			
			create_button_one_click2 ( " Points -0.1 ", function() changeSelectedEnvelopePoints (-0.1) end, 110, 25 )
			reaper.ImGui_SameLine(ctx)  -- Размещаем следующую кнопку на той же линии
			create_button_one_click2 ( " Points +0.1 ", function() changeSelectedEnvelopePoints (0.1) end, 110, 25 )
			reaper.ImGui_Text(ctx, '\n')
		end
		
		if reaper.ImGui_CollapsingHeader(ctx, 'Items Automation') then
			reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Options: Move envelope points with media items ", function() reaper.Main_OnCommand(40070, 0) end, 0, 25 )
			reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Envelope: Automation item properties ", function() reaper.Main_OnCommand(42090, 0) end, 0, 25 )
			create_button_one_click2 ( " Envelope: Insert automation item ", function() reaper.Main_OnCommand(42082, 0) end, 0, 25 )
			reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Envelope: Duplicate automation items ", function() reaper.Main_OnCommand(42083, 0) end, 0, 25 )
			create_button_one_click2 ( " Envelope: Duplicate and pool automation items ", function() reaper.Main_OnCommand(42085, 0) end, 0, 25 )
			reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Envelope: Delete automation items ", function() reaper.Main_OnCommand(42086, 0) end, 0, 25 )
			create_button_one_click2 ( " Envelope: Delete automation items, preserve points ", function() reaper.Main_OnCommand(42088, 0) end, 0, 25 )
			reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Envelope: Glue automation items ", function() reaper.Main_OnCommand(42089, 0) end, 0, 25 )
			create_button_one_click2 ( " Envelope: Mute automation items ", function() reaper.Main_OnCommand(42211, 0) end, 0, 25 )
			create_button_one_click2 ( " Envelope: Rename automation item ", function() reaper.Main_OnCommand(42091, 0) end, 0, 25 )
			create_button_one_click2 ( " Envelope: Split automation items ", function() reaper.Main_OnCommand(42087, 0) end, 0, 25 )
			reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Envelope: Set time selection to automation item ", function() reaper.Main_OnCommand(42197, 0) end, 0, 25 )
			create_button_one_click2 ( " Envelope: Toggle show all active envelopes for all tracks ", function() reaper.Main_OnCommand(40926, 0) end, 0, 25 )
			reaper.ImGui_Text(ctx, '\n')
		end
		
		if reaper.ImGui_CollapsingHeader(ctx, 'Sibilance') then
			reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Set Stretch Marker; Selected Items; Sibilance Start And End ", function() DetectAndMarkSibilance("start_end") end, 0, 25 )
			create_button_one_click2 ( " Set Stretch Marker; Selected Items; Sibilance Start ", function() DetectAndMarkSibilance("start") end, 0, 25 )
			create_button_one_click2 ( " Set Stretch Marker; Selected Items; Sibilance End ", function() DetectAndMarkSibilance("end") end, 0, 25 )
			reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Item: Remove All Stretch Markers In Time Selection ", function() reaper.Main_OnCommand(41845, 0) end, 0, 25 )
			create_button_one_click2 ( " Item: Remove All Stretch Markers In Selected Item ", function() reaper.Main_OnCommand(41844, 0) end, 0, 25 )
			reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Markers: Remove All Markers From Time Selection ", function() reaper.Main_OnCommand(40420, 0) end, 0, 25 )
			create_button_one_click2 ( " Item: Reset items volume to +0dB ", function() reaper.Main_OnCommand(41923, 0) end, 0, 25 )
			reaper.ImGui_Text(ctx, '\n')
		end
		
		if reaper.ImGui_CollapsingHeader(ctx, 'FX') then
			create_button_one_click2 ( " ReaEQ (Cockos) ", function() Add_FX ("ReaEQ (Cockos)", "MaxMusicMax — Default") end, 0, 25 )
			create_button_one_click2 ( " ReaDelay (Cockos) ", function() Add_FX ("ReaDelay (Cockos)", "") end, 0, 25 )
			create_button_one_click2 ( " ReaPitch (Cockos) ", function() Add_FX ("ReaPitch (Cockos)", "") end, 0, 25 )
			create_button_one_click2 ( " ReaComp (Cockos) ", function() Add_FX ("ReaComp (Cockos)", "") end, 0, 25 )
			reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Doubler4 Stereo (Waves) ", function() Add_FX ("Doubler4 Stereo (Waves)", "") end, 0, 25 )
			reaper.ImGui_Text(ctx, '\n')
			create_button_one_click2 ( " Pro-L 2 (FabFilter) ", function() Add_FX ("Pro-L 2 (FabFilter)", "") end, 0, 25 )
			create_button_one_click2 ( " Pro-Q 3 (FabFilter) ", function() Add_FX ("Pro-Q 3 (FabFilter)", "") end, 0, 25 )
			create_button_one_click2 ( " Pro-R (FabFilter) ", function() Add_FX ("Pro-R (FabFilter)", "") end, 0, 25 )
			create_button_one_click2 ( " Pro-MB (FabFilter) ", function() Add_FX ("Pro-MB (FabFilter)", "") end, 0, 25 )
			create_button_one_click2 ( " Saturn 2 (FabFilter) ", function() Add_FX ("Saturn 2 (FabFilter)", "") end, 0, 25 )
			create_button_one_click2 ( " Timeless 3 (FabFilter) ", function() Add_FX ("Timeless 3 (FabFilter)", "") end, 0, 25 )
			-- create_button_one_click2 ( " www ", function() Add_FX ("www", "") end, 0, 25 )
		end
		
		end
		
        -- Заканчиваем окно ImGui
        reaper.ImGui_End(ctx)
    end
	reaper.ImGui_PopFont (ctx)

    -- Если окно все еще открыто, вызываем функцию main снова
    if open then
        reaper.defer(main)
    end
end
-- ################################################
-- ################################################
-- Запускаем основной цикл скрипта
reaper.defer(main)
-- #######################################
-- #######################################
reaper.PreventUIRefresh(-1);
reaper.TrackList_AdjustWindows(0)  -- Updates the window view
reaper.UpdateArrange();  -- Updates the window view
-- #######################################
-- #######################################