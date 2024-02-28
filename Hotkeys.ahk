;{
    #Requires AutoHotkey v2.0 
    #Include <Functions>
    #Include <SettFunctions>
    #Include <Paths>
    
    /* GUIDE AND REMINDER
    
    ; Aktivira se bez {Space}
    :*:hotstring:: ; Ovaj hotstring će se automatski aktivirati kada se ukuca, bez pretiskanja {Space}
    
    ; Akcivira se sa {Space}
    ::hotstring::
    
    Karakteri koji se pišu umesto dugmića:
    # - Win
    ! - Alt
    + - Shift
    Primeri:
    
    */
    
    ;}t
    Search(input){
        if input == "c"
            input := A_Clipboard
        Run("https://duckduckgo.com/?t=ffab&q=" . StrReplace(input, A_Space, "+") . "&atb=v403-1&ia=web")
    }
    
    #!c::Run("C:\Users\LEPALALA\Documents\AutoHotkey\Scripts\Background Settings\Cmd.bat")
    ^!g::Run("https://chat.openai.com/c/2d6ba617-40be-496c-ad7d-05a851a44caf") ; GPT Random
    ^!s::Run("C:\Users\LEPALALA\Documents\AutoHotkey\Main\ShareXTerminal.ahk")
    #z::Run(Help)  ; Win+Z
    ^!t::{ ; Oglasna Tabla
        Run("https://imi.pmf.kg.ac.rs/oglasna-tabla") 
    } 
    ^!v:: ; VSC
    {
        UserInputHook(Options := "L1 T2", EndKeys := "{Enter}"){
            IH := InputHook(Options,EndKeys), IH.Start(), IH.Wait(), userInput := IH.Input
        Reason := IH.EndReason
        if (Reason == "EndKey")
            return userInput
        else 
            return userInput
        }
        input := UserInputHook("L5 T1.5")
        if input == "" {
            (Send("^!+v"),WinWait("AutoHotkey - VSCodium"), Sleep(2000), Send("^p"))
            return
        }
        WinExist("AutoHotkey - VSCodium") ? (WinActivate,SendIn("^p",0.3),SendIn(input,0.05),SendIn("{Enter}",0.2)) : (Send("+^!v"),WinWait("AutoHotkey - VSCodium"),SendIn("^p",2),SendIn(input,0.2),SendIn("{Enter}",1))
    }
    
    ^!k:: ; Gets Mouse Position
    {
        MouseGetPos &x, &y
        MsgBox("X: " x "`nY: " y)
        A_Clipboard := " " x . " , " y " "  
    }
    
    ^!+k::{ ; Gets Win x,y,ID,Class,Control,Title
        WatchCursor()
    }
    
    +!s::{ ; ScreenShot SCS ShareX
        Send("+!^{F6}")
    }
    
    RAlt:: ; Fast Terminal
    {
    GuiOptions := "AlwaysOnTop -caption Border"
    Font := "Consolas"
    FontColor := "ffe6e6"
    FontOptions := "s17 q5 bold"
    BGColor := "1e1e1e"
    SizeAndPosition := "w40 h38 x960 y700"
    EditBoxOptions := "-E0x200 -VScroll Center w35 h30 x1 y5.5"
    
    myGui := Gui(GuiOptions)
    myGui.BackColor := BGColor 
    myGui.SetFont(FontOptions " c" FontColor , Font) 
    global Input := myGui.Add("Edit", "Background" BGColor " " EditBoxOptions) ; Adds an Input(Edit) Box in GUI
    global WinID := myGui.Hwnd ; Saving Window handle for destroying GUI
    
    Destruction(t,shouldContinue := false) { ;for unknown reasons Destruction has to have 2 variables
        myGui.Destroy()
    }
    ; If Input Bar exists or is active the following hotkeys will do certain actions
    HotIfWinExist("ahk_id " WinID) 
        Hotkey("Escape",Destruction,"On") ; adds {Esc} hotkey if user wants to exit pop up
    HotIfWinActive("ahk_id " WinID)
        Hotkey("Enter",Destruction.Bind(,true),"On")
    myGui.Show(SizeAndPosition)
    
    IH := InputHook("L1 T1 V1",A_Space),IH.Start(),IH.Wait(),input := IH.Input
    SetTimer () => myGui.Destroy(), -50
    Fast := Map(
        "h", () => (Run(Help), Sleep(2000), Send("{F11}")),
        "o", () => Send("^!o"),
        "v", () => OpenVSC(AHK),   
        "d", () => YTtoMP(3),
        "i", "http://www.instagram.com/",
        "m", "https://www.youtube.com/watch?v=Q6MemVxEquE&t=272s",
        "w", "https://web.whatsapp.com",
        "k", "C:\Program Files\Krita (x64)\bin\krita.exe",
        "š", "https://www.chess.com/play",
        "l", "C:\Users\LEPALALA\Documents\ENV\Work\KaTeX.htm",
        "g", "https://chat.openai.com",
        "duo", "https://www.duolingo.com/",
        "t", "https://translate.google.com/",
        "c", Search.Bind(A_Clipboard),
        )
    GoThrough(Fast,input)
    
    GoThrough(Commands,command){
        for key in Commands{
            if (StrCompare(key,command) == 0) {
                if !(IsObject(Commands[key]))
                    Run(Commands[key])
                else
                    Commands[key].Call()
                return ; or Commands[key]() works the same
                }
            }
        } 
        return 
    }
    
    RControl::Run(Main "Terminal.ahk") 
    
    #HotIf !(WinActive("ahk_class gdkWindowToplevel"))
    ^!o:: ; Ctrl+Alt+O ==> Open Obsidian
    {
        global Obsidian
        AppTab := "New Tab - Main - Obsidian v1.4.16"
        If WinExist("AppTab")
            WinActivate()
        else
            Run(Obsidian)
        return
    }
    #HotIf
    ; RAlt +j/k ==> Switching trought tabs
    RAlt & k::AltTab    
    RAlt & j::ShiftAltTab
    ^!w:: ; Ctrl+Alt+W ==> Open RemNote 
    { 
        global RemNote
        AppTab := "RemNote | Your Notes"
        If WinExist("AppTab")
            WinActivate()
        else
            Run(RemNote)
    }
    #HotIf !WinActive("ahk_class Chrome_WidgetWin_1")
    ; Place mouse on file you want to edit and press Ctrl+E / same effect as Right Click and Edit
    ^e::Send("{RButton}e")
    
    #HotIf WinActive("ahk_class WorkerW")
    f7:: ; Show/Hide Desktop when desktop is active
    {
        SendIn("{RButton}",0.001)
        SendIn("{Down}",0.001)
        SendIn("{Right}",0.001)
        Loop 5 {
            SendIn("{Down}",0.001)
        }
        SendIn("{Enter}",0.001)
    }
    #HotIf
    
    !4:: ; Alt + 4 == Alt + F4
    {    
    Send("!{F4}")
    }
    
    #HotIf WinActive("ahk_class Chrome_WidgetWin_1")
    ^!l::{ ; Compiling LaTeX in VSC
        Sleep(1)
        Send("^!b")
        Sleep(1)
    
        Send("{Down 4}")
        Sleep(1)
        Send("{Enter}")
        Sleep(1)
    
    }
    #HotIf
    
    
    
    
    