#SingleInstance Force

; Defines the window title of the application
appTitle := "Warcraft I Remastered"

; Initializes the save counter
global saveCounter := 1


F11::Reload

F12::ExitApp


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


; Hotkey for instantly changing the game speed - faster
F1:: {

    if !WinExist(appTitle) {
        MsgBox "The application is not running. Script will not execute."
        Return
    }

    if !WinActive(appTitle) {
        MsgBox "Please make sure the application is active."
        Return
    }

    ; Opens the game menu
    Send "{F10}"
    Sleep 50

    ; Clicks the "Options" button
    MouseMove 955, 330
    Sleep 50
    Click "Down"
    Sleep 50
    Click "Up"
    Sleep 50

    ; Workaround: moves mouse cursor to a neutral position - middle of the screen => solves slider color change issue
    MouseMove 950, 500
    Sleep 50


    ;   -----   Searches for the "Game Speed" slider   -----   ;

    ; Top-left corner coordinates
    X1 := 620
    Y1 := 295

    ; Bottom-right corner coordinates
    X2 := 1258
    Y2 := 361

    ImageFile := "W1_GameSpeedSlider.png"

    ; Searches for an image on the screen
    ImageSearch &OutputVarX, &OutputVarY, X1, Y1, X2, Y2, ImageFile
    Sleep 50


    try {
        ; Moves mouse cursor to the "Game Speed" slider
        MouseMove OutputVarX, OutputVarY

        ; Moves the "Game Speed" slider
        SendEvent "{Click Down} {Click 1261, 329 Up}"

        ; Exits the menu
        Send "{Escape}"
    } catch {
        ; If the image is not found, show a message box
        ; MsgBox "Game Speed slider not found! Try again."
    }
    

    ; Workaround: solves ImageSearch issues/limitations
    loop 2 {
        Send "!{Enter}"
        Sleep 50
    }

    Return
}


; Hotkey for instantly changing the game speed - slower
F2:: {
    
    if !WinExist(appTitle) {
        MsgBox "The application is not running. Script will not execute."
        Return
    }

    if !WinActive(appTitle) {
        MsgBox "Please make sure the application is active."
        Return
    }

    ; Opens the game menu
    Send "{F10}"
    Sleep 50

    ; Clicks the "Options" button
    MouseMove 955, 330
    Sleep 50
    Click "Down"
    Sleep 50
    Click "Up"
    Sleep 50

    ; Workaround: moves mouse cursor to a neutral position - middle of the screen => solves slider color change issue
    MouseMove 950, 500
    Sleep 50


    ;   -----   Searches for the "Game Speed" slider   -----   ;

    ; Top-left corner coordinates
    X1 := 620
    Y1 := 295

    ; Bottom-right corner coordinates
    X2 := 1258
    Y2 := 361

    ImageFile := "W1_GameSpeedSlider.png"

    ; Searches for an image on the screen
    ImageSearch &OutputVarX, &OutputVarY, X1, Y1, X2, Y2, ImageFile
    Sleep 50


    try {
        ; Moves mouse cursor to the "Game Speed" slider
        MouseMove OutputVarX, OutputVarY

        ; Moves the "Game Speed" slider
        SendEvent "{Click Down} {Click 594, 318 Up}"
        ; Sleep 50

        ; Exits the menu
        Send "{Escape}"
    } catch {
        ; If the image is not found, show a message box}
        ; MsgBox "Game Speed slider not found! Try again."
    }


    ; Workaround: solves ImageSearch issues/limitations
    loop 2 {
        Send "!{Enter}"
        Sleep 50
    }
    
    Return
}