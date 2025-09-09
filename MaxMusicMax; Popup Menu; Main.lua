--@description Popup Menu; Main
--@version 1.0
--@author MaxMusicMax
-- https://forum.cockos.com/showthread.php?p=2059855
-- #######################################
-- #######################################
-- Настройки

-- Файл XML для редактирования меню пользователем. После редактирования меню (MenuPopupMain.xml) удалите файл "MenuPopupMain.TXT" чтобы он обновился
local xmlFileName = "MenuPopupMain.xml"

-- Файл TXT для более быстрой загрузки меню при вызове. Отредактируйте путь и имя файла как вам нужно.
local txtFileName = "MenuPopupMain.txt"

-- Путь к папке скрипта
local folderPath = "/Scripts/maxmusicmax/Track/"

-- https://notepad-plus-plus.org/downloads/
-- Любой путь к программе, двой слэш "\\" обязателен
local notepadPPPath = "G:\\Total Commander\\data\\Plugins\\exe\\Notepad++\\data\\notepad++.exe"
-- #####################################################
-- #####################################################
-- Настройки меню
local header_name = "Главное меню" -- Название заголовка меню
local show_window_header = false -- true/false -- Скрыть/показать заголовок меню (header_name)
local menu_header_position_x = 2 -- Положение меню от текущего положения курсора мыши
local menu_header_position_y = 0 -- Положение меню от текущего положения курсора мыши
local menu_header_width_x = 0 -- Ширина заголовка меню
local menu_header_width_y = 0 -- Высота заголовка меню

-- Настройка глобальных переменных для добавления FX
local show_fx = false -- Показывать/Не показывать плагин при добавлении -- true/false
local add_fx_to_item = true -- Добавлять FX к элементам -- true/false
local add_fx_to_track = true -- Добавлять FX к трекам -- true/false
local add_fx_to_master_track = true -- Добавлять FX к мастер треку -- true/false
-- Настройки
-- #####################################################
-- #####################################################
-- ===============================
-- createDefaultXML
-- print_rs
-- printTable
-- printValue
-- Add_FX
-- RunCommandList
-- SetAllTracksAndEnvelopesHeight
-- MoveMutedItemsToNewTrack
-- CreateTrackRelativeToSelected
-- OpenReaperProject
-- CreateFolderTrackAndMoveSelectedTracks
-- EnableMidiModeOnTheTrack
-- GetDurationBetweenLocatorsGivenPlayrate
-- GetExactDurationBetweenLocatorsGivenPlayrate
-- InsertNewTrackAndAddFX
-- delete_or_keep_cc
-- SelectItemsInTimeSelection
-- SelectItemsRelativeCursor
-- decodeMnemonics
-- hasActiveChild
-- getActionShortcutText
-- createMenuString
-- parseAttributes
-- parseXML
-- buildLuaTable
-- escapeString
-- serializeTable
-- saveTableToFile
-- loadTableFromFile
-- openTextFile
-- openFileInNotepadPP
-- open_folder_reaper
-- open_folder_any_specified_path
-- openProjectFolderOrTemp
-- handleMenuSelection
-- showMenu
-- #####################################################
-- #####################################################
reaper.PreventUIRefresh(1);
-- #####################################################
-- #####################################################
-- Функция для создания XML-файла по умолчанию
function createDefaultXML(xmlFilePath)
    local defaultXML = [[
<menuPopup>

<!-- 
Это примеры пунктов меню с разной функциональностью (не удаляйте их)
Не используйте в itemName (названия пунктов) символ "|", меню перестанет корректно работать
<menuPopup>
	<Item itemName="Это пример пункта меню" typeMenu="subMenu">
		<Item itemName="Примеры" typeMenu="subMenu">
		<Item itemName="&quot;Символ двойные кавычки&quot; — &quot;" typeMenu="item" action_id="" />
		<Item itemName="Символ амперсанда — &amp;&amp;" typeMenu="item" action_id="" />
		<Item itemName="Другие символы — ~ $ ? ! # @ ^ * № = + ( ) ' `, . : ; - _" typeMenu="item" action_id="" />
		<Item itemName="" typeMenu="separator" />
		
		<Item itemName="Не активный пункт меню" typeMenu="item" action_id="disabled_item" />
		<Item itemName="Удалить файл кэша" typeMenu="item" action_id="delete_cache" />
		<Item itemName="Окрыть XML" typeMenu="item" action_id="open_in_notepadpp" />
		<Item itemName="" typeMenu="separator" />
		
		<Item itemName="Track: Insert new track (встроенная комманда)" typeMenu="item" action_id="40001" />
		<Item itemName="Theme development: Show theme tweak configuration window" typeMenu="item" action_id="41930" />
		<Item itemName="Gui; Color switch" typeMenu="item" action_id="_RS251990727759d3dff9cf84df740cd6a87ea0d169" />
		<Item itemName="" typeMenu="separator" />
		
		<Item itemName="ReaEQ" typeMenu="item" add_fx="ReaEQ (Cockos)" preset_name="MaxMusicMax — Default" />
		<Item itemName="Pro-Q 3 (FabFilter)" typeMenu="item" add_fx="Pro-Q 3 (FabFilter)" preset_name="Default Setting" />
		<Item itemName="" typeMenu="separator" />
		
		<Item itemName="Open Project Folder In Explorer Or Finder" typeMenu="item" open_folder_reaper="openProjectFolderOrTemp" />
		<Item itemName="Reaper" typeMenu="item" open_folder_reaper="" />
		<Item itemName="Scripts" typeMenu="item" open_folder_reaper="Scripts" />
		<Item itemName="ColorThemes" typeMenu="item" open_folder_reaper="ColorThemes" />
		<Item itemName="" typeMenu="separator" />
		
		<Item itemName="Главное меню" typeMenu="item" switchMenu="MenuPopupMain.xml" />
		<Item itemName="Mouse Modifier" typeMenu="item" switchMenu="MenuPopupMainMouseModifier.xml" />
	</Item>
	</Item>
</menuPopup>
-->

	<Item itemName="Главное меню" typeMenu="item" action_id="disabled_item" />
	<Item itemName="" typeMenu="separator" />
	
	<!-- Примеры -->
	<Item itemName="Примеры" typeMenu="subMenu">
		<Item itemName="Неактивный пункт меню" typeMenu="item" action_id="disabled_item" />
		<Item itemName="" typeMenu="separator" />
		<Item itemName="Track: Insert new track (встроенная комманда)" typeMenu="item" action_id="40001" />
		<Item itemName="Track: Set to random colors (встроенная комманда)" typeMenu="item" action_id="40358" />
		<Item itemName="Archie_Gui; Color switch. (пользовательская комманда)" typeMenu="item" action_id="_RS1bba6d1e6fad1fee16900e38aa15db5a9bf58fae" />
		<Item itemName="" typeMenu="separator" />
		<Item itemName="ReaEQ (без пресета)" typeMenu="item" add_fx="ReaEQ (Cockos)" preset_name="" />
		<Item itemName="ReaEQ (с пресетом) (только внутренние пресеты Reaper)" typeMenu="item" add_fx="ReaEQ (Cockos)" preset_name="stock - Basic 11 band Cymbals" />
		<Item itemName="" typeMenu="separator" />
		<Item itemName="Настройки" typeMenu="subMenu">
			<Item itemName="Удалить файл кэша" typeMenu="item" action_id="delete_cache" />
			<Item itemName="Окрыть XML" typeMenu="item" action_id="open_in_notepadpp" />
		</Item>
	</Item>
	<!-- Примеры -->
	
	<!-- FX Plugins -->
	<Item itemName="FX Plugins" typeMenu="subMenu">
		
		<!-- Control -->
		<Item itemName="Control" typeMenu="subMenu">
			<Item itemName="ReaControlMIDI" typeMenu="item" add_fx="ReaControlMIDI (Cockos)" />
		</Item>
		<!-- Control -->
		
		<!-- Pitch -->
		<Item itemName="Pitch" typeMenu="subMenu">
			<Item itemName="ReaPitch" typeMenu="item" add_fx="ReaPitch (Cockos)" preset_name="" />
		</Item>
		<!-- Pitch -->
		
		<!-- Cockos -->
		<Item itemName="Cockos" typeMenu="subMenu">
			<Item itemName="ReaPitch" typeMenu="item" add_fx="ReaPitch (Cockos)" />
			<Item itemName="ReaEQ" typeMenu="item" add_fx="ReaEQ (Cockos)" />
			<Item itemName="ReaDelay" typeMenu="item" add_fx="ReaDelay (Cockos)" />
			<Item itemName="ReaComp" typeMenu="item" add_fx="ReaComp (Cockos)" />
			<Item itemName="ReaLimit" typeMenu="item" add_fx="ReaLimit (Cockos)" />
			<Item itemName="ReaControlMIDI" typeMenu="item" add_fx="ReaControlMIDI (Cockos)" />
			<Item itemName="ReaGate" typeMenu="item" add_fx="ReaGate (Cockos)" />
			<Item itemName="ReaSurround" typeMenu="item" add_fx="ReaSurround (Cockos)" />
			<Item itemName="ReaSurroundPan" typeMenu="item" add_fx="ReaSurroundPan (Cockos)" />
			<Item itemName="ReaTune" typeMenu="item" add_fx="ReaTune (Cockos)" />
			<Item itemName="ReaVerb" typeMenu="item" add_fx="ReaVerb (Cockos)" />
			<Item itemName="ReaVerbate" typeMenu="item" add_fx="ReaVerbate (Cockos)" />
			<Item itemName="ReaVocode" typeMenu="item" add_fx="ReaVocode (Cockos)" />
			<Item itemName="ReaVoice" typeMenu="item" add_fx="ReaVoice (Cockos)" />
			<Item itemName="ReaXcomp" typeMenu="item" add_fx="ReaXcomp (Cockos)" />
			<Item itemName="ReaSamplOmatic5000" typeMenu="item" add_fx="ReaSamplOmatic5000 (Cockos)" />
			<Item itemName="ReaSynth" typeMenu="item" add_fx="ReaSynth (Cockos)" />
		</Item>
		<!-- Cockos -->
	</Item>
	<!-- FX Plugins -->
	
	<!-- VST Instruments -->
	<Item itemName="VST Instruments" typeMenu="subMenu">
		<Item itemName="ReaSynth (Cockos)" typeMenu="item" add_fx="ReaSynth (Cockos)" preset_name="" />
	</Item>
	<!-- VST Instruments -->
	
	<!-- Open Folder -->
	<Item itemName="Open Folder" typeMenu="subMenu">
		<Item itemName="Open Project Folder In Explorer Or Finder" typeMenu="item" open_folder_reaper="openProjectFolderOrTemp" />
		<Item itemName="" typeMenu="separator" />
		<Item itemName="Reaper" typeMenu="item" open_folder_reaper="" />
		<Item itemName="Scripts" typeMenu="item" open_folder_reaper="Scripts" />
		<Item itemName="ColorThemes" typeMenu="item" open_folder_reaper="ColorThemes" />
		<Item itemName="Effects" typeMenu="item" open_folder_reaper="Effects" />
		<Item itemName="FXChains" typeMenu="item" open_folder_reaper="FXChains" />
		<Item itemName="ProjectTemplates" typeMenu="item" open_folder_reaper="ProjectTemplates" />
		<Item itemName="TrackTemplates" typeMenu="item" open_folder_reaper="TrackTemplates" />
		<Item itemName="UserPlugins" typeMenu="item" open_folder_reaper="UserPlugins" />
	</Item>
	<!-- Open Folder -->
	
	<!-- Project -->
	<Item itemName="Project" typeMenu="subMenu">
		<Item itemName="Options: Preferences" typeMenu="item" action_id="40016" />
		<Item itemName="View: Show project bay window" typeMenu="item" action_id="41157" />
		<Item itemName="View: Show track manager window" typeMenu="item" action_id="40906" />
		<Item itemName="View: Show region/marker manager window" typeMenu="item" action_id="40326" />
		<Item itemName="View: Show routing matrix window" typeMenu="item" action_id="40251" />
		<Item itemName="" typeMenu="separator" />
		<Item itemName="File: Project settings..." typeMenu="item" action_id="40021" />
		<Item itemName="File: Clean current project directory..." typeMenu="item" action_id="40098" />
		<Item itemName="File: Export project MIDI..." typeMenu="item" action_id="40849" />
		<Item itemName="File: Render project to disk..." typeMenu="item" action_id="40015" />
		<Item itemName="" typeMenu="separator" />
		<Item itemName="Project settings: Timebase help..." typeMenu="item" action_id="41825" />
		<Item itemName="Transport: Show transport docked above ruler" typeMenu="item" action_id="41604" />
		<Item itemName="Transport: Show transport docked below arrange" typeMenu="item" action_id="41603" />
		<Item itemName="Toggle fullscreen" typeMenu="item" action_id="40346" />
	</Item>
	<!-- Project -->
	
	<Item itemName="" typeMenu="separator" />
	
	<!-- Color -->
	<Item itemName="Color" typeMenu="subMenu">
		<Item itemName="View: Show peaks display settings" typeMenu="item" action_id="42074" />
		<Item itemName="Options: Show theme adjuster" typeMenu="item" action_id="42234" />
		<Item itemName="Options: Show theme color controls" typeMenu="item" action_id="42392" />
		<Item itemName="Theme development: Show theme tweak/configuration window" typeMenu="item" action_id="41930" />
	</Item>
	<!-- Color -->
	
	<!-- Envelope -->
	<Item itemName="Envelope" typeMenu="subMenu">
		<item itemName="Envelope: Show all envelopes for track" typeMenu="item" action_id="41148" />
		<item itemName="Envelope: Hide all envelopes for track" typeMenu="item" action_id="40889" />
		<Item itemName="" typeMenu="separator" />
		<item itemName="Envelope: Show all envelopes for all tracks" typeMenu="item" action_id="41149" />
		<item itemName="Envelope: Hide all envelopes for all tracks" typeMenu="item" action_id="41150" />
		<Item itemName="" typeMenu="separator" />
		<item itemName="Envelope: Insert automation item" typeMenu="item" action_id="42082" />
		<item itemName="Envelope: Duplicate automation items" typeMenu="item" action_id="42083" />
		<item itemName="Envelope: Duplicate and pool automation items" typeMenu="item" action_id="42085" />
	</Item>
	<!-- Envelope -->
	
	<!-- Grid -->
	<Item itemName="Grid" typeMenu="subMenu">	
		<Item itemName="Grid: Set to 1" typeMenu="item" action_id="40781" />
		<Item itemName="Grid: Set to 1/2" typeMenu="item" action_id="40780" />
		<Item itemName="Grid: Set to 1 /3 (1 /2 triplet)" typeMenu="item" action_id="42000" />
		<Item itemName="Grid: Set to 1/4" typeMenu="item" action_id="40779" />
		<Item itemName="Grid: Set to 1 /5 (1 /4 quintuplet)" typeMenu="item" action_id="42005" />
		<Item itemName="Grid: Set to 1 /6 (1 /4 triplet)" typeMenu="item" action_id="41214" />
		<Item itemName="Grid: Set to 1 /7 (1 /4 septuplet)" typeMenu="item" action_id="42004" />
		<Item itemName="Grid: Set to 1/8" typeMenu="item" action_id="40778" />
		<Item itemName="Grid: Set to 1/9" typeMenu="item" action_id="42003" />
		<Item itemName="Grid: Set to 1 /10 (1 /8 quintuplet)" typeMenu="item" action_id="42002" />
		<Item itemName="Grid: Set to 1 /12 (1 /8 triplet)" typeMenu="item" action_id="40777" />
		<Item itemName="Grid: Set to 1/16" typeMenu="item" action_id="40776" />
		<Item itemName="Grid: Set to 1/18" typeMenu="item" action_id="42001" />
		<Item itemName="Grid: Set to 1/24 (1/16 triplet)" typeMenu="item" action_id="41213" />
		<Item itemName="Grid: Set to 1/32" typeMenu="item" action_id="40775" />
		<Item itemName="Grid: Set to 1 /48 (1 /32 triplet)" typeMenu="item" action_id="41212" />
		<Item itemName="Grid: Set to 1/64" typeMenu="item" action_id="40774" />
		<Item itemName="Grid: Set to 1/128" typeMenu="item" action_id="41047" />
		<Item itemName="Grid: Set to 2" typeMenu="item" action_id="41210" />
		<Item itemName="Grid: Set to 2/3 (whole note triplet)" typeMenu="item" action_id="42007" />
		<Item itemName="Grid: Set to 3" typeMenu="item" action_id="42006" />
		<Item itemName="Grid: Set to 4" typeMenu="item" action_id="41211" />
	</Item>
	<!-- Grid -->
	
	<!-- Items -->
	<Item itemName="Items" typeMenu="subMenu">
		<Item itemName="●  Item grouping: Options" typeMenu="subMenu">
			<Item itemName="Item grouping: Options: Toggle item grouping override" typeMenu="item" action_id="1156" />
			<Item itemName="" typeMenu="separator" />
			<Item itemName="Item grouping: Group items" typeMenu="item" action_id="40032" />
			<Item itemName="Item grouping: Remove items from group" typeMenu="item" action_id="40033" />
			<Item itemName="Item grouping: Select all items in groups" typeMenu="item" action_id="40034" />
		</Item>
		
		<Item itemName="Item properties: Toggle take reverse" typeMenu="item" action_id="41051" />
		<Item itemName="Item: Delete all take markers" typeMenu="item" action_id="42387" />
		<Item itemName="Item: Reset items volume to +0dB" typeMenu="item" action_id="41923" />
		<Item itemName="" typeMenu="separator" />
		<Item itemName="Options: Move envelope points with media items" typeMenu="item" action_id="40070" />
		<Item itemName="Options: Auto-crossfade media items when editing" typeMenu="item" action_id="40041" />
		<Item itemName="" typeMenu="separator" />
		<Item itemName="View: Toggle show/hide item labels" typeMenu="item" action_id="40651" />
	</Item>
	<!-- Items -->
	
	<!-- Mouse Modifier -->
	<Item itemName="Mouse Modifier" typeMenu="subMenu">
		<Item itemName="MaxMusicMax; Mouse Modifier; Main; Set Default" typeMenu="item" action_id="_RSd075702be9c4889bf1adb2f6c8c88870f4149ff2" />
		<Item itemName="" typeMenu="separator" />
		
		<Item itemName="Arrange view middle drag" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39768" />
			<Item itemName="Hand scroll and horizontal zoom" typeMenu="item" action_id="39777" />
			<Item itemName="Hand scroll" typeMenu="item" action_id="39770" />
			<Item itemName="Horizontal zoom" typeMenu="item" action_id="39779" />
			<Item itemName="Jog audio (factory default)" typeMenu="item" action_id="39772" />
			<Item itemName="Marquee zoom" typeMenu="item" action_id="39775" />
			<Item itemName="Scroll browser-style" typeMenu="item" action_id="39771" />
			<Item itemName="Scrub audio" typeMenu="item" action_id="39769" />
			<Item itemName="Set edit cursor, hand scroll and horizontal zoom" typeMenu="item" action_id="39784" />
		</Item>
		
		<Item itemName="Arrange view right drag" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39256" />
			<Item itemName="Add to razor edit area" typeMenu="item" action_id="39282" />
			<Item itemName="Hand scroll and horizontal zoom" typeMenu="item" action_id="39271" />
			<Item itemName="Hand scroll" typeMenu="item" action_id="39264" />
			<Item itemName="Horizontal zoom" typeMenu="item" action_id="39273" />
			<Item itemName="Jog audio" typeMenu="item" action_id="39267" />
			<Item itemName="Marquee zoom" typeMenu="item" action_id="39270" />
			<Item itemName="Scroll browser-style" typeMenu="item" action_id="39265" />
			<Item itemName="Scrub audio" typeMenu="item" action_id="39266" />
		</Item>
		
		<Item itemName="Edit cursor handle left drag" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39800" />
			<Item itemName="Scrub audio" typeMenu="item" action_id="39801" />
			<Item itemName="Jog audio (factory default)" typeMenu="item" action_id="39802" />
			<Item itemName="Jog audio (looped-segment mode)" typeMenu="item" action_id="39804" />
		</Item>
		
		<Item itemName="MIDI CC lane left click/drag" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39352" />
			<Item itemName="Edit CC events" typeMenu="item" action_id="39368" />
			<Item itemName="Marquee select CC" typeMenu="item" action_id="39361" />
			<Item itemName="Linear ramp CC events" typeMenu="item" action_id="39357" />
			<Item itemName="Linear ramp CC events ignoring selection" typeMenu="item" action_id="39356" />
		</Item>
		
		<Item itemName="MIDI CC event left click/drag" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39384" />
			<Item itemName="Edit CC events" typeMenu="item" action_id="39408" />
			<Item itemName="Edit CC events ignoring selection" typeMenu="item" action_id="39407" />
			<Item itemName="Marquee select CC" typeMenu="item" action_id="39395" />
			<Item itemName="Linear ramp CC events" typeMenu="item" action_id="39409" />
			<Item itemName="Linear ramp CC events ignoring selection" typeMenu="item" action_id="39403" />
		</Item>
		
		<Item itemName="MIDI ruler left drag" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39416" />
			<Item itemName="Edit loop point (ruler) or time selection (piano roll) (factory default)" typeMenu="item" action_id="39417" />
			<Item itemName="Edit loop point (ruler) or time selection (piano roll) ignoring snap" typeMenu="item" action_id="39418" />
		</Item>
		
		<Item itemName="MIDI piano roll left drag" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39480" />
			<Item itemName="Marquee select notes" typeMenu="item" action_id="39487" />
			<Item itemName="Scrub preview MIDI" typeMenu="item" action_id="39496" />
		</Item>
		
		<Item itemName="Track left click" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39576" />
			<Item itemName="Deselect all items" typeMenu="item" action_id="39579" />
			<Item itemName="Deselect all items and move edit cursor (factory default)" typeMenu="item" action_id="39577" />
			<Item itemName="Deselect all items and move edit cursor ignoring snap" typeMenu="item" action_id="39578" />
		</Item>
		
		<Item itemName="Track left drag" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39192" />
			<Item itemName="Add to razor edit area" typeMenu="item" action_id="39219" />
			<Item itemName="Marquee zoom" typeMenu="item" action_id="39214" />
			<Item itemName="Marquee select items" typeMenu="item" action_id="39201" />
			<Item itemName="Marquee add to item selection" typeMenu="item" action_id="39205" />
		</Item>
	</Item>
	<!-- Mouse Modifier -->
	
	<!-- Project -->
	<Item itemName="Project" typeMenu="subMenu">
		<Item itemName="Options: Preferences" typeMenu="item" action_id="40016" />
		<Item itemName="View: Show project bay window" typeMenu="item" action_id="41157" />
		<Item itemName="View: Show track manager window" typeMenu="item" action_id="40906" />
		<Item itemName="View: Show region/marker manager window" typeMenu="item" action_id="40326" />
		<Item itemName="View: Show routing matrix window" typeMenu="item" action_id="40251" />
		<Item itemName="" typeMenu="separator" />
		<Item itemName="File: Project settings..." typeMenu="item" action_id="40021" />
		<Item itemName="File: Clean current project directory..." typeMenu="item" action_id="40098" />
		<Item itemName="File: Export project MIDI..." typeMenu="item" action_id="40849" />
		<Item itemName="File: Render project to disk..." typeMenu="item" action_id="40015" />
		<Item itemName="" typeMenu="separator" />
		<Item itemName="Project settings: Timebase help..." typeMenu="item" action_id="41825" />
		
		<Item itemName="Transport: Show transport docked above ruler" typeMenu="item" action_id="41604" />
		<Item itemName="Transport: Show transport docked below arrange" typeMenu="item" action_id="41603" />
		<Item itemName="Toggle fullscreen" typeMenu="item" action_id="40346" />
	</Item>
	<!-- Project -->
	
	<!-- Tracks -->
	<Item itemName="Tracks" typeMenu="subMenu">
		<item itemName="Track: Set track grouping parameters" typeMenu="item" action_id="40772" />
		<Item itemName="" typeMenu="separator" />
		<item itemName="Automation: Set track automation mode to trim/read" typeMenu="item" action_id="40400" />
		<item itemName="Automation: Set track automation mode to write" typeMenu="item" action_id="40403" />
		<item itemName="Automation: Set track automation mode to touch" typeMenu="item" action_id="40402" />
		<Item itemName="" typeMenu="separator" />
		<Item itemName="Options: Show FX inserts in TCP" typeMenu="item" action_id="40302" />
		<item itemName="Track: Toggle show/hide in TCP" typeMenu="item" action_id="40853" />
		<item itemName="Track: Toggle lock/unlock track controls" typeMenu="item" action_id="41314" />
	</Item>
	<!-- Tracks -->
	
	<!-- Настройки -->
	<Item itemName="" typeMenu="separator" />
	<Item itemName="--- Настройки ---" typeMenu="subMenu">
		<Item itemName="Удалить файл кэша" typeMenu="item" action_id="delete_cache" />
		<Item itemName="Окрыть XML" typeMenu="item" action_id="open_in_notepadpp" />
	</Item>
	<Item itemName="Выбрать другое меню" typeMenu="subMenu">
		<Item itemName="Главное меню" typeMenu="item" switchMenu="MenuPopupMain.xml" />
		<Item itemName="Mouse Modifier" typeMenu="item" switchMenu="MenuPopupMainMouseModifier.xml" />
	</Item>
	<!-- Настройки -->
	
</menuPopup>
]]
    local file = io.open(xmlFilePath, "w")
    if file then
        file:write(defaultXML)
        file:close()
    else
        print_rs("Ошибка создания XML-файла.\n\n01. Перед запуском скрипта создайте папку в которой хотите хранить настройки меню\n\n02. Проверте пути в скрипте к этой папке\n\nСейчас в пути прописано это:\n" .. xmlFilePath)
    end
end
-- Функция для создания XML-файла по умолчанию
-- #####################################################
-- #####################################################
-- print_rs
function print_rs (param)
	reaper.ShowConsoleMsg (tostring (param) .. "\n"); -- print_rs ("ReaScript console output")
end
-- #####################################################
-- #####################################################
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
-- #####################################################
-- #####################################################
-- Путь до XML-файла меню
local xmlFilePath = reaper.GetResourcePath():gsub('\\', '/') .. folderPath .. xmlFileName
local txtFilePath = reaper.GetResourcePath():gsub('\\', '/') .. folderPath .. txtFileName
-- #####################################################
-- #####################################################
-- Add_FX
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
-- #####################################################
-- #####################################################
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
-- #####################################################
-- #####################################################
-- SetAllTracksAndEnvelopesHeight
function SetAllTracksAndEnvelopesHeight(tr_height, en_height)
	
	reaper.PreventUIRefresh(1);
	
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
-- #####################################################
-- #####################################################
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
-- #####################################################
-- #####################################################
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
-- #####################################################
-- #####################################################
-- OpenReaperProject
function OpenReaperProject(project_path)
	if type(project_path) ~= "string" or project_path == "" then
		reaper.ShowMessageBox("Некорректный путь к проекту!", "Ошибка", 0)
		return
	end

	-- Проверка существования файла
	local file = io.open(project_path, "r")
	if not file then
		reaper.ShowMessageBox("Файл не найден:\n" .. project_path, "Ошибка", 0)
		return
	end
	file:close()

	-- Открытие проекта
	local result = reaper.Main_openProject(project_path)
	if not result then
		-- reaper.ShowMessageBox("Не удалось открыть проект:\n" .. project_path, "Ошибка", 0)
	end
end
-- #####################################################
-- #####################################################
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
-- #####################################################
-- #####################################################
-- EnableMidiModeOnTheTrack
function EnableMidiModeOnTheTrack ( enable, name_fx, name_preset )
	reaper.Undo_BeginBlock()
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
	reaper.Undo_EndBlock("Вставить трек", -1)
end
-- #####################################################
-- #####################################################
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
	reaper.ClearConsole()
	print_rs ("Длительность между локаторами (учитывая Playrate): " .. formatted_duration)
    -- reaper.ShowMessageBox("Длительность между локаторами (учитывая Playrate): \n\n" .. formatted_duration, "Время между локаторами", 0)
end
-- #####################################################
-- #####################################################
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
	reaper.ClearConsole()
	print_rs ("Длительность между локаторами (учитывая Playrate): " .. formatted_duration)
    -- reaper.ShowMessageBox("Длительность между локаторами (учитывая Playrate): \n\n" .. formatted_duration, "Время между локаторами", 0)
end
-- #####################################################
-- #####################################################
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
-- #####################################################
-- #####################################################
-- delete_or_keep_cc
function delete_or_keep_cc(cc_to_keep)
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
end
-- Selected Media Items Remove All CC's From MIDI
-- delete_or_keep_cc(true)  -- Удалить все CC сообщения
-- delete_or_keep_cc(64) -- Удалить все CC сообщения, кроме номера 64
-- Удалить MIDI CC
-- #####################################################
-- #####################################################
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
-- #####################################################
-- #####################################################
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
-- SelectItemsRelativeCursor
-- #####################################################
-- #####################################################
-- decodeMnemonics
-- Функция для декодирования мнемоник
function decodeMnemonics(str)
	local mnemonics = {
		["&quot;"] = '"',
		["&apos;"] = "'",
		["&amp;"] = "&",
		["&lt;"] = "<",
		["&gt;"] = ">",
		["&vert;"] = "|",
		["&nbsp;"] = " ",
		["&iexcl;"] = "¡",
		["&cent;"] = "¢",
		["&pound;"] = "£",
		["&curren;"] = "¤",
		["&yen;"] = "¥",
		["&brvbar;"] = "¦",
		["&sect;"] = "§",
		["&uml;"] = "¨",
		["&copy;"] = "©",
		["&ordf;"] = "ª",
		["&laquo;"] = "«",
		["&not;"] = "¬",
		["&shy;"] = "­",
		["&reg;"] = "®",
		["&macr;"] = "¯",
		["&deg;"] = "°",
		["&plusmn;"] = "±",
		["&sup2;"] = "²",
		["&sup3;"] = "³",
		["&acute;"] = "´",
		["&micro;"] = "µ",
		["&para;"] = "¶",
		["&middot;"] = "·",
		["&cedil;"] = "¸",
		["&sup1;"] = "¹",
		["&ordm;"] = "º",
		["&raquo;"] = "»",
		["&frac14;"] = "¼",
		["&frac12;"] = "½",
		["&frac34;"] = "¾",
		["&iquest;"] = "¿",
		["&Agrave;"] = "À",
		["&Aacute;"] = "Á",
		["&Acirc;"] = "Â",
		["&Atilde;"] = "Ã",
		["&Auml;"] = "Ä",
		["&Aring;"] = "Å",
		["&AElig;"] = "Æ",
		["&Ccedil;"] = "Ç",
		["&Egrave;"] = "È",
		["&Eacute;"] = "É",
		["&Ecirc;"] = "Ê",
		["&Euml;"] = "Ë",
		["&Igrave;"] = "Ì",
		["&Iacute;"] = "Í",
		["&Icirc;"] = "Î",
		["&Iuml;"] = "Ï",
		["&ETH;"] = "Ð",
		["&Ntilde;"] = "Ñ",
		["&Ograve;"] = "Ò",
		["&Oacute;"] = "Ó",
		["&Ocirc;"] = "Ô",
		["&Otilde;"] = "Õ",
		["&Ouml;"] = "Ö",
		["&times;"] = "×",
		["&Oslash;"] = "Ø",
		["&Ugrave;"] = "Ù",
		["&Uacute;"] = "Ú",
		["&Ucirc;"] = "Û",
		["&Uuml;"] = "Ü",
		["&Yacute;"] = "Ý",
		["&THORN;"] = "Þ",
		["&szlig;"] = "ß",
		["&agrave;"] = "à",
		["&aacute;"] = "á",
		["&acirc;"] = "â",
		["&atilde;"] = "ã",
		["&auml;"] = "ä",
		["&aring;"] = "å",
		["&aelig;"] = "æ",
		["&ccedil;"] = "ç",
		["&egrave;"] = "è",
		["&eacute;"] = "é",
		["&ecirc;"] = "ê",
		["&euml;"] = "ë",
		["&igrave;"] = "ì",
		["&iacute;"] = "í",
		["&icirc;"] = "î",
		["&iuml;"] = "ï",
		["&eth;"] = "ð",
		["&ntilde;"] = "ñ",
		["&ograve;"] = "ò",
		["&oacute;"] = "ó",
		["&ocirc;"] = "ô",
		["&otilde;"] = "õ",
		["&ouml;"] = "ö",
		["&divide;"] = "÷",
		["&oslash;"] = "ø",
		["&ugrave;"] = "ù",
		["&uacute;"] = "ú",
		["&ucirc;"] = "û",
		["&uuml;"] = "ü",
		["&yacute;"] = "ý",
		["&thorn;"] = "þ",
		["&yuml;"] = "ÿ"
	}
	return (str:gsub("(&%w+;)", mnemonics))
end
-- Функция для декодирования мнемоник
-- #####################################################
-- #####################################################
-- hasActiveChild
-- Функция для проверки наличия активных дочерних пунктов
function hasActiveChild(items)
    for _, item in ipairs(items) do
        if item.action_id then
            local commandId = reaper.NamedCommandLookup(item.action_id)
            if reaper.GetToggleCommandStateEx(0, commandId) == 1 then
                return true
            end
        end
        if item.switchMenu and item.switchMenu == reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMainGlobal") then
            return true
        end
        if item.children and #item.children > 0 and hasActiveChild(item.children) then
            return true
        end
    end
    return false
end
-- Функция для проверки наличия активных дочерних пунктов
-- #####################################################
-- #####################################################
-- getActionShortcutText
-- Функция для получения текста горячей клавиши для действия
function getActionShortcutText(command_id)
    local sections = {0, 32060, 32061, 32062, 32063}  -- Различные секции (main, MIDI editor, etc.)
    local shortcuts = {}  -- Таблица для хранения горячих клавиш
    for _, section_id in ipairs(sections) do  -- Проходим по всем секциям
        for i = 0, reaper.JS_Actions_CountShortcuts(section_id, command_id) - 1 do  -- Проходим по всем горячим клавишам для команды в секции
            local retval, desc = reaper.JS_Actions_GetShortcutDesc(section_id, command_id, i)  -- Получаем описание горячей клавиши
            if retval and desc and desc ~= "" then  -- Если горячая клавиша существует и не пустая
                table.insert(shortcuts, desc)  -- Добавляем горячую клавишу в таблицу
            end
        end
    end
    if #shortcuts > 0 then  -- Если есть горячие клавиши
        return table.concat(shortcuts, ", ")  -- Возвращаем их в виде строки, разделенной запятыми
    end
    return nil  -- Если горячих клавиш нет, возвращаем nil
end
-- Функция для получения текста горячей клавиши для действия
-- #####################################################
-- #####################################################
-- createMenuString
-- Функция для создания строки меню из таблицы и сохранения действий
function createMenuString(tbl, actions)  -- Определение функции createMenuString с параметрами tbl (таблица меню) и actions (таблица действий)
    local menuString = ""  -- Инициализация пустой строки menuString, которая будет содержать строку меню
	
	if tbl then  -- Проверка, существует ли таблица tbl
		for index, item in ipairs(tbl.children) do  -- Итерация по всем элементам children в таблице tbl
			item.itemName = decodeMnemonics(item.itemName) -- Декодирование мнемоник в itemName
			if item.typeMenu == "subMenu" then  -- Проверка, является ли текущий элемент подменю
				if hasActiveChild(item.children) then
					item.itemName = "!" .. item.itemName
				end
				menuString = menuString .. ">" .. item.itemName .. "|"  -- Добавление обозначения начала подменю и имени элемента в строку menuString
				menuString = menuString .. createMenuString(item, actions)  -- Рекурсивный вызов createMenuString для обработки подменю и добавление результата в menuString
				menuString = menuString .. "<|"  -- Добавление обозначения конца подменю в строку menuString
			elseif item.typeMenu == "item" then  -- Проверка, является ли текущий элемент пунктом меню
				if item.action_id then  -- Проверка, существует ли у элемента идентификатор действия (action_id)
					if item.action_id == "disabled_item" then
						item.itemName = "#" .. item.itemName  -- Добавление '#' перед именем элемента для указания, что он отключен
					else
						local commandId = reaper.NamedCommandLookup(item.action_id)  -- Поиск идентификатора команды по action_id
						if commandId > 0 then  -- Проверка, найден ли идентификатор команды
							local commandState = reaper.GetToggleCommandStateEx(0, commandId)  -- Получение состояния команды (включена/выключена) в главном разделе (section 0)
							if commandState == 1 then  -- Проверка, включена ли команда
								item.itemName = "!" .. item.itemName  -- Добавление '!' перед именем элемента для указания, что команда включена
							end
							local shortcut = getActionShortcutText(commandId)  -- Получаем текст горячей клавиши для команды
							if shortcut and shortcut ~= "" then  -- Если горячая клавиша существует и не пустая
								item.itemName = item.itemName .. " ( " .. shortcut .. " )"  -- Добавляем горячую клавишу к имени элемента
							end
						end
					end
				end
				
				if item.switchMenu and item.switchMenu == reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMainGlobal") then
					item.itemName = "!" .. item.itemName
				end
				
				menuString = menuString .. item.itemName .. "|"  -- Добавление имени элемента в строку menuString
				
				table.insert(actions, {
					action_id = item.action_id, 
					add_fx = item.add_fx, 
					preset_name = item.preset_name,
					switchMenu = item.switchMenu,
					open_folder_reaper = item.open_folder_reaper,
					open_page_settings = item.open_page_settings,
					action_function = item.action_function,
					tooltip = item.tooltip,
				})  -- Добавление действия в таблицу actions
			elseif item.typeMenu == "separator" then  -- Проверка, является ли текущий элемент разделителем
				menuString = menuString .. "|"  -- Добавление разделителя в строку menuString
			end
		end
    end
	
    return menuString  -- Возврат сформированной строки меню
end
-- Функция для создания строки меню из таблицы и сохранения действий
-- #####################################################
-- #####################################################
-- parseAttributes
-- Функция для парсинга атрибутов из строки
function parseAttributes(attrs)
    local attributes = {}
    -- Регулярное выражение для парсинга атрибутов с кавычками, которое поддерживает вложенные кавычки
    local pattern = '([%w_]+)=([\'"])(.-)%2'
    for key, quote, value in string.gmatch(attrs, pattern) do
        attributes[key] = value
    end
    return attributes
end
-- Функция для парсинга атрибутов из строки
-- #####################################################
-- #####################################################
-- parseXML
-- Функция для парсинга XML
function parseXML(xml)
    local stack = {}
    local top = {itemName = nil, typeMenu = "menuPopup", children = {}}
    table.insert(stack, top)

    local i = 1
    while true do
        local ni, j, close, label, attrs, empty = string.find(xml, "<(%/?)%s*([%w_:]+)(.-)(%/?)>", i)

        -- Проверка на комментарии
        local comment_start, comment_end = string.find(xml, "<!%-%-", i)
        if comment_start and (not ni or comment_start < ni) then
            local comment_close = string.find(xml, "%-%->", comment_start)
            if comment_close then
                i = comment_close + 3
                goto continue
            end
        end

        if not ni then break end

        local text = string.sub(xml, i, ni - 1)
        if not string.find(text, "^%s*$") then
            table.insert(stack[#stack].children, text)
        end

        if empty == "/" then
            table.insert(stack[#stack].children, {itemName = label, attrs = parseAttributes(attrs), children = {}})
        elseif close == "" then
            local newNode = {itemName = label, attrs = parseAttributes(attrs), children = {}}
            table.insert(stack[#stack].children, newNode)
            table.insert(stack, newNode)
        else
            if stack[#stack].itemName ~= label then
                error("XML Error: Mismatched tags")
            end
            table.remove(stack)
        end
        i = j + 1

        ::continue::
    end
	
    return top.children[1]
end
-- Функция для парсинга XML
-- #####################################################
-- #####################################################
-- buildLuaTable
-- Функция для создания таблицы из узла XML
function buildLuaTable(node)  -- Определение функции buildLuaTable с параметром node (узел XML)
    local result = {  -- Создание таблицы result для хранения данных узла
		itemName = node.attrs.itemName,  -- Копирование атрибута itemName из узла в таблицу result
		typeMenu = node.attrs.typeMenu,  -- Копирование атрибута typeMenu из узла в таблицу result
		action_id = node.attrs.action_id,  -- Копирование атрибута action_id из узла в таблицу result
		add_fx = node.attrs.add_fx,  -- Копирование атрибута add_fx из узла в таблицу result
		preset_name = node.attrs.preset_name,  -- Копирование атрибута preset_name из узла в таблицу result
		switchMenu = node.attrs.switchMenu,
		open_folder_reaper = node.attrs.open_folder_reaper,
		open_page_settings = node.attrs.open_page_settings,
		action_function = node.attrs.action_function,
		tooltip = node.attrs.tooltip,
		children = {}  -- Инициализация пустого списка для дочерних элементов
    }
    for _, child in ipairs(node.children) do  -- Итерация по всем дочерним элементам узла
        if type(child) == "table" then  -- Проверка, является ли дочерний элемент таблицей
            table.insert(result.children, buildLuaTable(child))  -- Рекурсивный вызов buildLuaTable для дочернего элемента и добавление результата в список children
        end
    end
	
    return result  -- Возврат таблицы result как результата функции
end  -- Завершение функции buildLuaTable
-- Функция для создания таблицы из узла XML
-- #####################################################
-- #####################################################
-- escapeString
-- Функция для экранирования строк
local function escapeString(str)
    str = str:gsub('\\', '\\\\')
    str = str:gsub('"', '\\"')
    return str
end
-- Функция для экранирования строк
-- #####################################################
-- #####################################################
-- serializeTable
-- Функция для сериализации таблицы Lua в строку
function serializeTable(tbl, indent)
    indent = indent or 0 -- Устанавливаем отступ по умолчанию в 0, если он не задан
    local str = "{\n" -- Начинаем строку с открывающей фигурной скобки и новой строки
    local indentation = string.rep("\t", indent) -- Увеличиваем отступы с каждым уровнем, используя табуляцию

    for k, v in pairs(tbl) do -- Проходим по всем парам ключ-значение в таблице
        local key = type(k) == "number" and "[" .. k .. "]" or '["' .. escapeString(k) .. '"]' -- Форматируем ключ в зависимости от его типа (число или строка)
        if type(v) == "table" then -- Если значение является таблицей
            if next(v) then -- Проверка, что таблица не пустая
                str = str .. indentation .. key .. " = " .. serializeTable(v, indent + 1) .. ",\n" -- Рекурсивно сериализуем вложенную таблицу с увеличением отступа
            else
                str = str .. indentation .. key .. " = {},\n" -- Если таблица пустая, добавляем пустую таблицу
            end
        elseif type(v) == "string" then -- Если значение является строкой
            str = str .. indentation .. key .. ' = "' .. escapeString(v) .. '",\n' -- Добавляем строковое значение с кавычками
        elseif type(v) == "boolean" then -- Если значение является булевым
            str = str .. indentation .. key .. ' = ' .. (v and "true" or "false") .. ",\n" -- Добавляем булево значение (true или false)
        else -- Если значение является числом или другим типом
            str = str .. indentation .. key .. " = " .. tostring(v) .. ",\n" -- Преобразуем значение в строку и добавляем
        end
    end
    str = str .. string.rep("\t", math.max(indent - 1, 0)) .. "}" -- Уменьшаем отступ перед закрывающей фигурной скобкой
    
    return str -- Возвращаем сериализованную строку
end
-- Функция для сериализации таблицы Lua в строку
-- #####################################################
-- #####################################################
-- saveTableToFile
-- Функция для сохранения таблицы Lua в файл
function saveTableToFile(tbl, filename)
    local file = io.open(filename, "w")
    if file then
        file:write("return ")
        file:write(serializeTable(tbl))
        file:close()
        return true
    else
        return false
    end
end
-- Функция для сохранения таблицы Lua в файл
-- #####################################################
-- #####################################################
-- loadTableFromFile
-- Функция для загрузки таблицы Lua из файла
function loadTableFromFile(filename)
    local chunk = loadfile(filename)
    if chunk then
        return chunk()
    else
        return nil
    end
end
-- Функция для загрузки таблицы Lua из файла
-- #####################################################
-- #####################################################
-- openTextFile
function openTextFile(path, fromResourcePath)
	if fromResourcePath then
		local sep = package.config:sub(1,1)
		path = reaper.GetResourcePath() .. sep .. path
	end

	local os = reaper.GetOS()
	if os:find("Win") then
		reaper.CF_ShellExecute(path)
	elseif os:find("OSX") then
		os.execute('open "' .. path .. '"')
	else
		os.execute('xdg-open "' .. path .. '"')
	end
end
-- #####################################################
-- #####################################################
-- openFileInNotepadPP
function openFileInNotepadPP(filePath)
    local command = '"' .. notepadPPPath .. '" "' .. filePath .. '"'
    -- os.execute(command)
    reaper.ExecProcess(command, -2)
end
-- #####################################################
-- #####################################################
-- open_folder_reaper
function open_folder_reaper ( folder_name )
	-- Получаем путь к папке Reaper
	local reaperPath = reaper.GetResourcePath()
	local sep = package.config:sub(1, 1)  -- Получаем системный разделитель путей
	local userPluginsPath = reaperPath .. sep .. folder_name
	-- Определяем операционную систему
	local os = reaper.GetOS()
	if os:find("Win") then
		-- Windows
		reaper.CF_ShellExecute(userPluginsPath)
		elseif os:find("OSX") then
		-- macOS
		os.execute('open "' .. userPluginsPath .. '"')
		else
		-- Linux
		os.execute('xdg-open "' .. userPluginsPath .. '"')
	end
end
-- #####################################################
-- #####################################################
-- open_folder_any_specified_path
function open_folder_any_specified_path(folder_path)
    -- Определяем операционную систему
    local os = reaper.GetOS()
    if os:find("Win") then
        -- Windows
        reaper.CF_ShellExecute(folder_path)
    elseif os:find("OSX") then
        -- macOS
        os.execute('open "' .. folder_path .. '"')
    else
        -- Linux
        os.execute('xdg-open "' .. folder_path .. '"')
    end
end
-- #####################################################
-- #####################################################
-- openProjectFolderOrTemp
function openProjectFolderOrTemp()
    -- Получаем путь к текущему проекту и проверяем его статус
    local projectFile = reaper.EnumProjects(-1, "")
    local projectPath = reaper.GetProjectPath("")

    -- Определяем путь к открытию
    local pathToOpen
    if projectFile ~= "" then
        -- Проект сохранен, используем папку проекта, поднимаясь на уровень выше
        pathToOpen = projectPath:match("^(.*[/\\])")
        -- pathToOpen = projectPath
    else
        -- Проект не сохранен, используем папку temp Reaper
        pathToOpen = reaper.GetResourcePath() .. package.config:sub(1, 1) .. "temp"
    end

    -- Определяем операционную систему и открываем папку
    local os = reaper.GetOS()
    if os:find("Win") then
        -- Windows
        reaper.CF_ShellExecute(pathToOpen)
    elseif os:find("OSX") then
        -- macOS
        os.execute('open "' .. pathToOpen .. '"')
    else
        -- Linux
        os.execute('xdg-open "' .. pathToOpen .. '"')
    end
end
-- #####################################################
-- #####################################################
-- handleMenuSelection
-- Обработка выбора пункта меню
local function handleMenuSelection(selectedAction)
	if selectedAction.action_id then  -- Если у действия есть идентификатор команды
		if selectedAction.action_id == "delete_cache" then  -- Если действие - удаление кэша
			os.remove(txtFilePath)  -- Удаление TXT файла кэша
		elseif selectedAction.action_id == "open_in_notepadpp" then  -- Если действие - открытие в Notepad++
			if reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMainGlobal") ~= "" then
				openFileInNotepadPP ( reaper.GetResourcePath():gsub('\\', '/') .. folderPath .. reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMainGlobal") )
			else
				openFileInNotepadPP(xmlFilePath)  -- Открытие XML файла в Notepad++
			end
		else  -- Если действие - выполнение команды Reaper
			local commandId = reaper.NamedCommandLookup(selectedAction.action_id)
			if commandId > 0 then
				local main_hwnd = reaper.GetMainHwnd()
				reaper.JS_Window_SetFocus(main_hwnd)
				reaper.Main_OnCommand(commandId, 0)  -- Выполнение команды в основном окне
			end
		end
	elseif selectedAction.add_fx then  -- Если действие - добавление FX
		Add_FX(selectedAction.add_fx, selectedAction.preset_name)  -- Добавление FX с заданным именем и пресетом
	elseif selectedAction.switchMenu then
		-- reaper.DeleteExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMidiEditorGlobal", true)
		reaper.SetExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMainGlobal", selectedAction.switchMenu, true)
		os.remove(txtFilePath)
	elseif selectedAction.action_function then
		local return_function_action = load(selectedAction.action_function)
		if return_function_action then
			return_function_action()
		else
			print_rs ( selectedAction.action_function )
		end
		
	elseif selectedAction.open_folder_reaper then
		if selectedAction.open_folder_reaper == "openProjectFolderOrTemp" then
			openProjectFolderOrTemp ()
		else
			open_folder_reaper ( selectedAction.open_folder_reaper )
		end
	elseif selectedAction.open_page_settings then
		reaper.ViewPrefs(selectedAction.open_page_settings, '')
	end
	
	reaper.PreventUIRefresh(-1);
	reaper.TrackList_AdjustWindows(0)  -- Updates the window view
	reaper.UpdateArrange();  -- Updates the window view
	-- gfx.quit()  -- Принудительное закрытие меню
end
-- Обработка выбора пункта меню
-- #####################################################
-- #####################################################
-- showMenu
function showMenu()  -- Определение функции showMenu
	
	-- Установка значений по умолчанию при первом запуске
	-- reaper.DeleteExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMainGlobal", true)
	if reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMainGlobal") == "" then
		reaper.SetExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMainGlobal", xmlFileName, true)
	end
	
	-- Проверка существования Lua-файла
	local luaTable  -- Объявление переменной luaTable для хранения загруженной таблицы
	if reaper.file_exists(txtFilePath) then -- Проверка существования TXT файла
		luaTable = loadTableFromFile(txtFilePath)  -- Загрузка таблицы из TXT файла
		
	elseif reaper.file_exists(xmlFilePath) then -- Проверка существования XML файла
		local title = reaper.JS_Localize('ReaScript console output', "common")  -- Локализация заголовка окна консоли ReaScript
		local hwnd = reaper.JS_Window_Find(title, true)  -- Поиск окна с заданным заголовком
		if hwnd then reaper.JS_Window_Destroy(hwnd) end  -- Уничтожение окна, если оно найдено
		
		local currentMenu = reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMainGlobal")
		if currentMenu ~= xmlFileName then
			if reaper.file_exists( reaper.GetResourcePath():gsub('\\', '/') .. folderPath .. currentMenu ) then -- Проверка существования XML файла
				xmlFilePath = reaper.GetResourcePath():gsub('\\', '/') .. folderPath .. currentMenu
			else
				xmlFilePath = reaper.GetResourcePath():gsub('\\', '/') .. folderPath .. xmlFileName
				reaper.SetExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMainGlobal", xmlFileName, true)
				os.remove(txtFilePath)
			end
		end
		
		local file = io.open(xmlFilePath, "r")  -- Открытие XML файла для чтения
		local xml = file:read("*all")  -- Чтение всего содержимого XML файла
		file:close()  -- Закрытие файла
		local parsedXML = parseXML(xml)  -- Парсинг XML содержимого в структуру данных
		luaTable = buildLuaTable(parsedXML)  -- Построение таблицы Lua из структуры данных XML
		
		saveTableToFile(luaTable, txtFilePath)  -- Сохранение таблицы Lua в TXT файл для кэширования
		-- print_rs ( "XML файл" )  -- Закомментированная строка для отладки, которая выводит сообщение о загрузке из XML файла
	else  -- Если ни TXT, ни XML файл не найден
		local title = reaper.JS_Localize('ReaScript console output', "common")  -- Локализация заголовка окна консоли ReaScript
		local hwnd = reaper.JS_Window_Find(title, true)  -- Поиск окна с заданным заголовком
		if hwnd then reaper.JS_Window_Destroy(hwnd) end  -- Уничтожение окна, если оно найдено
		
		-- Предложить пользователю указать путь к XML файлу или создать новый
		local ret = reaper.ShowMessageBox("Не найдено ни одной таблицы меню.\n\nВ настройках скрипта укажите правильный путь к XML-файлу или создайте новый XML-файл по умолчанию.\n\nСоздать новый XML-файл по умолчанию ?", "Ошибка", 1)  -- Показать сообщение пользователю с предложением создать новый XML файл

		if ret == 1 then -- Если пользователь выбрал "Да"
			createDefaultXML(xmlFilePath)  -- Создание нового XML файла по умолчанию
			local ret = reaper.ShowMessageBox("XML-файл по умолчанию успешно создан, вызовите ещё раз скрипт и вы увидите меню по умолчанию", "Ошибка", 0)  -- Показать сообщение об успешном создании XML файла
		else -- Пользователь выбрал "Отмена", окно просто закрывается
			-- print_rs ("Не найдено ни одной таблицы меню. \n\nУкажите правильный путь к файлу XML в начале этого скрипта \n\nСейчас путь в скрипте до XML-файла указан такой:\n\n" .. reaper.GetResourcePath():gsub('\\', '/') .. xmlFileName)  -- Закомментированная строка для отладки, которая выводит сообщение о необходимости указать путь к XML файлу
			return  -- Завершение функции
		end
	end
	-- Проверка существования Lua-файла

	-- Сохранение действий и создание строки меню
	local actions = {}  -- Инициализация пустой таблицы действий
	local menuString = createMenuString(luaTable, actions)  -- Создание строки меню и заполнение таблицы действий
	
	-- Инициализация графического окна и показ меню header_name
	local x_mouse, y_mouse = reaper.GetMousePosition()  -- Получение текущей позиции курсора мыши

	-- gfx.init(header_name, menu_header_width_x, menu_header_width_y, 0, x_mouse + menu_header_position_x, y_mouse + menu_header_position_y)  -- Инициализация графического окна меню
	
	--[[ 	]]--
	
	local title = "PopupMenu" -- .. reaper.genGuid()
	gfx.init( title, 0, 0, 0, 0, 0 )
	
	local hwnd = reaper.JS_Window_Find( title, true )
	local opacity = 0.0 -- Установите значение прозрачности 0.0 - полностью прозрачно, 1.0 - полностью непрозрачно
	
	if hwnd then
		reaper.JS_Window_Show( hwnd, "HIDE" )
		reaper.JS_Window_SetOpacity(hwnd, "ALPHA", opacity)
	end
	
	gfx.x, gfx.y = gfx.mouse_x-menu_header_position_x, gfx.mouse_y-menu_header_position_y
	
	-- Скрыть/показать заголовок окна меню
	if show_window_header == false then  -- Если флаг show_window_header установлен в false
		-- gfx.x, gfx.y = gfx.mouse_x + menu_header_position_x, gfx.mouse_y + menu_header_position_y  -- Установка позиции окна меню относительно курсора мыши
	end
	
	local selection = gfx.showmenu(menuString)  -- Показ меню и получение выбранного элемента
	-- Обработка выбора пункта меню
	if selection > 0 then  -- Если был выбран пункт меню
		local selectedAction = actions[selection]  -- Получение соответствующего действия из таблицы actions
		
		if selectedAction then  -- Если действие существует
			handleMenuSelection(selectedAction)
		end
		-- gfx.quit()  -- Принудительное закрытие меню
	end
	-- Обработка выбора пункта меню

	
end  -- Завершение функции showMenu
-- #####################################################
-- #####################################################
reaper.defer(showMenu)
-- #####################################################
-- #####################################################
reaper.PreventUIRefresh(-1)
reaper.TrackList_AdjustWindows(0)  -- Updates the window view
reaper.UpdateArrange()  -- Updates the window view