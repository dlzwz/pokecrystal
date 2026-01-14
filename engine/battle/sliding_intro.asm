BattleIntroSlidingPics:
; Skip the sliding animation for a faster battle intro.
; Just set the final state directly: hSCX = 0, palettes initialized.
	ldh a, [rWBK]
	push af
	ld a, BANK(wLYOverrides)
	ldh [rWBK], a

	; Set final scroll position (no offset)
	xor a
	ldh [hSCX], a

	; Clear wLYOverrides to 0 (final state)
	ld hl, wLYOverrides
	ld bc, SCREEN_HEIGHT_PX
	call ByteFill

	; Initialize palettes
	ld a, %11100100
	call DmgToCgbBGPals
	lb de, %11100100, %11100100
	call DmgToCgbObjPals

	; Move sprites to final X position.
	; Original animation moves each sprite left by 2 pixels, 72 times (for a total of 144 pixels).
	; We need to subtract 144 ($90) from each sprite's X coordinate.
	ld hl, wShadowOAMSprite00XCoord
	ld c, $12 ; 18 sprites
	ld de, OBJ_SIZE
.loop
	ld a, [hl]
	sub $90
	ld [hl], a
	add hl, de
	dec c
	jr nz, .loop

	pop af
	ldh [rWBK], a
	ret
