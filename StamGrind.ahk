: Start the script with Win+G AFTER letting the game Auto+ a single round.
#g::
: The number of runs it takes for Stam to run out.
regRun := 0
: The position to click to hit the retry button.
clickRetryPosX := 0
clickRetryPosY := 0

: The position to click to hit the ok button on the Stamina prompt.
clickStamPosX := 0
clickStamPosY := 0

: How long to wait between "next" and "retry" (in milliseconds).
: Default 200/2 seconds.
sleepRetry := 200
: How long to wait between runs (in milliseconds).
: Default 600/1 minute.
sleepRun := 600

: Literally just here so I don't need to update it in 2 places.
dexTitle := "Sir this is a Wendy's"

Loop
{
	: This if statement accounts for the first run being initiated manually.
	if(A_Index = 1)
	{
		%regRun% = %regRun% - 1
	}
	else if(A_Index = 2)
	{
		%regRun% = %regRun% + 1
	}
	
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
	Sleep %sleepRun%
}