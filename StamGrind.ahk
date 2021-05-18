; Start the script with Win+G AFTER choosing NO support character.
#g::

; Flag for the type of run.
; 0: No stamina used. Useful for outside of WoI
; 1: Orbs (15 sp)
; 2: Summon Boards/Edojas (50 sp)
farmFlag := 0

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
; Default 500/5 seconds.
sleepRetry := 500
; How long to wait for a single run.
; Set with charFlag. Default is 600ms/1 Minute.
sleepRun := 600

; How long loading takes (in milliseconds).
; Default 300/3 Seconds.
sleepLoad := 300

; The position to click to hit to start the runs.
clickStartPosX := 0
clickStartPosY := 0

; The position to click to hit the retry button.
clickRetryPosX := 0
clickRetryPosY := 0

; The position to click to hit the ok button on the Stamina prompt.
clickStamPosX := 0
clickStamPosY := 0

; The number of runs it takes for Stam to run out. Calculated based on farmFlag.
regRun := 0

; Used by the script to keep approximate track of how many runs per Stam refill.
currentStam := 200

; How much stamina per run.
stamPerRun := 0

; Literally just here so I don't need to update it in multiple places.
dexTitle := "Sir this is a Wendy's"

; Stam auto refill timer. Adds 1 stamina every 60 seconds.
SetTimer, Stam_Calc, 600

Switch %farmFlag%
{
	Case 1: ; Orbs.
		stamPerRun := 15
	Case 2: ; Summon Board/Edojas.
		stamPerRun := 50
	Default: ; No stam grinding.
		GoTo, No_Stam
}

Switch %charFlag%
{
	; TODO: get list of chars who can solo farm and optimize run time for each one.
	Case 0: ;Squall's optimization is currently UNIMPLEMENTED
		sleepRun := 0
	Case 1: ;Yuffie's optimization is currently UNIMPLEMENTED
		sleepRun := 0
	Default
		sleepRun := 600 ; It already defaults to this but just in case.
}

ControlClick, %clickStartPosX% %clickStartPosY%, %dexTitle%

currentStam := %currentStam% - %stamPerRun%

Sleep %sleepLoad% + %sleepRun%

Loop
{
	regRun = Format(":d", %currentStam% / %stamPerRun%)
	
	Loop %regRun%
	{
		Loop 2
		{
			ControlClick, %clickRetryPosX% %clickRetryPosY%, %dexTitle%
			Sleep, %sleepRetry%
		}
	
		Sleep %sleepRun%
	}
	
	ControlClick, %clickStamPosX% %clickStamPosY%, %dexTitle%
	Sleep, %sleepRetry%
	ControlClick, %clickRetryPosX% %clickRetryPosY%, %dexTitle%
	currentStam := %currentStam% + 200
	Sleep %sleepRun%
}

No_Stam:
Loop
	{
		Loop 2
		{
			ControlClick, %clickRetryPosX% %clickRetryPosY%, %dexTitle%
			Sleep, %sleepRetry%
		}
	
		Sleep %sleepRun%
	}


Stam_Calc:
currentStam := %currentStam% + 1
return