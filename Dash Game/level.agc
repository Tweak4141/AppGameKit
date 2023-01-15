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
#constant groupBackground 1
#constant groupSafeGround 2
#constant groupSafeCeiling 3
#constant groupDeadlyGround 4
#constant groupDeadlyObject 5
#constant groupParticle 6
#constant groupDeadlyFlyingObject 7

type imageType
	id as integer
	group as integer
endtype

type imageGroup
	acidGround as imageType[3]
	safeGround as imageType[3]
	spikeGround as imageType[3]
	ceiling as imageType[3]
	backGround as imageType[3]
	deadlyBarrel as imageType
endtype

function CreateLevel()
	
	scale as float = 0.4 //Image scale for loading images
	
	middleGroundId = LoadImageResized("level/Tile (2).png", scale, scale, 0)
	leftGroundId = LoadImageResized("level/Tile (3).png", scale, scale, 0)
	rightGroundId = LoadImageResized("level/Tile (1).png", scale, scale, 0)
	acidGroundId = LoadImageResized("level/Acid (1).png", scale, scale, 0)
	spikeGroundId = LoadImageResized("level/Spike.png", scale, scale, 0)
	leftCeilingId = LoadImageResized("level/BGTile (2).png", scale, scale, 0)
	middleCeilingId = LoadImageResized("level/BGTile (1).png", scale, scale, 0)
	rightCeilingId = LoadImageResized("level/BGTile (2).png", scale, scale, 0)
	leftBackgroundId = LoadImageResized("level/BGTile (3).png", scale, scale, 0)
	middleBackgroundId = LoadImageResized("level/BGTile (4).png", scale, scale, 0)
	middleAltBackgroundId = LoadImageResized("level/BGTile (5).png", scale, scale, 0)
	rightBackgroundId = LoadImageResized("level/BGTile (6).png", scale, scale, 0)
	deadlyBarrelId = LoadImageResized("objects/Barrel (1).png", 0.37, 0.37, 0)
	/*
	Create a set of four tiles
	Tile one: Jump Tile
	Tile two: Random Tile
	Tile three: Random Tile
	Tile four: Landing tile
	By creating tiles in four, ensures that there is a jump and landing
	Also prevents tiles that aren't compatible (spike, acid) from forming.
	*/
	gameImageGroup as imageGroup
	
	acidGround as imageType[3]
	acidGround[0].id = leftGroundId
	acidGround[0].group = groupSafeGround
	acidGround[1].id = acidGroundId
	acidGround[1].group = groupDeadlyGround
	acidGround[2].id = acidGroundId
	acidGround[2].group = groupDeadlyGround	
	acidGround[3].id = rightGroundId
	acidGround[3].group = groupSafeGround
	gameImageGroup.acidGround = acidGround
	
	safeGround as imageType[3]
	safeGround[0].id = middleGroundId
	safeGround[0].group = groupSafeGround
	safeGround[1].id = middleGroundId
	safeGround[1].group = groupSafeGround	
	safeGround[2].id = middleGroundId
	safeGround[2].group = groupSafeGround
	safeGround[3].id = middleGroundId
	safeGround[3].group = groupSafeGround
	gameImageGroup.safeGround = safeGround

	spikeGround as imageType[3]
	spikeGround[0].id = leftGroundId
	spikeGround[0].group = groupSafeGround
	spikeGround[1].id = spikeGroundId
	spikeGround[1].group = groupDeadlyGround	
	spikeGround[2].id = spikeGroundId
	spikeGround[2].group = groupDeadlyGround
	spikeGround[3].id = rightGroundId
	spikeGround[3].group = groupSafeGround
	gameImageGroup.spikeGround = spikeGround
	
	ceiling as imageType[3]
	ceiling[0].id = leftCeilingId
	ceiling[0].group = groupSafeCeiling
	ceiling[1].id = middleCeilingId
	ceiling[1].group = groupSafeCeiling
	ceiling[2].id = middleCeilingId
	ceiling[2].group = groupSafeCeiling		
	ceiling[3].id = rightCeilingId
	ceiling[3].group = groupSafeCeiling
	gameImageGroup.ceiling = ceiling
	
	backGround as imageType[3]
	backGround[0].id = leftBackgroundId
	backGround[0].group = groupBackground
	backGround[1].id = middleBackgroundId
	backGround[1].group = groupBackground
	backGround[2].id = middleAltBackgroundId
	backGround[2].group = groupBackground		
	backGround[3].id = rightBackgroundId
	backGround[3].group = groupBackground
	gameImageGroup.backGround = backGround	

	deadlyBarrel as imageType
	deadlyBarrel.id = deadlyBarrelId
	deadlyBarrel.group = groupDeadlyObject

	gameImageGroup.deadlyBarrel = deadlyBarrel
	
	xInc = GetImageWidth(middleGroundId) * 4
	yInc = GetImageHeight(leftBackgroundId)
	//This gets the ground y from the image height
	groundY = GetVirtualHeight() - GetImageHeight(middleGroundId) 
	
	//build background
	CreateStrip (gameImageGroup, 0.0, 0.0, xInc, yInc, 0)
	
	//build top and bottom
	CreateStrip (gameImageGroup, 0.0, 0.0, xInc, yInc, 2 )
endfunction

function AtGround(y as float)
	if y <= groundY then exitfunction 1
endfunction 0

function CreateStrip (gameImageGroup as imageGroup, x as float, y as float, xInc as float, yInc as float, mode as integer)    
	//max x  
	//create level up to certain point
    for i = 0 to 250 
        if mode = 0
			y = 0.0
			while y <= GetVirtualHeight() 
				BuildLevel(gameImageGroup.backGround, x, y, 0)
				y = y + yInc
			endwhile
			maxGameX = x
        endif

		if mode = 2
			
			BuildLevel(gameImageGroup.ceiling, x, 0.0, 0)  //Game ceiling 
			
			if Random(1, 3) = 2 and x > 800
				BuildLevel(gameImageGroup.acidGround, x, groundY, 1) //Acid
			elseif Random(1, 3) = 1 and x > 800
				BuildLevel(gameImageGroup.spikeGround, x, groundY, 1) //Spikes
			else
				BuildLevel(gameImageGroup.safeGround, x, groundY, 1) 
				if Random(1, 2) = 2 and x > 800 //solid ground
					BuildObject(gameImageGroup.deadlyBarrel, x + (GetImageWidth(gameImageGroup.deadlyBarrel.id) * 2), groundY - GetImageHeight(gameImageGroup.deadlyBarrel.id)) //build barrel
				endif 
			endif	
		endif
		
        x = x + xInc 
    next i
endfunction

function BuildObject(object as imageType, x as float, y as float)
	spriteId = CreateSprite(object.id)
	SetSpritePosition(spriteId, x, y)
	SetSpriteGroup(spriteId, object.group)
	SetSpritePhysicsOn(spriteId, 1)
	scenery[sceneryCount] = spriteId
	inc sceneryCount
endfunction

function BuildLevel(imageList as imageType[], x as float, y as float, addScenery as integer)
	
	for i = 0 to imageList.Length
		spriteId = CreateSprite(imageList[i].id)
		SetSpritePosition(spriteId, x, y)
		SetSpriteGroup(spriteId, imageList[i].group)
		if (addScenery = 1)
			scenery[sceneryCount] = spriteId
			inc sceneryCount
		endif
		x = x + GetSpriteWidth(spriteId)
	next i

endfunction

