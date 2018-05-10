#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         HoPollo

 Script Function:
	This script make sure your stream is not frozen or with black screen for a long time. (With OBS)
#ce ----------------------------------------------------------------------------

#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <AutoItConstants.au3>

Global $colors[] = []
Global $recheckTimer = 5000
Global $maxreTry = 5
Global $waitingScreenColor = 0x1A7FA9
Global $i = 1

Requierments()

Func Requierments()
   $result64 = ProcessExists("obs64.exe")
   $result32 = ProcessExists("obs32.exe")

   If $i = $maxreTry Then ExitScript()

   If $result64 <> 0 Or $result32 <> 0 Then
	  Start()
   Else
	  MsgBox(0, "Error", "Obs not detected, attemps : " & $i &"/"& $maxreTry, 3)
	  $i = $i + 1

	  Requierments()
   EndIf
EndFunc

Func Start()

   Investigate()

   While 1
	  Sleep(5000)
	  Requierments()
	  ExitLoop
   WEnd
EndFunc

Func Investigate()
   Local $colorpicked = PixelGetColor(617, 277)

   _ArrayAdd($colors, $colorpicked)
   ConsoleWrite("Color : " & $colorpicked & @CRLF)

   $size = Ubound($colors, 1) - 1
   If $size > 2 Then
	  If $colors[1] = $colors[3] And $colorpicked <> $waitingScreenColor Then
		 Unfreez()
		 _ArrayDelete($colors, 1)
	  Else
		 If $colors[3] = 0x000000 Then
			Beep(250, 500)
		 EndIf
		 _ArrayDelete($colors, 1)
	  EndIf
   EndIf
EndFunc

Func Unfreez()
   Send("{DOWN}")
   Sleep(1500)
   Send("{UP}")
   Sleep(2000)
EndFunc

Func ExitScript()
   MsgBox(0, "Exit", "Script existing", 5)
   Exit
EndFunc

While 1
   Sleep(100)
WEnd