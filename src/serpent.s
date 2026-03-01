  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Copyright (c) 2026 Jahan Addison
  ;; All rights reserved.
  ;;
  ;; Redistribution and use in source and binary forms, with or without
  ;; modification, are permitted provided that the following conditions are met:
  ;;
  ;; 1. Redistributions of source code must retain the above copyright notice, this
  ;;    list of conditions and the following disclaimer.
  ;;
  ;; 2. Redistributions in binary form must reproduce the above copyright notice,
  ;;    this list of conditions and the following disclaimer in the documentation
  ;;    and/or other materials provided with the distribution.
  ;;
  ;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ;; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIEDi
  ;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  ;; DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
  ;; ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  ;; (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  ;; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ;; ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  ;; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  ;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  .include "sfr.i"

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Bank 1 General Purpose Address Space
  ;;
  ;; 256 addresses ($00–$FF) are available for general-purpose data in bank 1:
  ;;
  ;;  $00–$0F: These double as the indirect register pointer cells (@R0–@R3 read
  ;;    their addresses from here depending on IRBK bits in PSW)
  ;;  $10–$FF: Orthogonal general purpose address space, 240 bytes
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;;;;;;;;;;;;;;
  ;; Variables ;;
  ;;;;;;;;;;;;;;;

X = $33   ; horizontal position in frame buffer
Y = $34   ; vertical position in frame buffer

direction = $30   ; movement direction (0 = horizontal, 1 = vertical)
serpent_size = $31  ; size of serpent, set to 0 at game start, winning size is 7
serpent_speed = $35   ; speed of serpent, "1" at game start

  ;; The "piece" that the serpent eats

piece_x = $36   ; horizontal position of piece on screen
piece_y = $37   ; vertical position of piece on screen

seed = $38    ; random seed

  ;; Serpent's tail coordinate addresses

serpent_x1 = $39
serpent_y1 = $3A
serpent_x2 = $3B
serpent_y2 = $3C
serpent_x3 = $3D
serpent_y3 = $3E
serpent_x4 = $40
serpent_y4 = $41
serpent_x5 = $42
serpent_y5 = $43
serpent_x6 = $44
serpent_y6 = $45
serpent_x7 = $46
serpent_y7 = $47


  ;; Reset and interrupt vectors

	.org	0

	jmpf	start

	.org	$3

	jmp	nop_irq

	.org	$b

	jmp	nop_irq

	.org	$13

	jmp	nop_irq

	.org	$1b

	jmp	t1int

	.org	$23

	jmp	nop_irq

	.org	$2b

	jmp	nop_irq

	.org	$33

	jmp	nop_irq

	.org	$3b

	jmp	nop_irq

	.org	$43

	jmp	nop_irq

	.org	$4b

	clr1	p3int,0
	clr1	p3int,1
nop_irq:
	reti


	.org	$130

t1int:
	push	ie
	clr1	ie,7
	not1	ext,0
	jmpf	t1int
	pop	ie
	reti


	.org	$1f0

goodbye:
	not1	ext,0
	jmpf	goodbye


  ;; Header

  .org    $200
  .byte	"Serpent         "
  .byte	"Snake on the VMS - Jahan Addison"

	;; Icon header

	.org	$240

	.word	2,10		; Two frames

	;; Icon palette

	.org	$260

	.word	$0000, $fcfc, $f0a0, $f0f0, $fccf, $f00a, $f00f, $ffff
	.word	$ffff, $ffff, $ffff, $ffff, $ffff, $ffff, $ffff, $ffff

	;; Icon

	.org	$280

	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$01,$11,$11,$11,$11,$11,$10,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$01,$22,$22,$31,$22,$22,$30,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$01,$22,$22,$31,$22,$22,$30,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$01,$22,$22,$31,$22,$22,$30,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$01,$22,$22,$31,$22,$22,$30,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$01,$33,$33,$31,$33,$33,$30,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$01,$11,$11,$11,$11,$11,$10,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$01,$22,$22,$31,$22,$22,$30,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$01,$22,$22,$31,$22,$22,$30,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$01,$22,$22,$31,$22,$22,$30,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$01,$22,$22,$31,$22,$22,$30,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$01,$33,$33,$31,$33,$33,$30,$00,$00,$00
	.byte	$00,$00,$00,$04,$44,$44,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$04,$55,$55,$60,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$04,$55,$55,$60,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$04,$55,$55,$60,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$04,$55,$55,$60,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$04,$66,$66,$60,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$04,$44,$44,$44,$44,$44,$44,$44,$44,$40,$00,$00,$00
	.byte	$00,$00,$00,$04,$55,$55,$64,$55,$55,$64,$55,$55,$60,$00,$00,$00
	.byte	$00,$00,$00,$04,$55,$55,$64,$55,$55,$64,$55,$55,$60,$00,$00,$00
	.byte	$00,$00,$00,$04,$55,$55,$64,$55,$55,$64,$55,$55,$60,$00,$00,$00
	.byte	$00,$00,$00,$04,$55,$55,$64,$55,$55,$64,$55,$55,$60,$00,$00,$00
	.byte	$00,$00,$00,$04,$66,$66,$64,$66,$66,$64,$66,$66,$60,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$01,$11,$11,$11,$11,$11,$10,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$01,$22,$22,$31,$22,$22,$30,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$01,$22,$22,$31,$22,$22,$30,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$01,$22,$22,$31,$22,$22,$30,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$01,$22,$22,$31,$22,$22,$30,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$01,$33,$33,$31,$33,$33,$30,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$04,$44,$44,$41,$11,$11,$11,$11,$11,$10,$00,$00,$00
	.byte	$00,$00,$00,$04,$55,$55,$61,$22,$22,$31,$22,$22,$30,$00,$00,$00
	.byte	$00,$00,$00,$04,$55,$55,$61,$22,$22,$31,$22,$22,$30,$00,$00,$00
	.byte	$00,$00,$00,$04,$55,$55,$61,$22,$22,$31,$22,$22,$30,$00,$00,$00
	.byte	$00,$00,$00,$04,$55,$55,$61,$22,$22,$31,$22,$22,$30,$00,$00,$00
	.byte	$00,$00,$00,$04,$66,$66,$61,$33,$33,$31,$33,$33,$30,$00,$00,$00
	.byte	$00,$00,$00,$04,$44,$44,$44,$44,$44,$44,$44,$44,$40,$00,$00,$00
	.byte	$00,$00,$00,$04,$55,$55,$64,$55,$55,$64,$55,$55,$60,$00,$00,$00
	.byte	$00,$00,$00,$04,$55,$55,$64,$55,$55,$64,$55,$55,$60,$00,$00,$00
	.byte	$00,$00,$00,$04,$55,$55,$64,$55,$55,$64,$55,$55,$60,$00,$00,$00
	.byte	$00,$00,$00,$04,$55,$55,$64,$55,$55,$64,$55,$55,$60,$00,$00,$00
	.byte	$00,$00,$00,$04,$66,$66,$64,$66,$66,$64,$66,$66,$60,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00


 ;
 ;; Start of program
 ;

start:
  ; For any game:
	clr1 ie,7
	mov #$a1,ocr
	mov #$09,mcr
	mov #$80,vccr
	clr1 p3int,0
	clr1 p1,7
	mov #$ff,p3

  call clrscr
  mov #0,xbnk       ; ensure we draw into bank 0 (upper screen)
  mov #3,X
  mov #$f,Y
  mov #$F8,2
  mov #$1,@R2

.keypress:
  call getkeys
  bn acc,4,.keypress
  bn acc,5,.keypress
  bn acc,3,.moveright
  bn acc,2,.moveleft
  bn acc,1,.movedown
  bn acc,0,.moveup
  br .done

  .moveright:
  call pause
  call moveright
  call pause
  br .done
  .moveleft:
  call pause
  call moveleft
  call pause
  br .done
  .movedown:
  call pause
  call movedown
  call pause
  br .done
  .moveup:
  call pause
  call moveup
  call pause
  br .done

  .done:
  br .keypress


; Subroutines.

moveup:
  clr1 ocr,5
  ld Y
  ; check if top of buffer
  be #0,.up
  ; branch to bank 0 coroutine at 16
  be #$10,.ubank
  ; check the lowest-order bit (big-endian) for even to skip
  bn Y,0,.upskip
  ; move up
  .upcont:
  dec Y
  ld @R2
  push acc
  mov #0,@R2
  .upcontt:
  ld 2
  sub #6
  st 2
  pop acc
  st @R2
  br .up
  .ubank:
  ; save our current state for bank 0
  ld @R2
  push acc
  mov #0,@R2
  mov #0,xbnk
  ld 2
  ; add by 118 to get the last row position on the new bank
  add #$76
  st 2
  dec Y
  pop acc
  st @R2
  ; we've moved up, we're done here
  br .up
  .upskip:
  dec Y
  ld @R2
  mov #0,@R2
  push acc
  ld 2
  sub #4
  st 2
  br .upcontt
  .up:
  set1 ocr,5
  ret


moveright:
  clr1 ocr,5
  ld X
  ; check if buffer cannot move right any further
  be #6,.right
  ; when we're on the last, we ensure we move until the most-significant bit
  be #5,.rightfinal
  .rightcontinue:
  ; move right
  ld @R2
  clr1 psw,7
  rorc
  ; check the carry flag for overflow of our bit, which
  ; means it's time to move to the next byte
  bp psw,7,.rightnext
  st @R2
  br .right
  .rightnext:
  ; move right the next byte to prepare to store the most-significant bit of current
  inc 2
  ror
  ld @R2
  set1 acc,7
  st @R2
  ; clear the current most-significant bit. if the byte is
  ; now clear, we can proceed with the next byte
  dec 2
  ld @R2
  clr1 acc,0
  st @R2
  clr1 psw,7
  bnz .right
  inc X
  ld X
  inc 2
  br .right
  .rightfinal:
  ld @R2
  bp acc,0,.rightdone
  br .rightcontinue
  .rightdone:
  inc X
  .right:
  set1 ocr,5
  ret


moveleft:
  clr1 ocr,5
  ld X
  ; check if buffer cannot move left any further
  be #0,.left
  ; when we're on the last, we ensure we move until the most-significant bit
  be #1,.leftfinal
  .leftcontinue:
  ; move left
  ld @R2
  clr1 psw,7        ; clear carry before rotate (matches moveright pattern)
  rolc
  ; check the carry flag for overflow of our bit, which
  ; means it's time to move to the preceding byte
  bp psw,7,.leftnext
  st @R2
  br .left
  .leftnext:
  ; move left the previous byte to prepare to store the most-significant bit of current
  dec 2
  rol
  ld @R2
  set1 acc,0
  st @R2
  ; clear the current most-significant bit. if the byte is
  ; now clear, we can proceed with the preceding byte
  inc 2
  ld @R2
  clr1 acc,7
  st @R2
  clr1 psw,7
  bnz .left
  dec X
  ld X
  dec 2
  br .left
  .leftfinal:
  ld @R2
  bp acc,7,.leftdone
  br .leftcontinue
  .leftdone:
  dec X
  .left:
  set1 ocr,5
  ret


movedown:
  clr1 ocr,5
  ld Y
  ; check if bottom of buffer
  be #$1F,.down
  ; branch to bank 1 coroutine at 15
  be #$f,.dbank
  ; check the lowest-order bit (big-endian) for odd to skip
  bp Y,0,.downskip
  ; move down
  .downcont:
  inc Y
  ld @R2
  push acc
  mov #0,@R2
  .downcontt:
  ld 2
  add #6
  st 2
  pop acc
  st @R2
  br .down
  .dbank:
  ; save our current state for bank 1
  ld @R2
  push acc
  mov #0,@R2
  mov #1,xbnk
  ld 2
  ; subtract by 118 to get the first row position on the new bank
  sub #$76
  st 2
  inc Y
  pop acc
  st @R2
  ; we've moved down, we're done here
  br .down
  .downskip:
  inc Y
  ld @R2
  mov #0,@R2
  push acc
  ld 2
  add #4
  st 2
  br .downcontt
  .down:
  set1 ocr,5
  ret


pause:
  mov #0,b
  .start:
  mov #0,t1lc       ; compare = 0: pulse stays high (no beep) while timer runs
  mov #1,t1lr
  mov #$48,t1cnt    ; T1LRUN (bit 6) = 1, starts T1L
  .run:
  ld t1lr
  bne #$ff,.run
  inc b
  ld b
 ; bne #1,.start
  mov #0,t1cnt      ; clear all T1 bits, stops T1L (bit 6) and T1H (bit 7)
  ret


clrscr:
  clr1 ocr,5
  push acc
  push xbnk
  push 2
  mov #0,xbnk
  .cbank:
  mov #$80,2
  .cloop:
  mov #0,@R2
  inc 2
  ld 2
  and #$f
  bne #$c,.cskip
  ld 2
  add #4
  st 2
  .cskip:
  ld 2
  bnz .cloop
  bp xbnk,0,.cexit
  mov #1,xbnk
  br .cbank
  .cexit:
  pop 2
  pop xbnk
  pop acc
  set1 ocr,5
  ret


setscr:
  clr1 ocr,5
  push acc
  push xbnk
  push c
  push 2
  mov #$80,2
  xor acc
  st xbnk
  st c
.sloop:
  ldc
  st @R2
  inc 2
  ld 2
  and #$f
  bne #$c,.sskip
  ld 2
  add #4
  st 2
  bnz .sskip
  inc xbnk
  mov #$80,2
.sskip:
  inc c
  ld c
  bne #$c0,.sloop
  pop 2
  pop c
  pop xbnk
  pop acc
  set1 ocr,5
  ret

getkeys:
  bp p7,0,quit
  ld p3
  bn acc,6,quit
  bn acc,7,sleep
  ret
quit:
  jmp goodbye

sleep:
  bn p3,7,sleep		; wait for SLEEP to be depressed (released)
  mov #0,vccr		; blank LCD before halting
sleepmore:
  set1 pcon,0		; enter HALT mode
  bp p7,0,quit		; docked?
  bp p3,7,sleepmore	; no SLEEP press yet
  mov #$80,vccr		; re-enable LCD
waitsleepup:
  bn p3,7,waitsleepup
  br getkeys

  .cnop   0,$200          ; pad to an even number of blocks
