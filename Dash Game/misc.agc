/*

   Copyright 2022-2023 Tweak4141

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
global backGroundMusic as integer
global openingMusic as integer
global playerLoseSound as integer
global playerRunSound as integer
global playerJumpSound as integer
global gameOverSound as integer
global explosionSound as integer
global robotDeathSound as integer

global backgroundId as integer

function Delay(seconds#)
    ResetTimer()
    repeat
		Sync()
	until Timer() >= seconds#
endfunction

function CreateBackground()
	backgroundId = CreateSprite(LoadImageResized("background/background.png", 1.01, 1.01, 0))
	FixSpriteToScreen(backgroundId, 0)
endfunction

function ShowBackground()
	RevealObject(backgroundId)
	
	if playingMusic = 0
		StopMusicOGG(backGroundMusic)
		Delay(1)
		PlayMusicOGG(openingMusic, 1)
		playingMusic = 1
	endif
endfunction

function HideBackground()
	FadeObject(backgroundId)
	
	playingMusic = 0
endfunction

function CreateTextEntities ( )
    font = LoadImage ("background/ascii.png") //text font

    CreateText (10, "SCORE: 0")
	SetTextPosition (10, 0, 60)
	SetTextSize (10, 20)
	SetTextFontImage (10, font)
	SetTextColorAlpha (10, 0)
	SetTextVisible (10, 0)
	FixTextToScreen (10, 1)

	CreateText (2, "LIVES: 3")
	SetTextPosition (2, 300, 60)
	SetTextSize (2, 20)
	SetTextFontImage (2, font)
	SetTextColorAlpha (2, 0)
	SetTextVisible (2, 0)
	FixTextToScreen (2, 1)

	CreateText (3, "START GAME")
	SetTextPosition ( 3, GetVirtualWidth() / 2, GetVirtualHeight() / 2 )
	SetTextSize (3, 40)
	SetTextAlignment(3, 1)
	SetTextFontImage (3, font)
	FixTextToScreen (3, 1)
	SetTextColorAlpha (3, 0)
	SetTextVisible (3, 0)
	
	CreateText ( 4, "HIT ENTER TO CONTINUE" )
	SetTextPosition (4, GetVirtualWidth() / 2, GetVirtualHeight() / 2)
	SetTextSize (4, 20)
	SetTextAlignment(4, 1)
	SetTextFontImage (4, font)
	FixTextToScreen (4, 1)
	SetTextColorAlpha (4, 0)
	SetTextVisible (4, 0)
endfunction

function FadeInEndText()
	// fade in text
    SetTextColorAlpha (3, GetTextColorAlpha (3) + 2)
	SetTextVisible (3, 1)
	SetTextColorAlpha ( 4, GetTextColorAlpha (3) + 2)
	SetTextVisible (4, 1)
endfunction

function UpdateText() //Updates the score text and lives left
	if playerState <> 1 and gameState = 1 then inc playerScore

	line$ = "SCORE: " + str (playerScore)
	SetTextString ( 10, line$ )

	line$ = "LIVES: " + str (playerLives)
    SetTextString (2, line$)
endfunction

function RevealObject(spriteId as integer)
	if GetSpriteColorAlpha(spriteId) <> 0 then exitfunction
    For i = 0 to 255 step 30
        SetSpriteColorAlpha(spriteId, i)
        Sync()
    Next i
    
    SetSpriteColorAlpha(spriteId, 255)
endfunction

function FadeObject(spriteId as integer)
    if GetSpriteColorAlpha(spriteId) <> 255 then exitfunction 
    For i = 255 to 0 step -30
        SetSpriteColorAlpha(spriteId, i)
        Sync()
    Next i
    
    SetSpriteColorAlpha(spriteId, 0)
    
endfunction

function CreateMusic()
    backGroundMusic = LoadMusicOGG ("sound/backgroundmusic2.ogg" )
	SetMusicFileVolume (backGroundMusic, 100)

	openingMusic = LoadMusicOGG("sound/openingmusic.ogg")
	SetMusicFileVolume (openingMusic, 70)
	
	SetMusicSystemVolumeOGG(20)
	
	playerLoseSound = LoadSoundOGG("sound/playerlose.ogg")
	playerRunSound = LoadSoundOGG("sound/playerrun.ogg")
	playerJumpSound = LoadSoundOGG("sound/playerjump.ogg")
	gameOverSound = LoadSoundOGG("sound/gameover.ogg")
	explosionSound = LoadSoundOGG("sound/explosion.ogg")
	robotDeathSound = LoadSoundOGG("sound/robotdeath.ogg")
	SetSoundInstanceVolume(robotDeathSound, 50)
endfunction

