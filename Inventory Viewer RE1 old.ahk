; This is a very old script with lots of duplicate code, refer to the new version for a cleaner implementation
#SingleInstance Force
#NoEnv
SetBatchLines -1
weapons := ["2", "3", "4", "5", "6", "7", "8", "9", "10"] ; Weapons have quantity to the left
countableItems := ["11", "12", "13", "14", "15", "16", "17", "18", "47"] ; Items with quantity to the right

Gui -Caption +E0x02000000 +E0x00080000
Gui Font, s30 Bold c0x00D200, Tahoma
; Cantidades Munición/Cinta (Derecha)
Gui Add, Text, Hidden vccrSlot1 x152 y112 w83 h38 +0x200 +Left +BackgroundTrans,
Gui Add, Text, Hidden vccrSlot2 x274 y112 w83 h38 +0x200 +Right +BackgroundTrans,
Gui Add, Text, Hidden vccrSlot3 x122 y232 w83 h38 +0x200 +Right +BackgroundTrans,
Gui Add, Text, Hidden vccrSlot4 x274 y232 w83 h38 +0x200 +Right +BackgroundTrans,
Gui Add, Text, Hidden vccrSlot5 x122 y352 w83 h38 +0x200 +Right +BackgroundTrans,
Gui Add, Text, Hidden vccrSlot6 x274 y352 w83 h38 +0x200 +Right +BackgroundTrans,
Gui Add, Text, Hidden vccrSlot7 x122 y472 w83 h38 +0x200 +Right +BackgroundTrans,
Gui Add, Text, Hidden vccrSlot8 x274 y472 w83 h38 +0x200 +Right +BackgroundTrans,
; Cantidades weapons (Izquierda)
Gui Add, Text, Hidden vcclSlot1 x60 y112 w83 h38 +0x200 +Left +BackgroundTrans,
Gui Add, Text, Hidden vcclSlot2 x212 y112 w83 h38 +0x200 +Left +BackgroundTrans,
Gui Add, Text, Hidden vcclSlot3 x60 y232 w83 h38 +0x200 +Left +BackgroundTrans,
Gui Add, Text, Hidden vcclSlot4 x212 y232 w83 h38 +0x200 +Left +BackgroundTrans,
Gui Add, Text, Hidden vcclSlot5 x60 y352 w83 h38 +0x200 +Left +BackgroundTrans,
Gui Add, Text, Hidden vcclSlot6 x212 y352 w83 h38 +0x200 +Left +BackgroundTrans,
Gui Add, Text, Hidden vcclSlot7 x60 y472 w83 h38 +0x200 +Left +BackgroundTrans,
Gui Add, Text, Hidden vcclSlot8 x212 y472 w83 h38 +0x200 +Left +BackgroundTrans,
; Panel Ocultar Munición Original (Derecha)
Gui Add, Picture, vicSlot1 x168 y112 w33 h41 Hidden, img\rightNumber.png
Gui Add, Picture, vicSlot2 x328 y112 w33 h40 Hidden, img\rightNumber.png
Gui Add, Picture, vicSlot3 x168 y232 w33 h40 Hidden, img\rightNumber.png
Gui Add, Picture, vicSlot4 x328 y240 w33 h40 Hidden, img\rightNumber.png
Gui Add, Picture, vicSlot5 x168 y352 w33 h40 Hidden, img\rightNumber.png
Gui Add, Picture, vicSlot6 x328 y352 w33 h40 Hidden, img\rightNumber.png
Gui Add, Picture, vicSlot7 x168 y472 w33 h40 Hidden, img\rightNumber.png
Gui Add, Picture, vicSlot8 x328 y472 w33 h40 Hidden, img\rightNumber.png
; Imagenes Inventario
Gui Add, Picture, viiSlot1 x48 y35 w158 h118, img\0.png
Gui Add, Picture, viiSlot2 x209 y35 w158 h118, img\0.png
Gui Add, Picture, viiSlot3 x48 y155 w158 h118, img\0.png
Gui Add, Picture, viiSlot4 x209 y155 w158 h118, img\0.png
Gui Add, Picture, viiSlot5 x48 y275 w158 h118, img\0.png
Gui Add, Picture, viiSlot6 x209 y275 w158 h118, img\0.png
Gui Add, Picture, viiSlot7 x48 y395 w158 h118, img\0.png
Gui Add, Picture, viiSlot8 x208 y395 w158 h118, img\0.png
Gui Add, Picture, x-1 y-8 w406 h551 gmoveWindow, img\inventory.png ; BG
Gui Show, w405 h540, RE1 Inventory GUI ; Show GUI

If !WinExist("ahk_exe Biohazard.exe")
{
    TrayTip, Resident Evil, Waiting for game to be oppened.
    WinWait, ahk_exe Biohazard.exe
    TrayTip, Resident Evil, Game detected.
}
global base := getBase("ahk_exe Biohazard.exe")
SetTimer, readMem, 250
Return

readMem:
	iSlot1 := RM(0x838814)
    cSlot1 := RM(0x838815)
    iSlot2 := RM(0x838816)
    cSlot2 := RM(0x838817)
    iSlot3 := RM(0x838818)
    cSlot3 := RM(0x838819)
    iSlot4 := RM(0x83881A)
    cSlot4 := RM(0x83881B)
    iSlot5 := RM(0x83881C)
    cSlot5 := RM(0x83881D)
    iSlot6 := RM(0x83881E)
    cSlot6 := RM(0x83881F)
    iSlot7 := RM(0x838820)
    cSlot7 := RM(0x838821)
    iSlot8 := RM(0x838822)
    cSlot8 := RM(0x838823)

	; Update Quantities
	if(cSlot1 != cSlot1old)
	{
		GuiControl,,ccrSlot1, % cSlot1
		GuiControl,,cclSlot1, % cSlot1
	}
	if(cSlot2 != cSlot2old)
	{
		GuiControl,,ccrSlot2, % cSlot2
		GuiControl,,cclSlot2, % cSlot2
	}
	if(cSlot3 != cSlot3old)
	{
		GuiControl,,ccrSlot3, % cSlot3
		GuiControl,,cclSlot3, % cSlot3
	}
	if(cSlot4 != cSlot4old)
	{
		GuiControl,,ccrSlot4, % cSlot4
		GuiControl,,cclSlot4, % cSlot4
	}
	if(cSlot5 != cSlot5old)
	{
		GuiControl,,ccrSlot5, % cSlot5
		GuiControl,,cclSlot5, % cSlot5
	}
	if(cSlot6 != cSlot6old)
	{
		GuiControl,,ccrSlot6, % cSlot6
		GuiControl,,cclSlot6, % cSlot6
	}
	if(cSlot7 != cSlot7old)
	{
		GuiControl,,ccrSlot7, % cSlot7
		GuiControl,,cclSlot7, % cSlot7
	}
	if(cSlot8 != cSlot8old)
	{
		GuiControl,,ccrSlot8, % cSlot8
		GuiControl,,cclSlot8, % cSlot8
	}
	
	; Update Images
	if(iSlot1 != iSlot1old)
	{
		GuiControl,,iiSlot1, % "img\" iSlot1 ".png"
	}
	if(iSlot2 != iSlot2old)
	{
		GuiControl,,iiSlot2, % "img\" iSlot2 ".png"
	}
	if(iSlot3 != iSlot3old)
	{
		GuiControl,,iiSlot3, % "img\" iSlot3 ".png"
	}
	if(iSlot4 != iSlot4old)
	{
		GuiControl,,iiSlot4, % "img\" iSlot4 ".png"
	}
	if(iSlot5 != iSlot5old)
	{
		GuiControl,,iiSlot5, % "img\" iSlot5 ".png"
	}
	if(iSlot6 != iSlot6old)
	{
		GuiControl,,iiSlot6, % "img\" iSlot6 ".png"
	}
	if(iSlot7 != iSlot7old)
	{
		GuiControl,,iiSlot7, % "img\" iSlot7 ".png"
	}
	if(iSlot8 != iSlot8old)
	{
		GuiControl,,iiSlot8, % "img\" iSlot8 ".png"
	}
	
	
	weaponSlots := [0,0,0,0,0,0,0,0]
	for k, v in weapons
	{
		if(iSlot1 = v)
			weaponSlots[1] := 1
		if(iSlot2 = v)
			weaponSlots[2] := 1
		if(iSlot3 = v)
			weaponSlots[3] := 1
		if(iSlot4 = v)
			weaponSlots[4] := 1
		if(iSlot5 = v)
			weaponSlots[5] := 1
		if(iSlot6 = v)
			weaponSlots[6] := 1
		if(iSlot7 = v)
			weaponSlots[7] := 1
		if(iSlot8 = v)
			weaponSlots[8] := 1
	}
	
	countableSlots := [0,0,0,0,0,0,0,0]
	for k, v in countableItems
	{
		if(iSlot1 = v)
			countableSlots[1] := 1
		if(iSlot2 = v)
			countableSlots[2] := 1
		if(iSlot3 = v)
			countableSlots[3] := 1
		if(iSlot4 = v)
			countableSlots[4] := 1
		if(iSlot5 = v)
			countableSlots[5] := 1
		if(iSlot6 = v)
			countableSlots[6] := 1
		if(iSlot7 = v)
			countableSlots[7] := 1
		if(iSlot8 = v)
			countableSlots[8] := 1
	}
	
	; Comprobar Slots weapons
	if(weaponSlots[1])
	{
		GuiControl, Hide, icSlot1
		GuiControl, Hide, ccrSlot1
		GuiControl, Show, cclSlot1
	}
	if(weaponSlots[2])
	{
		GuiControl, Hide, icSlot2
		GuiControl, Hide, ccrSlot2
		GuiControl, Show, cclSlot2
	}
	if(weaponSlots[3])
	{
		GuiControl, Hide, icSlot3
		GuiControl, Hide, ccrSlot3
		GuiControl, Show, cclSlot3
	}
	if(weaponSlots[4])
	{
		GuiControl, Hide, icSlot4
		GuiControl, Hide, ccrSlot4
		GuiControl, Show, cclSlot4
	}
	if(weaponSlots[5])
	{
		GuiControl, Hide, icSlot5
		GuiControl, Hide, ccrSlot5
		GuiControl, Show, cclSlot5
	}
	if(weaponSlots[6])
	{
		GuiControl, Hide, icSlot6
		GuiControl, Hide, ccrSlot6
		GuiControl, Show, cclSlot6
	}
	if(weaponSlots[7])
	{
		GuiControl, Hide, icSlot7
		GuiControl, Hide, ccrSlot7
		GuiControl, Show, cclSlot7
	}
	if(weaponSlots[8])
	{
		GuiControl, Hide, icSlot8
		GuiControl, Hide, ccrSlot8
		GuiControl, Show, cclSlot8
	}
	
	; Comprobar Slots Objetos countables
	if(countableSlots[1])
	{
		GuiControl, Show, icSlot1
		GuiControl, Show, ccrSlot1
		GuiControl, Hide, cclSlot1
	}
	if(countableSlots[2])
	{
		GuiControl, Show, icSlot2
		GuiControl, Show, ccrSlot2
		GuiControl, Hide, cclSlot2
	}
	if(countableSlots[3])
	{
		GuiControl, Show, icSlot3
		GuiControl, Show, ccrSlot3
		GuiControl, Hide, cclSlot3
	}
	if(countableSlots[4])
	{
		GuiControl, Show, icSlot4
		GuiControl, Show, ccrSlot4
		GuiControl, Hide, cclSlot4
	}
	if(countableSlots[5])
	{
		GuiControl, Show, icSlot5
		GuiControl, Show, ccrSlot5
		GuiControl, Hide, cclSlot5
	}
	if(countableSlots[6])
	{
		GuiControl, Show, icSlot6
		GuiControl, Show, ccrSlot6
		GuiControl, Hide, cclSlot6
	}
	if(countableSlots[7])
	{
		GuiControl, Show, icSlot7
		GuiControl, Show, ccrSlot7
		GuiControl, Hide, cclSlot7
	}
	if(countableSlots[8])
	{
		GuiControl, Show, icSlot8
		GuiControl, Show, ccrSlot8
		GuiControl, Hide, cclSlot8
	}
	
	if(!countableSlots[1] && !weaponSlots[1])
	{
		GuiControl, Hide, icSlot1
		GuiControl, Hide, ccrSlot1
		GuiControl, Hide, cclSlot1
	}
	
	; Check if not weapon nor countable item (hide quantities)
	if(!countableSlots[1] && !weaponSlots[1])
	{
		GuiControl, Hide, icSlot1
		GuiControl, Hide, ccrSlot1
		GuiControl, Hide, cclSlot1
	}if(!countableSlots[2] && !weaponSlots[2])
	{
		GuiControl, Hide, icSlot2
		GuiControl, Hide, ccrSlot2
		GuiControl, Hide, cclSlot2
	}if(!countableSlots[3] && !weaponSlots[3])
	{
		GuiControl, Hide, icSlot3
		GuiControl, Hide, ccrSlot3
		GuiControl, Hide, cclSlot3
	}if(!countableSlots[4] && !weaponSlots[4])
	{
		GuiControl, Hide, icSlot4
		GuiControl, Hide, ccrSlot4
		GuiControl, Hide, cclSlot4
	}if(!countableSlots[5] && !weaponSlots[5])
	{
		GuiControl, Hide, icSlot5
		GuiControl, Hide, ccrSlot5
		GuiControl, Hide, cclSlot5
	}if(!countableSlots[6] && !weaponSlots[6])
	{
		GuiControl, Hide, icSlot6
		GuiControl, Hide, ccrSlot6
		GuiControl, Hide, cclSlot6
	}if(!countableSlots[7] && !weaponSlots[7])
	{
		GuiControl, Hide, icSlot7
		GuiControl, Hide, ccrSlot7
		GuiControl, Hide, cclSlot7
	}if(!countableSlots[8] && !weaponSlots[8])
	{
		GuiControl, Hide, icSlot8
		GuiControl, Hide, ccrSlot8
		GuiControl, Hide, cclSlot8
	}
	
	; Compare old with new
	iSlot1old := iSlot1
	cSlot1old := cSlot1
	iSlot2old := iSlot2
	cSlot2old := cSlot2
	iSlot3old := iSlot3
	cSlot3old := cSlot3
	iSlot4old := iSlot4
	cSlot4old := cSlot4
	iSlot5old := iSlot5
	cSlot5old := cSlot5
	iSlot6old := iSlot6
	cSlot6old := cSlot6
	iSlot7old := iSlot7
	cSlot7old := cSlot7
	iSlot8old := iSlot8
	cSlot8old := cSlot8
return

moveWindow:
	PostMessage, 0xA1, 2,,, A
Return

RM(MADDRESS)
{
	global base
    winget, pid, PID, ahk_exe Biohazard.exe
    VarSetCapacity(MVALUE,4,0)
    ProcessHandle := DllCall("OpenProcess", "Int", 24, "Char", 0, "UInt", pid, "UInt")
    DllCall("ReadProcessMemory", "UInt", ProcessHandle, "Ptr", base+MADDRESS, "Ptr", &MVALUE, "Uint",1)
    Loop 4
    result += *(&MVALUE + A_Index-1) << 8*(A_Index-1)
    return, result
}

getBase(WindowTitle, windowMatchMode := "3")
{
    if (windowMatchMode && A_TitleMatchMode != windowMatchMode)
    {
        mode := A_TitleMatchMode
        StringReplace, windowMatchMode, windowMatchMode, 0x
        SetTitleMatchMode, %windowMatchMode%
    }
    WinGet, hWnd, ID, %WindowTitle%
    if mode
        SetTitleMatchMode, %mode%
    if !hWnd
        return
    return DllCall(A_PtrSize = 4
        ? "GetWindowLong"
        : "GetWindowLongPtr"
        , "Ptr", hWnd, "Int", -6, A_Is64bitOS ? "Int64" : "UInt")  
} 

GuiEscape:
GuiClose:
    ExitApp
