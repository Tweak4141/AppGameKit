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
// Project: DashGame 
// Created: 2022-05-19
// Author: Tweak4141
// show all errors



SetErrorMode(2)

#constant ResolutionWidth 1280
#constant ResolutionHeight 720

// set window properties
SetWindowTitle( "DashGame" )
SetWindowSize( ResolutionWidth, ResolutionHeight, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( ResolutionWidth, ResolutionHeight ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts
SetPhysicsScale(0.02)
SetPhysicsGravity(0, 0)

// scenery
global dim scenery [ 6000 ] as integer
global sceneryCount as integer = 0
global groundY as integer
global playingMusic as integer = 0
global maxGameX as float = 0

// player data
global playerState = 0
global playerLives = 3
global playerScore = 0

type flyingObject
	spriteId as integer
	speed as float
endtype

global flyingObjectImage as integer = 0
global dim flyingObjects [ 1 ] as flyingObject

// other globals
global gameState = 0

// includes
#include "misc.agc"
#include "keycommands.agc"
#include "level.agc"
#include "flyingobjects.agc"
#include "player.agc"

//build game
Begin()

// main loop
do
    // check the state
    if gameState = 0 then ShowStartGame()
    if gameState = 1 then RunGame()
    if gameState = 2 then ShowEndGame()

    // update the screen
    Sync()
loop


function Begin()
    // load everything for the game
   SetVirtualResolution( ResolutionWidth, ResolutionHeight )

	CreateMusic()
    CreateLevel()
    CreatePlayer()
    CreateFlyingObjects()
    CreateTextEntities()
    CreateBackground()
    
    HidePlayer()
endfunction

function ShowStartGame()
	//start screen

	
	ShowBackground()
	
    // wait for input
    if GetPointerPressed() or InputEnter()
		
		StopMusicOGG(openingMusic)
		Delay(1)
				
        // set game over text for later on
		SetTextColorAlpha ( 3, 0 )
		SetTextVisible ( 3, 0 )
		SetTextPosition ( 3, GetVirtualWidth() / 2, GetVirtualHeight() / 2 - 50 )
		SetTextString ( 3, "GAME OVER" )
		SetTextAlignment(3, 1)
		SetTextVisible ( 4, 0 )
		SetTextVisible ( 10, 1 )
		SetTextVisible ( 2, 1 )

		HideBackground() 
		
		PlayMusicOGG(backGroundMusic, 1)
		
		// show the player
		ShowPlayer()
				
        // switch to in game state
        gameState = 1
	endif
endfunction

function RunGame()
    // main game
	
	
    // fade in on screen text
    SetTextColorAlpha(10, GetTextColorAlpha(10) + 2 )
	SetTextColorAlpha(2, GetTextColorAlpha(2) + 2 )

    // update the player
	UpdatePlayer()
	UpdateFlyingObjects()
	UpdateText()
endfunction

function ShowEndGame()
    // handle the end of the game
	HideFlyingObjects()
	
    // hide the player
	HidePlayer()
	
	FadeInEndText()
    // act on input
	if GetPointerPressed() or InputEnter()
        // reset scrolling
		SetViewOffset (0, 0)

        // reset player
		ResetPlayer()
		//reset all flying objects
		ResetFlyingObjects()
		
		SetTextVisible(4, 0) //hit enter
        // set start game text
		SetTextColorAlpha (3, 0)
		SetTextVisible (3, 1)
		SetTextPosition (3, GetVirtualWidth() / 2, GetVirtualHeight() / 2 )
		SetTextString (3, "START GAME" )
		SetTextAlignment(3, 1)
		SetTextVisible (2, 1)
		SetTextColorAlpha (10, 0)
		SetTextColorAlpha (2, 0)
		
        // reset globals
		playerState = 0
        playerLives = 3
		playerScore = 0
		gameState = 0
    endif
endfunction



