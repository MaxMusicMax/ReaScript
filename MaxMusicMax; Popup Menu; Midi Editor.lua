--@description Popup Menu; Main; Insert Fx Or Complete The Command From The List Of Actions.lua
--@version 1.0
--@author MaxMusicMax
-- https://forum.cockos.com/showthread.php?p=2059855
-- #######################################
-- #######################################
-- Настройки

-- Файл XML для редактирования меню пользователем. После редактирования меню (MenuPopupMain.xml) удалите файл "MenuPopupMain.TXT" чтобы он обновился
local xmlFileName = "MenuPopupMidiEditorMain.xml"

-- Файл TXT для более быстрой загрузки меню при вызове. Отредактируйте путь и имя файла как вам нужно.
local txtFileName = "MenuPopupMidiEditor.txt"

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
-- ==========================
-- createDefaultXML
-- print_rs
-- printTable
-- printValue
-- Add_FX
-- decodeMnemonics
-- deselect_all_notes
-- set_selected_notes_velocity
-- midi_to_note_name
-- get_chords_and_notes_in_selection
-- get_selected_notes_to_str
-- createMenuString_Old
-- isItemActive
-- isSubMenuActive
-- createMenuString
-- parseAttributes
-- parseXML
-- buildLuaTable
-- serializeTable
-- saveTableToFile
-- loadTableFromFile
-- openFileInNotepadPP
-- note_to_midi
-- duration_to_ppq
-- setGlobalChordTranspose
-- setFocusToMidiEditor
-- insert_chord
-- handleMenuSelection
-- showMenu
-- #####################################################
-- #####################################################
reaper.PreventUIRefresh(1);
-- #####################################################
-- #####################################################
-- createDefaultXML
-- Функция для создания XML-файла по умолчанию
function createDefaultXML(xmlFilePath)
    local defaultXML = [[
<menuPopup>

<!-- 
Это примеры пунктов меню с разной функциональностью (не удаляйте их)
Не используйте в itemName (названия пунктов) символ "|", меню перестанет корректно работать

-->

	<Item itemName="--- MIDI Editor ---" typeMenu="item" action_id="disabled_item" />
	<Item itemName="" typeMenu="separator" />
	
	<!-- Event properties -->
	<Item itemName="Edit: Mute events (toggle)" typeMenu="item" action_id="40055" />
	<Item itemName="Midi Overdub All Midi Inputs And All Channels" typeMenu="item" action_id="_RS7d3c_398260c7bdb0b5d7e61f32001730107bcc539e93" />
	<Item itemName="Edit: Event properties" typeMenu="item" action_id="40004" />
	
	<Item itemName="Edit: Set events to channel" typeMenu="subMenu">
		<Item itemName="01" typeMenu="item" action_id="40020" />
		<Item itemName="02" typeMenu="item" action_id="40021" />
		<Item itemName="03" typeMenu="item" action_id="40022" />
		<Item itemName="04" typeMenu="item" action_id="40023" />
		<Item itemName="05" typeMenu="item" action_id="40024" />
		<Item itemName="06" typeMenu="item" action_id="40025" />
		<Item itemName="07" typeMenu="item" action_id="40026" />
		<Item itemName="08" typeMenu="item" action_id="40027" />
		<Item itemName="09" typeMenu="item" action_id="40028" />
		<Item itemName="10" typeMenu="item" action_id="40029" />
		<Item itemName="11" typeMenu="item" action_id="40030" />
		<Item itemName="12" typeMenu="item" action_id="40031" />
		<Item itemName="13" typeMenu="item" action_id="40032" />
		<Item itemName="14" typeMenu="item" action_id="40033" />
		<Item itemName="15" typeMenu="item" action_id="40034" />
		<Item itemName="16" typeMenu="item" action_id="40035" />
	</Item>
	
	<Item itemName="Notes" typeMenu="subMenu">
		<Item itemName="Transpose notes" typeMenu="item" action_id="40759" />
		<Item itemName="Filter: Show/hide filter window" typeMenu="item" action_id="40762" />
		<Item itemName="Split notes on grid" typeMenu="item" action_id="40641" />
		<Item itemName="Edit: Join notes" typeMenu="item" action_id="40456" />
		<Item itemName="Set note ends to start of next note (legato)" typeMenu="item" action_id="40405" />
	</Item>
	<!-- Event properties -->
	
	<!-- Mouse Modifier -->
	<Item itemName="" typeMenu="separator" />
	<Item itemName="Mouse Modifier" typeMenu="subMenu">
		<Item itemName="MaxMusicMax; Mouse Modifier; Set Default" typeMenu="item" action_id="_RS7d3c_d075702be9c4889bf1adb2f6c8c88870f4149ff2" />
		<Item itemName="" typeMenu="separator" />
		
		<Item itemName="MIDI CC event left click/drag" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39384" />
			<Item itemName="Copy CC event" typeMenu="item" action_id="39390" />
			<Item itemName="Copy CC event ignoring snap" typeMenu="item" action_id="39391" />
			<Item itemName="Delete CC events" typeMenu="item" action_id="39387" />
			<Item itemName="Draw/edit CC events ignoring selection" typeMenu="item" action_id="39402" />
			<Item itemName="Draw/edit CC events ignoring snap and selection" typeMenu="item" action_id="39404" />
			<Item itemName="Edit CC events" typeMenu="item" action_id="39408" />
			<Item itemName="Edit CC events ignoring selection" typeMenu="item" action_id="39407" />
			<Item itemName="Edit selected CC events if any, otherwise draw/edit" typeMenu="item" action_id="39405" />
			<Item itemName="Edit selected CC events if any, otherwise draw/edit ignoring snap" typeMenu="item" action_id="39406" />
			<Item itemName="Linear ramp CC events" typeMenu="item" action_id="39409" />
			<Item itemName="Linear ramp CC events ignoring selection" typeMenu="item" action_id="39403" />
			<Item itemName="Marquee add to CC selection" typeMenu="item" action_id="39397" />
			<Item itemName="Marquee select CC" typeMenu="item" action_id="39395" />
			<Item itemName="Marquee select CC and time" typeMenu="item" action_id="39398" />
			<Item itemName="Marquee select CC and time ignoring snap" typeMenu="item" action_id="39399" />
			<Item itemName="Marquee toggle CC selection" typeMenu="item" action_id="39396" />
			<Item itemName="Move CC event" typeMenu="item" action_id="39385" />
			<Item itemName="Move CC event ignoring snap" typeMenu="item" action_id="39386" />
			<Item itemName="Move CC event on one axis only" typeMenu="item" action_id="39388" />
			<Item itemName="Move CC event on one axis only ignoring snap" typeMenu="item" action_id="39389" />
			<Item itemName="Move CC horizontally" typeMenu="item" action_id="39392" />
			<Item itemName="Move CC horizontally ignoring snap" typeMenu="item" action_id="39393" />
			<Item itemName="Move CC vertically" typeMenu="item" action_id="39394" />
			<Item itemName="Reset CC events to default" typeMenu="item" action_id="39410" />
			<Item itemName="Select time" typeMenu="item" action_id="39400" />
			<Item itemName="Select time ignoring snap" typeMenu="item" action_id="39401" />
			<Item itemName="Set new default value for CC events" typeMenu="item" action_id="39411" />
		</Item>

		<Item itemName="MIDI CC lane left click/drag" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39352" />
			<Item itemName="Delete CC events" typeMenu="item" action_id="39355" />
			<Item itemName="Deselect events" typeMenu="item" action_id="39373" />
			<Item itemName="Draw/edit CC events ignoring selection" typeMenu="item" action_id="39353" />
			<Item itemName="Draw/edit CC events ignoring snap and selection" typeMenu="item" action_id="39358" />
			<Item itemName="Edit CC events" typeMenu="item" action_id="39368" />
			<Item itemName="Edit CC events ignoring selection" typeMenu="item" action_id="39359" />
			<Item itemName="Edit selected CC events if any, otherwise draw/edit" typeMenu="item" action_id="39354" />
			<Item itemName="Edit selected CC events if any, otherwise draw/edit ignoring snap" typeMenu="item" action_id="39360" />
			<Item itemName="Insert CC event" typeMenu="item" action_id="39369" />
			<Item itemName="Insert CC event ignoring snap" typeMenu="item" action_id="39370" />
			<Item itemName="Linear ramp CC events" typeMenu="item" action_id="39357" />
			<Item itemName="Linear ramp CC events ignoring selection" typeMenu="item" action_id="39356" />
			<Item itemName="Marquee add to CC selection" typeMenu="item" action_id="39363" />
			<Item itemName="Marquee select CC" typeMenu="item" action_id="39361" />
			<Item itemName="Marquee select CC and time" typeMenu="item" action_id="39364" />
			<Item itemName="Marquee select CC and time ignoring snap" typeMenu="item" action_id="39365" />
			<Item itemName="Marquee toggle CC selection" typeMenu="item" action_id="39362" />
			<Item itemName="Reset CC events to default" typeMenu="item" action_id="39371" />
			<Item itemName="Select time" typeMenu="item" action_id="39366" />
			<Item itemName="Select time ignoring snap" typeMenu="item" action_id="39367" />
			<Item itemName="Set new default value for CC events" typeMenu="item" action_id="39372" />
		</Item>

		<Item itemName="MIDI CC segment left click/drag" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="25320" />
			<Item itemName="Draw/edit CC events ignoring selection" typeMenu="item" action_id="25324" />
			<Item itemName="Draw/edit CC events ignoring snap and selection" typeMenu="item" action_id="25325" />
			<Item itemName="Edit CC segment curvature" typeMenu="item" action_id="25327" />
			<Item itemName="Insert CC event" typeMenu="item" action_id="25322" />
			<Item itemName="Insert CC event ignoring snap" typeMenu="item" action_id="25323" />
			<Item itemName="Move CC segment" typeMenu="item" action_id="25326" />
			<Item itemName="Move CC segment ignoring time selection" typeMenu="item" action_id="25321" />
		</Item>

		<Item itemName="MIDI editor right drag" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39448" />
			<Item itemName="Delete notes/CC" typeMenu="item" action_id="39454" />
			<Item itemName="Delete notes/CC immediately (suppress right-click context menu)" typeMenu="item" action_id="39458" />
			<Item itemName="Hand scroll" typeMenu="item" action_id="39457" />
			<Item itemName="Marquee add to notes/CC selection" typeMenu="item" action_id="39456" />
			<Item itemName="Marquee select notes/CC" typeMenu="item" action_id="39449" />
			<Item itemName="Marquee select notes/CC and time" typeMenu="item" action_id="39450" />
			<Item itemName="Marquee select notes/CC and time ignoring snap" typeMenu="item" action_id="39451" />
			<Item itemName="Marquee toggle note/CC selection" typeMenu="item" action_id="39455" />
			<Item itemName="Select notes touched while dragging" typeMenu="item" action_id="39459" />
			<Item itemName="Select time" typeMenu="item" action_id="39452" />
			<Item itemName="Select time ignoring snap" typeMenu="item" action_id="39453" />
			<Item itemName="Toggle selection for notes touched while dragging" typeMenu="item" action_id="39460" />
		</Item>

		<Item itemName="MIDI marker/region lanes left drag" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="25032" />
			<Item itemName="Hand scroll" typeMenu="item" action_id="25033" />
			<Item itemName="Hand scroll and horizontal zoom" typeMenu="item" action_id="25034" />
			<Item itemName="Hand scroll and reverse horizontal zoom (deprecated)" typeMenu="item" action_id="25035" />
			<Item itemName="Horizontal zoom" typeMenu="item" action_id="25036" />
			<Item itemName="Reverse horizontal zoom (deprecated)" typeMenu="item" action_id="25037" />
			<Item itemName="Set edit cursor and hand scroll" typeMenu="item" action_id="25040" />
			<Item itemName="Set edit cursor and horizontal zoom" typeMenu="item" action_id="25038" />
			<Item itemName="Set edit cursor and reverse horizontal zoom (deprecated)" typeMenu="item" action_id="25039" />
			<Item itemName="Set edit cursor, hand scroll and horizontal zoom" typeMenu="item" action_id="25041" />
			<Item itemName="Set edit cursor, hand scroll and reverse horizontal zoom (deprecated)" typeMenu="item" action_id="25042" />
		</Item>

		<Item itemName="MIDI note edge left drag" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39320" />
			<Item itemName="Move note edge" typeMenu="item" action_id="39321" />
			<Item itemName="Move note edge ignoring selection" typeMenu="item" action_id="39325" />
			<Item itemName="Move note edge ignoring snap" typeMenu="item" action_id="39322" />
			<Item itemName="Move note edge ignoring snap and selection" typeMenu="item" action_id="39326" />
			<Item itemName="Stretch notes" typeMenu="item" action_id="39323" />
			<Item itemName="Stretch notes ignoring snap" typeMenu="item" action_id="39324" />
		</Item>

		<Item itemName="MIDI note left click" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39672" />
			<Item itemName="Add a range of notes to selection" typeMenu="item" action_id="39677" />
			<Item itemName="Add a range of notes to selection and set time selection to selected notes" typeMenu="item" action_id="39691" />
			<Item itemName="Add all notes in measure to selection" typeMenu="item" action_id="39689" />
			<Item itemName="Add note and all later notes of same pitch to selection" typeMenu="item" action_id="39687" />
			<Item itemName="Add note and all later notes to selection" typeMenu="item" action_id="39685" />
			<Item itemName="Double note length" typeMenu="item" action_id="39682" />
			<Item itemName="Erase note" typeMenu="item" action_id="39678" />
			<Item itemName="Halve note length" typeMenu="item" action_id="39683" />
			<Item itemName="Select all notes in measure" typeMenu="item" action_id="39688" />
			<Item itemName="Select note" typeMenu="item" action_id="39673" />
			<Item itemName="Select note and all later notes" typeMenu="item" action_id="39684" />
			<Item itemName="Select note and all later notes of same pitch" typeMenu="item" action_id="39686" />
			<Item itemName="Select note and move edit cursor" typeMenu="item" action_id="39674" />
			<Item itemName="Select note and move edit cursor ignoring snap" typeMenu="item" action_id="39675" />
			<Item itemName="Set note channel higher" typeMenu="item" action_id="39680" />
			<Item itemName="Set note channel lower" typeMenu="item" action_id="39681" />
			<Item itemName="Toggle note mute" typeMenu="item" action_id="39679" />
			<Item itemName="Toggle note selection" typeMenu="item" action_id="39676" />
			<Item itemName="Toggle note selection and set time selection to selected notes" typeMenu="item" action_id="39690" />
		</Item>

		<Item itemName="MIDI note left drag" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39288" />
			<Item itemName="Copy note" typeMenu="item" action_id="39295" />
			<Item itemName="Copy note horizontally" typeMenu="item" action_id="39313" />
			<Item itemName="Copy note horizontally ignoring snap" typeMenu="item" action_id="39314" />
			<Item itemName="Copy note ignoring snap" typeMenu="item" action_id="39296" />
			<Item itemName="Copy note vertically" typeMenu="item" action_id="39315" />
			<Item itemName="Edit note velocity" typeMenu="item" action_id="39297" />
			<Item itemName="Edit note velocity (fine)" typeMenu="item" action_id="39298" />
			<Item itemName="Erase notes" typeMenu="item" action_id="39291" />
			<Item itemName="Marquee add to note selection" typeMenu="item" action_id="39305" />
			<Item itemName="Marquee select notes" typeMenu="item" action_id="39303" />
			<Item itemName="Marquee select notes and time" typeMenu="item" action_id="39306" />
			<Item itemName="Marquee select notes and time ignoring snap" typeMenu="item" action_id="39307" />
			<Item itemName="Marquee toggle note selection" typeMenu="item" action_id="39304" />
			<Item itemName="Move note" typeMenu="item" action_id="39289" />
			<Item itemName="Move note horizontally" typeMenu="item" action_id="39299" />
			<Item itemName="Move note horizontally ignoring snap" typeMenu="item" action_id="39300" />
			<Item itemName="Move note ignoring selection" typeMenu="item" action_id="39318" />
			<Item itemName="Move note ignoring snap" typeMenu="item" action_id="39290" />
			<Item itemName="Move note ignoring snap and selection" typeMenu="item" action_id="39319" />
			<Item itemName="Move note on one axis only" typeMenu="item" action_id="39293" />
			<Item itemName="Move note on one axis only ignoring snap" typeMenu="item" action_id="39294" />
			<Item itemName="Move note vertically" typeMenu="item" action_id="39301" />
			<Item itemName="Move note vertically ignoring scale/key" typeMenu="item" action_id="27289" />
			<Item itemName="Move note vertically ignoring scale/key" typeMenu="item" action_id="27288" />
			<Item itemName="Select notes touched while dragging" typeMenu="item" action_id="39316" />
			<Item itemName="Select time" typeMenu="item" action_id="39292" />
			<Item itemName="Select time ignoring snap" typeMenu="item" action_id="39302" />
			<Item itemName="Stretch note lengths (arpeggiate legato)" typeMenu="item" action_id="39312" />
			<Item itemName="Stretch note lengths ignoring snap (arpeggiate legato)" typeMenu="item" action_id="39311" />
			<Item itemName="Stretch note positions (arpeggiate)" typeMenu="item" action_id="39309" />
			<Item itemName="Stretch note positions ignoring snap (arpeggiate)" typeMenu="item" action_id="39308" />
			<Item itemName="Stretch note selection vertically (arpeggiate)" typeMenu="item" action_id="39310" />
			<Item itemName="Toggle selection for notes touched while dragging" typeMenu="item" action_id="39317" />
		</Item>

		<Item itemName="MIDI piano roll left click" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39704" />
			<Item itemName="Deselect all notes" typeMenu="item" action_id="39707" />
			<Item itemName="Deselect all notes and move edit cursor" typeMenu="item" action_id="39705" />
			<Item itemName="Deselect all notes and move edit cursor ignoring snap" typeMenu="item" action_id="39706" />
			<Item itemName="Insert note" typeMenu="item" action_id="39708" />
			<Item itemName="Insert note ignoring snap" typeMenu="item" action_id="39709" />
			<Item itemName="Insert note ignoring snap, leaving other notes selected" typeMenu="item" action_id="39713" />
			<Item itemName="Insert note, leaving other notes selected" typeMenu="item" action_id="39712" />
			<Item itemName="Set draw channel higher" typeMenu="item" action_id="39710" />
			<Item itemName="Set draw channel lower" typeMenu="item" action_id="39711" />
		</Item>

		<Item itemName="MIDI piano roll left drag" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39480" />
			<Item itemName="Copy selected notes" typeMenu="item" action_id="39507" />
			<Item itemName="Copy selected notes ignoring snap" typeMenu="item" action_id="39508" />
			<Item itemName="Erase notes" typeMenu="item" action_id="39483" />
			<Item itemName="Insert note" typeMenu="item" action_id="39511" />
			<Item itemName="Insert note ignoring scale/key, drag to extend or change pitch" typeMenu="item" action_id="27483" />
			<Item itemName="Insert note ignoring scale/key, drag to move" typeMenu="item" action_id="27481" />
			<Item itemName="Insert note ignoring snap" typeMenu="item" action_id="27480" />
			<Item itemName="Insert note ignoring snap and scale/key, drag to extend or change pitch" typeMenu="item" action_id="27484" />
			<Item itemName="Insert note ignoring snap and scale/key, drag to move" typeMenu="item" action_id="27482" />
			<Item itemName="Insert note ignoring snap, drag to edit velocity" typeMenu="item" action_id="39498" />
			<Item itemName="Insert note ignoring snap, drag to extend" typeMenu="item" action_id="39495" />
			<Item itemName="Insert note ignoring snap, drag to extend or change pitch" typeMenu="item" action_id="39482" />
			<Item itemName="Insert note ignoring snap, drag to move" typeMenu="item" action_id="39497" />
			<Item itemName="Insert note, drag to edit velocity" typeMenu="item" action_id="39499" />
			<Item itemName="Insert note, drag to extend" typeMenu="item" action_id="39494" />
			<Item itemName="Insert note, drag to extend or change pitch" typeMenu="item" action_id="39481" />
			<Item itemName="Insert note, drag to move" typeMenu="item" action_id="39492" />
			<Item itemName="Marquee add to note selection" typeMenu="item" action_id="39489" />
			<Item itemName="Marquee select notes" typeMenu="item" action_id="39487" />
			<Item itemName="Marquee select notes and time" typeMenu="item" action_id="39490" />
			<Item itemName="Marquee select notes and time ignoring snap" typeMenu="item" action_id="39491" />
			<Item itemName="Marquee toggle note selection" typeMenu="item" action_id="39488" />
			<Item itemName="Move selected notes" typeMenu="item" action_id="39509" />
			<Item itemName="Move selected notes ignoring snap" typeMenu="item" action_id="39510" />
			<Item itemName="Paint a row of notes of the same pitch" typeMenu="item" action_id="39493" />
			<Item itemName="Paint a stack of notes of the same time position" typeMenu="item" action_id="39500" />
			<Item itemName="Paint a straight line of notes" typeMenu="item" action_id="39503" />
			<Item itemName="Paint a straight line of notes ignoring snap" typeMenu="item" action_id="39504" />
			<Item itemName="Paint notes" typeMenu="item" action_id="39502" />
			<Item itemName="Paint notes and chords" typeMenu="item" action_id="39485" />
			<Item itemName="Paint notes ignoring snap" typeMenu="item" action_id="39501" />
			<Item itemName="Scrub preview MIDI" typeMenu="item" action_id="39496" />
			<Item itemName="Select notes touched while dragging" typeMenu="item" action_id="39505" />
			<Item itemName="Select time" typeMenu="item" action_id="39484" />
			<Item itemName="Select time ignoring snap" typeMenu="item" action_id="39486" />
			<Item itemName="Toggle selection for notes touched while dragging" typeMenu="item" action_id="39506" />
		</Item>

		<Item itemName="MIDI ruler left click" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39640" />
			<Item itemName="Clear loop or time selection" typeMenu="item" action_id="39644" />
			<Item itemName="Move edit cursor" typeMenu="item" action_id="39641" />
			<Item itemName="Move edit cursor ignoring snap" typeMenu="item" action_id="39642" />
			<Item itemName="Select notes or CC in time selection" typeMenu="item" action_id="39643" />
		</Item>

		<Item itemName="MIDI ruler left drag" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39416" />
			<Item itemName="Edit loop point (ruler) or time selection (piano roll)" typeMenu="item" action_id="39417" />
			<Item itemName="Edit loop point (ruler) or time selection (piano roll) ignoring snap" typeMenu="item" action_id="39418" />
			<Item itemName="Edit loop point and time selection together" typeMenu="item" action_id="39421" />
			<Item itemName="Edit loop point and time selection together ignoring snap" typeMenu="item" action_id="39422" />
			<Item itemName="Move loop points (ruler) or time selection (piano roll)" typeMenu="item" action_id="39419" />
			<Item itemName="Move loop points (ruler) or time selection (piano roll) ignoring snap" typeMenu="item" action_id="39420" />
			<Item itemName="Move loop points and time selection together" typeMenu="item" action_id="39423" />
			<Item itemName="Move loop points and time selection together ignoring snap" typeMenu="item" action_id="39424" />
		</Item>

		<Item itemName="MIDI source loop end marker left drag" typeMenu="subMenu">
			<Item itemName="No action" typeMenu="item" action_id="39960" />
			<Item itemName="Edit MIDI source loop length" typeMenu="item" action_id="39961" />
			<Item itemName="Edit MIDI source loop length ignoring snap" typeMenu="item" action_id="39962" />
			<Item itemName="Stretch MIDI source loop length" typeMenu="item" action_id="39963" />
			<Item itemName="Stretch MIDI source loop length ignoring snap" typeMenu="item" action_id="39964" />
		</Item>
		
	</Item>
	<!-- Mouse Modifier -->
	
	<!-- Настройки -->
	<Item itemName="" typeMenu="separator" />
	<Item itemName="--- Настройки ---" typeMenu="subMenu">
		<Item itemName="Удалить файл кэша" typeMenu="item" action_id="delete_cache" />
		<Item itemName="Окрыть XML" typeMenu="item" action_id="open_in_notepadpp" />
	</Item>
	<Item itemName="Выбрать другое меню" typeMenu="subMenu">
		<Item itemName="MIDI Editor" typeMenu="item" switchMenu="MenuPopupMidiEditorMain.xml" />
		<Item itemName="Insert Chord" typeMenu="item" switchMenu="MenuPopupMidiEditorInsertChord.xml" />
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
					if show_fx and reaper.CountSelectedTracks(0) == 1 and reaper.TrackFX_GetOffline(track, fx_index) == false and add_to_master == false then
						reaper.TrackFX_Show(track, fx_index, 3)
					end
				end
			end
			insert_string = "to selected tracks"
		end
	elseif (add_fx_to_track == false and add_fx_to_item == true) or (add_fx_to_track == true and add_fx_to_item == true and cursor == 1) then
		if reaper.CountSelectedMediaItems(0) > 0 then
			for i = 0, reaper.CountSelectedMediaItems(0) - 1 do
				local item = reaper.GetSelectedMediaItem(0, i)
				local take = reaper.GetActiveTake(item)
				local fx_index = reaper.TakeFX_AddByName(take, name, -1)
				if fx_index ~= -1 then
					if preset_name then
						reaper.TakeFX_SetPreset(take, fx_index, preset_name)
					end
					if show_fx and reaper.CountSelectedMediaItems(0) == 1 and reaper.TakeFX_GetOffline(take, fx_index) == false then
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
-- deselect_all_notes
-- Функция для снятия выделения со всех нот
function deselect_all_notes()
	-- Получаем активный MIDI-элемент
	local take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
	if take == nil then return end
	-- Обходим все ноты
	local note_index = -1
	while true do
		note_index = reaper.MIDI_EnumSelNotes(take, note_index)
		if note_index == -1 then break end

		local retval, selected, muted, startppqpos, endppqpos, chan, pitch, velocity = reaper.MIDI_GetNote(take, note_index)
		if retval then
			reaper.MIDI_SetNote(take, note_index, false, muted, startppqpos, endppqpos, chan, pitch, velocity, true)
		end
	end
	-- Включаем режим сортировки обратно
	reaper.MIDI_Sort(take)
end
-- Функция для снятия выделения со всех нот
-- #####################################################
-- #####################################################
-- set_selected_notes_velocity
-- Функция для установки велосити выделенных нот
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
-- Функция для установки велосити выделенных нот
-- #####################################################
-- #####################################################
-- midi_to_note_name
-- Функция для конвертации MIDI номера в ноту
function midi_to_note_name(midi_num)
	local notes = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}
	local note = notes[(midi_num % 12) + 1]
	local octave = math.floor(midi_num / 12) - 1
	return note .. octave
end
-- Функция для конвертации MIDI номера в ноту
-- #####################################################
-- #####################################################
-- get_chords_and_notes_in_selection
-- Выделенные ноты найдены, скрипт обрабатывает их, иначе он обрабатывает выделенный временной интервал
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
-- Выделенные ноты найдены, скрипт обрабатывает их, иначе он обрабатывает выделенный временной интервал
-- #####################################################
-- #####################################################
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
-- Функция для получения выделенных нот
-- #####################################################
-- #####################################################
-- createMenuString_Old
-- Функция для создания строки меню из таблицы и сохранения действий
function createMenuString_Old(tbl, actions)
	local menuString = ""

	if tbl then
		for index, item in ipairs(tbl.children) do
			item.itemName = decodeMnemonics(item.itemName)
			if item.typeMenu == "subMenu" then
				menuString = menuString .. ">" .. item.itemName .. "|"
				menuString = menuString .. createMenuString(item, actions)
				menuString = menuString .. "<|"
			elseif item.typeMenu == "item" then
				if item.action_id then
					if item.action_id == "disabled_item" then
						item.itemName = "#" .. item.itemName
					else
						local commandId = reaper.NamedCommandLookup(item.action_id)
						if commandId > 0 then
							local commandState = reaper.GetToggleCommandStateEx(0, commandId)
							if commandState == 1 then
								item.itemName = "!" .. item.itemName
							end
						end
					end
				end

				-- Подсвечивание текущих настроек
				if item.note_length and item.note_length == reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "NoteLengthGlobal") then
					item.itemName = "!" .. item.itemName
				elseif item.chord_transpose and tonumber(item.chord_transpose) == tonumber(reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "ChordTransposeGlobal")) then
					item.itemName = "!" .. item.itemName
				elseif item.insert_chord_settings and item.insert_chord_settings == "cursor_start_end" then
					local cursor_value = reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "CursorStartOrEndNoteGlobal")
					if cursor_value == "1" then
						item.itemName = "!" .. item.itemName
					end
				elseif item.insert_chord_settings and item.insert_chord_settings == "select_unselect_all_note" then
					local SelectUnselectAllNote = reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "SelectUnselectAllNoteGlobal")
					if SelectUnselectAllNote == "1" then
						item.itemName = "!" .. item.itemName
					end
				elseif item.notes_velocity and tonumber(item.notes_velocity) == tonumber(reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "NotesVelocityGlobal")) then
					item.itemName = "!" .. item.itemName
				elseif item.switchMenu and item.switchMenu == reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMidiEditorGlobal") then
					item.itemName = "!" .. item.itemName
				end

				menuString = menuString .. item.itemName .. "|"
				
				table.insert(actions, {
					action_id = item.action_id,
					add_fx = item.add_fx,
					preset_name = item.preset_name,
					insert_chord = item.insert_chord,
					note_length = item.note_length,
					chord_transpose = item.chord_transpose,
					insert_chord_settings = item.insert_chord_settings,
					notes_velocity = item.notes_velocity,
					switchMenu = item.switchMenu,
				})
			elseif item.typeMenu == "separator" then
				menuString = menuString .. "|"
			end
		end
	end

	return menuString
end
-- Функция для создания строки меню из таблицы и сохранения действий
-- #####################################################
-- #####################################################
-- isItemActive
-- Функция для проверки, активен ли элемент меню
local function isItemActive(item)
	if item.action_id then
		if item.action_id == "disabled_item" then
			return false
		end
		local commandId = reaper.NamedCommandLookup(item.action_id)
		if commandId and commandId > 0 then
			local commandState = reaper.GetToggleCommandStateEx(0, commandId)
			if commandState == 1 then
				return true
			end
		end
	end
	if item.note_length and item.note_length == reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "NoteLengthGlobal") then
		return true
	elseif item.chord_transpose and tonumber(item.chord_transpose) == tonumber(reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "ChordTransposeGlobal")) then
		return true
	elseif item.insert_chord_settings and item.insert_chord_settings == "cursor_start_end" then
		local cursor_value = reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "CursorStartOrEndNoteGlobal")
		if cursor_value == "1" then
			return true
		end
	elseif item.insert_chord_settings and item.insert_chord_settings == "select_unselect_all_note" then
		local SelectUnselectAllNote = reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "SelectUnselectAllNoteGlobal")
		if SelectUnselectAllNote == "1" then
			return true
		end
	elseif item.notes_velocity and tonumber(item.notes_velocity) == tonumber(reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "NotesVelocityGlobal")) then
		return true
	elseif item.switchMenu and item.switchMenu == reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMidiEditorGlobal") then
		return true
	end
	return false
end
-- Функция для проверки, активен ли элемент меню
-- #####################################################
-- #####################################################
-- isSubMenuActive
-- Функция для проверки, активен ли подменю
local function isSubMenuActive(subMenu)
	for _, item in ipairs(subMenu.children) do
		if item.typeMenu == "subMenu" then
			if isSubMenuActive(item) then
				return true
			end
		elseif item.typeMenu == "item" then
			if isItemActive(item) then
				return true
			end
		end
	end
	return false
end
-- Функция для проверки, активен ли подменю
-- #####################################################
-- #####################################################
-- createMenuString
-- Функция для создания строки меню из таблицы и сохранения действий
function createMenuString(tbl, actions)
	local menuString = ""

	if tbl then
		for _, item in ipairs(tbl.children) do
			item.itemName = decodeMnemonics(item.itemName)

			if item.typeMenu == "subMenu" then
				local subMenuActive = isSubMenuActive(item)
				if subMenuActive then
					item.itemName = "!" .. item.itemName
				end
				menuString = menuString .. ">" .. item.itemName .. "|"
				local subMenuString = createMenuString(item, actions)
				menuString = menuString .. subMenuString
				menuString = menuString .. "<|"
			elseif item.typeMenu == "item" then
				if item.action_id then
					if item.action_id == "disabled_item" then
						item.itemName = "#" .. item.itemName
					elseif isItemActive(item) then
						item.itemName = "!" .. item.itemName
					end
				elseif isItemActive(item) then
					item.itemName = "!" .. item.itemName
				end

				menuString = menuString .. item.itemName .. "|"
				
				table.insert(actions, {
					action_id = item.action_id,
					add_fx = item.add_fx,
					preset_name = item.preset_name,
					insert_chord = item.insert_chord,
					note_length = item.note_length,
					chord_transpose = item.chord_transpose,
					insert_chord_settings = item.insert_chord_settings,
					notes_velocity = item.notes_velocity,
					action_function = item.action_function,
					switchMenu = item.switchMenu,
				})
			elseif item.typeMenu == "separator" then
				menuString = menuString .. "|"
			end
		end
	end

	return menuString
end
-- Функция для создания строки меню из таблицы и сохранения действий
-- #####################################################
-- #####################################################
-- parseAttributes
-- Функция для парсинга атрибутов из строки
function parseAttributes(attrs)
	local attributes = {}
	for key, value in string.gmatch(attrs, '([%w_]+)="([^"]*)"') do
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
function buildLuaTable(node)
	local result = {
		itemName = node.attrs.itemName,
		typeMenu = node.attrs.typeMenu,
		action_id = node.attrs.action_id,
		add_fx = node.attrs.add_fx,
		preset_name = node.attrs.preset_name,
		insert_chord = node.attrs.insert_chord,
		note_length = node.attrs.note_length,
		insert_chord_settings = node.attrs.insert_chord_settings,
		select_unselect_all_note = node.attrs.select_unselect_all_note,
		chord_transpose = node.attrs.chord_transpose,
		get_selected_notes_to_str = node.attrs.get_selected_notes_to_str,
		get_chords_and_notes_in_selection = node.attrs.get_chords_and_notes_in_selection,
		notes_velocity = node.attrs.notes_velocity,
		action_function = node.attrs.action_function,
		switchMenu = node.attrs.switchMenu,
		children = {}
	}
	for _, child in ipairs(node.children) do
		if type(child) == "table" then
			table.insert(result.children, buildLuaTable(child))
		end
	end
	return result
end
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
-- openFileInNotepadPP
function openFileInNotepadPP(filePath)
    local command = '"' .. notepadPPPath .. '" "' .. filePath .. '"'
    -- os.execute(command)
    reaper.ExecProcess(command, -2)
end
-- #####################################################
-- #####################################################
-- note_to_midi
-- Функция для конвертации ноты в MIDI-значение
function note_to_midi(note)
    local notes = {C = 0, ["C#"] = 1, D = 2, ["D#"] = 3, E = 4, F = 5, ["F#"] = 6, G = 7, ["G#"] = 8, A = 9, ["A#"] = 10, B = 11}
    local octave = tonumber(note:sub(-1))
    local key = note:sub(1, -2)
    return (octave + 1) * 12 + notes[key]
end
-- Функция для конвертации ноты в MIDI-значение
-- #####################################################
-- #####################################################
-- duration_to_ppq
-- Функция для конвертации длительности в PPQ
function duration_to_ppq(duration)
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
-- Функция для конвертации длительности в PPQ
-- #####################################################
-- #####################################################
-- setGlobalChordTranspose
-- Функция для установки глобального транспонирования аккорда и получения текущего значения
function setGlobalChordTranspose(selectedAction)
    if selectedAction.chord_transpose then
        reaper.SetExtState("MaxMusicMax_PopupMenuGlobal", "ChordTransposeGlobal", tostring(selectedAction.chord_transpose), true)
    end
    return tonumber(reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "ChordTransposeGlobal")) or 0
end
-- #####################################################
-- #####################################################
-- setFocusToMidiEditor
function setFocusToMidiEditor()
    local midi_editor = reaper.MIDIEditor_GetActive()
    if midi_editor then
        reaper.JS_Window_SetFocus(midi_editor)
    end
end
-- #####################################################
-- #####################################################
-- insert_chord
-- Функция для вставки аккорда
function insert_chord(chord_str)
    local state_section = "MaxMusicMax_PopupMenuGlobal"
    local length_key = "NoteLengthGlobal"
    local transpose_key = "ChordTransposeGlobal"
    local velocity_key = "NotesVelocityGlobal"

    local transpose = tonumber(reaper.GetExtState(state_section, transpose_key)) or 0
    local notes_velocity = tonumber(reaper.GetExtState(state_section, velocity_key)) or 96
    local take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
    if take == nil then return end

    reaper.MIDI_DisableSort(take)
    local cursor_pos = reaper.GetCursorPosition()

    local default_duration = reaper.GetExtState(state_section, length_key)
    local global_duration = default_duration

    local gnl_match = string.match(chord_str, "%[gnl=([%d/]+)%]")
    if gnl_match then
        global_duration = gnl_match
        chord_str = string.gsub(chord_str, "%[gnl=[%d/]+%]", "")
    end

    for part in string.gmatch(chord_str, "[^|]+") do
        local combined_durations = 0
        for duration_part in string.gmatch(part, "nl=([%d/]+)") do
            combined_durations = combined_durations + (duration_to_ppq(duration_part) or 0)
        end

        local duration = (combined_durations > 0 and combined_durations) or duration_to_ppq(global_duration)
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

    reaper.MIDI_Sort(take)
    reaper.UpdateArrange()
end
-- #####################################################
-- #####################################################
-- handleMenuSelection
-- Обработка выбора пункта меню
local function handleMenuSelection (selectedAction)
	local proj = reaper.EnumProjects(-1, "")
	reaper.Undo_BeginBlock2(proj)  -- Отключаем основную систему отмены действий
	
	local midi_editor = reaper.MIDIEditor_GetActive()
	
	-- action_id ——————————————————————————————
	if selectedAction.action_id then
		if selectedAction.action_id == "delete_cache" then
			os.remove(txtFilePath)
		elseif selectedAction.action_id == "open_in_notepadpp" then
			if reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMidiEditorGlobal") ~= "" then
				openFileInNotepadPP ( reaper.GetResourcePath():gsub('\\', '/') .. folderPath .. reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMidiEditorGlobal") )
			else
				openFileInNotepadPP(xmlFilePath)
			end
		else
			
			if midi_editor then
				reaper.MIDIEditor_LastFocused_OnCommand(reaper.NamedCommandLookup(selectedAction.action_id), 0)
				reaper.JS_Window_SetFocus(midi_editor)
			else
				reaper.Main_OnCommand(reaper.NamedCommandLookup(selectedAction.action_id), 0)
			end
		end
		
	elseif selectedAction.action_function then
		local return_function_action = load(selectedAction.action_function)
		if return_function_action then
			return_function_action()
		else
			print_rs ( selectedAction.action_function )
		end
	-- add_fx ——————————————————————————————
	elseif selectedAction.add_fx then
		Add_FX(selectedAction.add_fx, selectedAction.preset_name)
	
	-- insert_chord_settings ——————————————————————————————
	elseif selectedAction.insert_chord_settings  then
		
		-- Установить курсор в начало или конец ноты — Запись состояния
		if selectedAction.insert_chord_settings == "cursor_start_end" then
			-- Записываем значение 0 или 1 в зависимости от текущего состояния
			local current_value = reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "CursorStartOrEndNoteGlobal")
			local new_value = (current_value == "1" and "0") or "1"
			reaper.SetExtState("MaxMusicMax_PopupMenuGlobal", "CursorStartOrEndNoteGlobal", new_value, true)
		end
		-- Установить курсор в начало или конец ноты — Запись состояния
		
		-- Снять выделение со всех нот — Запись состояния
		if selectedAction.insert_chord_settings == "select_unselect_all_note" then
			-- Записываем значение 0 или 1 в зависимости от текущего состояния
			local SelectUnselectAllNote_CurrentValue = reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "SelectUnselectAllNoteGlobal")
			local SelectUnselectAllNote_NewValue = (SelectUnselectAllNote_CurrentValue == "1" and "0") or "1"
			reaper.SetExtState("MaxMusicMax_PopupMenuGlobal", "SelectUnselectAllNoteGlobal", SelectUnselectAllNote_NewValue, true)
		end
		-- Снять выделение со всех нот — Запись состояния
		
		-- Получить строку выделеных нот
		if selectedAction.insert_chord_settings == "get_selected_notes_to_str" then
			local selected_notes_str = get_selected_notes_to_str()
			print_rs(selected_notes_str)
		end
		-- Получить строку выделеных нот
		
		-- Получить выделенные ноты или временной интервал
		if selectedAction.insert_chord_settings == "get_chords_and_notes_in_selection" then
			local get_chords_and_notes_in_selection = get_chords_and_notes_in_selection()
			print_rs(get_chords_and_notes_in_selection)
		end
		-- Получить выделенные ноты или временной интервал
		
	-- insert_chord ——————————————————————————————
	elseif selectedAction.insert_chord then
		
		-- Создаем блок Undo для MIDI-редактора
		local take = reaper.MIDIEditor_GetTake(midi_editor)
		reaper.Undo_OnStateChange_Item(0, "MIDI Editor Block Start", reaper.GetMediaItemTake_Item(take))
		
		-- insert_chord
		insert_chord(selectedAction.insert_chord)
		
		-- Установить курсор в начало или конец ноты — Чтение состояния
		local CursorStartOrEnd = reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "CursorStartOrEndNoteGlobal")
		if CursorStartOrEnd == "0" then
			reaper.MIDIEditor_LastFocused_OnCommand(reaper.NamedCommandLookup(40440), 0) -- Navigate: Move edit cursor to start of selected events
		else
			reaper.MIDIEditor_LastFocused_OnCommand(reaper.NamedCommandLookup(40639), 0) -- Navigate: Move edit cursor to end of selected events
		end
		-- Установить курсор в начало или конец ноты — Чтение состояния
		
		-- Снять выделение со всех нот — Чтение состояния
		local SelectUnselectAllNote = reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "SelectUnselectAllNoteGlobal")
		if SelectUnselectAllNote == "1" then
			deselect_all_notes ()
		else
		end
		-- Снять выделение со всех нот — Чтение состояния
		
		-- Завершаем блок Undo для MIDI-редактора
		reaper.Undo_OnStateChange_Item(0, "MIDI Editor Block End", reaper.GetMediaItemTake_Item(take))
		
	-- note_length ——————————————————————————————
	elseif selectedAction.note_length then
		reaper.SetExtState("MaxMusicMax_PopupMenuGlobal", "NoteLengthGlobal", tostring(selectedAction.note_length), true)
		
	-- chord_transpose ——————————————————————————————
	elseif selectedAction.chord_transpose then
		setGlobalChordTranspose(selectedAction)
		
	-- notes_velocity ——————————————————————————————
	elseif selectedAction.notes_velocity then
		reaper.SetExtState("MaxMusicMax_PopupMenuGlobal", "NotesVelocityGlobal", tostring(selectedAction.notes_velocity), true)
		
	-- switchMenu ——————————————————————————————
	elseif selectedAction.switchMenu then
		-- reaper.DeleteExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMidiEditorGlobal", true)
		reaper.SetExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMidiEditorGlobal", selectedAction.switchMenu, true)
		os.remove(txtFilePath)
		
	end
	
	reaper.Undo_EndBlock2(proj, "Обработка выбора пункта меню", -1)  -- Включаем основную систему отмены действий обратно
	
	gfx.quit()
	setFocusToMidiEditor()
	
end
-- Обработка выбора пункта меню
-- #####################################################
-- #####################################################
-- showMenu
function showMenu()
	-- Установка значений по умолчанию при первом запуске
	-- reaper.DeleteExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMidiEditorGlobal", true)
	if reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMidiEditorGlobal") == "" then
		reaper.SetExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMidiEditorGlobal", xmlFileName, true)
	end
	
	if reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "SelectUnselectAllNoteGlobal") == "" then
		reaper.SetExtState("MaxMusicMax_PopupMenuGlobal", "SelectUnselectAllNoteGlobal", "1", true)
	end
	
	if reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "CursorStartOrEndNoteGlobal") == "" then
		reaper.SetExtState("MaxMusicMax_PopupMenuGlobal", "CursorStartOrEndNoteGlobal", "1", true)
	end
	
	if reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "ChordTransposeGlobal") == "" then
		reaper.SetExtState("MaxMusicMax_PopupMenuGlobal", "ChordTransposeGlobal", "0", true)
	end

	if reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "NoteLengthGlobal") == "" then
		reaper.SetExtState("MaxMusicMax_PopupMenuGlobal", "NoteLengthGlobal", "1/2", true)
	end
	
	if reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "NotesVelocityGlobal") == "" then
        reaper.SetExtState("MaxMusicMax_PopupMenuGlobal", "NotesVelocityGlobal", "96", true)
    end
	
	local luaTable
	if reaper.file_exists(txtFilePath) then
		luaTable = loadTableFromFile(txtFilePath)
		
	elseif reaper.file_exists(xmlFilePath) then
		local title = reaper.JS_Localize('ReaScript console output', "common")
		local hwnd = reaper.JS_Window_Find(title, true)
		if hwnd then reaper.JS_Window_Destroy(hwnd) end
		
		local currentMenu = reaper.GetExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMidiEditorGlobal")
		if currentMenu ~= xmlFileName then
			if reaper.file_exists( reaper.GetResourcePath():gsub('\\', '/') .. folderPath .. currentMenu ) then -- Проверка существования XML файла
				xmlFilePath = reaper.GetResourcePath():gsub('\\', '/') .. folderPath .. currentMenu
			else
				xmlFilePath = reaper.GetResourcePath():gsub('\\', '/') .. folderPath .. xmlFileName
				reaper.SetExtState("MaxMusicMax_PopupMenuGlobal", "CurrentMenuMidiEditorGlobal", xmlFileName, true)
				os.remove(txtFilePath)
			end
		end
		
		local file = io.open(xmlFilePath, "r")
		local xml = file:read("*all")
		file:close()
		local parsedXML = parseXML(xml)
		luaTable = buildLuaTable(parsedXML)

		saveTableToFile(luaTable, txtFilePath)
	else
		local title = reaper.JS_Localize('ReaScript console output', "common")
		local hwnd = reaper.JS_Window_Find(title, true)
		if hwnd then reaper.JS_Window_Destroy(hwnd) end

		local ret = reaper.ShowMessageBox("Не найдено ни одной таблицы меню.\n\nВ настройках скрипта укажите правильный путь к XML-файлу или создайте новый XML-файл по умолчанию.\n\nСоздать новый XML-файл по умолчанию ?", "Ошибка", 1)

		if ret == 1 then
			createDefaultXML(xmlFilePath)
			local ret = reaper.ShowMessageBox("XML-файл по умолчанию успешно создан, вызовите ещё раз скрипт и вы увидите меню по умолчанию", "Ошибка", 0)
		else
			return
		end
	end

	local actions = {}
	local menuString = createMenuString(luaTable, actions)

	local x_mouse, y_mouse = reaper.GetMousePosition()

	-- gfx.init(header_name, menu_header_width_x, menu_header_width_y, 0, x_mouse + menu_header_position_x, y_mouse + menu_header_position_y)
	
	local title = "PopupMenu" -- .. reaper.genGuid()
	gfx.init( title, 0, 0, 0, 0, 0 )
	
	local hwnd = reaper.JS_Window_Find( title, true )
	local opacity = 0.0 -- Установите значение прозрачности 0.0 - полностью прозрачно, 1.0 - полностью непрозрачно
	
	if hwnd then
		reaper.JS_Window_Show( hwnd, "HIDE" )
		reaper.JS_Window_SetOpacity(hwnd, "ALPHA", opacity)
	end
	
	gfx.x, gfx.y = gfx.mouse_x-menu_header_position_x, gfx.mouse_y-menu_header_position_y

	if show_window_header == false then
		-- gfx.x, gfx.y = gfx.mouse_x + menu_header_position_x, gfx.mouse_y + menu_header_position_y
	end
	
	local selection = gfx.showmenu(menuString)
	if selection > 0 then
		local selectedAction = actions[selection]
		if selectedAction then
			handleMenuSelection(selectedAction)
		end
	end
	gfx.quit()
	
end
-- #####################################################
-- #####################################################
reaper.defer(showMenu)
-- #####################################################
-- #####################################################
reaper.PreventUIRefresh(-1)
reaper.TrackList_AdjustWindows(0)  -- Updates the window view
reaper.UpdateArrange()  -- Updates the window view