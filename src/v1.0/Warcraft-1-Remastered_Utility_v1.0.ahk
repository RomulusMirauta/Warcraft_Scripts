#SingleInstance Force

; Defines the window title of the application
appTitle := "Warcraft I Remastered"

; Initializes the save counter
global saveCounter := 1


; Hotkey for instantly saving the game
F6:: {

    ; Initializes the save counter
    global saveCounter

    ; Checks if the application is running
    if !WinExist(appTitle) {
        MsgBox "The application is not running. Script will not execute."
        Return
    }

    ; Ensures the application is active
    if !WinActive(appTitle) {
        MsgBox "Please make sure the application is active."
        Return
    }

    ; Opens the game menu
    Send "{F10}"

    ; Adds 'wait time' for the menu to appear
    Sleep 50

    ; Clicks on the "Save Game" button
    MouseMove 780, 270
    Sleep 50
    Click "Down"
    Sleep 50
    Click "Up"
    Sleep 50

    ; Clicks on the empty text box
    MouseMove 960, 270
    Click "Down"
    Sleep 50
    Click "Up"
    Sleep 50

    ; Enters the save name
    A_Clipboard := "" ; empties the clipboard => solves an annnoying bug
    SendInput ('QuickSave_' saveCounter)
    Sleep 50

    ; Increments the save counter
    saveCounter++
    Sleep 50
    
    ; Clicks on the "Save" button
    MouseMove 1180, 870
    Click "Down"
    Sleep 50
    Click "Up"

    Return
}


; Hotkey for instantly loading the latest save game
F7:: {

    ; Checks if the application is running
    if !WinExist(appTitle) {
        MsgBox "The application is not running. Script will not execute."
        Return
    }

    ; Ensures the application is active
    if !WinActive(appTitle) {
        MsgBox "Please make sure the application is active."
        Return
    }

    ; Opens the game menu
    Send "{F10}"
    Sleep 50

    ; Clicks on the "Load Game" button
    MouseMove 1120, 270
    Sleep 50
    Click "Down"
    Sleep 50
    Click "Up"
    Sleep 50

    ; Moves mouse in order to highlight the list
    MouseMove 930, 680
    Sleep 50

    ; Scrolls down to the bottom of the list
    Loop 1000 {
        Send "{WheelDown}"
    }
    Sleep 50

    ; Clicks on the latest save
    Click "Down"
    Sleep 50
    Click "Up"
    Sleep 50

    ; Clicks on the "Load" button
    MouseMove 1180, 870
    Sleep 50
    Click "Down"
    Sleep 50
    Click "Up"
    Sleep 50

    Return
}


F11::Reload
F12::ExitApp