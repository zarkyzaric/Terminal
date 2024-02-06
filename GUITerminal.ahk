;Header
#Requires Autohotkey v2.0
#SingleInstance Force
#Include <Functions> ; library for personalized functions
#Include <Paths> ;library for file locations and urls

;Gui Design

myGui := Gui("AlwaysOnTop -caption")
myGui.BackColor := "600000"
myGui.SetFont("s17 q5 cffe6e6","Consolas")
global Input := myGui.Add("Edit", "Background600000 -E0x200 Center x10 w377 h45")
global WinID := myGui.Hwnd
myGui.Show("W400 H50 y20")

;Input Handling  and Gui's Destruction

Destruction(t,shouldContinue := false) { ;for unknown reasons Destruction has to have 2 variables
    global Input
    if Input.Value == ""{
        myGui.Destroy()
        return
    }
    else if shouldContinue = true {
        if !(Terminal_1(Input.Value)){ ;If not found in first terminal, then go into a second one
            Terminal_2(Input.Value)
        }
    }
    myGui.Destroy()

}
; If Input Bar exists or is active the following hotkeys will do certain actions
HotIfWinExist("ahk_id " WinID) 
Hotkey("Escape",Destruction,"On") ; adds {Esc} hotkey if user wants to exit pop up

HotIfWinActive("ahk_id " WinID)
Hotkey("Enter",Destruction.Bind(,true),"On") ; adds {Enter} hotkey if user wants to send value into execution



Terminal_1(Input) {

    if Input==""
        return

    static Solos := Map(
    "docs", A_MyDocuments,
    "main", Main,
    "sup", Startup,
    "rem", RemNote,
    "fox", Firefox,
    "t", ahkTerminal,
    "h", "https://www.autohotkey.com/docs/v2/FAQ.htm",
    "latex", "C:\Users\LEPALALA\Documents\ENV\Work\KaTeX.htm",
    "h", "https://www.autohotkey.com/docs/v2/FAQ.htm",
    "trans", "https://translate.google.com/",
    )
    if !(Solos.Has(Input)) ; if it doesn't have corresponding key, it goes onto a next terminal
        return 0
    GoThrough(Solos,Input)
    return 1
}

Terminal_2(Input) {

    if Input==""
        return

    spacePos := InStr(Input, " ") ; returns 0 if not found
    if !(spacePos)
        return
    else{
        prefix := SubStr(Input, 1, spacePos - 1)
        command := SubStr(Input, spacePos + 1)
    }
    
    static FuncCalls := Map( 
        "y", YTSearch.Bind(Input),
        )

    GoThrough(FuncCalls,prefix)

    Static Clrs := Map(
        "hex", "https://www.w3schools.com/colors/colors_hex.asp",
        "picker", "https://www.w3schools.com/colors/colors_picker.asp",
        "mixer", "https://www.w3schools.com/colors/colors_mixer.asp",
        "converter", "https://www.w3schools.com/colors/colors_converter.asp",
        "scheme", "https://www.w3schools.com/colors/colors_schemes.asp",
    )
    static GPTs := Map(
        "ahk", gptAHK,
    )
    static Prefixes := Map(
        "g", GPTs,
        "c", Clrs,
    )

    if !(Prefixes.Has(prefix)) ; if prefix is not contained in Map, it exists program
        return
    for key in Prefixes { ; for loop for searching in for key matching with prefix
        if (key == prefix) { 
            Commands := Prefixes[key]
            for com in Commands { ; for loop for searching a command that should be executed
                if (com == command)
                    Run(Commands[com])
            } 
        }  
    }
}

GoThrough(Commands,command, SubCommands := Map.Call()){
    for key in Commands{
        if (StrCompare(key,command) == 0) {
            if !(IsObject(Commands[key])) 
                Run(Commands[key])
            else
                Commands[key].Call() ; or Commands[key]() works the same
        }
    }
}

YTSearch(input) {
    Run("https://www.youtube.com/results?search_query=" . StrReplace(SubStr(input,3,StrLen(input)), A_Space, "+"))
}
