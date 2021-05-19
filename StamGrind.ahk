; Debug flag
; Displays a ToolTip with Debug information.
; True/False
debug := true

; Flag for the type of run.
; 0: No stamina used. Useful for outside of WoI
; 1: Orbs (15 sp)
; 2: Summon Boards/Edojas (50 sp)
farmFlag := 1

; Character flags. Use these to optimize the time of each run.
; UNIMPLEMENTED
; Each run is based on a MAXED character using AUTO+.
; Exceptions are noted beside the character.
; -1: Default (600ms/1 Minute per run)
; 0: Squall
; 1: Yuffie
; 2: yuna
; 3: Jack
; 4: Eight
; 5: Etc.
charFlag := -1

; How long to wait between "next" and "retry" (in milliseconds).
; Default 5000/5 seconds.
sleepRetry := 5000
; How long to wait for a single run.
; Set with charFlag. Default is 60000ms/1 Minute.
sleepRun := 60000

; How long loading takes (in milliseconds).
; Default 3000/3 Seconds.
sleepLoad := 3000

; The position to click to hit to start the runs.
clickStartPosX := 1250
clickStartPosY := 830

; The position to click to hit the retry button.
clickRetryPosX := 1030
clickRetryPosY := 830

; The position to click to hit the ok button on the Stamina prompt.
clickStamPosX := 935
clickStamPosY := 115

; The number of runs it takes for Stam to run out. Calculated based on farmFlag.
regRun := 0

; Used by the script to keep approximate track of how many runs per Stam refill.
currentStam := 200

; How much stamina per run.
stamPerRun := 0

; Literally just here so I don't need to update it in multiple places.
dexTitle := "ahk_exe SamsungDeX.exe"

; Stam auto refill timer. Adds 1 stamina every 3 minutes.
SetTimer, Stam_Calc, 180000

ControlClick, X%clickStartPosX% Y%clickStartPosY%, %dexTitle%

Switch farmFlag
{
	Case 1: ; Orbs.
		stamPerRun := 15
	Case 2: ; Summon Board/Edojas.
		stamPerRun := 50
	Default: ; No stam grinding.
		GoTo, No_Stam
}

Switch charFlag
{
	; TODO: get list of chars who can solo farm and optimize run time for each one.
	Case 0: ;Squall's optimization is currently UNIMPLEMENTED
		sleepRun := 0
	Case 1: ;Yuffie's optimization is currently UNIMPLEMENTED
		sleepRun := 0
	Default:
		sleepRun := 60000 ; It already defaults to this but just in case.
}

; Experimenting with different start hotkeys for different modes.
; Start the script with ctrl+shift+a AFTER choosing NO support character.
^!a::

currentStam -= stamPerRun


ToolTip, Loading..., 50, 50
Sleep, %sleepLoad%
ToolTip, First Run, 50, 50
Sleep, %sleepRun%

Loop
{
	regRun := Format("{:d}", currentStam // stamPerRun)
	
	

	Loop %regRun%
	{
		Loop 2
		{
			ControlClick, X%clickRetryPosX% Y%clickRetryPosY%, %dexTitle%
			Sleep, %sleepRetry%
		}
		
		currentStam -= stamPerRun
		
		if(debug)
		{
			DebugTip(currentStam, stamPerRun, regRun)
		}
		
		Sleep, %sleepRun%
	}
	
	ControlClick, X%clickStamPosX% Y%clickStamPosY%, %dexTitle%
	Sleep, %sleepRetry%
	ControlClick, X%clickRetryPosX% Y%clickRetryPosY%, %dexTitle%
	currentStam += 200
	Sleep, %sleepRun%
}

No_Stam:
Loop
	{
		Loop 2
		{
			ControlClick, X%clickRetryPosX% Y%clickRetryPosY%, %dexTitle%
			Sleep, %sleepRetry%
		}
	
		Sleep, %sleepRun%
	}


DebugTip(byRef currentStam, byRef stamPerRun, byRef regRun)
{
	ToolTip, Debug Window`nCurrent stamina`n%currentStam%`n`nStamina per run`n%stamPerRun%`n`nRuns between refills`n%regRun%, 50, 50
}

Stam_Calc:
currentStam++
return

^!z::ExitApp