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
#constant    KEY_BACK         8
#constant    KEY_TAB          9
#constant    KEY_ENTER        13
#constant    KEY_SHIFT        16
#constant    KEY_CONTROL      17
#constant    KEY_ESCAPE       27
#constant    KEY_SPACE        32
#constant    KEY_PAGEUP       33
#constant    KEY_PAGEDOWN     34
#constant    KEY_END          35
#constant    KEY_HOME         36
#constant    KEY_LEFT         37
#constant    KEY_UP           38
#constant    KEY_RIGHT        39
#constant    KEY_DOWN         40
#constant    KEY_INSERT       45
#constant    KEY_DELETE       46
#constant    KEY_0            48
#constant    KEY_1            49
#constant    KEY_2            50
#constant    KEY_3            51
#constant    KEY_4            52
#constant    KEY_5            53
#constant    KEY_6            54
#constant    KEY_7            55
#constant    KEY_8            56
#constant    KEY_9            57
#constant    KEY_A            65
#constant    KEY_B            66
#constant    KEY_C            67
#constant    KEY_D            68
#constant    KEY_E            69
#constant    KEY_F            70
#constant    KEY_G            71
#constant    KEY_H            72
#constant    KEY_I            73
#constant    KEY_J            74
#constant    KEY_K            75
#constant    KEY_L            76
#constant    KEY_M            77
#constant    KEY_N            78
#constant    KEY_O            79
#constant    KEY_P            80
#constant    KEY_Q            81
#constant    KEY_R            82
#constant    KEY_S            83
#constant    KEY_T            84
#constant    KEY_U            85
#constant    KEY_V            86
#constant    KEY_W            87
#constant    KEY_X            88
#constant    KEY_Y            89
#constant    KEY_Z            90
#constant    KEY_F1           112
#constant    KEY_F2           113
#constant    KEY_F3           114
#constant    KEY_F4           115
#constant    KEY_F5           116
#constant    KEY_F6           117
#constant    KEY_F7           118
#constant    KEY_F8           119
#constant    KEY_S1           186    
#constant    KEY_S2           187
#constant    KEY_S3           188
#constant    KEY_S4           189
#constant    KEY_S5           190
#constant    KEY_S6           191
#constant    KEY_S7           192
#constant    KEY_S8           219
#constant    KEY_S9           220
#constant    KEY_S10          221
#constant    KEY_S11          222
#constant    KEY_S12          223

function InputLeft()
	if GetRawKeyState(KEY_LEFT) or GetRawKeyPressed(KEY_LEFT) then exitfunction 1
endfunction 0

function InputRight()
	if GetRawKeyState(KEY_RIGHT) or GetRawKeyPressed(KEY_RIGHT) then exitfunction 1
endfunction 0

function InputUp()
	if GetRawKeyState(KEY_UP) then exitfunction 1
endfunction 0 

function InputDown()
	if GetRawKeyState(KEY_DOWN) then exitfunction 1
endfunction 0  

function InputW()
	if GetRawKeyState(KEY_W) then exitfunction 1
endfunction 0

function InputS()
	if GetRawKeyState(KEY_S) then exitfunction 1
endfunction 0

function InputA()
	if GetRawKeyState(KEY_A) or GetRawKeyPressed(KEY_A) then exitfunction 1
endfunction 0

function InputD()
	if GetRawKeyState(KEY_D) or GetRawKeyPressed(KEY_D) then exitfunction 1
endfunction 0        

function InputEnter()
	if GetRawKeyState(KEY_ENTER) then exitfunction 1
endfunction 0

function InputSpace()
	if GetRawKeyState(KEY_SPACE) then exitfunction 1
endfunction 0

function InputEscape()
	if GetRawKeyState(KEY_ESCAPE) then exitfunction 1
endfunction 0    
