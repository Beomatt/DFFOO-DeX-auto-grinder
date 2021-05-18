; Start the script with Win+G AFTER letting the game Auto+ a single round.
#g::

; Flag for the type of run.
; 1. Orbs (15 sp)
; 2. Summon Board (50? sp)
; 3. WoI farm (? sp)
farmFlag := 0

; How long to wait between "next" and "retry" (in milliseconds).
; Default 200/2 seconds.
sleepRetry := 200
; How long to wait between runs (in milliseconds).
; Default 600/1 minute.
sleepRun := 600

; How long loading takes (in milliseconds).
; Default 0/MUST BE USER SET.
sleepLoad := 0

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
		stamPerRun = 15
	Case 2: ; Summon Board.
		stamPerRun = 50
	Default: ; If no flag set don't even bother.
		stamPerRun = 0
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
	currentStam := %currentStam% + 200
	Sleep %sleepRun%
}

Stam_Calc:
currentStam := %currentStam% + 1
return