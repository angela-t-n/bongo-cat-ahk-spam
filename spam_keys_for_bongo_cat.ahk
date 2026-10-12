; Basically just types stuff on a toggle
#Requires AutoHotkey v2.0
#SingleInstance Force

;
;
;
; ------ USER MODIFIABLE ------

; set the key combination to ctrl:[
KEY_COMBO_TO_TURN_ON_SCRIPT := "delete"

; hide the "Script: ON! / OFF!" tooltip after 1 second or not
TOGGLE_HIDE_SCRIPT_TOOLTIP := false

; spam these keys!
; can view a whole list of valid keys under the keynames
; https://www.autohotkey.com/docs/v2/lib/Send.htm#keynames
; apparently there's more than 12 function keys! i didn't know that
; surely F23 and 24 aren't used anywhere
KEY_SPAM := ["F24", "F23"]

; set the delay (in miliseconds) between each button press
; default: 25
; kinda found this range off of steam and a little bit of trial and error
; https://steamcommunity.com/sharedfiles/filedetails/?id=3679770188
ACTION_DELAY := 25

; set how much you want each increment to be when pressing
; the increment/decrement button
INC := 5

; ------ END OF USER MODIFIABLE -------
;
;
;

; flag of the script's on/off state
FLAG_TOGGLE := false

; allows for live adjusting of that delay
UpdateDelay(increment) {
    global ACTION_DELAY
    ACTION_DELAY := Max(25, ACTION_DELAY + increment)
    ToolTip("Action delay: " ACTION_DELAY " ms")
    SetTimer(() => ToolTip(), -1000)

    FLAG_TOGGLE ? SetTimer(SpamKey, ACTION_DELAY) : false
}
NumpadAdd:: {
    global INC
    UpdateDelay(INC)
}

NumpadSub:: {
    global INC
    UpdateDelay(-INC)
}

; link these together as a hotkey!
Hotkey(KEY_COMBO_TO_TURN_ON_SCRIPT, main)

main(*) {
    ; upon entering the class, revert the state of toggle
    ; this runs everytime the hotkey is pressed!
    global FLAG_TOGGLE
    FLAG_TOGGLE := !FLAG_TOGGLE

    ; show a tooltip that'll kinda stay stuck to your screen somewhere
    ; until you either increment the delay thingy or quit the script
    ; idk, I kinda like it :3
    status := FLAG_TOGGLE ? "ON" : "OFF"
    ToolTip("Script: " status "!")
    TOGGLE_HIDE_SCRIPT_TOOLTIP ? SetTimer(() => ToolTip(), -1000) : false

    ; if the toggle is still on, spam the key
    if FLAG_TOGGLE
        ; send the keypress by a specific milisecond
        ; runs repeatedly if it's a positive int, once if negative
        ; this kinda determines how fast it spams it
        SetTimer(SpamKey, ACTION_DELAY)
    else
    ; disable the timer by setting it to 0 for that func
        SetTimer(SpamKey, 0)
}

SpamKey() {
    ; turns out we need more keys to spam...
    global KEY_SPAM
    global ACTION_DELAY
    index := Random(1, KEY_SPAM.Length)
    currKey := KEY_SPAM[index]

    Send("{" . currKey . " Down}")
    Sleep(ACTION_DELAY)
    Send("{" . currKey . " Up}")
}
