.MODEL large, stdcall
.STACK 1000h
.386
exit EQU <.EXIT>
start EQU <.STARTUP>
;============================================================
.data

cursorx db 10
cursory db 3

starting_column dw 17	;starting column
starting_row dw 20	;starting row

string1 db "PLAY$"
string2 db "INSTRUCTIONS$"
string3 db "EXIT$"
string4 db "GOOD BYE$"
string5 db "BACK$"
string6 db "Score$"
string7 db "Lives$"
string8 db "C 2019 All Rights Reserved$"
string9 db "Credits$"
string10 db "****** **** (i00-0000)$"
string11 db "****** ** ****** (i00-0000)$"
string12 db "Rizwan Haidar (i00-0000)$"
;Identity Hide
string13 db "LOADING$"
string14 db "........$"
string15 db "WELCOME TO T-EAX GAME$"

string17 db "Player:$"
string16 db "ENTER YOUR NAME: $"
string18 db "Game Over$"
stringname db 100 dup('$')

string_x_axis_b db 17
string_y_axis_b db 7

string_x_axis db 17
string_y_axis db 7

input_coordinate_x dw 0
input_coordinate_y dw 0

input_coordinate_x1 db 0
input_coordinate_y1 db 0

tempo db 8
mouse_y_coordinate db ?
mouse_x_coordinate db ?

handle dw ?
fname db "instFile.txt",0
instructions db 600 dup ("$")
instSize dw 0
;**********Key Board Input Variables*************88

	scanCode db 0
	ASCIICode db 0

;************3 bool values for screen************

scren1 db 0
scren2 db 0
scren3 db 0

;============================================================

pixel_width dw ?	;used in pixel function

;==========================================

	cloud_y1 dw 90
	cloud_x1 dw 120			;cloud1
	
	cloud_y2 dw 70
	cloud_x2 dw 180			;cloud2
	
	cloud_y3 dw 90
	cloud_x3 dw 240			;cloud3

	cloud_y1_new dw 90
	cloud_x1_new dw 120			;cloud1
	
	cloud_y2_new dw 70
	cloud_x2_new dw 180			;cloud2
	
	cloud_y3_new dw 90
	cloud_x3_new dw 240			;cloud3

	cloud_x dw ?
	cloud_y dw ?
	
temp_cloud_y dw ?
temp_cloud_x dw ?
;==========================================
bird_y dw 110
bird_x dw 200
temp_bird_y dw ?
temp_bird_x dw ?
;===============
dino_y dw 134
dino_x dw 60
temp_dino_y dw ?
temp_dino_x dw ?
;===============
heartx dw 60
hearty dw 32
life_x dw 150
life_y dw 155
life_x_new dw 0


dino_x_new dw 60

hurdle1_y dw 154
hurdle1_x dw 300
hurdle2_y dw 143
hurdle2_x dw 170
hurdle3_y dw 125
hurdle3_x dw 240
temp_hurdle_y dw ?
temp_hurdle_x dw ?
temp_hurdle_y1 dw ?
temp_hurdle_x1 dw ?
temp_hurdle_y2 dw ?
temp_hurdle_x2 dw ?
leg_x dw ?
leg_y dw ?
temp_leg_y dw ?
temp_leg_x dw ?
;===============
buildingx dw 19
buildingy dw 85
;===============
in_ret db 0
colour db ? 
;================temps for loading......
tem1 db 3
tem2 db 3
;================temporary for flags...
flag1 db 3
flagcounter dw 0
temporary_use1 dw ?
temporary_use2 dw ?
temporary_use3 dw ?
temporary_use4 dw ?
temporary_use5 dw ?
temporary_use6 dw ?
temporary_use7 dw ?
temporary_use8 dw ?
temp_dino_head_var dw 0
legstimer dw 0
temporary_use_bird1 dw ?
temporary_use_bird2 dw ?
temporary_use_bird3 dw ?
temporary_use_bird4 dw ?
lives dw 5
random_hurdle_count dw ?
random_bird_count dw ?
life_print db 0

;----------------------------HighSore:
scorecount db 0
score dw 0
scores db 30 dup('$')
spaces db "   ",0
strOutput db 30 dup('$')
ssize db 0
fname1 db "scores.txt",0
tempdl db ?
intOutput dw 0

;--------------------------heart collision temp
temporary_use_heart1 dw ?
temporary_use_heart2 dw ?
temporary_use_heart3 dw ?
temporary_use_heart4 dw ?
flagforrand dw 0

;---------------------------System time:
timestring db 9 dup("$")
fname2 db "time.txt",0
.code
MAIN PROC	

		mov ax,@data
		mov ds,ax
	
		mov ax,1
		int 33h
		
		call BEEP
;--------------Before Menu Welcome-------------------------
	
		mov ah,0
		mov al,13h
		int 10h
		
		mov cx,21
		mov dl,string_x_axis
		sub dl,10
		mov dh,string_y_axis
		sub dh,5
		mov si,offset string15 
		call charprint

	MOV CX, 0AH
	MOV DX, 820H
	MOV AH, 86H      ;BIOS Wait/Delay function
	INT 15H

		mov cx,7
		mov dl,string_x_axis
		sub dl,5
		mov dh,string_y_axis
		sub dh,3
		mov si,offset string13
		call charprint
		
	MOV CX, 0AH
	MOV DX, 820H
	MOV AH, 86H      ;BIOS Wait/Delay function
	INT 15H


	mov cx,8
	mov si,offset[string14]

	looploading:
		push cx
			
		mov cx,1
		mov dl,string_x_axis
		add dl,tem1
		mov dh,string_y_axis
		sub dh,3
		mov si,offset string14
		call charprint
		add tem1,1

	MOV CX, 0AH
	MOV DX, 200H
	MOV AH, 86H      ;BIOS Wait/Delay function
	INT 15H
	pop cx
		loop looploading
;---------------------------------------------Board Creation:
	Initial:	
		mov si,starting_column       
		mov di,starting_row
		mov colour,0
		call board
		
		mov buildingy,140
		call CityLine

		mov dx,offset fname1
		mov si,offset scores
		mov cx,30
		
		call ReadFromFile
		
		SIZECOUNT1:
		
			mov al,[si]
			cmp al,'$'
			je sizecountout1
			
			add ssize,1
			inc si
			
		jmp SIZECOUNT1
		
		SIZECOUNTOUT1:
		
		sub ssize,2
	
;---------------------------------------------Displaying Menu:
	
		mov cx,4
		mov dl,string_x_axis
		mov dh,string_y_axis
		mov si,offset string1  
		call charprint
		
		mov cx,12
		mov dl,string_x_axis
		sub dl,4
		mov dh,string_y_axis
		add dh,3
		mov si,offset string2   
		
		call charprint
	

		mov cx,4
		mov dl,string_x_axis
	
		mov dh,string_y_axis
		add dh,6
		mov si,offset string3   
		call charprint
			
			call rights

;---------------------------------------------Mouse Functionality:

	mouse_working:
	call mouse_function_1

	check_coordinates:

		call Screen1
		call Screen2
		call Screen3

		cmp scren1,1
			je implement_screen1
		cmp scren2,1
			je implement_screen2
		cmp scren3,1
			je impllement_screen3

			jmp mouse_working

;-----------------------------Screen1------------------:

	implement_screen1:
	
	mov si,starting_column       
	mov di,starting_row			;draw board
	mov colour,0
	call board

					mov buildingx,18
				mov buildingy,105
				call CityLine

			mov cx,17
		mov dl,string_x_axis_b
		mov dh,string_y_axis_b
		sub dl,10
	
		mov si,offset string16
		call charprint


		mov si,offset stringname
		l_name_input:
		mov ah,1
		int 21h
		.if(al==13)
		mov bx,'#'
		mov [si],bx
		jmp out_name_input
		
		.endif
		mov [si],al
		inc si
		 jmp l_name_input
		out_name_input:
			
			mov ah,08h
			int 21h

		mov si,starting_column       
	mov di,starting_row			;draw board
	mov colour,0
	call board


	mov ax,0
	mov si,offset stringname
	l1_name_count:
	mov bx,'#'
	.if([si]!=bx)
	inc ax
	inc si
	.endif
	mov bx,'#'
	.if([si]==bx)
	jmp out_of_count

	.endif

	jmp l1_name_count
	
	out_of_count:
	
		mov cx,ax
		mov dl,101
		mov dh,5
		mov si,offset stringname
		call charprint

		mov cx,7
		mov dl,93
		mov dh,5
		mov si,offset string17
		call charprint

	mov di,170			;row number
	mov si,0			;column number
	mov cx,2			;how many height			;draw line below
	mov pixel_width,319 ;how many width
	mov colour,15
	call PixelDraw
	
	 mov di,54			;row number
	 mov si,0	;column number
	 mov cx,2			;how many height			;draw line above
	 mov pixel_width,319 ;how many width
	 mov colour,15
	 call PixelDraw

	;------------Score And Lives-----------
	
	re_Draw:
		mov di,5			;row number
		mov si,5			;column number
		mov cx,30			;how many height			;draw line above
		mov pixel_width,120 ;how many width
		mov colour,0
		call PixelDraw
		
		mov cx,5
		mov dl,string_x_axis
		sub dl,16
		mov dh,string_y_axis
		sub dh,5
		mov si,offset string7  
		call charprint

		mov cx,5
		mov dl,string_x_axis
		sub dl,16
		mov dh,string_y_axis
		sub dh,3
		mov si,offset string6
		call charprint
		
		mov cx,1
		mov dl,string_x_axis
		sub dl,11
		mov dh,string_y_axis
		sub dh,3
		mov si,offset spaces
		call charprint
		
		mov ax,score
		call Display
		
		inc scorecount
		.if(scorecount == 5)
			
			mov scorecount,0
			inc score
			
		.endif
		
		mov ch,0
		mov cl,17
		mov dl,114
		mov dh,string_y_axis
		sub dh,6
		mov tempdl,114
		mov si,offset scores  
		call charprint1

		mov dl,0
		mov dh,0
		int 10h
		
		mov dx,lives

		mov colour,135
		mov cx,lives
		
		mov heartx,59
		mov hearty,15
		
		
		loophearts:
			push cx
			call Heart_Drawing
			add heartx,10
			mov hearty,15
			pop cx
		loop loophearts
		
	
	;------------building--------------
;	mov buildingx,18
;	mov buildingy,129
;	call CityLine
	

	;--------level2 quick movements

		.if(score>200)
			sub cloud_x1_new,2
			sub cloud_x2_new,2
			sub cloud_x3_new,2
			sub bird_x,2
			sub hurdle1_x,2
			sub life_x,2		
		.endif
		
		.if(score>400)
			sub cloud_x1_new,2
			sub cloud_x2_new,2
			sub cloud_x3_new,2
			sub bird_x,2
			sub hurdle1_x,2
			sub life_x,2		
		.endif
	

	;--------------------------------
	;-------------clouds---------------
	

	;cloud1
	mov colour,15
	mov cloud_y1,90
	mov ax,cloud_x1_new
	mov cloud_x1,ax	
	mov ax,cloud_y1
	mov bx,cloud_x1
	mov cloud_x,bx 
	mov cloud_y,ax
	
	call cloud_drawing

	dec cloud_x1_new
	
	.if(cloud_x1_new<=3)
		mov cloud_x1_new,315
	.endif
	
			
	mov ax,cloud_x2_new
	mov cloud_x2,ax	
	
	mov ax,cloud_y2
	mov bx,cloud_x2
	mov cloud_x,bx 
	mov cloud_y,ax
	call cloud_drawing

	dec cloud_x2_new
	
	.if(cloud_x2_new<=3)
		mov cloud_x2_new,315
	.endif
	


	mov ax,cloud_x3_new
	mov cloud_x3,ax	
			;cloud3
	
	mov ax,cloud_y3
	mov bx,cloud_x3
	mov cloud_x,bx 
	mov cloud_y,ax
	call cloud_drawing

	dec cloud_x3_new
	
	.if(cloud_x3_new<=3)
		mov cloud_x3_new,315
	.endif
	
	;--------clouds finishes-----------
	;-------------------Bird-----------

	mov colour,165
	call Bird_Drawing

	;-----------------Bird Finished -----------
	;----------------dino----------------------	
	
	
	mov colour,92
	Call Dino_headup
	call Dino_Drawing
	
		.if(legstimer==5)
			call Dino_normallegs               ;jumping dino
		.endif	
		.if(legstimer==0)
			call Dino_normallegs
		.endif
			
		.if(legstimer==1)
			call Dino_normallegs				;legs condition
			inc legstimer
		.endif
		
		.if(legstimer==3)
			call Dino_uplegs
		.endif
		
		inc legstimer
		
		.if(legstimer==4)
			mov legstimer,1
		.endif

	;--------------dino finished---------------
	;----------------Hurdles-------------------
	
	mov colour,121
	call Cactus_Drawing
	
	;mov hurdle2_y,143
	;mov hurdle2_x,210
	;mov colour,121
	;call Burner_Drawing

	;mov hurdle3_y,125
	;mov hurdle3_x,240
	;mov colour,121
	;call Spades_Drawing
	inc life_print

	;-------------------New Lives------------------

		time_for_life:
		mov colour,135
		mov ax,life_x
		mov bx,life_y
		mov heartx,ax
		mov hearty,bx
		
		
		call Heart_Drawing
		mov ax,life_x
		mov life_x_new,ax
		dec life_x_new
		
		.if(life_x_new<=0)
			mov life_x_new,300
		.endif
	;------------------New Life end------------------

	;---------------hurdles end---------------
	;---------------Rights Reserved start-------
		call rights
	;---------------Rights Reserved end-------
	
	
	;-------------key board interrupt start--------
	
	calling_keyboard:
	mov ah,1
	mov al,00
	int 16h
	mov scanCode, ah
	mov ASCIICode, al


	;check_ascii:
		cmp ah,4Dh
		je implement_dino_right
		cmp ah,4Bh
		je implement_dino_left
		cmp ah,50h
		je implement_dino_bend
		cmp ah,48h
		je implement_dino_jump
		cmp al,27
		je exit_krjao
		cmp ah,00
		jmp reverse
	exit_krjao:
		jmp exit1
	
	;-------------key board interrupt end--------

;************Dino Movement*************
	
;----------------Dino RIght--------------
 
 implement_dino_right:

	add dino_x_new,1	
	mov ah,08h
	int 21h
	jmp reverse

;--------------Implement DIno Left movement-------------
implement_dino_left:
	 
	 sub dino_x_new,1
	 mov ah,08h
	 int 21h
	 jmp reverse

;-----------------Implement Dino Bend Movement-----------
implement_dino_bend:
	
	 mov colour,0
	 call Dino_headup
	 mov colour,92
	 Call Dino_headdown
	 mov ah,08h
	 int 21h
	 mov temp_dino_head_var,1
	 ;jmp exit1

	jmp reverse
;==============Implement dino jump===========		
implement_dino_jump:

	mov ah,08h
	int 21h
	mov flag1,0
	mov legstimer,5
	
reverse:

	MOV CX, 0H
	MOV DX, 8264565H
	MOV AH, 86H      ;BIOS Wait/Delay function
	INT 15H
 
	mov colour,0
	call Cactus_Drawing

	mov colour,0
	call Dino_headup
	call Dino_headdown
	call Dino_Drawing
	call Dino_normallegs				;legs condition
	call Dino_uplegs	

	mov colour,0
	call Bird_Drawing

	
	mov colour,0
	mov ax,life_x
	mov bx,life_y
	mov heartx,ax
	mov hearty,bx
	call Heart_Drawing
	mov ax,life_x_new
	mov life_x,ax

	mov colour,0
	mov ax,cloud_y1
	mov bx,cloud_x1
	mov cloud_x,bx 
	mov cloud_y,ax
	
	call cloud_drawing
	
	mov ax,cloud_y2
	mov bx,cloud_x2
	mov cloud_x,bx 
	mov cloud_y,ax
	call cloud_drawing

	mov ax,cloud_y3
	mov bx,cloud_x3
	mov cloud_x,bx 
	mov cloud_y,ax
	call cloud_drawing


	.if(dino_x_new<300)
		mov ax,dino_x_new
		mov dino_x,ax
	.endif
	.if(dino_x_new>300)
		mov dino_x_new,40
		mov ax,dino_x_new
		mov dino_x,ax
	.endif
	sub bird_x,1
	sub hurdle1_x,1
	.if(hurdle1_x<=3)
		mov hurdle1_x,319
	.endif
	.if(bird_x<=3)
		mov bird_x,319
		.if(flagforrand==0)
			mov bird_y,150
			mov flagforrand,1
			jmp continuity
		.endif
		.if(flagforrand==1)
			mov bird_y,110
			mov flagforrand,0
		.endif
	.endif
	continuity:
	.if(flag1==0)
		sub dino_y,5
		add dino_x_new,1
		mov legstimer,5
		inc flagcounter
			.if(flagcounter==12)			;jump
				 mov flag1,1
			.endif
	.endif

	.if(flag1==1)
		add dino_y,5	
		add dino_x_new,1
		dec flagcounter
		mov legstimer,5
			.if(flagcounter==0)			;back to ground
				 mov flag1,3
				 mov legstimer,0
			.endif
	.endif


	;------------------collision test movements
	
	mov bx,dino_x
	add bx,7
	mov temporary_use1,bx

	mov bx,dino_x
	sub bx,20
	mov temporary_use2,bx

	mov bx,dino_y
	add bx,34
	mov temporary_use4,bx
	
	.if(temp_dino_head_var==0)		
		mov bx,dino_y
		mov temporary_use3,bx
	.endif
	.if(temp_dino_head_var==1)		
		mov bx,dino_y
		add bx,15
		mov temporary_use3,bx
	.endif

	;hurdle tempo
			mov dx,hurdle1_x
			sub dx,3
			mov temporary_use5,dx
					
			mov dx,hurdle1_x
			add dx,5
			mov temporary_use6,dx
			
			mov dx,hurdle1_y
			mov temporary_use7,dx
			
			mov dx,hurdle1_y
			add dx,16
			mov temporary_use8,dx
			
	;bird temp
			mov dx,bird_x
			sub dx,3
			mov temporary_use_bird1,dx
			
			mov dx,bird_x
			add dx,8
			mov temporary_use_bird2,dx

			mov dx,bird_y
			mov temporary_use_bird3,dx

			mov dx,bird_y
			add dx,8
			mov temporary_use_bird4,dx

	;hearts temp
			
			mov dx,life_y
			sub dx,2
			mov temporary_use_heart3,dx

			
		;hurdle colision

		mov bx,temporary_use7
		mov dx,temporary_use8
		.if(temporary_use4>=bx && temporary_use4<dx)
			mov bx,temporary_use5
			mov dx,temporary_use6
			add dx,15
				.if(temporary_use1<=dx && temporary_use1>=bx ) 
					mov bx,temporary_use5
					mov dx,temporary_use6
					add dx,15
					.if(temporary_use2>dx || temporary_use2<=bx ) 
						sub lives,1
						.if(lives==0)
						mov colour,0
						call Heart_Drawing

						jmp exit1
						.endif
						.if(lives!=0)
						mov dino_x_new,40
						mov ax,dino_x_new
						mov dino_x,ax

						mov hurdle1_x,312

						jmp continue
						.endif
					.endif
			.endif
			jmp continue
		.endif
		
	continue:
	mov temp_dino_head_var,0
		;----------bird collision-----------

		mov bx,temporary_use_bird3
		mov dx,bird_x
		add dx,15
		mov cx,bird_x
		add cx,23
		.if(temporary_use1>=dx && temporary_use1<=cx)
			.if(temporary_use4>bx && temporary_use3<bx )
				sub lives,1
					.if(lives==0)
						mov colour,0
						call Heart_Drawing
						jmp exit1
					.endif
					.if(lives!=0)
						mov dino_x_new,40
						mov ax,dino_x_new
						mov dino_x,ax
					
						mov bird_x,310
						jmp oops
					.endif				
			.endif
			;jmp oops
		.endif

		;=------------hearts collision
		mov bx,temporary_use_heart3
		mov dx,life_x
		sub dx,5
		mov cx,life_x
		add cx,23
		.if(temporary_use1>=dx && temporary_use1<=cx)
			.if(temporary_use4>bx)
				.if(lives<5)
				inc lives
				mov life_x,310
				.endif
				mov life_x,310
			.endif
			jmp oops
		.endif

oops:
jmp re_Draw
	;-------------------screen1 implementation over----------
jmp exit1			

;---------------------------------------------Screen2:

	implement_screen2:
	call BEEP

	mov dx,offset fname
	mov si,offset instructions
	mov cx,70
	
	call ReadFromFile
	
	SIZECOUNT:
	
		mov al,[si]
		cmp al,'$'
		je sizecountout
		
		add instSize,1
		inc si
		
	jmp SIZECOUNT
	
	SIZECOUNTOUT:
	
	mov si,starting_column     
	mov di,starting_row
	mov colour,3
	call board
	
	
	mov di,43			;row number
	mov si,50			;column number
	mov cx,90			;how many height
	mov pixel_width,220 ;how many width
	mov colour,0
	call PixelDraw

	mov cx,12
	mov dl,13
	mov dh,7
	mov si,offset string2 
	call charprint

	mov tempdl,7
	inc tempdl
	mov cx,instSize
	mov dl,10
	mov dh,9
	mov si,offset instructions
	call charprint1
	call rights
	
	clearLoop:

		mov si,0
		mov instructions[si],'$'
		inc si

	loop clearLoop
		
	mov cx,4
	mov dl,33
	mov dh,18
	mov si,offset string5
	call charprint
		
	mov dl,0
	mov dh,0
	int 10h

	MOV CX, 0AH
	MOV DX, 420H
	MOV AH, 86H      ;BIOS Wait/Delay function
	INT 15H

	not_matched:
			call mouse_function_1

			mov scren1,0
			mov scren2,0
			mov scren3,0
			mov instSize,0
				mov buildingx,18
				mov buildingy,105

			call Back_from_screen_2
			cmp in_ret,1
			je done
			jmp not_matched
			done:
			jmp initial

			

	jmp exit1

;---------------------------------------------Screen3:

	impllement_screen3:
	call BEEP

	mov si,starting_column       
	mov di,starting_row
	mov colour,0
	call board
;----------------Credits And Roll Nos Printing-----------------	
	MOV CX, 0H
	MOV DX, 20H
	MOV AH, 86H      ;BIOS Wait/Delay function
	INT 15H
			
		mov cx,7
		mov dl,string_x_axis
		sub dl,1
		mov dh,string_y_axis
		sub dh,3
		mov si,offset string9  
		call charprint

	MOV CX, 0H
	MOV DX, 20H
	MOV AH, 86H      ;BIOS Wait/Delay function
	INT 15H
			
		mov cx,22
		mov dl,string_x_axis
		sub dl,7
		mov dh,string_y_axis
		mov si,offset string10 
		call charprint
	MOV CX, 0H
	MOV DX, 20H
	MOV AH, 86H      ;BIOS Wait/Delay function
	INT 15H
			
		mov cx,24
		mov dl,string_x_axis
		sub dl,8
		mov dh,string_y_axis
		add dh,2
		mov si,offset string12
		call charprint
	MOV CX, 0H
	MOV DX, 20H
	MOV AH, 86H      ;BIOS Wait/Delay function
	INT 15H
			
		mov cx,26
		mov dl,string_x_axis
		sub dl,9
		mov dh,string_y_axis
		add dh,4
		mov si,offset string11 
		call charprint


		mov cx,8
		mov dl,string_x_axis

	sub dl,2
		mov dh,string_y_axis
		add dh,10
		mov si,offset string4
		call charprint
		call rights
		mov dl,0
		mov dh,0
		int 10h
		
		mov ah,4ch
		int 21h
	
	exit1:
	
		call convert
		call compareScore
		
mov buildingx,18
mov buildingy,129
call CityLine
		mov cx,9
		mov dl,string_x_axis
		sub dl,4
		mov dh,string_y_axis
		add dh,2
		mov si,offset string18
		call charprint
				mov colour,0
		mov cx,1
		
		mov heartx,59
		mov hearty,15
		
		
		loophearts1:
			push cx
			call Heart_Drawing
			add heartx,10
			mov hearty,15
			pop cx
		loop loophearts1
		


		exit 
	MAIN ENDP

	Back_from_screen_2 proc

		horizontal_start_check_back:
		cmp mouse_x_coordinate,66
		jae horizontal_end_check_back
		jmp ret4
		horizontal_end_check_back:
		cmp mouse_x_coordinate,72
		jbe vertical_start_check_back
		jmp ret4
		vertical_start_check_back:
		cmp mouse_y_coordinate,18
		je Screen_back
		jmp ret4

		Screen_back:

			mov in_ret,1

		ret4:

	ret
	Back_from_screen_2 endp

	keyboard_interrupt proc
	mov ah, 0h
	int 16h
	mov scanCode, ah
	mov ASCIICode, al
	ret
	keyboard_interrupt endp

	ReadFromFile proc
	
		mov al,0
		mov ah,3dh
		int 21h

		mov handle,ax
		mov bx,ax
		
		mov dx,si
		mov ah,3fh
		int 21h

		mov ah,3eh
		mov dx,handle
		int 21h
	
	ret	
	ReadFromFile endp
	
	systemTime proc
	
		mov ah,2ch
		int 21h
		
		mov si,offset timestring
		
	;-----------------------------Printing hours:

		mov ah,0
		mov al,ch
		mov bl,10
		div bl
		mov bl,ah
		
		mov dl,al
		add dl,48
		
		mov [si],dl
		inc si
		
		mov dl,bl 
		add dl,48
		
		mov [si],dl
		inc si
		
		mov dl,':'
		mov [si],dl
		inc si
		
	;-----------------------------Printing minutes:
		
		mov ah,0
		mov al,cl
		mov bl,10
		div bl
		mov bl,ah
		
		mov dl,al
		add dl,48
		
		mov [si],dl
		inc si
		
		mov dl,bl 
		add dl,48
		
		mov [si],dl
		inc si
		
		mov dl,':'
		mov [si],dl
		inc si
		
	;-----------------------------Printing seconds:
		
		mov ah,0
		mov al,dh
		mov bl,10
		div bl
		mov bl,ah
		
		mov dl,al
		add dl,48
		
		mov [si],dl
		inc si
		
		mov dl,bl
		add dl,48
		
		mov [si],dl
		inc si
		
		mov dl,'$'
		mov [si],dl
		
	;------------------------file handling:
		
		mov ah,3ch
		lea dx,fname2
		mov cl,2
		int 21h
		
		mov handle,ax
		mov bx,ax
		
		mov cx,9
		lea dx,timestring
		mov ah,40h
		int 21h
		
		mov ah,3eh
		mov dx,handle
		int 21h
	
	ret
	systemTime endp
	
	compareScore proc
	
		mov ax,0
		mov si,offset scores
		
		compare:
		
			mov dl,[si]
			
			.if(dl == 'Z' && ax == 1)
				jmp continue
			.endif
			.if(dl == 'Z' && ax == 0)
				inc ax
			.endif
			
			inc si
			jmp compare
			
		continue:
		
;-------------------------convert string to int:
		
		inc si
		mov di,si
		
		mov dh,0
		mov bx,10000
		mov dl,[si]
		sub dl,48
		mov ax,dx
		mul bx
		
		add intOutput,ax
		inc si
		
		mov dh,0
		mov bx,1000
		mov dl,[si]
		sub dl,48
		mov ax,dx
		mul bx
		
		add intOutput,ax
		inc si
		
		mov dh,0
		mov bx,100
		mov dl,[si]
		sub dl,48
		mov ax,dx
		mul bx
		
		add intOutput,ax
		inc si
		
		mov dh,0
		mov bx,10
		mov dl,[si]
		sub dl,48
		mov ax,dx
		mul bx
		
		add intOutput,ax
		inc si
		
		mov dh,0
		mov dl,[si]
		sub dl,48
		mov ax,dx
		
		add intOutput,ax
		inc si

;----------------------------comparison:		
		
		mov bx,score
		mov ax,intOutput
		
		cmp bx,ax
		jb dontwrite
		
		mov si,offset scores
		mov cx,2
		
		loopp:
		
			push cx
			mov cx,5
			
			loop2:
			
				mov bl,[si+6]
				mov [si],bl
				inc si
				
			loop loop2
			
			inc si
			pop cx
			
		loop loopp
		
		mov cx,5
		
		loop3:
		
			mov bl,'0'
			mov [si],bl
			inc si
			
		loop loop3
		
		mov bl,'$'
		mov [si],bl
		
;----------------------------size of new string:
		
		mov si,offset strOutput
		mov dl,[si]
		
		mov cx,1
		
		.while(dl != '$')
		
			inc si
			inc cx
			
			mov dl,[si]
			
		.endw
		
		mov dx,6
		sub dx,cx
		mov si,0
		add di,dx
		
		loop1:
		
			mov bl,strOutput[si]
			mov [di],bl
			inc di
			inc si
			
		loop loop1
		
		mov bl,'$'
		mov [di],bl
		
		mov ah,3ch
		lea dx,fname1
		mov cl,2
		int 21h
		
		mov handle,ax
		mov bx,ax
		
		mov cx,20
		lea dx,scores
		mov ah,40h
		int 21h
		
		mov ah,3eh
		mov dx,handle
		int 21h
		
		call systemTime
		
		dontwrite:
	
	ret
	compareScore endp
	
	convert proc

		mov ax, score
		mov cx, 10
		xor bx, bx 				; Count the PUSHes

		divide:
		xor dx, dx
		div cx
		push dx 				; DL is a digit in range [0..9]
		inc bx 					; Count it

		test ax, ax
		jnz divide 				; EAX is not zero - so, continue...

								; Now POP them all using BX as a counter
		mov cx, bx
		lea si, strOutput 		; DS:SI points to your buffer

		get_digit:
		pop ax
		add al, '0' 			; Make it ASCII

								; Save it in the buffer
		mov [si], al
		inc si

		loop get_digit

								; Store '$' to use with Func. 9h Int 21h
		mov al, '$'
		mov [si], al
	
	ret
	convert endp
	
	display proc       ;Beginning of procedure
	   MOV BX, 10      ;Initializes divisor
	   MOV DX, 0000H   ;Clears DX
	   MOV CX, 0000H   ;Clears CX
		
	;___________	
	;Splitting process starts here
	;=============================
	L1:  
	   MOV DX, 0000H    ;Clears DX during jump
	   div BX           ;Divides AX by BX
	   PUSH DX          ;Pushes DX(remainder) to stack
	   INC CX           ;Increments counter to track the number of digits
	   CMP AX, 0        ;Checks if there is still something in AX to divide
	   JNE L1           ;Jumps if AX is not zero
		
	L2:  
	   POP DX          ;Pops from stack to DX
	   ADD DX, 30H     ;Converts to it's ASCII equivalent
	   MOV AH, 02H     
	   INT 21H         ;calls DOS to display character
	   LOOP L2         ;Loops till CX equals zero
	   RET             ;returns control
	display  ENDP
	
	CityLine proc
	
	mov colour,17
	
	mov di,buildingy			;row number
	mov si,buildingx			;column number		
	mov cx,40					;how many height
	mov pixel_width,15 			;how many width
	call PixelDraw
	
	sub buildingy,10
	mov di,buildingy
	add buildingx,2
	mov si,buildingx
	mov cx,40
	mov pixel_width,3 			
	call PixelDraw

	add colour,5
	
	sub buildingy,10
	mov di,buildingy
	add buildingx,20	
	mov si,buildingx						
	mov cx,60
	mov pixel_width,14
	call PixelDraw
	
	sub buildingy,7
	mov di,buildingy
	add buildingx,3	
	mov si,buildingx						
	mov cx,67
	mov pixel_width,8
	call PixelDraw
	
	sub buildingy,10
	mov di,buildingy
	add buildingx,3	
	mov si,buildingx						
	mov cx,67
	mov pixel_width,2
	call PixelDraw
	
	sub colour,5
	
	add buildingy,52
	mov di,buildingy
	sub buildingx,13	
	mov si,buildingx						
	mov cx,25	
	mov pixel_width,18
	call PixelDraw
	
	add buildingy,18
	mov di,buildingy
	add buildingx,18	
	mov si,buildingx						
	mov cx,7
	mov pixel_width,10	
	call PixelDraw
	
	sub buildingy,35
	mov di,buildingy
	add buildingx,10	
	mov si,buildingx						
	mov cx,42
	mov pixel_width,12	
	call PixelDraw
	
	sub buildingy,5
	mov di,buildingy
	add buildingx,2
	mov si,buildingx						
	mov cx,42
	mov pixel_width,8	
	call PixelDraw
	
	add buildingy,35
	mov di,buildingy
	add buildingx,11	
	mov si,buildingx						
	mov cx,12
	mov pixel_width,25	
	call PixelDraw
	
	sub buildingy,18
	mov di,buildingy
	add buildingx,7	
	mov si,buildingx						
	mov cx,30
	mov pixel_width,25	
	call PixelDraw
	
	sub buildingy,5
	mov di,buildingy
	add buildingx,16	
	mov si,buildingx						
	mov cx,30
	mov pixel_width,5	
	call PixelDraw
	
	add colour,5
	
	sub buildingy,7
	mov di,buildingy
	add buildingx,15	
	mov si,buildingx						
	mov cx,40
	mov pixel_width,14
	call PixelDraw
	
	sub colour,5
	
	add buildingy,25
	mov di,buildingy
	sub buildingx,7	
	mov si,buildingx						
	mov cx,17
	mov pixel_width,16	
	call PixelDraw
	
	add buildingy,13
	mov di,buildingy
	add buildingx,16	
	mov si,buildingx						
	mov cx,4
	mov pixel_width,24	
	call PixelDraw
	
	sub buildingy,30
	mov di,buildingy
	add buildingx,18	
	mov si,buildingx						
	mov cx,34
	mov pixel_width,18	
	call PixelDraw
	
	sub buildingy,5
	mov di,buildingy
	add buildingx,2	
	mov si,buildingx						
	mov cx,34
	mov pixel_width,14	
	call PixelDraw
	
	sub buildingy,5
	mov di,buildingy
	add buildingx,2	
	mov si,buildingx						
	mov cx,34
	mov pixel_width,10	
	call PixelDraw
	
	sub buildingy,5
	mov di,buildingy
	add buildingx,2	
	mov si,buildingx						
	mov cx,34
	mov pixel_width,6	
	call PixelDraw
	
	sub buildingy,5
	mov di,buildingy
	add buildingx,2	
	mov si,buildingx						
	mov cx,34
	mov pixel_width,2	
	call PixelDraw
	
	add buildingy,47
	mov di,buildingy
	add buildingx,11	
	mov si,buildingx						
	mov cx,7
	mov pixel_width,10	
	call PixelDraw
	
	sub buildingy,33
	mov di,buildingy
	add buildingx,8	
	mov si,buildingx						
	mov cx,40
	mov pixel_width,15	
	call PixelDraw
	
	add buildingy,15
	mov di,buildingy
	add buildingx,15	
	mov si,buildingx						
	mov cx,25	
	mov pixel_width,18
	call PixelDraw
	
	add buildingy,18
	mov di,buildingy
	add buildingx,18	
	mov si,buildingx						
	mov cx,7
	mov pixel_width,10	
	call PixelDraw
	
	sub buildingy,35
	mov di,buildingy
	add buildingx,10	
	mov si,buildingx						
	mov cx,42
	mov pixel_width,12	
	call PixelDraw
	
	sub buildingy,5
	mov di,buildingy
	add buildingx,2
	mov si,buildingx						
	mov cx,42
	mov pixel_width,8	
	call PixelDraw
	
	add buildingy,35
	mov di,buildingy
	add buildingx,11	
	mov si,buildingx						
	mov cx,12
	mov pixel_width,25	
	call PixelDraw
	
	sub buildingy,18
	mov di,buildingy
	add buildingx,7	
	mov si,buildingx						
	mov cx,30
	mov pixel_width,25	
	call PixelDraw
	
	sub buildingy,5
	mov di,buildingy
	add buildingx,16	
	mov si,buildingx						
	mov cx,30
	mov pixel_width,5	
	call PixelDraw
	
	add colour,5
	
	sub buildingy,10
	mov di,buildingy
	add buildingx,13	
	mov si,buildingx						
	mov cx,30
	mov pixel_width,8
	call PixelDraw
	
	sub colour,5
	
	add buildingy,28
	mov di,buildingy
	sub buildingx,4	
	mov si,buildingx						
	mov cx,17
	mov pixel_width,16	
	call PixelDraw
	
	add buildingy,13
	mov di,buildingy
	add buildingx,16	
	mov si,buildingx						
	mov cx,4
	mov pixel_width,24	
	call PixelDraw
	
	sub buildingy,30
	mov di,buildingy
	add buildingx,5	
	mov si,buildingx						
	mov cx,34
	mov pixel_width,18	
	call PixelDraw
	
	sub buildingy,5
	mov di,buildingy
	add buildingx,2	
	mov si,buildingx						
	mov cx,34
	mov pixel_width,14	
	call PixelDraw
	
	sub buildingy,5
	mov di,buildingy
	add buildingx,2	
	mov si,buildingx						
	mov cx,34
	mov pixel_width,10	
	call PixelDraw
	
	add buildingy,34
	mov di,buildingy
	add buildingx,10	
	mov si,buildingx						
	mov cx,10
	mov pixel_width,9
	call PixelDraw
	
	ret
	CityLine endp

	Cactus_Drawing proc

	mov di,hurdle1_y			;row number
	mov si,hurdle1_x			;column number
	mov cx,16					;how many height
	mov pixel_width,2 			;how many width
	call PixelDraw
	
	mov dx,hurdle1_y
	mov temp_hurdle_y,dx
	add temp_hurdle_y,8
	mov di,temp_hurdle_y
	mov dx,hurdle1_x
	mov temp_hurdle_x,dx
	sub temp_hurdle_x,3
	mov si,temp_hurdle_x			
	mov cx,2					
	mov pixel_width,8 			
	call PixelDraw
	
	mov dx,hurdle1_y
	mov temp_hurdle_y,dx
	sub temp_hurdle_y,4
	mov di,temp_hurdle_y
	mov dx,hurdle1_x
	mov temp_hurdle_x,dx
	sub temp_hurdle_x,5
	mov si,temp_hurdle_x			
	mov cx,14					
	mov pixel_width,2 			
	call PixelDraw


	mov dx,hurdle1_y
	mov temp_hurdle_y,dx
	sub temp_hurdle_y,4
	mov di,temp_hurdle_y
	mov dx,hurdle1_x
	mov temp_hurdle_x,dx
	add temp_hurdle_x,5
	mov si,temp_hurdle_x			
	mov cx,14					
	mov pixel_width,2 			
	call PixelDraw

	
	ret
	Cactus_Drawing endp

	Spades_Drawing proc
	
	mov di,hurdle3_y			;row number
	mov si,hurdle3_x			;column number
	mov cx,2			;how many height
	mov pixel_width,4 ;how many width
	call PixelDraw

	mov dx,hurdle3_y
	mov temp_hurdle_y,dx
	add temp_hurdle_y,2
	mov di,temp_hurdle_y		;row number
	mov dx,hurdle3_x
	mov temp_hurdle_x,dx
	sub temp_hurdle_x,2
	mov si,temp_hurdle_x		;column number
	mov cx,2					;how many height
	mov pixel_width,8			;how many width
	call PixelDraw

	mov dx,hurdle3_y
	mov temp_hurdle_y,dx
	add temp_hurdle_y,4
	mov di,temp_hurdle_y		;row number
	mov dx,hurdle3_x
	mov temp_hurdle_x,dx
	sub temp_hurdle_x,4
	mov si,temp_hurdle_x			;column number
	mov cx,2			;how many height
	mov pixel_width,12 ;how many width
	call PixelDraw

	mov dx,hurdle3_y
	mov temp_hurdle_y,dx
	add temp_hurdle_y,6
	mov di,temp_hurdle_y		;row number
	mov dx,hurdle3_x
	mov temp_hurdle_x,dx
	sub temp_hurdle_x,6
	mov si,temp_hurdle_x			;column number
	mov cx,2			;how many height
	mov pixel_width,16 ;how many width
	call PixelDraw

	mov dx,hurdle3_y
	mov temp_hurdle_y,dx
	add temp_hurdle_y,7
	mov di,temp_hurdle_y		;row number
	mov dx,hurdle3_x
	mov temp_hurdle_x,dx
	sub temp_hurdle_x,5
	mov si,temp_hurdle_x			;column number
	mov cx,2			;how many height
	mov pixel_width,14 ;how many width
	call PixelDraw

	mov dx,hurdle3_y
	mov temp_hurdle_y,dx
	add temp_hurdle_y,8
	mov di,temp_hurdle_y		;row number
	mov dx,hurdle3_x
	mov temp_hurdle_x,dx
	sub temp_hurdle_x,4
	mov si,temp_hurdle_x			;column number
	mov cx,2			;how many height
	mov pixel_width,12 ;how many width
	call PixelDraw

	mov dx,hurdle3_y
	mov temp_hurdle_y,dx
	add temp_hurdle_y,10
	mov di,temp_hurdle_y		;row number
	mov dx,hurdle3_x
	mov temp_hurdle_x,dx
	sub temp_hurdle_x,3
	mov si,temp_hurdle_x			;column number
	mov cx,1			;how many height
	mov pixel_width,10 ;how many width
	call PixelDraw

	mov dx,hurdle3_y
	mov temp_hurdle_y,dx
	add temp_hurdle_y,11
	mov di,temp_hurdle_y		;row number
	mov dx,hurdle3_x
	mov temp_hurdle_x,dx
	sub temp_hurdle_x,2
	mov si,temp_hurdle_x			;column number
	mov cx,2			;how many height
	mov pixel_width,8 ;how many width
	call PixelDraw

	mov dx,hurdle3_y
	mov temp_hurdle_y,dx
	add temp_hurdle_y,12
	mov di,temp_hurdle_y		;row number
	mov dx,hurdle3_x
	mov temp_hurdle_x,dx
	sub temp_hurdle_x,1
	mov si,temp_hurdle_x			;column number
	mov cx,2			;how many height
	mov pixel_width,6 ;how many width
	call PixelDraw

	mov dx,hurdle3_y
	mov temp_hurdle_y,dx
	add temp_hurdle_y,13
	mov di,temp_hurdle_y		;row number
	mov dx,hurdle3_x
	mov temp_hurdle_x,dx
	add temp_hurdle_x,1
	mov si,temp_hurdle_x		;column number
	mov cx,7					;how many height
	mov pixel_width,2			;how many width
	call PixelDraw

	ret
	Spades_drawing endp

	Burner_Drawing proc
	
	mov di,hurdle2_y			;row number
	mov si,hurdle2_x			;column number
	mov cx,2			;how many height
	mov pixel_width,5 ;how many width
	call PixelDraw

	mov dx,hurdle2_y
	mov temp_hurdle_y,dx
	sub temp_hurdle_y,2
	mov di,temp_hurdle_y		;row number
	mov dx,hurdle2_x
	mov temp_hurdle_x,dx
	sub temp_hurdle_x,2
	mov si,temp_hurdle_x			;column number
	mov cx,2			;how many height
	mov pixel_width,9 ;how many width
	call PixelDraw

	mov dx,hurdle2_y
	mov temp_hurdle_y,dx
	sub temp_hurdle_y,4
	mov di,temp_hurdle_y		;row number
	mov dx,hurdle2_x
	mov temp_hurdle_x,dx
	sub temp_hurdle_x,4
	mov si,temp_hurdle_x			;column number
	mov cx,2			;how many height
	mov pixel_width,13 ;how many width
	call PixelDraw

	mov dx,hurdle2_y
	mov temp_hurdle_y,dx
	sub temp_hurdle_y,6
	mov di,temp_hurdle_y		;row number
	mov dx,hurdle2_x
	mov temp_hurdle_x,dx
	sub temp_hurdle_x,6
	mov si,temp_hurdle_x			;column number
	mov cx,2			;how many height
	mov pixel_width,17 ;how many width
	call PixelDraw

	mov dx,hurdle2_y
	mov temp_hurdle_y,dx
	sub temp_hurdle_y,8
	mov di,temp_hurdle_y		;row number
	mov dx,hurdle2_x
	mov temp_hurdle_x,dx
	sub temp_hurdle_x,8
	mov si,temp_hurdle_x		;column number
	mov cx,2					;how many height
	mov pixel_width,21			;how many width
	call PixelDraw

	mov dx,hurdle2_y
	mov temp_hurdle_y,dx
	sub temp_hurdle_y,16
	mov di,temp_hurdle_y		;row number
	mov dx,hurdle2_x
	mov temp_hurdle_x,dx
	sub temp_hurdle_x,4
	mov si,temp_hurdle_x			;column number
	mov cx,8			;how many height
	mov pixel_width,1 ;how many width
	call PixelDraw

	mov dx,hurdle2_y
	mov temp_hurdle_y,dx
	sub temp_hurdle_y,16
	mov di,temp_hurdle_y		;row number
	mov dx,hurdle2_x
	mov temp_hurdle_x,dx
	add temp_hurdle_x,2
	mov si,temp_hurdle_x			;column number
	mov cx,8			;how many height
	mov pixel_width,1 ;how many width
	call PixelDraw

	mov dx,hurdle2_y
	mov temp_hurdle_y,dx
	sub temp_hurdle_y,16
	mov di,temp_hurdle_y		;row number
	mov dx,hurdle2_x
	mov temp_hurdle_x,dx
	add temp_hurdle_x,8
	mov si,temp_hurdle_x			;column number
	mov cx,8			;how many height
	mov pixel_width,1 ;how many width
	call PixelDraw


	ret
	Burner_Drawing endp


	Dino_headup proc
	mov di,dino_y			;row number
	mov si,dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,7 ;how many width
	call PixelDraw
	
	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,1
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,2
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,3 ;how many width
	call PixelDraw

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,1
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	add temp_dino_x,4
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,5 ;how many width
	call PixelDraw
	
	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,2
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,2
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,3 ;how many width
	call PixelDraw

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,2
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	add temp_dino_x,4
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,5 ;how many width
	call PixelDraw
	
	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,4
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,2
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,11 ;how many width
	call PixelDraw
	
	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,6
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,2
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,11 ;how many width
	call PixelDraw
	
	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,8
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,2
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,6 ;how many width
	call PixelDraw
		
	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,10
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,2
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,9 ;how many width
	call PixelDraw
	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,12
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,4
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,7 ;how many width
	call PixelDraw
	
	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,14
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,6
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,9 ;how many width
	call PixelDraw
	
	ret
	Dino_headup endp

	Dino_headdown proc
	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,15
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,2
	mov si,temp_dino_x			;column number
	mov cx,4			;how many height
	mov pixel_width,17 ;how many width
	call PixelDraw

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,16
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	add temp_dino_x,4
	mov si,temp_dino_x			;column number
	mov cx,4			;how many height
	mov pixel_width,15 ;how many width
	call PixelDraw

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,20
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	add temp_dino_x,12
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,7 ;how many width
	call PixelDraw
	
	
	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,22
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	add temp_dino_x,12
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,3 ;how many width
	call PixelDraw
	
	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,22
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	add temp_dino_x,18
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,1 ;how many width
	call PixelDraw

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,24
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	add temp_dino_x,12
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,7 ;how many width
	call PixelDraw
	

	ret
	Dino_headdown endp

	Dino_Drawing proc
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;
	
	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,16
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,8
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,14 ;how many width
	call PixelDraw
		
	
	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,18
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,10
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,13 ;how many width
	call PixelDraw

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,20
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,20
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,23 ;how many width
	call PixelDraw

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,22
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,18
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,20 ;how many width
	call PixelDraw

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,24
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,16
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,16 ;how many width
	call PixelDraw

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,26
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,14
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,12 ;how many width
	call PixelDraw

	;------------tail------------

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,18
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,20
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,3 ;how many width
	call PixelDraw

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,16
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,20
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,2 ;how many width
	call PixelDraw

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,14
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,20
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,1 ;how many width
	call PixelDraw
	ret
	Dino_Drawing endp
	


	Dino_normallegs proc
	
	;------------legs & feets---------------------
	;---left leg
	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,28
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,12
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,4 ;how many width
	call PixelDraw

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,30
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,12
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,2 ;how many width
	call PixelDraw

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,32
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,12
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,1 ;how many width
	call PixelDraw

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,34
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,12
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,2 ;how many width
	call PixelDraw

	;-----------right leg--------

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,28
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,4
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,2 ;how many width
	call PixelDraw
	
	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,30
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,3
	mov si,temp_dino_x			;column number
	mov cx,4			;how many height
	mov pixel_width,1 ;how many width
	call PixelDraw

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,34
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,3
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,2 ;how many width
	call PixelDraw


	ret
	Dino_normallegs endp

	Dino_uplegs proc
	
	;------------legs & feets---------------------
	;---left leg
	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,28
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,12
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,4 ;how many width
	call PixelDraw

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,30
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,12
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,6 ;how many width
	call PixelDraw

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,30
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,6
	mov si,temp_dino_x			;column number
	mov cx,3			;how many height
	mov pixel_width,2 ;how many width
	call PixelDraw

	;-----------right leg--------

	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,28
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,2
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,1 ;how many width
	call PixelDraw
	
	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,30
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	sub temp_dino_x,2
	mov si,temp_dino_x			;column number
	mov cx,2			;how many height
	mov pixel_width,5 ;how many width
	call PixelDraw
	
	mov dx,dino_y
	mov temp_dino_y,dx
	add temp_dino_y,30
	mov di,temp_dino_y		;row number
	mov dx,dino_x
	mov temp_dino_x,dx
	add temp_dino_x,1
	mov si,temp_dino_x			;column number
	mov cx,3			;how many height
	mov pixel_width,2 ;how many width
	call PixelDraw

	
	ret
	Dino_uplegs endp

	Heart_Drawing proc
	
		sub heartx,3
		mov si,heartx
		mov di,hearty
		mov cx,2
		mov pixel_width,10
		call PixelDraw
		
		add heartx,1
		mov si,heartx
		add hearty,2
		mov di,hearty
		mov cx,2
		mov pixel_width,8
		call PixelDraw
		
		add heartx,1
		mov si,heartx
		add hearty,2
		mov di,hearty
		mov cx,2
		mov pixel_width,6
		call PixelDraw
		
		add heartx,1
		mov si,heartx
		add hearty,2
		mov di,hearty
		mov cx,2
		mov pixel_width,4
		call PixelDraw
		
		add heartx,1
		mov si,heartx
		add hearty,2
		mov di,hearty
		mov cx,2
		mov pixel_width,2
		call PixelDraw
		
		sub heartx,2
		mov si,heartx
		sub hearty,11
		mov di,hearty
		mov cx,1
		mov pixel_width,1
		call PixelDraw
		
		sub heartx,1
		mov si,heartx
		add hearty,1
		mov di,hearty
		mov cx,2
		mov pixel_width,3
		call PixelDraw
		
		add heartx,6
		mov si,heartx
		sub hearty,1
		mov di,hearty
		mov cx,1
		mov pixel_width,1
		call PixelDraw
		
		sub heartx,1
		mov si,heartx
		add hearty,1
		mov di,hearty
		mov cx,2
		mov pixel_width,3
		call PixelDraw
		
	
	ret
	Heart_Drawing endp
	
	Cloud_Drawing proc
	
	
		
	mov di,cloud_y
	mov si,cloud_x	
	mov cx,5				
	mov pixel_width,8 			
	call PixelDraw
	
	add cloud_y,1
	mov di,cloud_y
	sub cloud_x,4
	mov si,cloud_x	
	mov cx,3				
	mov pixel_width,16 			
	call PixelDraw
	
	add cloud_y,1
	mov di,cloud_y
	sub cloud_x,3
	mov si,cloud_x	
	mov cx,1				
	mov pixel_width,22 			
	call PixelDraw

	ret
	Cloud_Drawing endp

	Bird_Drawing proc
	mov di,bird_y			;row number
	mov si,bird_x			;column number
	mov cx,1			;how many height
	mov pixel_width,1 ;how many width
	call PixelDraw
	
	mov dx,bird_y
	mov temp_bird_y,dx
	add temp_bird_y,1
	mov di,temp_bird_y		;row number
	;mov dx,bird_x
	;mov temp_bird_x,dx
	;sub temp_bird_x,1
	;mov si,temp_bird_x			;column number
	mov si,bird_x
	mov cx,1			;how many height
	mov pixel_width,2 ;how many width
	call PixelDraw
	
	mov dx,bird_y
	mov temp_bird_y,dx
	add temp_bird_y,2
	mov di,temp_bird_y		;row number
	;mov dx,bird_x
	;mov temp_bird_x,dx
	;sub temp_bird_x,2
	;mov si,temp_bird_x			;column number
	mov si,bird_x
	mov cx,1			;how many height
	mov pixel_width,3 ;how many width
	call PixelDraw

	mov dx,bird_y
	mov temp_bird_y,dx
	add temp_bird_y,3
	mov di,temp_bird_y		;row number
	;mov dx,bird_x
	;mov temp_bird_x,dx
	;sub temp_bird_x,3
	;mov si,temp_bird_x			;column number
	mov si,bird_x
	mov cx,1			;how many height
	mov pixel_width,4 ;how many width
	call PixelDraw

	mov dx,bird_y
	mov temp_bird_y,dx
	add temp_bird_y,4
	mov di,temp_bird_y		;row number
	mov si,bird_x		;column number
	mov cx,1			;how many height
	mov pixel_width,5 ;how many width
	call PixelDraw

	mov dx,bird_y
	mov temp_bird_y,dx
	add temp_bird_y,5	
	mov di,temp_bird_y		;row number
	mov si,bird_x		;column number
	mov cx,1			;how many height
	mov pixel_width,6 ;how many width
	call PixelDraw

	mov dx,bird_y
	mov temp_bird_y,dx
	add temp_bird_y,6	
	mov di,temp_bird_y		;row number		
	mov si,bird_x		;column number
	mov cx,1			;how many height
	mov pixel_width,7 ;how many width
	call PixelDraw

	mov dx,bird_y
	mov temp_bird_y,dx
	add temp_bird_y,7	
	mov di,temp_bird_y		;row number		
	mov si,bird_x		;column number
	mov cx,1			;how many height
	mov pixel_width,8 ;how many width
	call PixelDraw

	mov dx,bird_y
	mov temp_bird_y,dx
	add temp_bird_y,8
	mov di,temp_bird_y		;row number
	mov dx,bird_x
	mov temp_bird_x,dx
	sub temp_bird_x,3
	mov si,temp_bird_x			;column number
	mov cx,2			;how many height
	mov pixel_width,17 ;how many width
	call PixelDraw

	mov dx,bird_y
	mov temp_bird_y,dx
	add temp_bird_y,9
	mov di,temp_bird_y		;row number
	mov dx,bird_x
	mov temp_bird_x,dx
	sub temp_bird_x,1
	mov si,temp_bird_x			;column number
	mov cx,2			;how many height
	mov pixel_width,9 ;how many width
	call PixelDraw

	mov dx,bird_y
	mov temp_bird_y,dx
	add temp_bird_y,11
	mov di,temp_bird_y		;row number		
	mov si,bird_x			;column number
	mov cx,1			;how many height
	mov pixel_width,10 ;how many width
	call PixelDraw

	mov dx,bird_y
	mov temp_bird_y,dx
	add temp_bird_y,12
	mov di,temp_bird_y		;row number
	mov dx,bird_x
	mov temp_bird_x,dx
	add temp_bird_x,2
	mov si,temp_bird_x			;column number
	mov cx,1			;how many height
	mov pixel_width,6 ;how many width
	call PixelDraw

	mov dx,bird_y
	mov temp_bird_y,dx
	add temp_bird_y,7
	mov di,temp_bird_y		;row number
	mov dx,bird_x
	mov temp_bird_x,dx
	sub temp_bird_x,10
	mov si,temp_bird_x			;column number
	mov cx,1			;how many height
	mov pixel_width,7 ;how many width
	call PixelDraw

	
	mov dx,bird_y
	mov temp_bird_y,dx
	add temp_bird_y,6
	mov di,temp_bird_y		;row number
	mov dx,bird_x
	mov temp_bird_x,dx
	sub temp_bird_x,9
	mov si,temp_bird_x			;column number
	mov cx,1			;how many height
	mov pixel_width,5 ;how many width
	call PixelDraw

	
	mov dx,bird_y
	mov temp_bird_y,dx
	add temp_bird_y,5
	mov di,temp_bird_y		;row number
	mov dx,bird_x
	mov temp_bird_x,dx
	sub temp_bird_x,8
	mov si,temp_bird_x			;column number
	mov cx,1			;how many height
	mov pixel_width,0 ;how many width
	call PixelDraw

	mov dx,bird_y
	mov temp_bird_y,dx
	add temp_bird_y,5
	mov di,temp_bird_y		;row number
	mov dx,bird_x
	mov temp_bird_x,dx
	sub temp_bird_x,6
	mov si,temp_bird_x			;column number
	mov cx,1			;how many height
	mov pixel_width,1 ;how many width
	call PixelDraw


	mov dx,bird_y
	mov temp_bird_y,dx
	add temp_bird_y,4
	mov di,temp_bird_y		;row number
	mov dx,bird_x
	mov temp_bird_x,dx
	sub temp_bird_x,7
	mov si,temp_bird_x			;column number
	mov cx,1			;how many height
	mov pixel_width,1 ;how many width
	call PixelDraw
	ret
	Bird_Drawing endp

	PixelDraw proc
		
	mov bx,pixel_width				
	push si
	push di
	outer_pixel_draw:
		push cx
			mov bl,00
			mov bh,00
			inner_pixel_draw:
			cmp bx,pixel_width
			ja again
			mov ah,0ch       ;interrupt number
			mov al,colour		 ;color
			mov cx,si        ;column number
			mov dx,di        ;row number
			int 10h
			inc si
			inc bx
			jmp inner_pixel_draw
		again:
		pop cx
		pop di
		pop si
		inc di
		push si
		push di
	loop outer_pixel_draw
	pop dx
	pop dx
	ret	
	PixelDraw endp

	Screen1 proc
		horizontal_start_check:
		cmp mouse_x_coordinate,34
		jae horizontal_end_check
		jmp ret1
		horizontal_end_check:
		cmp mouse_x_coordinate,40
		jbe vertical_start_check
		jmp ret1
		vertical_start_check:
		cmp mouse_y_coordinate,7
		je Screen1a
		jmp ret1

	Screen1a:
	
		mov scren1,1
		mov scren2,0
		mov scren3,0

		ret1:

		ret
	Screen1 endp

	Screen2 proc
		horizontal_start_check2:
		cmp mouse_x_coordinate,24
		jae horizontal_end_check2
		jmp ret2
		horizontal_end_check2:
		cmp mouse_x_coordinate,50
		jbe vertical_start_check2
		jmp ret2
		vertical_start_check2:
		cmp mouse_y_coordinate,10
		je Screen2a
		jmp ret2

		Screen2a:
			mov scren1,0
			mov scren2,1
			mov scren3,0

	ret2:

	ret
	Screen2 endp

		Screen3 proc
		horizontal_start_check2:
		cmp mouse_x_coordinate,34
		jae horizontal_end_check2
		jmp ret3
		horizontal_end_check2:
		cmp mouse_x_coordinate,40
		jbe vertical_start_check2
		jmp ret3
		vertical_start_check2:
		cmp mouse_y_coordinate,13
		je Screen3a
		jmp ret3

		Screen3a:
			mov scren1,0
			mov scren2,0
			mov scren3,1

		ret3:

	ret
	Screen3 endp



	charprint proc
	
		l1:
		mov ah,02h
		mov bh,0
		int 10h
		
		mov ah,02h
		push dx
		
		mov dl,[si]
		cmp dl,'Z'
		je printEnter
		
		mov dl,[si]
		int 21h
		pop dx
		jmp POUT
		
		PRINTENTER:
		
		pop dx
		add dh,2
		mov dl,0
		
		POUT:
		inc si
		add dl,1
		loop l1
	ret
	charprint endp

	charprint1 proc
	
	
		l1:
		mov ah,02h
		mov bh,0
		int 10h
		
		mov ah,02h
		push dx
		
		mov dl,[si]
		cmp dl,'Z'
		je printEnter
		
		mov dl,[si]
		int 21h
		pop dx
		jmp POUT
		
		PRINTENTER:
		
		pop dx
		add dh,2
		mov dl,tempdl
		sub dl,1
		
		POUT:
		inc si
		add dl,1
		loop l1
	ret
	charprint1 endp
	
	
	board proc

		mov ah,0
		mov al,13h
		int 10h

	outer:
		cmp di,160        ;20-180 row
		je away
		mov si,starting_column
	here:
		cmp si,300       ;20-300 column
		je quit
		inc si
		mov ah,0ch       ;interrupt number
		mov al,colour       ;color
		mov cx,si        ;column number
		mov dx,di        ;row number
		int 10h
		
		jmp here
	quit:
		inc di
		jmp outer
	away:

	ret
	board endp
	mouse_function_1 proc

		mouse_interrupt:	
	 
		mov ax,1
		int 33h

		mov ax,03
		int 33h
	 
		cmp bx,1
		jne mouse_interrupt

		mov tempo,8
	 
		mov ax,dx
		div tempo
		mov dh,0         ; for y
		mov dl,al
		mov mouse_y_coordinate,dl
	 
		mov ax,cx
		div tempo
		mov ch,0
		mov cl,al        ; for x
		mov dl,cl
		mov mouse_x_coordinate,dl


	ret 
	mouse_function_1 endp

	rights proc
	
			mov cx,26
		mov dl,string_x_axis
	sub dl,10
		mov dh,string_y_axis
		add dh,16
		mov si,offset string8
		call charprint

		mov dl,0
		mov dh,0
		int 10h
		
	ret
	rights endp
	Beep	 PROC USES AX BX CX
	IN AL, 61h  ;Save state
	PUSH AX	  

	MOV BX, 6818; 1193180/175
	MOV AL, 0B6h  ; Select Channel 2, write LSB/BSB mode 3
	OUT 43h, AL	 
	MOV AX, BX	
	OUT 24h, AL  ; Send the LSB
	MOV AL, AH	 
	OUT 42h, AL  ; Send the MSB
	IN AL, 61h	 ; Get the 8255 Port Contence
	OR AL, 3h		
	OUT 61h, AL  ;End able speaker and use clock channel 2 for input
	MOV CX, 03h ; High order wait value
	MOV DX ,0D04h; Low order wait value
	MOV AX, 86h;Wait service
	INT 15h			
	POP AX;restore Speaker state
	OUT 61h, AL
	RET
BEEP ENDP

end
