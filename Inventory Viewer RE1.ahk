;@Ahk2Exe-SetName Inventory Viewer for RE1
;@Ahk2Exe-SetDescription Real-time inventory overlay
;@Ahk2Exe-SetVersion 1.4.0
;@Ahk2Exe-SetCopyright 2026 elModo7 - VictorDevLog
;@Ahk2Exe-SetOrigFilename Inventory Viewer RE1.exe
#SingleInstance Force
#NoEnv
#Include <aboutScreen>
SetBatchLines -1
version := "1.4"

; Tray Menu
Menu, Tray, NoStandard
Menu, Tray, Tip, Inventory Viewer for RE1 %version% 
Menu, Tray, Add, HD Textures, toggleTextures
Menu, Tray, Add,
Menu, Tray, Add, About, showAbout
Menu, Tray, Add, Exit, GuiClose

weapons := ["2", "3", "4", "5", "6", "7", "8", "9", "10"]
countableItems := ["11", "12", "13", "14", "15", "16", "17", "18", "47"]

slotAddresses := [0x838814, 0x838816, 0x838818, 0x83881A, 0x83881C, 0x83881E, 0x838820, 0x838822]

oldIDs := []
oldQtys := []

global changeType := "" ; damage/heal
global currentState := ""
global OldHealthValue := ""
global hdTextures := 0

; INVENTORY GUI
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

Gui Add, Picture, x0 y0 w406 h551 gmoveWindow vbgImg, img\inventory.png
Gui Show, x30 y182 w405 h550, RE1 Inventory GUI

; HEALTH GUI
Gui, Health: -Caption +LastFound +E0x02000000 +E0x00080000
Gui, Health:Font, s20 cAAAAAA
Gui, Health:Add, Text, +BackgroundTrans gmoveWindow x45 y15 w300 vtxtHealth,
Gui Health:Add, Picture, +BackgroundTrans vtxtOverlay gmoveWindow x0 y0 w198 h92, ; img\damage.PNG
Gui Health:Add, Picture, vtxtImg gmoveWindow x0 y0 w198 h92, img\fine.PNG
Gui, Health:show, x30 y30 w198 h92, HEALTH


; IGT GUI (In-Game Timer)
Gui, IGT:-Caption +LastFound +E0x02000000 +E0x00080000
Gui, IGT:Color, Black
Gui, IGT:Font, s20 cWhite
Gui, IGT:Add, Text, gmoveWindow x25 y15 w320 h120 vtxtTime,
Gui, IGT:show, x30 y122 w320 h60, IGT

gosub, regainBaseAddress
SetTimer, readMem, 250
SetTimer, playerCheck, 3000
SetTimer, regainBaseAddress, 5000
Return

readMem:
    ; Inventory Update
    Loop % isJill ? 8 : 6 {
        idx := A_Index
        addr := slotAddresses[idx]
        
        ; Read Memory
        currID  := RM(addr)
        currQty := RM(addr + 1)

        ; Update Image if ID changed
        if (currID != oldIDs[idx]) {
            GuiControl,, iiSlot%idx%, % hdTextures ? "img\hd\" currID ".png" : "img\" currID ".png"
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
    
    ; IGT & HP
    igt := Round(RM(0x6A8E10, 4) / 30)
    Current := RM(0x83523C)
    
    ; IGT UPDATE
    hours := Floor(igt / 3600)
    minutes := Floor(igt / 60)
    if (minutes >= 60)
        minutes := minutes - 60
    seconds := Mod(igt, 60)

    hours := SubStr("0" . hours, -1)
    minutes := SubStr("0" . minutes, -1)
    seconds := SubStr("0" . seconds, -1)

    GuiControl, IGT:Text, txtTime, IGT -> %hours%:%minutes%:%seconds%
    
    ; HEALTH
    if (Current <= 24 && currentState != "danger")
    {
        currentState := "danger"
        GuiControl, Health: +cRed, txtHealth
        GuiControl, Health: Text, txtImg, % hdTextures ? "img\hd\" currentState ".PNG" : "img\" currentState ".PNG"
    }
    else if (Current > 25 && Current <= 48 && currentState != "caution2")
    {
        currentState := "caution2"
        GuiControl, Health: +cFF681F, txtHealth
        GuiControl, Health: Text, txtImg, % hdTextures ? "img\hd\" currentState ".PNG" : "img\" currentState ".PNG"
    }
    else if (Current > 49 && Current <= 72 && currentState != "caution1")
    {
        currentState := "caution1"
        GuiControl, Health: +cYellow, txtHealth
        GuiControl, Health: Text, txtImg, % hdTextures ? "img\hd\" currentState ".PNG" : "img\" currentState ".PNG"
    }
    else if (Current > 73 && Current <= 140 && currentState != "fine")
    {
        currentState := "fine"
        GuiControl, Health: +cGreen, txtHealth
        GuiControl, Health: Text, txtImg, % hdTextures ? "img\hd\" currentState ".PNG" : "img\" currentState ".PNG"
    }

    ; Convert raw HP to %
    if (jill)
        hpPercent := Round((Current * 100) / 96)
    else
        hpPercent := Round((Current * 100) / 140)

    if (OldHpPercent != hpPercent)
    {
        if (hpPercent <= 200)
        {
            ; State change overlay
            if (hpPercent < OldHpPercent)
            {
                changeType := "damage"
                Gosub, SetOverlay
            }
            else if (hpPercent > OldHpPercent)
            {
                changeType := "heal"
                Gosub, SetOverlay
            }

            GuiControl, Health: Text, txtHealth, HP: %hpPercent%`%
        }
        else
        {
            changeType := "damage"
            Gosub, SetOverlay
            currentState := "danger"
            GuiControl, Health: +cRed, txtHealth
            GuiControl, Health: Text, txtHealth, You Died
            GuiControl, Health: Text, txtImg, % hdTextures ? "img\hd\" currentState ".PNG" : "img\" currentState ".PNG"
        }
    }

    OldHpPercent := hpPercent
return

playerCheck:
    ; Update inventory size
    playerValue := RM(0x8386F9)
    isJill := (playerValue == 1 || playerValue == 5) ? true : false
    if (wasJill != isJill) {
        if (isJill) {
            GuiControl,, bgImg, % hdTextures ? "img\hd\inventory.png" : "img\inventory.png" ; Jill
            if (hdTextures)
                GuiControl, Move, bgImg, x0 y0 w416 h551
            else
                GuiControl, Move, bgImg, x0 y0 w406 h551
            WinMove, RE1 Inventory GUI,,,,, 550
            GuiControl, Show, iiSlot7
            GuiControl, Show, iiSlot8
        } else {
            GuiControl,, bgImg, % hdTextures ? "img\hd\inventory_chris.png" : "img\inventory_chris.png" ; Chris / Other
            if (hdTextures)
                GuiControl, Move, bgImg, x0 y0 w416 h451
            else
                GuiControl, Move, bgImg, x0 y0 w406 h451
            GuiControl, Hide, iiSlot7
            GuiControl, Hide, iiSlot8
            WinMove, RE1 Inventory GUI,,,,, 450
        }
    }
    
    wasJill := isJill
return

toggleTextures:
    hdTextures := !hdTextures
    if (hdTextures) {
        Menu, Tray, Rename, HD Textures, Normal Textures
    } else {
        Menu, Tray, Rename, Normal Textures, HD Textures
    }
    
    Loop % isJill ? 8 : 6 {
        idx := A_Index
        addr := slotAddresses[idx]

        currID  := RM(addr)
        GuiControl,, iiSlot%idx%, % hdTextures ? "img\hd\" currID ".png" : "img\" currID ".png"
        oldIDs[idx] := currID
    }
    
    if (isJill) {
        GuiControl,, bgImg, % hdTextures ? "img\hd\inventory.png" : "img\inventory.png"
        if (hdTextures)
            GuiControl, Move, bgImg, x0 y0 w416 h551
        else 
            GuiControl, Move, bgImg, x0 y0 w406 h551
    } else {
        GuiControl,, bgImg, % hdTextures ? "img\hd\inventory_chris.png" : "img\inventory_chris.png"
        if (hdTextures)
            GuiControl, Move, bgImg, x0 y0 w416 h451
        else
            GuiControl, Move, bgImg, x0 y0 w406 h451
    }
    
    GuiControl, Health: Text, txtImg, % hdTextures ? "img\hd\" currentState ".PNG" : "img\" currentState ".PNG"
return

SetOverlay:
    if (changeType = "damage")
        GuiControl, Health: Text, txtOverlay, % hdTextures ? "img\hd\damage.PNG" : "img\damage.PNG"
    else if (changeType = "heal")
        GuiControl, Health: Text, txtOverlay, % hdTextures ? "img\hd\heal.PNG" : "img\heal.PNG"
    SetTimer, ClearOverlay, 1000
return

ClearOverlay:
    SetTimer, SetOverlay, Off
    SetTimer, ClearOverlay, Off
    GuiControl, Health: Text, txtOverlay,
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
    WinGet, pid, PID, ahk_exe Biohazard.exe
return

RM(MADDRESS, BYT := 1) {
    global base, pid
    ProcessHandle := DllCall("OpenProcess", "Int", 24, "Char", 0, "UInt", pid, "UInt")
    VarSetCapacity(MVALUE, 4, 0)
    DllCall("ReadProcessMemory", "UInt", ProcessHandle, "Ptr", base+MADDRESS, "Ptr", &MVALUE, "Uint", BYT, "Ptr", 0)
    Loop 4
    result += *(&MVALUE + A_Index-1) << 8*(A_Index-1)
    DllCall("CloseHandle", "Ptr", ProcessHandle)
    return, result
    
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
	showAboutScreen("Inventory Viewer for RE1 v" version, "Real-time inventory overlay for the Classic Rebirth path of Resident Evil 1 PC.`nHD textures: SHDP Team, LeigiBoy. Testing: SenhorX.")
}

HealthGuiClose:
HealthGuiEscape:
IGTGuiClose:
IGTGuiEscape:
GuiEscape:
GuiClose:
    ExitApp