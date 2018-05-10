#cs ----------------------------------------------------------------------------
 Author:         HoPollo

 Script Function:
	This script make sure your stream is not frozen or with black screen. (With OBS)
#ce ----------------------------------------------------------------------------

#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <AutoItConstants.au3>

Global $colors[] = []
Global $recheckTimer = 5000
Global $maxreTry = 5 ; change this if needed
Global $waitingScreenColor = 0x1A7FA9 ; update this to your waiting screen colors
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
   ; Change this to the position you want to check color (better take if from a part where your logo or something not moving is visible on your waiting scene)
   Local $colorpicked = PixelGetColor(617, 277)

   _ArrayAdd($colors, $colorpicked)
   ConsoleWrite("Color : " & $colorpicked & @CRLF)

   $size = Ubound($colors, 1) - 1
   If $size > 2 Then
	  If $colors[1] = $colors[3] And $colorpicked <> $waitingScreenColor Then
		 Unfreez()
		 _ArrayDelete($colors, 1)
	  Else
		 If $colors[3] = 0x000000 Then Beep(250, 500)
		 _ArrayDelete($colors, 1)
	  EndIf
   EndIf
EndFunc

Func Unfreez()
   ; I use only 2 scenes on my streaming pc, so to unfreez my rtmp source i just switch between them.
   ; you maybe want to replace that to mouseclick in most cases.
   Send("{DOWN}")
   Sleep(1500)
   Send("{UP}")
   Sleep(2000) ; wait to the rtmp to display video
EndFunc

Func ExitScript()
   MsgBox(0, "Exit", "Script exiting", 5)
   Exit
EndFunc

While 1
   Sleep(100)
WEnd