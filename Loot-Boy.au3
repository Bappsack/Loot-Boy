#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\Downloads\favicon (4).ico
#AutoIt3Wrapper_Outfile_x64=Loot-Boy.exe
#AutoIt3Wrapper_Res_Comment=a GTMP Bot for Farming Ressources
#AutoIt3Wrapper_Res_Description=Loot Boy
#AutoIt3Wrapper_Res_Fileversion=2.6.0.0
#AutoIt3Wrapper_Res_LegalCopyright=(c) Chris White
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;
#include <Misc.au3>
#include <Date.au3>
#include <GuiRichEdit.au3>
#include <PostMessage.au3>
#include <KeyCodes.au3>
#include <InetConstants.au3>
#include <ImageSearch.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

; Close Updater and delete file.
ProcessClose("cmd.exe")
FileDelete(@ScriptDir & "\update.bat")

; Version Check

Global $Version = "3.0"
Global $WorkingDir = @ScriptDir & "\"

$Check_Version = BinaryToString(InetRead("https://raw.githubusercontent.com/Mitsukiii/Loot-Boy/master/Assets/Update/Version.txt", 1))
$Changelog = BinaryToString(InetRead("https://raw.githubusercontent.com/Mitsukiii/Loot-Boy/master/Assets/Update/Changelog.txt", 1))
If $Version < $Check_Version Then
	MsgBox(0, "Changelog", "New Version Released: " & $Check_Version & @CRLF & @CRLF & "Changelog: " & @CRLF & $Changelog)
	InetGet("https://raw.githubusercontent.com/Mitsukiii/Loot-Boy/master/Assets/Update/Loot-Boy.exe", $WorkingDir & "latest.exe", 1, 0)
	FileWrite($WorkingDir & "update.bat", "@echo off" & @CRLF & "DEL " & @ScriptName & @CRLF & "REN latest.exe " & @ScriptName & @CRLF & @ScriptName & @CRLF & "DEL update.bat")
	Run($WorkingDir & "update.bat /s /q")
	Exit
EndIf

; Program Duplicate Runtime Check

If WinExists("Loot Boy ") Then
	MsgBox(48, "Error", "Program is already open!")
	Exit 0
EndIf

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Loot Boy [" & $Version & "]", 397, 438, 192, 124)
$Group1 = GUICtrlCreateGroup("Loot Mode", 256, 0, 137, 129)
$Radio1 = GUICtrlCreateRadio("Oranges", 264, 24, 60, 17)
$Radio2 = GUICtrlCreateRadio("Stones", 264, 48, 60, 17)
$Radio3 = GUICtrlCreateRadio("Wheat", 264, 72, 60, 17)
$Radio4 = GUICtrlCreateRadio("Tomatoes", 264, 96, 65, 17)
$Radio5 = GUICtrlCreateRadio("Iron", 336, 72, 60, 17)
$Radio6 = GUICtrlCreateRadio("Wood", 336, 24, 60, 17)
$Radio7 = GUICtrlCreateRadio("Sand", 336, 48, 60, 17)
$Radio8 = GUICtrlCreateRadio("Gold", 336, 96, 60, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Loot Settings", 8, 0, 241, 129)
$Label1 = GUICtrlCreateLabel("Custom Delay after Loot:", 16, 24, 149, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Input1 = GUICtrlCreateInput("500", 168, 24, 33, 21)
$Input2 = GUICtrlCreateInput("1000", 208, 24, 33, 21)
$Label2 = GUICtrlCreateLabel("Put in Truck after X Loots:", 16, 48, 152, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Input3 = GUICtrlCreateInput("12", 168, 48, 73, 21)
$Label3 = GUICtrlCreateLabel("Loot Slot:", 16, 72, 59, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Combo1 = GUICtrlCreateCombo("4", 168, 72, 73, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
$Progress1 = GUICtrlCreateProgress(16, 104, 222, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("Log", 8, 128, 385, 297)
$Edit1 = GUICtrlCreateEdit("", 16, 144, 369, 273)
GUICtrlSetData(-1, "Edit1")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
GUICtrlSetData($Combo1, "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|AUTO")
GUICtrlSetData($Edit1, "GTMP Loot Boy v." & $Version & " Ready!" & @CRLF & "NUM5 - Start" & @CRLF & "F9 - Pause" & @CRLF & "F11 - Quit" & @CRLF & @CRLF & "Please use a Game Resolution of 1920x1080 and " & @CRLF & " Fullscreen without Border or it might not work." & @CRLF)
#EndRegion ### END Koda GUI section ###

; Load Settings

_LoadSettings()

HotKeySet("{F11}", "_Panic")
HotKeySet("{F9}", "_idle")
HotKeySet("{NUMPAD5}", "_start")

Opt("WinTitleMatchMode", 4)
Opt("MouseClickDelay", 1)
Opt("MouseCoordMode", 1)

Global $Stop = False
Global $FREEInvSlots = 100
Global $Count = 1
Global $Sleeper = 5000
Global $Time = _NowTime()
Global $LootAmount = 0
Global $LootSlot = 0
Global $CustomDelay1 = 1
Global $CustomDelay2 = 2
Global $Mats = 0
Global $BotMode = 0
Global $BucketSize = 0
Global $InventorySize = 0
Global $Gamename = "Grand Theft Multiplayer"
Global $Mode = 0
Global $x = 0, $y = 0
Global $Inventory_Slots_X = [0, 150, 270, 390, 510, 630, 750, 870, 170, 290, 410, 530, 650, 770, 790, 160, 280, 400, 520, 640, 760, 880]
Global $Inventory_Slots_Y = [0, 284, 280, 280, 280, 280, 280, 280, 400, 400, 400, 400, 400, 400, 400, 500, 500, 500, 500, 500, 500, 500]

Global $Item = [0, 0]

_idle()

Func _start()
	If GUICtrlRead($Radio1) = $GUI_CHECKED Then ; Oranges
		_farm_oranges()
	ElseIf GUICtrlRead($Radio2) = $GUI_CHECKED Then ; Stones
		_farm_stones()
	ElseIf GUICtrlRead($Radio3) = $GUI_CHECKED Then ; Wheat
		_farm_wheat()
	ElseIf GUICtrlRead($Radio4) = $GUI_CHECKED Then ; Tomatoes
		_farm_Tomatoes()
	ElseIf GUICtrlRead($Radio5) = $GUI_CHECKED Then ; Iron // Doubt its possible via PostMessage :/
		UpdateLog("Not included yet!")
	ElseIf GUICtrlRead($Radio6) = $GUI_CHECKED Then ; Wood
		UpdateLog("Not included yet!")
	ElseIf GUICtrlRead($Radio7) = $GUI_CHECKED Then ; Sand
		_farm_Sand()
	ElseIf GUICtrlRead($Radio8) = $GUI_CHECKED Then ; Gold
		_farm_gold()

	Else
		UpdateLog("No Mode Selected!")

	EndIf

EndFunc   ;==>_start

Func _GetLootSlot()
	$Item[0] = 0
	$Item[1] = 0
	If $Mode = 1 Then
		$Itemslot = _ImageSearchArea(@AppDataDir & "\LootBoy\Assets\Orange.bmp", 1, 105, 228, 949, 655, $x, $y, 100)
		If $Itemslot = 1 Then

			$Item[0] = $x
			$Item[1] = $y
			UpdateLog("Oranges Detected at: " & $x & "," & $y & " !")
			Return $Item
		Else
			Return False
		EndIf
	ElseIf $Mode = 2 Then
		$Itemslot = _ImageSearchArea(@AppDataDir & "\LootBoy\Assets\Stone.bmp", 1, 105, 228, 949, 655, $x, $y, 150)
		If $Itemslot = 1 Then
			$Item[0] = $x
			$Item[1] = $y
			UpdateLog("Stones Detected at: " & $x & "," & $y & " !")
			Return $Item
		Else
			Return False
		EndIf
	ElseIf $Mode = 3 Then
		$Itemslot = _ImageSearchArea(@AppDataDir & "\LootBoy\Assets\Wheat.bmp", 1, 105, 228, 949, 655, $x, $y, 100)
		If $Itemslot = 1 Then
			$Item[0] = $x
			$Item[1] = $y
			UpdateLog("Wheat Detected at: " & $x & "," & $y & " !")
			Return $Item
		Else
			Return False
		EndIf

	ElseIf $Mode = 4 Then
		$Itemslot = _ImageSearchArea(@AppDataDir & "\LootBoy\Assets\Tomatoes.bmp", 1, 105, 228, 949, 655, $x, $y, 100)
		If $Itemslot = 1 Then
			$Item[0] = $x
			$Item[1] = $y
			UpdateLog("Tomatoes Detected at: " & $x & "," & $y & " !")
			Return $Item
		Else
			Return False
		EndIf

		#csElseif $Mode = 5 Then

			; Iron Farm Mode, not included yet.


		#ceElseif $Mode = 5 Then

	ElseIf $Mode = 6 Then
		$Itemslot = _ImageSearchArea(@AppDataDir & "\LootBoy\Assets\Wood.bmp", 1, 105, 228, 949, 655, $x, $y, 100)
		If $Itemslot = 1 Then
			$Item[0] = $x
			$Item[1] = $y
			UpdateLog("Wood Detected at: " & $x & "," & $y & " !")
			Return $Item
		Else
			Return False
		EndIf

	ElseIf $Mode = 7 Then
		$Itemslot = _ImageSearchArea(@AppDataDir & "\LootBoy\Assets\Wood.bmp", 1, 105, 228, 949, 655, $x, $y, 100)
		If $Itemslot = 1 Then
			$Item[0] = $x
			$Item[1] = $y
			UpdateLog("Tomatoes Detected at: " & $x & "," & $y & " !")
			Return $Item
		Else
			Return False
		EndIf
	EndIf

	Return False
EndFunc   ;==>_GetLootSlot

Func _Panic()
	_SaveSettings()
	Exit
EndFunc   ;==>_Panic

Func _idle()
	UpdateLog("Paused!")
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				_SaveSettings()
				Exit

		EndSwitch
	WEnd
EndFunc   ;==>_idle

Func UpdateProgressBar()
	GUICtrlSetData($Progress1, $Count / $LootAmount * 100)
EndFunc   ;==>UpdateProgressBar



Func _farm_Tomatoes()
	$Mode = 3
	$Stop = False
	$InventoryIsFull = False
	$Clientpos = _GetWindowSize($Gamename, False)

	If Not IsArray($Clientpos) Then
		UpdateLog("GTMP not found!")
		$Stop = True
	EndIf

	Do
		_SaveSettings()
		_LoadSettings()

		$Loot = _ImageSearchArea(@AppDataDir & "\LootBoy\Assets\Inventory.bmp", 1, 1579, 32, 1774, 210, $x, $y, 50)
		If $Loot = 1 Then
			UpdateLog("Inventory is Open, closing...")
			_PostMessage_Send($Gamename, $VK_I, 10)
			UpdateLog("Wait for Inventory Cooldown...")
			Sleep($Sleeper)
		EndIf

		; Farm Loot
		; Check if Inventory is full
		If $Count > $LootAmount Then
			$Count = 1
			UpdateLog("LootAmount Reached! ( Total Loot collected yet: " & $Mats & " )")

			_TransferToTruck()
			$Sleeper = 3000
		Else
			UpdateLog("Looting Tomatoes ( " & $Count & "/" & $LootAmount & " ) ...")
			;	_PostMessage_Send($Gamename, $VK_ALT, 10)
			;	Sleep(200)
			_PostMessage_Send($Gamename, $VK_E, 10)

			Sleep(1500)
			$InventorySize = _ImageSearchArea(@AppDataDir & "\LootBoy\Assets\Tomatoes_Error.bmp", 1, 0, 0, 500, 500, $x, $y, 25)
			If $InventorySize = 1 Then
				$Count = 1
				UpdateLog("Inventory is full!")
				$Sleeper = 5500
				_TransferToTruck()
			EndIf
			Sleep(10000 + Random($CustomDelay1, $CustomDelay2, 1))
			$Count = $Count + 1
			$Mats = $Mats + 2
			UpdateProgressBar()
		EndIf

	Until $Stop = True


EndFunc   ;==>_farm_Tomatoes



Func _farm_wheat()
	$Mode = 3
	$Stop = False
	$InventoryIsFull = False
	$Clientpos = _GetWindowSize($Gamename, False)

	If Not IsArray($Clientpos) Then
		UpdateLog("GTMP not found!")
		$Stop = True
	EndIf

	Do
		_SaveSettings()
		_LoadSettings()

		$Loot = _ImageSearchArea(@AppDataDir & "\LootBoy\Assets\Inventory.bmp", 1, 1579, 32, 1774, 210, $x, $y, 25)
		If $Loot = 1 Then
			UpdateLog("Inventory is Open, closing...")
			_PostMessage_Send($Gamename, $VK_I, 10)
			UpdateLog("Wait for Inventory Cooldown...")
			Sleep($Sleeper)
		EndIf

		; Farm Loot
		; Check if Inventory is full
		If $Count > $LootAmount Then
			$Count = 1
			UpdateLog("LootAmount Reached! ( Total Loot collected yet: " & $Mats & " )")

			_TransferToTruck()
			$Sleeper = 3000
		Else
			UpdateLog("Looting Wheat ( " & $Count & "/" & $LootAmount & " ) ...")
			;	_PostMessage_Send($Gamename, $VK_ALT, 10)
			;	Sleep(200)
			_PostMessage_Send($Gamename, $VK_E, 10)

			Sleep(1500)
			$InventorySize = _ImageSearchArea(@AppDataDir & "\LootBoy\Assets\Wheat_Error.bmp", 1, 0, 0, 500, 500, $x, $y, 25)
			If $InventorySize = 1 Then
				$Count = 1
				UpdateLog("Inventory is full!")
				$Sleeper = 5500
				_TransferToTruck()
			EndIf
			Sleep(10500 + Random($CustomDelay1, $CustomDelay2, 1))
			$Count = $Count + 1
			$Mats = $Mats + 2
			UpdateProgressBar()
		EndIf

	Until $Stop = True


EndFunc   ;==>_farm_wheat

Func _farm_stones()
	$Mode = 3
	$Stop = False
	$InventoryIsFull = False
	$Clientpos = _GetWindowSize($Gamename, False)
	If Not IsArray($Clientpos) Then
		UpdateLog("GTM not found!")
		$Stop = True
	EndIf
	Do
		_SaveSettings()
		_LoadSettings()

		;Check if Inventory is Open
		$Loot = _ImageSearchArea(@AppDataDir & "\LootBoy\Assets\Inventory.bmp", 1, 1579, 32, 1774, 210, $x, $y, 50)
		If $Loot = 1 Then
			UpdateLog("Inventory is Open, closing...")
			_PostMessage_Send($Gamename, $VK_I, 10)
			UpdateLog("Wait for Inventory Cooldown...")
			Sleep($Sleeper)
		EndIf

		; Farm Loot
		; Check if Inventory is full
		If $Count > $LootAmount Then
			$Count = 1
			UpdateLog("LootAmount Reached! ( Total Loot collected yet: " & $Mats & " )")

			_TransferToTruck()
			$Sleeper = 1500
		Else
			UpdateLog("Looting Stones ( " & $Count & "/" & $LootAmount & " ) ...")
			;	_PostMessage_Send($Gamename, $VK_ALT, 1)
			;	Sleep(200)
			_PostMessage_Send($Gamename, $VK_E, 10)
			;_PostMessage_Click(WinGetHandle($Gamename), 1713, 641, "Left", 1, 10)

			Sleep(1500)
			$InventorySize = _ImageSearchArea(@AppDataDir & "\LootBoy\Assets\Stone_Error.bmp", 1, 0, 0, 500, 500, $x, $y, 100)
			If $InventorySize = 1 Then
				$Count = 1
				UpdateLog("Inventory is full!")
				$Sleeper = 1500
				_TransferToTruck()
			EndIf
			Sleep(6850 + Random($CustomDelay1, $CustomDelay2, 1))
			UpdateProgressBar()
			$Count += 1
			$Mats += 2
		EndIf

	Until $Stop = True Or $InventorySize >= 85

	;Transfer Loot to Track
EndFunc   ;==>_farm_stones

Func _farm_oranges()
	$Mode = 1
	$Stop = False
	$InventoryIsFull = False
	$Clientpos = _GetWindowSize($Gamename, False)
	If Not IsArray($Clientpos) Then
		UpdateLog("GTM not found!")
		$Stop = True
	EndIf
	Do
		_SaveSettings()
		_LoadSettings()

		;Check if Inventory is Open
		$Loot = _ImageSearchArea(@AppDataDir & "\LootBoy\Assets\Inventory.bmp", 1, 1579, 32, 1774, 210, $x, $y, 25)
		If $Loot = 1 Then
			UpdateLog("Inventory is Open, closing...")
			_PostMessage_Send($Gamename, $VK_I, 10)
			UpdateLog("Wait for Inventory Cooldown...")
			Sleep($Sleeper)
		EndIf

		; Farm Loot
		; Check if Inventory is full
		If $Count > $LootAmount Then
			$Count = 1
			UpdateLog("LootAmount Reached! ( Total Loot collected yet: " & $Mats & " )")

			_TransferToTruck()
			$Sleeper = 3500
		Else
			UpdateLog("Looting Oranges ( " & $Count & "/" & $LootAmount & " ) ...")
			;	_PostMessage_Send($Gamename, $VK_ALT, 1)
			;	Sleep(200)
			_PostMessage_Send($Gamename, $VK_E, 10)
			;_PostMessage_Click(WinGetHandle($Gamename), 1713, 641, "Left", 1, 10)

			Sleep(1500)
			$InventorySize = _ImageSearchArea(@AppDataDir & "\LootBoy\Assets\Orange_Error.bmp", 1, 0, 0, 500, 500, $x, $y, 100)
			If $InventorySize = 1 Then
				$Count = 1
				UpdateLog("Inventory is full!")
				$Sleeper = 5000
				_TransferToTruck()
			EndIf
			Sleep(9350 + Random($CustomDelay1, $CustomDelay2, 1))
			UpdateProgressBar()
			$Count += 1
			$Mats += 2
		EndIf

	Until $Stop = True Or $InventorySize >= 85

	;Transfer Loot to Track
EndFunc   ;==>_farm_oranges

Func _farm_gold()
	_SaveSettings()
	_LoadSettings()

	If Not WinExists($Gamename) Then
		UpdateLog("Game not found!")
		Return
	EndIf

	$Stop = False
	Do
		;WinActive("Grand Theft Multiplayer")
		UpdateLog("Looting Gold (" & $Mats & ")...")
		;ControlSend("Grand Theft Multiplayer","",0,"{e}")
		_PostMessage_Send($Gamename, $VK_E, 10)
		_PostMessage_Send($Gamename, $VK_X, 10)

		Sleep(5800 + Random($CustomDelay1, $CustomDelay2, 1))
		$Mats += 24
	Until $Stop = True Or $BucketSize >= 7500

EndFunc   ;==>_farm_gold


Func _farm_Sand()
	_SaveSettings()
	_LoadSettings()

	If Not WinExists($Gamename) Then
		UpdateLog("Game not found!")
		Return
	EndIf

	$Stop = False
	Do
		;WinActive("Grand Theft Multiplayer")
		UpdateLog("Looting Sand (" & $Mats & ")...")
		;ControlSend("Grand Theft Multiplayer","",0,"{e}")
		_PostMessage_Send($Gamename, $VK_E, 10)
		_PostMessage_Send($Gamename, $VK_X, 10)

		Sleep(5800 + Random($CustomDelay1, $CustomDelay2, 1))
		$Mats += 24
	Until $Stop = True Or $BucketSize >= 7500

EndFunc   ;==>_farm_Sand


Func _TransferToTruck()
	$Item[0] = 0
	$Item[1] = 0
	UpdateLog("Open Inventory...")
	_PostMessage_Send($Gamename, $VK_I, 10)
	$oldwin = WinGetTitle("[ACTIVE]")
	$oldMouse = MouseGetPos()
	WinActivate($Gamename)
	Sleep(1000)
	$Loot = _ImageSearch(@AppDataDir & "\LootBoy\Assets\Inventory.bmp", 0, $x, $y, 100)
	If $Loot = 1 Then
		UpdateLog("Inventory Detected!")
		If $LootSlot = "AUTO" Then
			$Item = _GetLootSlot()
			If @error Then
				UpdateLog("Error while Detecting Loot Slot!")
			EndIf

			If IsArray($Item) Then
				UpdateLog("Disable Inputs...")
				BlockInput(1)
				UpdateLog("Set Transfer Amount...")

				MouseClick("left", 1713, 641, 50, 1)
				Sleep(50)
				_PostMessage_Send($Gamename, $VK_9, 10)
				Sleep(50)
				UpdateLog("Move Loot to Truck...")
				MouseClickDrag("left", $Item[0], $Item[1], 1021, 341, 1)
			Else
				BlockInput(0)
				_PostMessage_Send($Gamename, $VK_I, 10)
				UpdateLog("No Loot Found, wait some Seconds and try again.")
				Sleep(3000)
				Return
			EndIf

		Else
			MouseClickDrag("left", $Inventory_Slots_X[$LootSlot], $Inventory_Slots_Y[$LootSlot], 1021, 341, 1)
		EndIf

		UpdateLog("Enable Inputs...")
		BlockInput(0)
		UpdateLog("Restore old Window...")
		WinActivate($oldwin)
		WinActivate($oldwin)
		WinActivate($oldwin)

		MouseMove($oldMouse[0], $oldMouse[1], 1)
		Sleep(50)
		UpdateLog("Close Inventory...")
		Sleep(100)
		_PostMessage_Send($Gamename, $VK_I, 10)
		UpdateLog("Wait for Inventory Cooldown...")
		GUICtrlSetData($Progress1, 0)
		Sleep(1500 + Random($CustomDelay1, $CustomDelay2, 1))

		;Aditional Check for failed inventory Close.
		$Loot = _ImageSearch(@AppDataDir & "\LootBoy\Assets\Inventory.bmp", 0, $x, $y, 25)
		If $Loot = 1 Then
			UpdateLog("Failed to Close Inventory, closing again...")
			_PostMessage_Send($Gamename, $VK_I, 10)
			Sleep(1600 + Random($CustomDelay1, $CustomDelay2, 1))
		EndIf

		If $Mode = 1 Then
			_farm_oranges()
		ElseIf $Mode = 2 Then
			_farm_stones()
		ElseIf $Mode = 3 Then
			_farm_wheat()
		ElseIf $Mode = 4 Then
			_farm_Tomatoes()
		EndIf

	Else
		; Can't find Loot in Inventory, force Close any Menues and repeat Function.
		UpdateLog("No Inventory Detected, try again...")
		WinActivate($oldwin)
		MouseMove($oldMouse[0], $oldMouse[1], 1)
		Sleep(200)
		_PostMessage_Send($Gamename, $VK_I, 10)
		Sleep(1000)
		If $Mode = 1 Then
			_farm_oranges()
		ElseIf $Mode = 2 Then
			_farm_stones()
		ElseIf $Mode = 3 Then
			_farm_wheat()
		ElseIf $Mode = 4 Then
			_farm_Tomatoes()
		EndIf

	EndIf

	Sleep(1000)
	If $Mode = 1 Then
		_farm_oranges()
	ElseIf $Mode = 2 Then
		_farm_stones()
	ElseIf $Mode = 3 Then
		_farm_wheat()
	ElseIf $Mode = 4 Then
		_farm_Tomatoes()
	EndIf
EndFunc   ;==>_TransferToTruck

#cs
	Func _CheckDisconnect()

	$DisconectScreen = _ImageSearch(@AppDataDir & "\LootBoy\Assets\Disconnected.bmp", 0, $x, $y, 50)
	If $DisconectScreen = 1 Then
	UpdateLog("Disconnected, trying to Connect...")
	_PostMessage_Send($Gamename, $VK_RETURN, 10)
	EndIf


	EndFunc   ;==>_CheckDisconnect
#ce
#cs
	Func _WaitForInventory()
	While $tries > 10
	$Loot = _ImageSearch(@AppDataDir & "\LootBoy\Assets\Inventory.bmp", 0, $x, $y, 50)
	If $Loot = 1 Then
	Return True
	Else
	$tries += 1
	EndIf

	If $tries > 10 Then

	EndIf
	WEnd

	EndFunc   ;==>_WaitForInventory
#ce
#cs
	Func _Reconnect()

	; Disconnect Screen
	$DisconectScreen = PixelSearch(1251, 569, 1591, 637, 0xDF0101, 1)
	If IsArray($DisconectScreen) Then
	UpdateLog("Disconnect Screen Detected, Confirm...")
	EndIf

	; News Screen
	$NewsScreen = PixelSearch(1251, 569, 1591, 637, 0xDF0101, 1)
	If IsArray($NewsScreen) Then
	UpdateLog("News Screen Detected, Reconnecting...")
	EndIf

	; Auth Screen
	$AuthScreen = PixelSearch(725, 542, 1148, 591, 0xDC3545, 1)
	If IsArray($AuthScreen) Then
	UpdateLog("Auth Screen Detected! Confirm...")
	Sleep(15000)
	EndIf





	EndFunc   ;==>_Reconnect
#ce



Func _Stop()
	UpdateLog("Stopped!")
	$Stop = True
EndFunc   ;==>_Stop


Func _LoadSettings()
	If Not FileExists(@AppDataDir & "\LootBoy\") Then
		UpdateLog("No Directory found, creating Directory...")
		DirCreate(@AppDataDir & "\LootBoy\")


	EndIf

	If Not FileExists(@AppDataDir & "\LootBoy\Assets\") Then
		UpdateLog("No Directory found, creating Directory...")
		DirCreate(@AppDataDir & "\LootBoy\Assets\")
	EndIf

	If Not FileExists(@ScriptDir & "\ImageSearchDLL.dll") Then
		UpdateLog("Downloading Assets(.DLL)...")
		InetGet("https://raw.githubusercontent.com/Mitsukiii/Loot-Boy/master/Assets/ImageSearchDLL.dll", @ScriptDir & "\ImageSearchDLL.dll", 0, 0)
	EndIf


	If Not FileExists(@AppDataDir & "\LootBoy\Assets\ImageSearchDLL.dll") Then
		UpdateLog("Downloading Assets(-1)...")
		InetGet("https://raw.githubusercontent.com/Mitsukiii/Loot-Boy/master/Assets/ImageSearchDLL.dll", @AppDataDir & "\LootBoy\Assets\ImageSearchDLL.dll", 0, 0)
	EndIf



	If Not FileExists(@AppDataDir & "\LootBoy\Assets\Orange.bmp") Then
		UpdateLog("Downloading Assets(0)...")
		InetGet("https://raw.githubusercontent.com/Mitsukiii/Loot-Boy/master/Assets/orange.bmp", @AppDataDir & "\LootBoy\Assets\Orange.bmp", 0, 0)
	EndIf

	If Not FileExists(@AppDataDir & "\LootBoy\Assets\Stone.bmp") Then
		UpdateLog("Downloading Assets(1)...")
		InetGet("https://raw.githubusercontent.com/Mitsukiii/Loot-Boy/master/Assets/stone.bmp", @AppDataDir & "\LootBoy\Assets\Stone.bmp", 0, 0)
	EndIf

	If Not FileExists(@AppDataDir & "\LootBoy\Assets\Inventory.bmp") Then
		UpdateLog("Downloading Assets(2)...")
		InetGet("https://raw.githubusercontent.com/Mitsukiii/Loot-Boy/master/Assets/Inventory.bmp", @AppDataDir & "\LootBoy\Assets\Inventory.bmp", 0, 0)
	EndIf

	If Not FileExists(@AppDataDir & "\LootBoy\Assets\Orange_Error.bmp") Then
		UpdateLog("Downloading Assets(3)...")
		InetGet("https://raw.githubusercontent.com/Mitsukiii/Loot-Boy/master/Assets/Orange_Error.bmp", @AppDataDir & "\LootBoy\Assets\Orange_Error.bmp", 0, 0)
	EndIf

	If Not FileExists(@AppDataDir & "\LootBoy\Assets\ServerRestart.bmp") Then
		UpdateLog("Downloading Assets(4)...")
		InetGet("https://raw.githubusercontent.com/Mitsukiii/Loot-Boy/master/Assets/ServerRestart.bmp", @AppDataDir & "\LootBoy\Assets\ServerRestart.bmp", 0, 0)
	EndIf

	If Not FileExists(@AppDataDir & "\LootBoy\Assets\Disconnected.bmp") Then
		UpdateLog("Downloading Assets(5)...")
		InetGet("https://raw.githubusercontent.com/Mitsukiii/Loot-Boy/master/Assets/Disconnected.bmp", @AppDataDir & "\LootBoy\Assets\Disconnected.bmp", 0, 0)
	EndIf


	If Not FileExists(@AppDataDir & "\LootBoy\Assets\Wheat.bmp") Then
		UpdateLog("Downloading Assets(6)...")
		InetGet("https://raw.githubusercontent.com/Mitsukiii/Loot-Boy/master/Assets/Wheat.bmp", @AppDataDir & "\LootBoy\Assets\Wheat.bmp", 0, 0)
	EndIf

	If Not FileExists(@AppDataDir & "\LootBoy\Assets\Wheat_Error.bmp") Then
		UpdateLog("Downloading Assets(7)...")
		InetGet("https://raw.githubusercontent.com/Mitsukiii/Loot-Boy/master/Assets/Wheat_Error.bmp", @AppDataDir & "\LootBoy\Assets\Wheat_Error.bmp", 0, 0)
	EndIf

	If Not FileExists(@AppDataDir & "\LootBoy\Assets\Tomatoes_Error.bmp") Then
		UpdateLog("Downloading Assets(8)...")
		InetGet("https://raw.githubusercontent.com/Mitsukiii/Loot-Boy/master/Assets/Tomatoes_Error.bmp", @AppDataDir & "\LootBoy\Assets\Tomatoes_Error.bmp", 0, 0)
	EndIf

	If Not FileExists(@AppDataDir & "\LootBoy\Assets\Tomatoes.bmp") Then
		UpdateLog("Downloading Assets(9)...")
		InetGet("https://raw.githubusercontent.com/Mitsukiii/Loot-Boy/master/Assets/Tomatoes.bmp", @AppDataDir & "\LootBoy\Assets\Tomatoes.bmp", 0, 0)
	EndIf

	If Not FileExists(@AppDataDir & "\LootBoy\Assets\Stone_Error.bmp") Then
		UpdateLog("Downloading Assets(9)...")
		InetGet("https://raw.githubusercontent.com/Mitsukiii/Loot-Boy/master/Assets/Stone_Error.bmp", @AppDataDir & "\LootBoy\Assets\Stone_Error.bmp", 0, 0)
	EndIf


	$Mode = IniRead(@AppDataDir & "\LootBoy\Settings.ini", "Settings", "Mode", 1)

	If $Mode = 1 Then
		GUICtrlSetState($Radio1, $GUI_CHECKED)
	ElseIf $Mode = 2 Then
		GUICtrlSetState($Radio2, $GUI_CHECKED)
	ElseIf $Mode = 3 Then
		GUICtrlSetState($Radio3, $GUI_CHECKED)
	ElseIf $Mode = 4 Then
		GUICtrlSetState($Radio4, $GUI_CHECKED)
	ElseIf $Mode = 5 Then
		GUICtrlSetState($Radio5, $GUI_CHECKED)
	ElseIf $Mode = 6 Then
		GUICtrlSetState($Radio6, $GUI_CHECKED)
	ElseIf $Mode = 7 Then
		GUICtrlSetState($Radio7, $GUI_CHECKED)
	ElseIf $Mode = 8 Then
		GUICtrlSetState($Radio8, $GUI_CHECKED)
	EndIf

	$CustomDelay1 = IniRead(@AppDataDir & "\LootBoy\Settings.ini", "Settings", "CustomDelay1", 500)
	$CustomDelay2 = IniRead(@AppDataDir & "\LootBoy\Settings.ini", "Settings", "CustomDelay2", 1000)
	$LootSlot = IniRead(@AppDataDir & "\LootBoy\Settings.ini", "Settings", "LootSlot", 4)
	$LootAmount = IniRead(@AppDataDir & "\LootBoy\Settings.ini", "Settings", "LootAmount", 12)
	$LootSlot = IniRead(@AppDataDir & "\LootBoy\Settings.ini", "Settings", "LootSlot", "AUTO")
	$Mats = IniRead(@AppDataDir & "\LootBoy\Settings.ini", "Settings", "TotalMats", 0)

	GUICtrlSetData($Input1, $CustomDelay1)
	GUICtrlSetData($Input2, $CustomDelay2)
	GUICtrlSetData($Combo1, $LootSlot)
	GUICtrlSetData($Input3, $LootAmount)

	If ProcessExists("GrandTheftMultiplayer.Launcher.exe") Then
		UpdateLog("GTMP Launcher is Running, closing it to avoid issues.")
		ProcessClose("GrandTheftMultiplayer.Launcher.exe")
	EndIf

	If Not ProcessExists("GTA5.exe") Then
		UpdateLog("Game not found!")
		$Stop = True

		_idle()
	EndIf

EndFunc   ;==>_LoadSettings

Func _SaveSettings()

	If Not FileExists(@AppDataDir & "\LootBoy\") Then
		UpdateLog("No Directory found, creating Directory...")
		DirCreate(@AppDataDir & "\LootBoy\")
	EndIf

	If GUICtrlRead($Radio1) = $GUI_CHECKED Then
		$Mode = 1
	ElseIf GUICtrlRead($Radio2) = $GUI_CHECKED Then
		$Mode = 2
	ElseIf GUICtrlRead($Radio3) = $GUI_CHECKED Then
		$Mode = 3
	ElseIf GUICtrlRead($Radio4) = $GUI_CHECKED Then
		$Mode = 4
	ElseIf GUICtrlRead($Radio5) = $GUI_CHECKED Then
		$Mode = 5
	ElseIf GUICtrlRead($Radio6) = $GUI_CHECKED Then
		$Mode = 6
	ElseIf GUICtrlRead($Radio7) = $GUI_CHECKED Then
		$Mode = 7
	ElseIf GUICtrlRead($Radio8) = $GUI_CHECKED Then
		$Mode = 8

	EndIf

	IniWrite(@AppDataDir & "\LootBoy\Settings.ini", "Settings", "CustomDelay1", GUICtrlRead($Input1))
	IniWrite(@AppDataDir & "\LootBoy\Settings.ini", "Settings", "CustomDelay2", GUICtrlRead($Input2))
	IniWrite(@AppDataDir & "\LootBoy\Settings.ini", "Settings", "TotalMats", $Mats)
	IniWrite(@AppDataDir & "\LootBoy\Settings.ini", "Settings", "LootAmount", GUICtrlRead($Input3))
	IniWrite(@AppDataDir & "\LootBoy\Settings.ini", "Settings", "LootSlot", GUICtrlRead($Combo1))
	IniWrite(@AppDataDir & "\LootBoy\Settings.ini", "Settings", "Mode", $Mode)

EndFunc   ;==>_SaveSettings

Func UpdateLog($Text)
	$Time = _NowTime()
	$CurrentTime = "[" & $Time & "]: "

	GUICtrlSetData($Edit1, GUICtrlRead($Edit1) & @CRLF & $CurrentTime & $Text)
	GUICtrlSendMsg($Edit1, $EM_LINESCROLL, 0, GUICtrlSendMsg($Edit1, $EM_GETLINECOUNT, 0, 0))
	_GUICtrlRichEdit_ScrollToCaret($Edit1)
EndFunc   ;==>UpdateLog
