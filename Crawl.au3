#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\..\Desktop\instagram.ico
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <IE.au3>
#include <_HttpRequest.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 615, 437, 192, 124)
$link = GUICtrlCreateInput("", 192, 96, 289, 31)
GUICtrlSetFont(-1, 14, 400, 0, "Arial Narrow")
$Label1 = GUICtrlCreateLabel("Link to HashTag:", 48, 96, 121, 27)
GUICtrlSetFont(-1, 14, 400, 0, "Arial Narrow")
GUICtrlSetColor(-1, 0x000000)
$run = GUICtrlCreateButton("Run", 496, 96, 73, 33)
GUICtrlSetBkColor(-1, 0x00FFFF)
$stop = GUICtrlCreateButton("Export get ", 48, 296, 249, 81)
GUICtrlSetFont(-1, 17, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xFF0000)
;GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetCursor (-1, 0)
$Result = GUICtrlCreateEdit("", 48, 168, 521, 113)
GUICtrlSetData(-1, "Result")
;GUICtrlSetState(-1, $GUI_DISABLE)
$command = GUICtrlCreateInput("", 192, 32, 281, 34)
GUICtrlSetFont(-1, 14, 400, 0, "Open Sans")
$Label2 = GUICtrlCreateLabel("Command:", 80, 40, 95, 26)
GUICtrlSetFont(-1, 12, 800, 0, "Open Sans")
$Label3 = GUICtrlCreateLabel("Fill Stop to stop, pause to pause", 224, 72, 118, 17)
GUICtrlSetBkColor(-1, 0xA0A0A4)
$execute = GUICtrlCreateButton("Execute", 312, 296, 249, 81)
GUICtrlSetFont(-1, 17, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0x008080)
;GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetCursor (-1, 0)
$Label2 = GUICtrlCreateLabel("Status:", 200, 392, 75, 17)
$status = GUICtrlCreateLabel("Waiting...", 256, 392, 49, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
$check = True;
HotKeySet("^q", "_Exit")
Global $json_dir = @ScriptDir & '/links.txt'
Global $count = 1;
Global $elements = []
$first = True
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			_Exit()
		Case $run
			If $check == False Then
				MsgBox(0,0,"Exit Loop")
				ExitLoop
			EndIf
			GUICtrlSetData($run,"Resume")
			GUICtrlSetState($run,$GUI_DISABLE)
			GUICtrlSetData($command,"")
			If $first == True Then
				$txtlink = GUICtrlRead($link)
				Global $oIE = _IECreate($txtlink)
				$first = False;
			EndIf
			Sleep(5000);
			While 1
				If GUICtrlRead($command) == "stop" Then
						MsgBox(0,0,"Stopped get data")
						GUICtrlSetState($stop,$GUI_ENABLE)
						GUICtrlSetState($execute,$GUI_ENABLE)
						GUICtrlSetState($run,$GUI_ENABLE)
						ExitLoop
				EndIf
				If GUICtrlRead($command) == "pause" Then
					GUICtrlSetState($run,$GUI_ENABLE)
					ContinueLoop
				EndIf
				doGet()
			WEnd
		Case $stop
			Run(@ScriptDir & '\export.cmd',"",@SW_HIDE)
			;Run('Explorer.exe ' & @ScriptDir)
			MsgBox(0,0,"Export Success. (Export.xlsx)")
		Case $execute

			While 1
				If GUICtrlRead($command) == "stop" Then
						MsgBox(0,0,"Stopped Execute")

						GUICtrlSetState($command,"")
						ExitLoop
				EndIf
				If FileExists($json_dir) Then
					$size = FileGetSize($json_dir)
					If $size  < 1 Then
						MsgBox(0,0,"End execute")
						ExitLoop
					EndIf
					GUICtrlSetData($status,"Running ...")
					Run( @ScriptDir & '\run.cmd',"",@SW_HIDE)
					Sleep(4000)
					GUICtrlSetData($status,"Waiting ...")
					Sleep(2000)
				Else
					ExitLoop
				EndIf
			WEnd
	EndSwitch
WEnd

Func _Exit()
	_IEQuit($oIE)
    Exit
 EndFunc

Func doGet()
		_ArrayUnique($elements)
		$oIE.document.documentElement.scrollTop = $oIE.document.body.scrollHeight
		Sleep(4000)
		$arr = $oIE.document.querySelector('.qxft6 > div:nth-child(4) > div:nth-child(1)').children;

		Global $c = 1;
		ConsoleWrite(UBound($arr))
		For $i in $arr
			ConsoleWrite("Count:" & $c & "  ")
			getA($i.children)
			$c = $c +1;
		Next
		Sleep(5000)
		$count = $count  + 1
		If $count > 10 Then
			;Do something
			;Run( @ScriptDir & '\run.cmd')
		EndIf
		Sleep(5000)
EndFunc
Func getA($as)
	Local $elements_local = []
	For $j in $as
	_ArrayAdd($elements,$j.firstChild.href )
	_ArrayAdd($elements_local,$j.firstChild.href )
	Next
	;$string = '["' & _ArrayToString($elements,  '",' ) &  '"]'
	GUICtrlSetData($Result,_ArrayToString($elements,  ',' ))

	If FileExists($json_dir) Then FileDelete($json_dir)
	_FileWriteFromArray($json_dir,$elements)
EndFunc