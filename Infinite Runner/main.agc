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
// Name:
// Project: Infinite Runner 
// Created: 2022-04-08
// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "Infinite Runner" )
SetWindowSize( 640, 640, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 360, 640 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

//===================SETTINGS===========================
SetPrintSize(30)
//===================TYPES===========================
type coordinate_pair
    x as float
    y as float
endtype

type obstacle
	x as float
    y as float
    w as float
    h as float
    obsType as integer
endtype
/*
============ @type {float} x,y,w,h ================
Holds value of:
x axis
y axis
obstacle width
obstacle height
============ @type {integer} obsType ================
0 = red obstacle, hostile
1 = green obstacle, friendly
2 = blue obstacle, random chance, could be hostile or harmless.
*/
type obstacleTypeArray
    value as float
    color as integer
endtype
/*
============ @type {float} value ================
RGB value for corresponding color
============ @type {integer} color ================
0 = red obstacle
1 = green obstacle
2 = blue obstacle
*/
//===================VARIABLES===========================
//speed conf
speed = 10 //start speed
maxSpeed = 40 //Max speed for objects
speedIncreaseBy = 0.6 //speed increases by
//player conf
playerSpeed = 10
//game vars
liveObs = 0 
startScreen = 1
instructions = 1
score = 0
// Create Sprites
gosub createSprites
// ==============MAIN CODE=================================
do
	gosub startScreen
	gosub instructions
	print( "Infinite Runner" )
    print("Score: " + Str(Score))
    print("Speed: " + Str(speed))
    print("Player Speed: " + Str(playerSpeed))
    gosub movePlayer
    gosub moveObs
    gosub collision
    Sync()
loop

//===================SUBROUTINES===========================
createSprites:
	
	// create Background
	CreateImageColor(1,128,128,128,255) //color of the background
	CreateSprite(1,1) //Uses image color sprite 1 from above
	SetSpriteSize(1, GetVirtualWidth(), GetVirtualHeight()) // make the sprite the size of the whole screen
	SetSpritePosition(1,0,0)

	// Make Player
	CreateImageColor(2,255,255,255,255)
	CreateSprite(2,2) // Uses image color sprite 2 from above to make sprite 2
	SetSpriteSize(2, 20, 20)
	player as coordinate_pair
	player.x = (GetVirtualWidth()-GetSpriteWidth(2))/2
	player.y = GetVirtualHeight() - GetSpriteHeight(2) - 10 // give a buffer for our player
	SetSpritePosition(2, player.x, player.y)
	// Make Obstacles
	obs as obstacle
	CreateImageColor(3,50,50,50,255)
	CreateSprite(3, 3) // Uses image color sprite 3 from above to make sprite 3
	obs.w = random(40,80)
	obs.h = random(40,80)
	SetSpriteSize(3, obs.w, obs.h)
	obs.x = random(0, GetVirtualWidth() - GetSpriteWidth(3))  // randomly choose a value between 1 and our width
	obs.y = 50
	SetSpritePosition(3, obs.x, obs.y)
	SetSpriteVisible(3, 0)

return
//==============================================
startScreen:
	while startScreen = 1
		Print("Infinite Runner" + Chr(10) + "Press ENTER to begin" + Chr(10) + "Press ESC to quit")
		if GetRawKeyPressed(13) =  1 //Enter key
			startScreen = 0
		endif
		if GetRawKeyPressed(27) = 1 //esc
			end
		endif
		Sync()
	endwhile
return
//==============================================
instructions:
	while instructions = 1
		Print("Avoid Red Blocks" + Chr(10) + "Get Green Blocks" + Chr(10) + "Blue Blocks can act as a:" + Chr(10) + "- Red Block" + Chr(10) + "- Green Block" + Chr(10) + "Hit ENTER to start")
		if GetRawKeyPressed(13) =  1 //Enter key
			SetSpriteVisible(3, 1)
			instructions = 0
		endif
		Sync()
	endwhile
return
//==============================================

movePlayer:
	if speed > 30
		playerSpeed = 15
	endif
	if GetKeyboardExists() = 1
		if GetRawKeyState(65)=1
				player.x = player.x - playerSpeed
				if player.x < 0
					player.x = 0
				endif
				SetSpritePosition(2, player.x, player.y)
			else
				if GetRawKeyState(68) = 1
					player.x = player.x + playerSpeed
					if player.x > GetVirtualWidth() - GetSpriteWidth(2)
						player.x = GetVirtualWidth() - GetSpriteWidth(2)
					endif
					SetSpritePosition(2, player.x, player.y)
				endif
			endif
	endif
return

//==============================================

moveObs:
	
	if liveObs = 0
		resetObstacle(obs, 3)
		if speed < maxSpeed
			speed = speed + speedIncreaseBy
		endif
		liveObs = 1
	endif
	//obstacle movement
	obs.y = obs.y + speed
	SetSpritePosition(3, obs.x, obs.y)
	
	if GetSpriteY(3) > GetVirtualHeight()
		score =  score + 1
		liveObs = 0
	endif

return
// ==================================

collision:

	if GetSpriteCollision(3, 2)	
		if obs.obsType = 0
			centerPlayer(player, 2)
			do
				Print("Game Over!" + Chr(10) + "Your score is: " + Str(score) + Chr(10) + "Play again? (y) yes, (n) no")
				if GetRawKeyPressed(89) = 1
					ClearScreen()	
					startScreen = 1
					liveObs = 0
					score = 0
					speed = 10
					playerSpeed = 10
					exit
				else
					if GetRawKeyPressed(78) = 1
						end
					endif
				endif
				Sync()
			loop
		endif
		if obs.obsType = 1
			score =  score + 1 //hit the block successfully.
			liveObs = 0
		endif 
	endif
	
return	

//=============Functions==============
function resetObstacle(obs ref as obstacle, id)
	obs.y = 0
	obs.x = Random (0, GetVirtualWidth() -  GetSpriteWidth(id))
	obs.w = Random(40, 80)
	obs.h = Random(40, 80)
	SetSpriteSize(id, obs.w, obs.h)
	determineNextObstacle(obs, id)
endfunction

function determineNextObstacle(obs ref as obstacle, id)
	obsTypes as obstacleTypeArray[2]
	obsTypes[0].value = random(150, 255) : obsTypes[0].color = 0
	obsTypes[1].value = random(150, 255) : obsTypes[1].color = 1
	obsTypes[2].value = random(150, 255) : obsTypes[2].color = 2
	obsTypes.sort()
	obs.obsType = obsTypes[0].color
	if obsTypes[0].color = 0 //red
		obsTypes[0].value = 249
		obsTypes[1].value = 0
		obsTypes[2].value = 0
	endif
	if obsTypes[0].color = 1 //green
		obsTypes[0].value = 0
		obsTypes[1].value = 249
		obsTypes[2].value = 0
	endif
	if obsTypes[0].color = 2
		obs.obsType = random(0,1) //Blue is random, it could be your doom, or it could net you a point. 
		obsTypes[0].value = 0
		obsTypes[1].value = 0
		obsTypes[2].value = 249
	endif
	SetSpriteColor(id, obsTypes[0].value, obsTypes[1].value, obsTypes[2].value, 255)
endfunction

function centerPlayer(player ref as coordinate_pair, id)
	player.x = (GetVirtualWidth() - GetSpriteWidth(2))/2
	player.y = GetVirtualHeight() - GetSpriteHeight(2)
	SetSpritePosition(id, player.x, player.y)
endfunction
