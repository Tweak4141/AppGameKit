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
#constant maxFlyingObjects 1

function CreateFlyingObjects()
    
    // load images
    flyingObjectImage = LoadImageResized ("objects/Saw.png", 0.18, 0.18, 0)
	
    // set initial data
    for i = 1 to maxFlyingObjects
		flyingObjects[i].spriteId = 0
		flyingObjects[i].speed = 0.0
	next i

    // build
    ResetFlyingObjects()
endfunction

function HideFlyingObjects()
	for i = 1 to 1
		SetSpriteVisible(flyingObjects[i].spriteId, 0)
	next i
endfunction

function UpdateFlyingObjects()
    // update the flying objects
	for i = 1 to maxFlyingObjects
		
		spriteId = flyingObjects[i].spriteId 
		
        // get the new location
		x#   = GetSpriteX(spriteId)
		y#   = GetSpriteY(spriteId)

        // reset once they have moved off the screen
		if (WorldToScreenX(x#) < -200)
			// set position
			x# = GetVirtualWidth()
			y# = GetFlyingObjectsY(spriteId)

            // convert to world position instead of screen (because of scrolling)
			x#   = ScreenToWorldX(x#)
			y#   = ScreenToWorldY(y#)

            // generate new values for movement
			speed# = Random (100, 250)
			flyingObjects[i].speed = speed# * -1
			SetSpritePhysicsAngularVelocity(spriteId, -5)
			SetSpritePosition (spriteId, x#, y#)
		endif

        // update position of flying object
        SetSpritePhysicsForce(spriteId, GetSpriteXByOffset(spriteId), GetSpriteYByOffset(spriteId), flyingObjects[i].speed, 0)
	next i
endfunction

function ResetFlyingObjects()
 
    // run through them
    for i = 1 to 1
        // delete if it exists
		if GetSpriteExists(flyingObjects[i].spriteId) = 1
			DeleteSprite(flyingObjects[i].spriteId)
        endif
		
		spriteId = CreateSprite(flyingObjectImage)
		
        // create flying object and engine
        flyingObjects[i].spriteId = spriteId

        // set position
        x# = GetVirtualWidth()
		y# = GetFlyingObjectsY(spriteId)

        // give it a circle shape
		SetSpritePhysicsOn(spriteId, 2)
		SetSpriteShape(spriteId, 1)
		SetSpritePhysicsCanRotate(spriteId, 1)
		SetSpritePhysicsIsBullet(spriteId, 1)
		SetSpritePhysicsAngularVelocity(spriteId, -5)
		SetSpriteGroup(spriteId, groupDeadlyFlyingObject)
		SetSpritePosition ( spriteId, x#, y# )

        // set up for movement
		speed# = Random (100, 250) //random saw speed
		flyingObjects [ i ].speed = speed# * -1 
    next i
endfunction

function GetFlyingObjectsY(spriteId as integer)
	y# = Random(120, groundY - (GetSpriteHeight(playerSprite) * 1.6))	//return random y
endfunction y#

