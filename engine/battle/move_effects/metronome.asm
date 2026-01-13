BattleCommand_Metronome:
	call ClearLastMove
	call CheckUserIsCharging
	jr nz, .charging

	ld a, [wBattleAnimParam]
	push af
	call BattleCommand_LowerSub
	pop af
	ld [wBattleAnimParam], a

.charging
	call LoadMoveAnim

.GetMove:
	call BattleRandom

; No invalid moves.
	cp NUM_ATTACKS + 1
	jr nc, .GetMove

; Only allow attacking moves (power > 0).
	ld b, a                    ; Store move ID in b
	push bc
	dec a                      ; Move IDs are 1-indexed, adjust to 0-indexed
	ld hl, Moves + MOVE_POWER  ; Point to MOVE_POWER offset in Moves table
	call GetMoveAttr           ; Get power value for move a
	and a                      ; Check if power is 0
	pop bc
	jr z, .GetMove             ; If power = 0 (status move), re-roll

; None of the moves in MetronomeExcepts.
	ld a, b                    ; Restore move ID from b
	push af
	ld de, 1
	ld hl, MetronomeExcepts
	call IsInArray
	pop bc
	jr c, .GetMove

; No moves the user already has.
	ld a, b
	call CheckUserMove
	jr z, .GetMove

	ld a, BATTLE_VARS_MOVE
	call GetBattleVarAddr
	ld [hl], b
	call UpdateMoveData
	jp ResetTurn

INCLUDE "data/moves/metronome_exception_moves.asm"
