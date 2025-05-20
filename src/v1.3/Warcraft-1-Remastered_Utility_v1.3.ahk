#SingleInstance Force

; Defines the window title of the application
appTitle := "Warcraft I Remastered"

; EnvGet retrieves the value of the USERPROFILE environment variable that will be stored in the currentUserProfilePath variable
currentUserProfilePath := EnvGet("USERPROFILE") 

; Creates a variable to store the full address of the save game directory <=> "C:\Users\<CurrentUsername>\Saved Games\WarcraftRemastered"
saveGameDirectory := currentUserProfilePath . "\Saved Games\WarcraftRemastered"

; Creates a variable that will store the save counter value
global saveCounter

; Creates a variable to store the full address of the file that will store saveCounter's value
global saveCounterFile := saveGameDirectory "\saveCounter.txt"


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


global oldSaveGamesCounter
global oldSaveGamesCounterFile := saveGameDirectory "\OldSaveGamesCounterFile.txt"

if FileExist(oldSaveGamesCounterFile) {
    oldSaveGamesCounter:= FileRead(oldSaveGamesCounterFile)
    ; MsgBox "File exists. The counter value is: " oldSaveGamesCounter
    if oldSaveGamesCounter= "" {
        oldSaveGamesCounter := 0
    }
} else {
    oldSaveGamesCounter := 0
}


F11::Reload

F12::ExitApp


; --------------------------------------------------------------------     Hotkey for instantly SAVING the game     -------------------------------------------------------------------- ;
F6:: {

    ; Initializes the required variables so they can be used locally
    global saveCounter
    global saveCounterFile

    ; Checks if the application is running
    if !WinExist(appTitle) {
        ; MsgBox [Text, Title, Options] ; Options = Buttons, Icon
        ; 0 = OK; 0x1 = OK/Cancel; 0x2 = Abort/Retry/Ignore; 0x3 = Yes/No/Cancel; 0x4 = Yes/No; 0x5 = Retry/Cancel; 0x6 = Cancel/Try Again/Continue
        ; 0x10 = stop/error icon; 0x20 = question icon; 0x30 = exclamation icon; 0x40 = asterisk/info icon
        MsgBox("The application is not running. The script will not execute.", "Warcraft I: Remastered - Utility Script", 0 + 0x40)
        Return
    }

    ; Ensures the application is active
    if !WinActive(appTitle) {
        MsgBox("Please make sure that the application is active.", "Warcraft I: Remastered - Utility Script", 0 + 0x40)
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
        MsgBox("The application is not running. The script will not execute.", "Warcraft I: Remastered - Utility Script", 0 + 0x40)
        Return
    }

    ; Ensures the application is active
    if !WinActive(appTitle) {
        MsgBox("Please make sure that the application is active.", "Warcraft I: Remastered - Utility Script", 0 + 0x40)
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
        MsgBox("The application is not running. The script will not execute.", "Warcraft I: Remastered - Utility Script", 0 + 0x40)
        Return
    }

    if !WinActive(appTitle) {
        MsgBox("Please make sure that the application is active.", "Warcraft I: Remastered - Utility Script", 0 + 0x40)
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
        ; If the image is not found, it shows a message box
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
        MsgBox("The application is not running. The script will not execute.", "Warcraft I: Remastered - Utility Script", 0 + 0x40)
        Return
    }

    if !WinActive(appTitle) {
        MsgBox("Please make sure that the application is active.", "Warcraft I: Remastered - Utility Script", 0 + 0x40)
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
        MsgBox("The application is not running. The script will not execute.", "Warcraft I: Remastered - Utility Script", 0 + 0x40)
        Return
    }

    if !WinActive(appTitle) {
        MsgBox("Please make sure that the application is active.", "Warcraft I: Remastered - Utility Script", 0 + 0x40)
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
        MsgBox("The application is not running. The script will not execute.", "Warcraft I: Remastered - Utility Script", 0 + 0x40)
        Return
    }

    if !WinActive(appTitle) {
        MsgBox("Please make sure that the application is active.", "Warcraft I: Remastered - Utility Script", 0 + 0x40)
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



; -----------------------------------------------------------------------------     Deletes all save game files     ----------------------------------------------------------------------------- ;
^+D:: { ; ^+D = CTRL SHIFT D
    global saveGameDirectory
    global FileList := Array()

    ; Confirmation dialog
    userChoice := MsgBox("Are you sure you want to PERMANENTLY delete ALL your save game files? `n`nWARNING: This action cannot be undone!", "Warcraft I: Remastered - Utility Script", 0x4 + 0x30)
    if (userChoice = "Yes") {
        try {
            ; Checks if the directory exists
            if FileExist(saveGameDirectory) {
                ; Gets the list of files in the directory
                Loop Files saveGameDirectory "\*.*" { ; \*.* = wildcard that matches all files (with any extension) within the directory 
                    ; Checks if the file fits into the "save game file" pattern
                    if (A_LoopFileName ~= ".*\.sav$") {
                        ; ~= = regular expression match operator, it checks if the string on the left matches the regular expression on the right
                        ; .* = any character (except a new line), zero or more times of the preceding character (in this case, any character)
                        ; \ = escape character, it allows you to use special characters in a string
                        ; \. = a literal dot
                        ; $ = matches the end of the string
                        FileList.Push(A_LoopFileName) ; Pushes the file name into the FileList array
                    }
                }
            } else {
                MsgBox("The save game directory does not exist:`n" saveGameDirectory "`n`nPlease play the game first.`nTrust me, it's worth it.", "Warcraft I: Remastered - Utility Script", 0 + 0x40)
                Return
            }

            ; Checks if there are any save game files in the directory
            if (FileList.Length = 0) {
                MsgBox("No save game files were found in the specified directory:`n" saveGameDirectory, "Warcraft I: Remastered - Utility Script", 0 + 0x10)
                Return
            } else {
                ; Verifier of values stored in FileList
                ; for index, value in FileList { ; info: arrays in AHK v2 are 1-based
                ;     MsgBox value
                ; }

                ; Deletes all save game files
                for _, fileName in FileList { ; _ = underscore, index, it is a convention to indicate that the variable is not used (placeholder)
                FileDelete saveGameDirectory "\" fileName
                }

                MsgBox("Operation successful! `n`nAll save game files have been deleted from:`n" saveGameDirectory, "Warcraft I: Remastered - Utility Script", 0 + 0x40)
            }
        } catch {
            MsgBox("Conflict(s) encountered! `n`nPlease press the assigned key again.", "Warcraft I: Remastered - Utility Script", 0 + 0x10)
        }
    } else {
        MsgBox("Operation cancelled! `n`nNo save game files were deleted.", "Warcraft I: Remastered - Utility Script", 0 + 0x40)
        Return
    }

    Sleep 50
    Return
}


; ---------------------------------------------------     Moves all save game files to a new OldSaveGames folder     ---------------------------------------------------- ;
^+M:: { ; ^+M = CTRL SHIFT M
    global saveGameDirectory
    global FileList := Array()

    global oldSaveGamesCounter
    global oldSaveGamesCounterFile

    try {
        ; Checks if the directory exists
        if FileExist(saveGameDirectory) {
            ; Gets the list of files in the directory
            Loop Files saveGameDirectory "\*.*" { ; \*.* = wildcard that matches all files (with any extension) within the directory 
                ; Checks if the file fits into the "save game file" pattern
                if (A_LoopFileName ~= ".*\.sav$") {
                    ; ~= = regular expression match operator, it checks if the string on the left matches the regular expression on the right
                    ; .* = any character (except a new line), zero or more times of the preceding character (in this case, any character)
                    ; \ = escape character, it allows you to use special characters in a string
                    ; \. = a literal dot
                    ; $ = matches the end of the string
                    FileList.Push(A_LoopFileName) ; Pushes the file name into the FileList array
                }
            }
        } else {
            MsgBox("The save game directory does not exist:`n" saveGameDirectory "`n`nPlease play the game first.`nTrust me, it's worth it.", "Warcraft I: Remastered - Utility Script", 0 + 0x40)
            Return
        }

        ; Checks if there are any save game files in the directory
        if (FileList.Length = 0) {
            MsgBox("ERROR! `n`nNo save game files were moved! `nReason: None were found in the main directory:`n" saveGameDirectory, "Warcraft I: Remastered - Utility Script", 0 + 0x10)
            Return
        } else {
            try {
                Loop Files saveGameDirectory "\OldSaveGames*", "D" { ; "D" = directories only
                    if (A_LoopFileName ~= "^OldSaveGames(\d+)$") {
                        ; ^ = ensures that the match starts at the beginning of the folder name
                        ; () = capturing the digits as a group, so we can extract them
                        ; \d = any digit (0-9)
                        ; + = one or more times => more than one digit
                        ; $ = ensures that the match ends at the end of the folder name
            
                        num := RegExReplace(A_LoopFileName, "^OldSaveGames(\d+)$", "$1")
                        ; RegExReplace = replaces the matched string with a value
                        ; $1 = the first capturing group in the regular expression
                        if (num > oldSaveGamesCounter)
                            oldSaveGamesCounter := num
                    }
                }
                ; MsgBox "At least one OldSaveGames directory already exists here: `n" saveGameDirectory
            } catch {
                ; MsgBox "No OldSaveGames directory was found!"
            }

            if (oldSaveGamesCounter = 0)
                oldSaveGamesCounter := 1
            else
                oldSaveGamesCounter++

            ; first step
            try FileDelete oldSaveGamesCounterFile
            catch {
                ; MsgBox "OldSaveGamesCounterFile not found!"
            }

            FileAppend oldSaveGamesCounter, oldSaveGamesCounterFile

            ; second step
            DirCreate saveGameDirectory "\OldSaveGames" oldSaveGamesCounter

            ; Moves all save game files
            for _, fileName in FileList {
            FileMove saveGameDirectory "\" fileName, saveGameDirectory "\OldSaveGames" oldSaveGamesCounter, false ; false = no overwrite
            }

            MsgBox("Operation successful! `n`nYour old save game files have been moved to:`n" saveGameDirectory "\OldSaveGames" oldSaveGamesCounter, "Warcraft I: Remastered - Utility Script", 0 + 0x40)
        }
    } catch {
        MsgBox("Conflict(s) encountered! `n`nPlease press the assigned key again.", "Warcraft I: Remastered - Utility Script", 0 + 0x10)
    }

    Sleep 50
    Return
}


; ---------------------------------------------------     Unlocks all campaign levels - requires a restart of the game     ---------------------------------------------------- ;
^+U:: { ; ^+C = CTRL SHIFT U
    global saveGameDirectory

    try {
        ; Checks if the required file actually exists
        if FileExist(saveGameDirectory "\GlobalSave.json") {
            ; Creates a backup of the original file
            FileMove saveGameDirectory "\GlobalSave.json", saveGameDirectory "\OldGlobalSave.json"

            ; UnlockAllOrcLevels := '{"missionsCompleted":{"orc":12,"human":0}}'
            ; UnlockAllHumanLevels := '{"missionsCompleted":{"orc":0,"human":12}}'
            UnlockBothCampaignLevels := '{"missionsCompleted":{"orc":12,"human":12}}'

            FileAppend UnlockBothCampaignLevels, saveGameDirectory "\GlobalSave.json"

            if WinExist(appTitle) {
                MsgBox("Operation successful! `n`nWARNING: The game is currently running! `nPlease restart the game in order to apply the changes - unlocking all campaign levels.", "Warcraft I: Remastered - Utility Script", 0 + 0x40)
            } else {
                MsgBox("Operation successful! `n`nYou've just unlocked all campaign levels.", "Warcraft I: Remastered - Utility Script", 0 + 0x40)
            }
        } else {
            MsgBox("The 'GlobalSave.json' file does not exist in the default folder: `n" saveGameDirectory "`n`nPlease play the game first.`nTrust me, it's worth it.", "Warcraft I: Remastered - Utility Script", 0 + 0x40)
            Return
        }
    } catch {
        MsgBox("No changes were made! `n`nReason: You've already unlocked all campaign levels.", "Warcraft I: Remastered - Utility Script", 0 + 0x30)
    }

    Sleep 50
    Return
}