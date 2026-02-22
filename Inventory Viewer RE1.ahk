;@Ahk2Exe-SetName Inventory Viewer for RE1
;@Ahk2Exe-SetDescription Real-time inventory overlay
;@Ahk2Exe-SetVersion 1.0.0
;@Ahk2Exe-SetCopyright 2026 elModo7 - VictorDevLog
;@Ahk2Exe-SetOrigFilename Inventory Viewer RE1.exe
#SingleInstance Force
#NoEnv
#Include <aboutScreen>
SetBatchLines -1
version := "1.0"

; Tray Menu
Menu, Tray, NoStandard
Menu, Tray, Tip, Inventory Viewer for RE1 %version% 
Menu, Tray, Add, About, showAbout
Menu, Tray, Add, Exit, GuiClose

weapons := ["2", "3", "4", "5", "6", "7", "8", "9", "10"]
countableItems := ["11", "12", "13", "14", "15", "16", "17", "18", "47"]

slotAddresses := [0x838814, 0x838816, 0x838818, 0x83881A, 0x83881C, 0x83881E, 0x838820, 0x838822]

oldIDs := []
oldQtys := []

Gui -Caption +E0x02000000 +E0x00080000
Gui Font, s30 Bold c0x00D200, Tahoma

Loop 8 {
    row := Ceil(A_Index / 2) - 1
    yBase := 112 + (row * 120)
    xQtyR := (Mod(A_Index, 2) = 1) ? 152 : 274
    xQtyL := (Mod(A_Index, 2) = 1) ? 60 : 212

    Gui Add, Text, Hidden vccrSlot%A_Index% x%xQtyR% y%yBase% w83 h38 +0x200 +Right +BackgroundTrans

    Gui Add, Text, Hidden vcclSlot%A_Index% x%xQtyL% y%yBase% w83 h38 +0x200 +Left +BackgroundTrans

    xPic := (Mod(A_Index, 2) = 1) ? 168 : 328
    Gui Add, Picture, vicSlot%A_Index% x%xPic% y%yBase% w33 h41 Hidden, img\rightNumber.png

    xImg := (Mod(A_Index, 2) = 1) ? 48 : 209
    yImg := 35 + (row * 120)
    Gui Add, Picture, viiSlot%A_Index% x%xImg% y%yImg% w158 h118, img\0.png
}

Gui Add, Picture, x-1 y-8 w406 h551 gmoveWindow, img\inventory.png
Gui Show, w405 h540, RE1 Inventory GUI

global base := getBase("ahk_exe Biohazard.exe")
SetTimer, readMem, 250
SetTimer, regainBaseAddress, 5000
Return

readMem:
    Loop 8 {
        idx := A_Index
        addr := slotAddresses[idx]
        
        ; Read Memory
        currID  := RM(addr)
        currQty := RM(addr + 1)

        ; Update Image if ID changed
        if (currID != oldIDs[idx]) {
            GuiControl,, iiSlot%idx%, % "img\" currID ".png"
            oldIDs[idx] := currID
        }
        
        if (currQty != oldQtys[idx]) {
            GuiControl,, ccrSlot%idx%, %currQty%
            GuiControl,, cclSlot%idx%, %currQty%
            oldQtys[idx] := currQty
        }
        
        ; Determine Visibility (Weapon vs Countable vs None)
        isWeapon := HasValue(weapons, currID)
        isCountable := HasValue(countableItems, currID)
        
        if (isWeapon) {
            GuiControl, Hide, icSlot%idx%
            GuiControl, Hide, ccrSlot%idx%
            GuiControl, Show, cclSlot%idx%
        } 
        else if (isCountable) {
            GuiControl, Show, icSlot%idx%
            GuiControl, Show, ccrSlot%idx%
            GuiControl, Hide, cclSlot%idx%
        } 
        else {
            ; Hide everything if it's neither
            GuiControl, Hide, icSlot%idx%
            GuiControl, Hide, ccrSlot%idx%
            GuiControl, Hide, cclSlot%idx%
        }
    }
return

HasValue(arr, val) {
    for index, value in arr
        if (value = val)
            return true
    return false
}

moveWindow:
    PostMessage, 0xA1, 2,,, A
Return

regainBaseAddress:
    base := getBase("ahk_exe Biohazard.exe")
return

RM(MADDRESS) {
    global base
    static pid
    if !pid
        WinGet, pid, PID, ahk_exe Biohazard.exe
    
    ProcessHandle := DllCall("OpenProcess", "Int", 24, "Char", 0, "UInt", pid, "UInt")
    VarSetCapacity(MVALUE, 4, 0)
    DllCall("ReadProcessMemory", "UInt", ProcessHandle, "Ptr", base+MADDRESS, "Ptr", &MVALUE, "Uint", 1, "Ptr", 0)
    DllCall("CloseHandle", "Ptr", ProcessHandle)
    return NumGet(MVALUE, 0, "UChar")
}

getBase(WindowTitle) {
    WinGet, hWnd, ID, %WindowTitle%
    if !hWnd
        return
    return DllCall(A_PtrSize = 4 ? "GetWindowLong" : "GetWindowLongPtr", "Ptr", hWnd, "Int", -6, "Ptr")
}

aboutGuiEscape:
aboutGuiClose:
	AboutGuiClose()
return

showAbout() {
	global version
	showAboutScreen("Inventory Viewer for RE1 v" version, "Real-time inventory overlay for the Classic Rebirth path of Resident Evil 1 PC.")
}

GuiEscape:
GuiClose:
    ExitApp