--@description MaxMusicMax; ImGui; PlayBack (Backing Tracks) (Cover Band)
--@version 1.0
--@author MaxMusicMax
-- https://forum.cockos.com/showthread.php?p=2059855
-- #######################################
-- #######################################
-- 111111111111111111111111111
-- menu_structure
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
-- Меню
local menu_structure = {
	{label = "Menu", children = {
		{label = "Region For PlayBack", show_content = "Region_For_PlayBack_Content_Show"},
		{label = "Region Various", show_content = "Region_Various_Content_Show"},
		-- {is_separator = true}, -- Разделитель
	}},

	{label = "Settings", children = {
		{label = "Set Default Tab ImGui", action_function = function() SetDefaultMenuItemImGui () end},
		{label = "Set Alpha Tab ImGui", show_content = "Alpha_Window_ImGui_Content_Show"},
	}},
	
	--[[
	{label = "Example", children = {
		{label = "Color 1", action_function = function() reaper.ShowMessageBox("Color 1 selected", "Information", 0) end},
		{label = "Content 1", show_content = "Content_1_Content_Show"},
		{label = "Options: Preferences", action_id = "40016"},
		{label = "Gui; Color switch", action_id = "_RS251990727759d3dff9cf84df740cd6a87ea0d169"},
	}},
	]]--
}
-- Меню
-- #######################################
-- #######################################
local ctx = reaper.ImGui_CreateContext("_cy5wzDXuMrqjrAvqbIfJCcYzwiqHgv") -- Пример: a4eyqstr5b3t7k375ohg
-- Любой Уникальный Идентификатор, Пример: a4eyqstr5b3t7k375ohg
-- #######################################
-- #######################################
-- cboc2 / create_button_one_click2
function cboc2(label, callback_function, button_width, button_height )
	if reaper.ImGui_Button( ctx, label, button_width, button_height ) then
		callback_function()
		-- print_rs("create_button_one_click: " .. label)
	end
end
-- #######################################
-- #######################################
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
-- #######################################
-- #######################################
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
function CreateOrRemoveRegionFromTimeSelection(mode)
    -- mode == 0: Создать регион из Time Selection
    -- mode == 1: Удалить регионы в зоне Time Selection
    -- mode == 2: Создать регион по выделенным айтемам
    -- mode == 3: Удалить все регионы

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
            reaper.AddProjectMarker2(project, true, time_start, time_end, "", -1, 0)
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
-- #######################################
-- #######################################
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
-- #######################################
-- #######################################
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
-- #######################################
-- #######################################
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
-- #######################################
-- #######################################
-- Загружаем шрифты с разными размерами
local font_size_verdana_18 = reaper.ImGui_CreateFont('verdana', 18)
local font_size_verdana_22 = reaper.ImGui_CreateFont('verdana', 22)

-- Присоединяем шрифты к контексту
reaper.ImGui_Attach(ctx, font_size_verdana_18)
reaper.ImGui_Attach(ctx, font_size_verdana_22)
-- #######################################
-- #######################################
local alpha_window_ImGui = tonumber(reaper.GetExtState("MaxMusicMax_ImGuiWindow", "ImGuiAlphaWindow_cy5wzDXuMrqjrAvqbIfJCcYzwiqHgv")) or 0.6
local name_window_cy5wzDXuMrqjrAvqbIfJCcYzwiqHgv = "PlayBack (Backing Tracks) (Cover Band)"
-- #######################################
-- #######################################
-- Пункт меню по умолчанию
local selected_content = "Frequent_Content_Show" -- Color_Content_Show / Frequent_Content_Show
local current_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiWindow", "ImGuiCurrentMenuItem_cy5wzDXuMrqjrAvqbIfJCcYzwiqHgv")
local default_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiWindow", "ImGuiDefaultMenuItem_cy5wzDXuMrqjrAvqbIfJCcYzwiqHgv")

if current_menu_item_imgui == "" then
	reaper.SetExtState("MaxMusicMax_ImGuiWindow", "ImGuiCurrentMenuItem_cy5wzDXuMrqjrAvqbIfJCcYzwiqHgv", selected_content, true)
end

if default_menu_item_imgui == "" then
	reaper.SetExtState("MaxMusicMax_ImGuiWindow", "ImGuiDefaultMenuItem_cy5wzDXuMrqjrAvqbIfJCcYzwiqHgv", selected_content, true)
else
	selected_content = default_menu_item_imgui
end
-- Пункт меню по умолчанию
-- ##################################################
-- ##################################################
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
					reaper.SetExtState("MaxMusicMax_ImGuiWindow", "ImGuiCurrentMenuItem_cy5wzDXuMrqjrAvqbIfJCcYzwiqHgv", selected_content, true)
				end
			end
		end
	end
end
-- ##################################################
-- ##################################################
function SetDefaultMenuItemImGui ()
	current_menu_item_imgui = reaper.GetExtState("MaxMusicMax_ImGuiWindow", "ImGuiCurrentMenuItem_cy5wzDXuMrqjrAvqbIfJCcYzwiqHgv")
	reaper.SetExtState("MaxMusicMax_ImGuiWindow", "ImGuiDefaultMenuItem_cy5wzDXuMrqjrAvqbIfJCcYzwiqHgv", current_menu_item_imgui, true)
end
-- ##################################################
-- ##################################################
function main()
	reaper.ImGui_SetNextWindowBgAlpha(ctx, alpha_window_ImGui) -- Установить прозрачность фона окна
	reaper.ImGui_PushFont (ctx, font_size_verdana_18)
	-- reaper.ImGui_SetNextWindowSize(ctx, 500, 300, reaper.ImGui_Cond_FirstUseEver())

	local visible, open = reaper.ImGui_Begin(ctx, name_window_cy5wzDXuMrqjrAvqbIfJCcYzwiqHgv, true, reaper.ImGui_WindowFlags_MenuBar())
	if visible then
		if reaper.ImGui_BeginMenuBar(ctx) then
			ShowMenuItems(menu_structure)
			reaper.ImGui_EndMenuBar(ctx)
		end
		
		-- #######################################
		-- menu_structure___
		if selected_content == "" then
		elseif selected_content == "Region_Various_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Region Various" )
			
			local btn_width = 570
			local btn_height = 30
			
			cboc2 ( " View: Show region/marker manager window ", function() reaper.Main_OnCommand("40326", 0) end, btn_width, btn_height )
			cboc2 ( " Ruler: Display region number even if region is named ", function() reaper.Main_OnCommand("42435", 0) end, btn_width, btn_height )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			cboc2 ( " Create Region From Items Selection ", function() CreateOrRemoveRegionFromTimeSelection (2) end, btn_width, btn_height )
			cboc2 ( " Create Region From Time Selection ", function() CreateOrRemoveRegionFromTimeSelection (0) end, btn_width, btn_height )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			cboc2 ( " Remove Region From Time Selection ", function() CreateOrRemoveRegionFromTimeSelection (1) end, btn_width, btn_height )
			cboc2 ( " Delete all regions ", function() CreateOrRemoveRegionFromTimeSelection (3) end, btn_width, btn_height )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			cboc2 ( " Markers/Regions: Export markers/regions to file ", function() reaper.Main_OnCommand(41758, 0) end, btn_width, btn_height )
			cboc2 ( " Markers/Regions: Import markers/regions from file (replace all existing) ", function() reaper.Main_OnCommand(41759, 0) end, btn_width, btn_height )
			reaper.ImGui_Dummy(ctx, 0, 20)  -- Добавление вертикального пространства
			
			DrawColorBoxPresetColor2(ctx, "#0070CA", 30, 30, true, modeTrackAndItemPresetColorChanger)
			cboc2 ( " Couplet ", function() CreateRegionFromSelectedItem("Куплет", "#0070CA") end, 532, btn_height )
			DrawColorBoxPresetColor2(ctx, "#E87400", 30, 30, true, modeTrackAndItemPresetColorChanger)
			cboc2 ( " Chorus ", function() CreateRegionFromSelectedItem("Припев", "#B05800") end, 532, btn_height )
			DrawColorBoxPresetColor2(ctx, "#0A8B16", 30, 30, true, modeTrackAndItemPresetColorChanger)
			cboc2 ( " Interlude ", function() CreateRegionFromSelectedItem("Проигрыш", "#0A8B16") end, 532, btn_height )
			DrawColorBoxPresetColor2(ctx, "#F24040", 30, 30, true, modeTrackAndItemPresetColorChanger)
			cboc2 ( " Code ", function() CreateRegionFromSelectedItem("Кода", "#F24040") end, 532, btn_height )
			
		elseif selected_content == "Region_For_PlayBack_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Region For PlayBack" )
			
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
			
			cboc2 ( " Set Top Track Height ", function()
				reaper.Main_OnCommand("40454", 0) -- Screenset: Load window set #01
				SetAllTracksAndEnvelopesHeight(58, 58)  -- track_height / envelope_height
				SetTopTrackHeight(120) -- Установить высоту 150 пикселей
				ZoomArrangeToItems(1, 2) -- Отступ 1 секунда слева и 2 секунды справа
			end, 772, 50 )
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			cboc2 ( " Track Height Default ", function()
				reaper.Main_OnCommand("40456", 0) -- Screenset: Load window set #03
				SetAllTracksAndEnvelopesHeight(58, 58)  -- track_height / envelope_height
				ZoomArrangeToItems(1, 2) -- Отступ 1 секунда слева и 2 секунды справа
			end, 772, 50 )
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			cboc2 ( "  Midi Off  ", function() reaper.Main_OnCommand("40345", 0) end, 772, 50 ) -- Send all-notes-off and all-sounds-off to all MIDI outputs/plug-ins
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			cboc2 ( " Screenset 01 ", function()
				reaper.Main_OnCommand("40454", 0) -- Screenset: Load window set #01
				SetAllTracksAndEnvelopesHeight(58, 58)  -- track_height / envelope_height
				ZoomArrangeToItems(1, 2) -- Отступ 1 секунда слева и 2 секунды справа
			end, 772, 50 )
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			cboc2 ( " Screenset 02 ", function()
				reaper.Main_OnCommand("40455", 0) -- Screenset: Load window set #02
				SetAllTracksAndEnvelopesHeight(58, 58)  -- track_height / envelope_height
				ZoomArrangeToItems(1, 2) -- Отступ 1 секунда слева и 2 секунды справа
			end, 772, 50 )
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			cboc2 ( " Screenset 03 ", function()
				reaper.Main_OnCommand("40456", 0) -- Screenset: Load window set #03
				SetAllTracksAndEnvelopesHeight(58, 58)  -- track_height / envelope_height
				ZoomArrangeToItems(1, 2) -- Отступ 1 секунда слева и 2 секунды справа
			end, 772, 50 )
			reaper.ImGui_Dummy(ctx, 0, 5)  -- Добавление вертикального пространства
			
			reaper.ImGui_PopFont(ctx)
			
		elseif selected_content == "Alpha_Window_ImGui_Content_Show" then
			reaper.ImGui_SeparatorText( ctx, "Alpha Window ImGui" )
			local changed, new_alpha = reaper.ImGui_DragDouble(ctx, ' ', alpha_window_ImGui, 0.01, 0.0, 1.0, '%.2f')
			if changed then
				alpha_window_ImGui = new_alpha
				reaper.SetExtState("MaxMusicMax_ImGuiWindow", "ImGuiAlphaWindow_cy5wzDXuMrqjrAvqbIfJCcYzwiqHgv", tostring(alpha_window_ImGui), true)
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
		reaper.defer(main)
	end
end

reaper.defer(main)
-- #######################################
-- #######################################
reaper.PreventUIRefresh(-1);
reaper.TrackList_AdjustWindows(0)  -- Updates the window view
reaper.UpdateArrange();  -- Updates the window view
-- #######################################
-- #######################################