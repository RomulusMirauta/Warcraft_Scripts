#SingleInstance Force

; Defines the window title of the application
appTitle := "Warcraft I Remastered"

; Creates a variable that will store the save counter value
global saveCounter

; Creates a variable to store the full address of the file that will store saveCounter's value
global saveCounterFile := A_ScriptDir "\saveCounter.txt"


; Reads saveCounter's value from file and treats possible flow issues
if FileExist(saveCounterFile) {
    saveCounter := FileRead(saveCounterFile)
    ; MsgBox "File exists. The counter value is: " saveCounter
    if saveCounter = "" {
        saveCounter := 0
    }
} else {
    saveCounter := 0
}


F11::Reload

F12::ExitApp


; -------------------------------------------------------------     Hotkey for instantly SAVING the game     ------------------------------------------------------------- ;
F6:: {

    ; Initializes the required variables so they can be used locally
    global saveCounter
    global saveCounterFile

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

    ; Increments the save counter
    saveCounter++
    Sleep 50

    ; Enters the save name
    A_Clipboard := "" ; empties the clipboard => solves an annnoying bug
    SendInput ('QuickSave_' saveCounter)
    Sleep 50

    ; attempts to delete the file that stores saveCounter's value
    try FileDelete saveCounterFile
    catch {
        ; MsgBox "File not found!"
    }

    ; creates a new file that stores saveCounter's NEW value
    FileAppend saveCounter, saveCounterFile
    
    ; Clicks on the "Save" button
    MouseMove 1180, 870
    Click "Down"
    Sleep 50
    Click "Up"

    Return
}


; ------------------------------------------------------     Hotkey for instantly LOADING the latest save game     ------------------------------------------------------ ;
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


; ----------------------------------------------------     Hotkey for instantly changing the game speed - SLOWER     ---------------------------------------------------- ;
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


    ;   -----   Searching for and using the "Game Speed" slider   -----   ;

    ; Top-left corner coordinates
    X1 := 616
    Y1 := 287

    ; Bottom-right corner coordinates
    X2 := 1249
    Y2 := 371

    SliderColor := 0x4450C7 ; https://www.color-hex.com/color/4450c7
    ShadeVariation := 0 ; Allows NO color variation(s)

    ; Searches for the slider - using the color of a pixel
    PixelSearch &OutputVarX, &OutputVarY, X1, Y1, X2, Y2, SliderColor, ShadeVariation
    Sleep 50


    try {
        ; Timer-based drag distance calculation
        TimerDuration := 150 ; There are 5 slider positions, each ~150ms apart
        MaxDragDistance := 1200 ; Maximum distance the slider can move - calculated from min position to max position
        DragDistance := Floor((TimerDuration / 1000) * MaxDragDistance) ; Calculates the drag distance based on timer
    
        ; Ensures that the drag distance doesn't exceed the maximum distance
        if (DragDistance > MaxDragDistance) {
            DragDistance := MaxDragDistance
        }
    
        ; Calculates the end position for the drag
        DragEndX := OutputVarX - DragDistance
        DragEndY := OutputVarY ; Keeping the same Y-coordinate => horizontal-only drag
    
        ; Performs the click & drag
        MouseMove OutputVarX, OutputVarY ; Moves the mouse cursor to the starting position
        Sleep 50
        SendEvent "{Click Down}" ; Presses and holds the left mouse button
        MouseMove DragEndX, DragEndY, 0 ; Moves to the end position (adjust speed as needed, 0 = instant, 1-100 <=> slower-faster)
        Sleep 100
        SendEvent "{Click Up}" ; Releases the left mouse button
        Sleep 100

        ; Exits the menu
        Send "{Escape}"
    } catch {
        ; If the image is not found, shows a message box
        ; MsgBox "Game Speed slider not found! Try again."
    }


    ; Workaround: solves PixelSearch issues/limitations
    loop 2 {
        Send "!{Enter}"
        Sleep 50
    }
    

    Sleep 50
    Return
}


; ----------------------------------------------------     Hotkey for instantly changing the game speed - FASTER     ---------------------------------------------------- ;
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


    ;   -----   Searching for and using the "Game Speed" slider   -----   ;

    ; Top-left corner coordinates
    X1 := 616
    Y1 := 287

    ; Bottom-right corner coordinates
    X2 := 1249
    Y2 := 371

    SliderColor := 0x4450C7 ; https://www.color-hex.com/color/4450c7
    ShadeVariation := 0 ; Allows NO color variation(s)

    ; Searches for the slider - using the color of a pixel
    PixelSearch &OutputVarX, &OutputVarY, X1, Y1, X2, Y2, SliderColor, ShadeVariation
    Sleep 50


    try {
        ; Timer-based drag distance calculation
        TimerDuration := 150 ; There are 5 slider positions, each ~150ms apart
        MaxDragDistance := 1200 ; Maximum distance the slider can move - calculated from min position to max position
        DragDistance := Floor((TimerDuration / 1000) * MaxDragDistance) ; Calculates the drag distance based on timer
    
        ; Ensures that the drag distance doesn't exceed the maximum distance
        if (DragDistance > MaxDragDistance) {
            DragDistance := MaxDragDistance
        }
    
        ; Calculates the end position for the drag
        DragEndX := OutputVarX + DragDistance
        DragEndY := OutputVarY ; Keeping the same Y-coordinate => horizontal-only drag
        
        ; Performs the click & drag
        MouseMove OutputVarX, OutputVarY ; Moves the mouse cursor to the starting position
        Sleep 50
        SendEvent "{Click Down}" ; Presses and holds the left mouse button
        MouseMove DragEndX, DragEndY, 0 ; Moves to the end position (adjust speed as needed, 0 = instant, 1-100 <=> slower-faster)
        Sleep 100
        SendEvent "{Click Up}" ; Releases the left mouse button
        Sleep 100

        ; Exits the menu
        Send "{Escape}"
    } catch {
        ; If the image is not found, shows a message box
        ; MsgBox "Game Speed slider not found! Try again."
    }


    ; Workaround: solves PixelSearch issues/limitations
    loop 2 {
        Send "!{Enter}"
        Sleep 50
    }


    Sleep 50
    Return
}


; ---------------------------------------------------     Hotkey for instantly changing the game speed - SLOWEST     ---------------------------------------------------- ;
+F1:: {
    
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


    ;   -----   Searching for and using the "Game Speed" slider   -----   ;

    ; Top-left corner coordinates
    X1 := 616
    Y1 := 287

    ; Bottom-right corner coordinates
    X2 := 1249
    Y2 := 371

    SliderColor := 0x4450C7 ; https://www.color-hex.com/color/4450c7
    ShadeVariation := 0 ; Allows NO color variation(s)

    ; Searches for the slider - using the color of a pixel
    PixelSearch &OutputVarX, &OutputVarY, X1, Y1, X2, Y2, SliderColor, ShadeVariation
    Sleep 50


    try {
        ; Moves mouse cursor to the "Game Speed" slider
        MouseMove OutputVarX, OutputVarY

        ; Moves the "Game Speed" slider
        SendEvent "{Click Down} {Click 594, 329 Up}"
        ; Sleep 50

        ; Exits the menu
        Send "{Escape}"
        Sleep 50
    } catch {
        ; If the image is not found, shows a message box
        ; MsgBox "Game Speed slider not found! Try again."
    }


    ; Workaround: solves PixelSearch issues/limitations
    loop 2 {
        Send "!{Enter}"
        Sleep 50
    }
    

    Sleep 50
    Return
}


; ----------------------------------------------------     Hotkey for instantly changing the game speed - FASTEST     ---------------------------------------------------- ;
+F2:: {

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


    ;   -----   Searching for and using the "Game Speed" slider   -----   ;

    ; Top-left corner coordinates
    X1 := 616
    Y1 := 287

    ; Bottom-right corner coordinates
    X2 := 1249
    Y2 := 371

    SliderColor := 0x4450C7 ; https://www.color-hex.com/color/4450c7
    ShadeVariation := 0 ; Allows NO color variation(s)

    ; Searches for the slider - using the color of a pixel
    PixelSearch &OutputVarX, &OutputVarY, X1, Y1, X2, Y2, SliderColor, ShadeVariation
    Sleep 50


    try {
        ; Moves mouse cursor to the "Game Speed" slider
        MouseMove OutputVarX, OutputVarY

        ; Moves the "Game Speed" slider
        SendEvent "{Click Down} {Click 1261, 329 Up}"
        ; Sleep 50

        ; Exits the menu
        Send "{Escape}"
        Sleep 50
    } catch {
        ; If the image is not found, shows a message box
        ; MsgBox "Game Speed slider not found! Try again."
    }


    ; Workaround: solves PixelSearch issues/limitations
    loop 2 {
        Send "!{Enter}"
        Sleep 50
    }


    Sleep 50
    Return
}