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
// Project: Sprites 
// Created: 2022-04-04

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "Sprites" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts
// ======= Types   ======== //
type coordinate_pair
    x as float
    y as float
endtype
// ======= Variables ====== //
	egg_dir as coordinate_pair
	Pikachu_Coordinates as coordinate_pair
	direction_egg as coordinate_pair
	direction_egg.x = 15
	direction_egg.y = 15
	global lives = 5
	game_time = 60
// Audio
LoadSound(1, "Hit.wav")

// ======= Functions ======= //
function getRandomCoordinates(a ref as coordinate_pair, id)
	Random_X = random(0, GetVirtualWidth() - GetSpriteWidth(id))
    Random_Y = random(0, GetVirtualHeight() - GetSpriteHeight(id))
    a.x = Random_X
    a.y = Random_Y
endfunction

function centerCoordinates(a ref as coordinate_pair, id)
	a.x = GetVirtualWidth()/2 - GetSpriteWidth(id)/2
	a.y = GetVirtualHeight()/2 - GetSpriteHeight(id)/2
endfunction

function resetGameState()
	SetTextVisible(4, 1)
	SetSpriteVisible(4, 1)
	SetSpriteVisible(5, 0)
	SetSpriteVisible(3, 1)
	SetSpriteVisible(2, 1)
	SetTextVisible(1, 0)
	ResetTimer()
endfunction
// ======= Sprites ======== //
CreateImageColor(1, 80, 180, 198, 100)
CreateSprite(1,1)
SetSpriteSize(1, GetVirtualWidth(), GetVirtualHeight()) //Background
SetSpriteVisible(1, 0)

CreateImageColor(5, 125, 221, 185, 255) //#7dddba
CreateSprite(5,5)
SetSpriteSize(5, GetVirtualWidth(), GetVirtualHeight()) //Welcome
/*
Sprite_X = GetVirtualWidth()/2 - GetSpriteWidth(1)/2
Sprite_Y = GetVirtualHeight()/2 - GetSpriteHeight(1)/2
*/
//text
CreateText(1, "Game Over" + Chr(10) + "Do you want to play again? Y/N")
SetTextSize(1,50)
SetTextColor (1, 255, 255, 255, 255)
SetTextPosition(1, GetVirtualWidth()/2 - GetTextTotalWidth(1)/2, GetVirtualHeight()/2 - GetTextTotalHeight(1)/2)
SetTextVisible(1, 0)
CreateText(2, "Welcome to Egg Hunt!" + Chr(10) + "Survive for " + Str(game_time) + " seconds..." + Chr(10) + "And don't let the egg catch you.")
SetTextSize(2,50)
SetTextColor (2, 255, 255, 255, 255)
SetTextPosition(2,GetVirtualWidth()/2 - GetTextTotalWidth(1)/2, GetVirtualHeight()/2 - GetTextTotalHeight(2)/2)
SetTextVisible(2, 1)
CreateText(3, "Hit the Spacebar to play!")
SetTextSize(3,50)
SetTextColor (3, 255, 255, 255, 255)
SetTextPosition(3,GetVirtualWidth()/2 - GetTextTotalWidth(1)/2, GetVirtualHeight() - GetTextTotalHeight(3))
SetTextVisible(3, 1)
CreateText(4, "Time Remaining: No Timer Started" )
SetTextSize(4, 30)
SetTextColor (4, 255, 255, 255, 255)
SetTextPosition(4, 5, 50)
SetTextVisible(4, 0)
//end text
LoadImage(2, "Egg.png")
CreateSprite(2, 2)
LoadImage(3, "Pikachu.png")
CreateSprite(3, 3)
SetSpriteSize(3, 70, 70)
LoadImage(4, "Heart.png")
CreateSprite(4, 4)
SetSpriteSize(4, 50, 50)
SetSpriteVisible(2, 0)
SetSpriteVisible(3, 0)
SetSpriteVisible(4, 0)
//getRandomCoordinates(Pikachu_Coordinates, 3)
//SetSpritePosition(3, Pikachu_Coordinates.x, Pikachu_Coordinates.y)
Pikachu_Coordinates.x = GetVirtualWidth()/2 - GetSpriteWidth(3)/2
Pikachu_Coordinates.y = GetVirtualHeight()/2 - GetSpriteHeight(3)/2
SetSpritePosition(3, Pikachu_Coordinates.x, Pikachu_Coordinates.y)
do
	if GetRawKeyPressed(32) = 1 //spacebar hit
		SetTextVisible(2, 0) //egg hunt text not visible
		SetTextVisible(3, 0) //spacebar text not visible
		SetTextVisible(4, 1) //timer
		SetSpriteVisible(2, 1) //egg sprite
		SetSpriteVisible(3, 1) //Pikachu
		SetSpriteVisible(4, 1) //Hearts
		SetSpriteVisible(5, 0) //background
		ResetTimer()
		exit
	endif
	Sync()
	
loop

do
	//UI section
	livesX = 5
	for i = 1 to lives //hearts
		SetSpritePosition(4, livesX, 0) 
		DrawSprite(4) //add heart to screen
		livesX = livesX + 42 //spacing
	next i
	//timer	
	time = timer() - 0
	SetTextString(4, "Time Remaining: " + Str(game_time - time))
	//end ui
	if time = game_time and lives > 0 //Has lives remaining but countdown clock finished. Win.
		SetSpriteVisible(5, 1)
		SetTextString(1, "You won with " + Str(lives) + " lives remaining!" + Chr(10) + "Do you want to play again? Y/N")		
		SetTextVisible(1, 1)
		SetTextVisible(4, 0)
		SetSpriteVisible(4, 0)
		SetSpriteVisible(3, 0)
		SetSpriteVisible(2, 0)
		
		do
			if GetRawKeyState(89) = 1 //Y
				resetGameState() //reset game for next run
				lives = 5 //reset lives here
				exit 
			endif
			
			if GetRawKeyState(78) = 1 //N 
				end //exit program
			endif
			//exit
			Sync()
		loop
	endif
	
	if lives = 0 //no more lives, lose
		SetTextVisible(4, 0)
		SetTextVisible(1, 1)
		SetSpriteVisible(4, 0)
		SetSpriteVisible(3, 0)
		SetSpriteVisible(2, 0)
		do
			if GetRawKeyState(89) = 1 //Y
				ResetGameState() //reset game for next run 
				lives = 5 //reset lives here
				exit
			endif
			
			if GetRawKeyState(78) = 1 //N
				end
			endif
			//exit
			Sync()
		loop
	endif
	//end ui
	//pikachu movement
	if GetRawKeyState(83) = 1//w 
		Pikachu_Coordinates.y = Pikachu_Coordinates.y + 10
	endif
	if GetRawKeyState(65) = 1//a
		Pikachu_Coordinates.x = Pikachu_Coordinates.x - 10
	endif
	if GetRawKeyState(87) = 1//s
		Pikachu_Coordinates.y = Pikachu_Coordinates.y - 10
	endif
	if GetRawKeyState(68) = 1//d
		Pikachu_Coordinates.x = Pikachu_Coordinates.x + 10
	endif
	SetSpritePosition(3, Pikachu_Coordinates.x, Pikachu_Coordinates.y)
	//end pikachu movement
	//start pikachu boundaries
	//x boundaries
	    if GetSpriteX(3) < 0
		Pikachu_Coordinates.x = 0
	endif
	if GetSpriteX(3) > GetVirtualWidth() - GetSpriteWidth(3) //right side
		Pikachu_Coordinates.x = GetVirtualWidth() - GetSpriteWidth(3)
	endif
	
	//y Boundaries
	if GetSpriteY(3) < 0
		Pikachu_Coordinates.y = 0
	endif
	if GetSpriteY(3) > GetVirtualHeight() - GetSpriteHeight(3) //bottom side
		Pikachu_Coordinates.y = GetVirtualHeight() - GetSpriteWidth(3)
	endif
	//end pikachu boundaries
	//start sprite collision
	if GetSpriteCollision(2, 3) = 1
		PlaySound(1) //notify player of hit
		centerCoordinates(Pikachu_Coordinates, 3) //spawn pikachu in center
		SetSpritePosition(3, Pikachu_Coordinates.x, Pikachu_Coordinates.y)	
		getRandomCoordinates(egg_dir, 2) //spawn egg in random place
		while abs(egg_dir.x - Pikachu_Coordinates.x) < 250 and abs(egg_dir.y - Pikachu_Coordinates.y) < 250 
			/*
			use absolute value to determine egg distance from pikachu to ensure egg doesn;t spawn close.
			while egg is too close, get more random coordinates.
			*/
			getRandomCoordinates(egg_dir, 2)
		endwhile
		SetSpritePosition(2, egg_dir.x, egg_dir.y)
		lives = lives - 1 //subtract a life
    endif
	//egg boundaries
	//x bound
    if GetSpriteX(2) < 0
		direction_egg.x = 15
	endif
	if GetSpriteX(2) > GetVirtualWidth() - GetSpriteWidth(2) //right side
		direction_egg.x = -15
	endif
	
	//y Bound
	if GetSpriteY(2) < 0
		direction_egg.y = 15
	endif
	if GetSpriteY(2) > GetVirtualHeight() - GetSpriteHeight(2) //bottom side
		direction_egg.y = -15
	endif
	// Egg Movement
	egg_dir.x = egg_dir.x + direction_egg.x
	egg_dir.y = egg_dir.y + direction_egg.y
	SetSpritePosition(2, egg_dir.x, egg_dir.y)
    Sync()
loop

