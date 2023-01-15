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

#include "KeyCommands.agc"

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

type lifeBarDisplay
	position as float
	spriteId as integer
	lifeSprites as integer [2]
	imageId as integer
endtype
//life bar
type player
	name as string
    x as float
    y as float
    lives as integer
    blocks as integer
    spriteId as integer
    lifeBar as lifeBarDisplay
endtype
//player
type gameBall
	x as float
    y as float  
    dirX as float
    dirY as float
    speed as integer
    spriteId as integer
    ballBounces as integer
endtype
//ball
type gameTextDisplay
    startScreenId as integer
    gameOverScreenId as integer
    hitEnterId as integer
    hitSpaceId as integer
    winnerId as integer	
endtype

type defaultGame
	gameOver as integer
    startScreen as integer
    players as player [1]
    ball as gameBall
    winner as string
	textDisplay as gameTextDisplay
endtype

// ======= Config Variables ====== //
	global game as defaultGame
	
	global playerLives = 3
	global speedIncrement = 2
	global numberPlayers = 1
	

// ======= Functions ======= //
function createBackground()
	spriteId = CreateSprite(LoadImage("background.png")) //Uses image color sprite 1 from above
	SetSpriteDepth (spriteId, 10000)
endfunction 

function centerBall(a ref as gameBall)
	a.x = GetVirtualWidth()/2 - GetSpriteWidth(a.spriteId)/2
	a.y = GetVirtualHeight()/2 - GetSpriteHeight(a.spriteId)/2
	SetSpritePosition(a.spriteId, a.x, a.y)
endfunction

function centerText(id)
	SetTextPosition(id, GetVirtualWidth()/2-GetTextTotalWidth(id)/2, GetVirtualHeight()/2-GetTextTotalHeight(id)/2)
endfunction

function startingPositions(a ref as player, b ref as player)
	a.x = 0
	a.y = GetVirtualHeight()/2 - GetSpriteHeight(a.spriteId)/2 //player 1
	b.y = GetVirtualHeight()/2 - GetSpriteHeight(b.spriteId)/2 //player 2
	b.x = GetVirtualWidth() - GetSpriteWidth(b.spriteId)
	SetSpritePosition(a.spriteId, a.x, a.y)
	SetSpritePosition(b.spriteId, b.x, b.y)
endfunction

function move(p ref as player, dir as integer)
    if dir = 0 //up
		p.y = p.y + 10 + game.ball.ballBounces
	endif
	
	if dir = 1 //down
		p.y = p.y - 10 - game.ball.ballBounces
	endif
	
	if p.y < 0
		p.y = 0
	endif
	
	if p.y > GetVirtualHeight() - GetSpriteHeight(p.spriteId) //bottom side
		p.y = GetVirtualHeight() - GetSpriteHeight(p.spriteId)
	endif
	
	SetSpritePosition(p.spriteId, p.x, p.y)
endfunction

function collision(p ref as player, g ref as defaultGame) //p ref as player, b ref as ball
   p.lives = p.lives - 1
   if p.lives <= 0
	   exitfunction 1
	endif
endfunction 0

function drawLifeBar(player ref as Player, x as float, y as float, increment as float)
	for currentSprite = 0 to player.lifeBar.lifeSprites.length
		spriteId = CreateSprite(player.lifeBar.imageId)
		SetSpritePosition(spriteId, x, y)
		player.lifeBar.lifeSprites[currentSprite] = spriteId
		x = x + increment
	next currentSprite
endfunction
function resetGameState(game ref as defaultGame) //default positions, all tracking vars cleared.
	startingPositions(game.players[0], game.players[1])
	centerBall(game.ball)
	game.startScreen = 1
	game.gameOver = 0
	game.ball.dirX = 10
	game.ball.dirY = 10
	game.ball.ballBounces = 0
	for i = 0 to game.players.length
		game.players[i].lives = 3
	next i
	
endfunction

// ======= Sprites ======== //


function createPlayerSprite()
	spriteId = CreateSprite(LoadImage("Pong Paddle.png"))
	SetSpritePhysicsOn(spriteId, 3)
endfunction spriteId

function createBallSprite(ball ref as gameBall)
	spriteId = CreateSprite(LoadImage("Pong Ball.png"))
	SetSpriteShapeCircle(spriteId, 0, 0, 20)
	SetSpritePhysicsOn(spriteId, 2)
	SetSpritePhysicsAngularVelocity(spriteId, 3)
	ball.spriteId = spriteId
endfunction 

function showStartScreen(textDisplay ref as gameTextDisplay, show as integer)
	SetTextVisible(textDisplay.startScreenId, show)
	SetTextVisible(textDisplay.hitEnterId, show)
	
endfunction

function showGameOverScreen(textDisplay ref as gameTextDisplay, show as integer)
	SetTextVisible(textDisplay.gameOverScreenId, show)
	SetTextVisible(textDisplay.hitSpaceId, show)
	SetTextString(textDisplay.winnerId, "The Winner is " + game.winner + "!")
	SetTextPosition(textDisplay.winnerId, GetVirtualWidth()/2-GetTextTotalWidth(textDisplay.winnerId)/2, GetVirtualHeight()/2 - GetTextTotalHeight(textDisplay.gameOverScreenId) - GetTextTotalHeight(textDisplay.winnerId))
	SetTextVisible(textDisplay.winnerId, show)
endfunction

function showGameScreen(game ref as defaultGame, show as integer)
	SetSpriteVisible(game.ball.spriteId, show)
	showPlayers(game, show)
endfunction

function showPlayers(game ref as defaultGame, show as integer)
	for i = 0 to game.players.length
		SetSpriteVisible(game.players[i].spriteId, show)
		showLifeBar(game.players[i].lifeBar, show)
	next i
endfunction

function showLifeBar(lifeBar ref as lifeBarDisplay, show as integer)
	for i = 0 to lifeBar.lifeSprites.length
		SetSpriteVisible(lifeBar.lifeSprites[i], show)
	next i 
endfunction

function createTextScreens(textDisplay ref as gameTextDisplay)
	spriteId = CreateText("Welcome to PONG!")
	SetTextColor (spriteId, 255, 255, 255, 255)
	SetTextSize(spriteId, 100)
	centerText(spriteId)
	textDisplay.startScreenId = spriteId
	
	spriteId = CreateText("Hit ENTER to play")
	SetTextColor (spriteId, 255, 255, 255, 255)
	SetTextSize(spriteId, 50)
	SetTextPosition(spriteId, GetVirtualWidth()/2-GetTextTotalWidth(spriteId)/2, GetVirtualHeight()- GetTextTotalHeight(spriteId))
	textDisplay.hitEnterId = spriteId
	
	spriteId = CreateText("Game Over")
	SetTextColor (spriteId, 255, 255, 255, 255)
	SetTextSize(spriteId, 100)
	centerText(spriteId)
	textDisplay.gameOverScreenId = spriteId
	
	spriteId = CreateText("Winner")
	SetTextColor (spriteId, 255, 255, 255, 255)
	SetTextSize(spriteId, 60)
	SetTextPosition(spriteId, GetVirtualWidth()/2-GetTextTotalWidth(spriteId)/2, GetVirtualHeight()/2 - GetTextTotalHeight(textDisplay.gameOverScreenId) - GetTextTotalHeight(spriteId))
	textDisplay.winnerId = spriteId
	
	spriteId = CreateText("Hit SPACE to continue")
	SetTextColor (spriteId, 255, 255, 255, 255)
	SetTextSize(spriteId, 50)
	SetTextPosition(spriteId, GetVirtualWidth()/2-GetTextTotalWidth(spriteId)/2, GetVirtualHeight()- GetTextTotalHeight(spriteId))
	textDisplay.HitSpaceId = spriteId
endfunction


function createLifeBarSprites(game ref as defaultGame)
	imageId = LoadImage("Player Life.png")
	for currentPlayer = 0 to game.players.length
		game.players[currentPlayer].lifeBar.imageId = imageId
	next currentPlayer
	
	game.players[0].lifeBar.position = 0
	
	spriteId = CreateSprite(imageId)
	
	game.players[1].lifeBar.position = GetVirtualWidth() - GetSpriteWidth(spriteId)
	
	DeleteSprite(spriteId) 
	
	drawLifeBar(game.players[0], game.players[0].lifeBar.position, 5, 50)
	drawLifeBar(game.players[1], game.players[1].lifeBar.position, 5, -50)
endfunction

function createPlayers(game ref as defaultGame)
	game.players.length = numberPlayers
	
	for i = 0 to numberPlayers
		game.players[i].spriteId = createPlayerSprite()
		//game.players[i].lifeBar.spriteId = createLifeBarSprite()
	next i
	
	game.players[0].name = "Player One"
	game.players[1].name = "Player Two"
	
endfunction

function initializeGame(game ref as defaultGame)
	createPlayers(game)
	createTextScreens(game.textDisplay)
	createBallSprite(game.ball)
	createLifeBarSprites(game)
	createBackground()
	showGameScreen(game, 0)
	showStartScreen(game.textDisplay, 1)
	showGameOverScreen(game.textDisplay, 0)
endfunction


initializeGame(game) //start new game
resetGameState(game) //ensure default positions
 
/*
		if lastBlink# + 1.0 <= timer()
			if GetTextVisible(game.textDisplay.hitEnterId) then SetTextVisible(game.textDisplay.hitEnterId,0) else SetTextVisible(game.textDisplay.hitEnterId,1)
			lastBlink# = timer()
		endif 
		*/
do
	gosub playerUI
	gosub ballMovement
	gosub playerMovement
	gosub UpdateLifeBar
    Sync()
loop

ballMovement:
	game.gameOver = 0 
	
    if GetSpriteX(game.ball.spriteId) < 0
		game.ball.dirX = 10 + game.ball.ballBounces
		game.gameOver = collision(game.players[0], game) //return 1 if no more lives
		if game.gameOver then game.winner = game.players[1].name //set winner
	endif
	
	if GetSpriteX(game.ball.spriteId) > GetVirtualWidth() - GetSpriteWidth(game.ball.spriteId) //right side
		game.ball.dirX = -10 - game.ball.ballBounces
		game.gameOver = collision(game.players[1], game)
		if game.gameOver then game.winner = game.players[0].name //set winner
	endif
	
	if game.gameOver then Return //exit out
	
	//y Bound
	if GetSpriteY(game.ball.spriteId) < 0 //top
		game.ball.dirY = 10 + game.ball.ballBounces
	endif
	
	if GetSpriteY(game.ball.spriteId) > GetVirtualHeight() - GetSpriteHeight(game.ball.spriteId) //bottom side
		game.ball.dirY = -10 - game.ball.ballBounces
	endif
	  
	if GetSpriteCollision(game.ball.spriteId, game.players[0].spriteId) = 1 //player 1
		game.ball.dirX = 10
		game.players[0].blocks = game.players[0].blocks + 1
		game.ball.ballBounces = game.ball.ballBounces + speedIncrement
	endif  
	//p2
	if GetSpriteCollision(game.ball.spriteId, game.players[1].spriteId) = 1   // player 2
		game.ball.dirX = -10 
		game.players[1].blocks = game.players[1].blocks + 1  //block increment
		game.ball.ballBounces = game.ball.ballBounces + speedIncrement //speed up ball
	endif
	
	game.ball.x = game.ball.x + game.ball.dirX //add x coordinate
	game.ball.y = game.ball.y + game.ball.dirY //add y coordinate
	
	SetSpritePosition(game.ball.spriteId, game.ball.x, game.ball.y) //ball movement
	
return

playerMovement:
	if GetKeyboardExists() = 0 then return
	
	if InputS() //Down, p1
		move(game.players[0], 0)
	endif

	if InputW() //Up, p1
		move(game.players[0], 1)
	endif
	
	if InputDown() //Down, p2
		move(game.players[1], 0)
	endif

	if InputUp() //Up, p2
		move(game.players[1], 1)
	endif

return

playerUI:
	while game.startScreen = 1 //start screen
		showStartScreen(game.textDisplay, 1)
		if InputEnter() //Enter key
			showGameScreen(game, 1) //start game
			game.startScreen = 0
			showStartScreen(game.textDisplay, 0)
		endif
		if InputEscape() //esc
			end
		endif
		Sync()
	endwhile
	
	while game.gameOver = 1 
		showGameScreen(game, 0) //hide sprites
		showGameOverScreen(game.textDisplay, 1)	
		if InputSpace() //space
			resetGameState(game)
			showGameOverScreen(game.textDisplay, 0)
		endif		
		if InputEscape() //esc
			end
		endif
		Sync()
	endwhile
	//showPlayerLives(game)
return

UpdateLifeBar:
	if game.startScreen = 1 or game.gameOver = 1 then Return
	
	for player = 0 to game.players.length
		for i = 0 to game.players[player].lifeBar.lifeSprites.length
			if i < game.players[player].lives 
				SetSpriteVisible(game.players[player].lifeBar.lifeSprites[i], 1)
			else
				SetSpriteVisible(game.players[player].lifeBar.lifeSprites[i], 0)
			endif
		next i
	next player
Return 
//show life bar
