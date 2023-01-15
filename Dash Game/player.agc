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
#constant Standing 1
#constant RunningRight 2
#constant RunningLeft 3
#constant JumpingUp 4
#constant JumpingUpRight 5
#constant JumpingUpLeft 6
#constant JumpingDown 7
#constant JumpingDownRight 8
#constant JumpingDownLeft 9
#constant Sliding 10

#constant IdleFrameStart 1
#constant IdleFrameEnd 10
#constant RunFrameStart 11
#constant RunFrameEnd 18
#constant JumpUpFrameStart 19
#constant JumpUpFrameEnd 23
#constant JumpDownFrameStart 24
#constant JumpDownFrameEnd 28
#constant DeadFrameStart 29
#constant DeadFrameEnd 38
#constant SlideFrameStart 39
#constant SlideFrameEnd 48

global maxJumpHeight as integer = 500
global playerSprite as integer
global playerHeight as float
global particleSprite as integer
global barrelExplosion as integer = 0
global actionState as integer = Standing

function CreatePlayer()

	playerSprite = CreateSprite (0)
		
	scale as float = 0.25
	
	playerHeight = GetImageHeight(LoadImageResized("player/Idle (1).png", scale, scale, 0))
	
	for i = 1 to 10
		AddSpriteAnimationFrame(playerSprite, LoadImageResized("player/Idle (" + Str(i) + ").png", scale, scale, 0))
	next i

	for i = 1 to 8
		AddSpriteAnimationFrame(playerSprite, LoadImageResized("player/Run (" + Str(i) + ").png", scale, scale, 0))
	next i

	for i = 1 to 10
		AddSpriteAnimationFrame(playerSprite, LoadImageResized("player/Jump (" + Str(i) + ").png", scale, scale, 0))
	next i
	
	for i = 1 to 10
		AddSpriteAnimationFrame(playerSprite, LoadImageResized("player/Dead (" + Str(i) + ").png", scale, scale, 0))
	next i
	
	for i = 1 to 10
		AddSpriteAnimationFrame(playerSprite, LoadImageResized("player/Slide (" + Str(i) + ").png", scale, scale, 0))
	next i
	
	SetSpritePhysicsOn(playerSprite, 1)
	SetSpriteShape(playerSprite, 2)
	
	particleSprite = LoadImage("objects/particle.png")
	
	ResetPlayer()
endfunction

function PlayStanding()
	StopSound(playerRunSound)
	PlaySound(playerRunSound, 100, 1)
	PlaySprite(playerSprite, 10, 1, 11, 18)
endfunction

function PlayRunningLeft()
	StopSound(playerRunSound)
	PlaySound(playerRunSound, 100, 1)
	PlaySprite(playerSprite, 10, 1, 18, 11)
endfunction

function PlayRunningRight()
	StopSound(playerRunSound)
	PlaySound(playerRunSound, 100, 1)
	PlaySprite(playerSprite, 10, 1, 11, 18)
endfunction

function PlayJumpingUp()
	StopSound(playerRunSound)
	PlaySound(playerJumpSound)
	PlaySprite(playerSprite, 10, 0, 19, 23)
endfunction

function PlayJumpingDown()
	PlaySprite(playerSprite, 10, 0, 24, 28)
endfunction

function PlayingSliding()

endfunction

function ResetPlayer()
	SetSpritePosition(playerSprite, 20, groundY - playerHeight)
	barrelExplosion = CreateParticles ( -1000, -1000 )
endfunction

function HidePlayer()
    SetSpriteVisible(playerSprite, 0)
    StopSound(playerRunSound)
endfunction

function ShowPlayer()
	SetSpriteVisible(playerSprite, 1)
	PlayRunningRight()
	actionState = RunningRight
endfunction

function UpdatePlayer()
    select (playerState)
        case 0:
            MovePlayer()
            CheckPlayerWithScenery()
            CheckPlayerWithFlyingObjects()
        endcase
        case 1:
            DestroyPlayer()
        endcase
    endselect
endfunction

function KillPlayerGround()
	StopSound(playerRunSound)
	StopSound(playerJumpSound)
	PlaySound(robotDeathSound, 80)
	PlaySprite(playerSprite, 10, 0, DeadFrameStart, DeadFrameEnd)
	SetSpritePosition(playerSprite, GetSpriteX(playerSprite), groundY - (GetSpriteHeight(playerSprite) / 2))
	
	Delay(3)
	
	PlaySound(gameOverSound, 70)
    
    dec playerLives
    playerState = 1
endfunction

function KillPlayerObject(spriteId as integer)
	StopSound(playerRunSound)
	StopSound(playerJumpSound)
	PlaySound(explosionSound)
	
	ResetParticleCount(barrelExplosion)
	
	SetParticlesPosition(barrelExplosion, GetSpriteX(spriteId) + 30, GetSpriteY(spriteId) + 30)
    SetParticlesImage(barrelExplosion, particleSprite)	
	SetParticlesFrequency(barrelExplosion, 250)
    SetParticlesLife(barrelExplosion, 3.0)
    SetParticlesSize(barrelExplosion, 64)
    SetParticlesStartZone(barrelExplosion, 0, 0, 0, 0)
    SetParticlesDirection(barrelExplosion, 10, 10)
    SetParticlesAngle(barrelExplosion, 360)
    SetParticlesVelocityRange(barrelExplosion, 0.8, 2.5)
    SetParticlesMax(barrelExplosion, 400)
    AddParticlesColorKeyFrame(barrelExplosion, 0.0, 0, 0, 0, 0)
    AddParticlesColorKeyFrame(barrelExplosion, 0.5, 255, 255, 0, 255)
    AddParticlesColorKeyFrame(barrelExplosion, 2.8, 255, 0, 0, 0)
    AddParticlesForce(barrelExplosion, 2.0, 2.8, 25, -25)
	
	PlaySprite(playerSprite, 10, 0, DeadFrameStart, DeadFrameEnd)
	SetSpritePosition(playerSprite, GetSpriteX(playerSprite), groundY - playerHeight + 10)
	
	Delay(2)
	
	PlaySound(robotDeathSound, 80)

	Delay(3)
	
	PlaySound(gameOverSound, 70)
    dec playerLives
    playerState = 1
endfunction

function KillPlayerFlyingObject()
	StopSound(playerRunSound)
	StopSound(playerJumpSound)
	PlaySound(robotDeathSound, 80)
	
	y1# = GetSpriteY(playerSprite)
	y2# = groundY - playerHeight + 10
	
	PlayJumpingDown()
	
	while y1# < y2#
		SetSpritePosition(playerSprite, GetSpriteX(playerSprite), y1#)
		y1# = y1# + 10
		Sync()
	endwhile
	
	SetSpritePosition(playerSprite, GetSpriteX(playerSprite), y2#)
	
	PlaySprite(playerSprite, 10, 0, DeadFrameStart, DeadFrameEnd)
	
	Delay(3)
	
	PlaySound(gameOverSound, 70)
    
    dec playerLives
    playerState = 1
endfunction

function MovePlayer()
    //guard to if player doesn't die before game ends
    if GetViewOffsetX() > maxGameX
		HidePlayer()
		gameState = 2
		exitfunction
	endif 
    
    x# = 5.0
    y# = 0.0
	//move view to create scrolling
	SetViewOffset(GetViewOffsetX() + x#, 0)
	screenX# = WorldToScreenX(GetSpriteX(playerSprite))
	
    if IsJumpingUp()
		if GetSpriteY(playerSprite) >= maxJumpHeight
			y# = -20
			x# = GetJumpingMotionX()
		else
			if actionState = JumpingUp then actionState = JumpingDown
			if actionState = JumpingUpLeft then actionState = JumpingDownLeft
			if actionState = JumpingUpRight then actionState = JumpingDownRight
			maxJumpHeight = 500
			PlayJumpingDown()
		endif
	elseif IsJumpingDown()
		if GetSpriteY(playerSprite) >= groundY - GetSpriteHeight(playerSprite)
			SetSpritePosition(playerSprite, GetSpriteX(playerSprite), groundY - GetSpriteHeight(playerSprite))
			actionState = Standing
			PlayStanding()
		else
			y# = 20
			x# = GetJumpingMotionX()
		endif
    elseif InputSpace()
		if IsJumpingUp() = 0 and IsJumpingDown() = 0
 			maxJumpHeight = GetSpriteY(playerSprite) - 220
			actionState = JumpingUp
			if IsRunningRight() then actionState = JumpingUpRight
			if IsRunningLeft() then actionState = JumpingUpLeft
			PlayJumpingUp()
		endif
    elseif IsRunningRight()
        x# = 13.0
		if actionState <> RunningRight 
			actionState = RunningRight
			PlayRunningRight()
		endif
    elseif IsRunningLeft()
        x# = -10.0
		if actionState <> RunningLeft
			actionState = RunningLeft
			PlayRunningLeft()
		endif
	else
		if actionState <> Standing
			actionState = Standing
			PlayStanding()
		endif	    
    endif
 
    x# = GetSpriteX (playerSprite) + x#
    y# = GetSpriteY (playerSprite) + y#
    
    if screenX# > GetVirtualWidth() - GetSpriteWidth(playerSprite)
		x# = GetSpriteX(playerSprite)
    endif
    //view offset
    if x# < (20 + GetViewOffsetX())
		x# = 20 + GetViewOffsetX() 
	endif
    
    if y# < 0.0 
		y# = 0
    endif

    if y# > GetVirtualHeight() - GetSpriteHeight(playerSprite)
		y# = GetVirtualHeight() - GetSpriteHeight(playerSprite)
	endif
	
    SetSpritePosition ( playerSprite, x#, y#)

endfunction

function IsSliding()
	if InputDown() or InputS() then exitfunction 1
endfunction 0

function IsJumpingUp()
	if actionState >= JumpingUp and actionState < JumpingDown then exitfunction 1
endfunction 0

function IsJumpingDown()
	if actionState >= JumpingDown then exitfunction 1
endfunction 0 

function GetJumpingMotionX()
	if actionState = JumpingDownRight or actionState = JumpingUpRight
		if IsRunningLeft() then exitfunction 10
		exitfunction 20
	endif
	if actionState = JumpingDownLeft or actionState = JumpingUpLeft
		if IsRunningRight() then exitfunction -10
		exitfunction -20
	endif
endfunction 0

function IsRunningRight()
	if InputD() or InputRight() then exitfunction 1
endfunction 0

function IsRunningLeft()
	if InputA() or InputLeft() then exitfunction 1
endfunction 0

function CheckPlayerWithScenery()
    for i = 1 to sceneryCount
		if GetSpriteExists (scenery [ i ]) = 1
			if IsDeadlyGroundCollision(scenery [ i ]) = 1
				KillPlayerGround()
                exit
			endif
			if IsDeadlyObjectCollision(scenery [ i ]) = 1
				KillPlayerObject(scenery[i])
				exit
			endif
		endif
    next i
endfunction

function CheckPlayerWithFlyingObjects()
	for i = 1 to 1
		if GetSpriteExists(flyingObjects[i].spriteId)
			if IsDeadlyFlyingObjectCollision(flyingObjects[i].spriteId)
				KillPlayerFlyingObject()
				exit
			endif
		endif
	next i
endfunction

function IsDeadlyGroundCollision(spriteId as integer)
	if GetSpriteGroup(spriteId) <> groupDeadlyGround then exitfunction 0
	
	x1# = GetSpriteX(spriteId) + GetSpriteWidth(playerSprite)
	x2# = GetSpriteX(spriteId) + GetSpriteWidth(spriteId) - GetSpriteWidth(playerSprite)
	y1# = GetSpriteY(spriteId)
	y2# = GetSpriteY(spriteId) + GetSpriteHeight(spriteId)
	if GetSpriteInBox(playerSprite, x1#, y1#, x2#, y2#) = 1
		exitfunction 1
	endif
endfunction 0 

function IsDeadlyObjectCollision(spriteId as integer)
	if GetSpriteGroup(spriteId) <> groupDeadlyObject then exitfunction 0
	
	x1# = GetSpriteX(spriteId) + (GetSpriteWidth(spriteId) * 0.45)
	x2# = GetSpriteX(spriteId) + GetSpriteWidth(spriteId) - (GetSpriteWidth(spriteId) * 0.45)
	y1# = GetSpriteY(spriteId)
	y2# = GetSpriteY(spriteId) + GetSpriteHeight(spriteId)
	if GetSpriteInBox(playerSprite, x1#, y1#, x2#, y2#) = 1
		exitfunction 1
	endif
endfunction 0

function IsDeadlyFlyingObjectCollision(spriteId as integer)
	if GetSpriteGroup(spriteId) <> groupDeadlyFlyingObject then exitfunction 0
	
	x# = GetSpriteGroup(spriteId)
	
	if GetSpriteCollision(spriteId, playerSprite)
		exitfunction 1
	endif
endfunction 0

function DestroyPlayer()
	
	Delay(5)
	
	SetViewOffset ( 0, 0 )

    ResetPlayer()
    ResetFlyingObjects()
    
    playerState = 0
    playerScore = 0

    if ( playerLives = 0 )
        gameState = 2
    else
		ShowPlayer()
    endif
    
endfunction

