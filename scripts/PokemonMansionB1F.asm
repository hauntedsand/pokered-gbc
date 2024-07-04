PokemonMansionB1F_Script:
	call MansionB1FCheckReplaceSwitchDoorBlocks
	call EnableAutoTextBoxDrawing
	ld hl, Mansion4TrainerHeaders
	ld de, PokemonMansionB1F_ScriptPointers
	ld a, [wPokemonMansionB1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonMansionB1FCurScript], a
	ret

MansionB1FCheckReplaceSwitchDoorBlocks:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	CheckEvent EVENT_MANSION_SWITCH_ON
	jr nz, .switchTurnedOn
	ld a, $e
	ld bc, $80d
	call Mansion2ReplaceBlock
	ld a, $e
	ld bc, $b06
	call Mansion2ReplaceBlock
	ld a, $5f
	ld bc, $304
	call Mansion2ReplaceBlock
	ld a, $54
	ld bc, $808
	call Mansion2ReplaceBlock
	ret
.switchTurnedOn
	ld a, $2d
	ld bc, $80d
	call Mansion2ReplaceBlock
	ld a, $5f
	ld bc, $b06
	call Mansion2ReplaceBlock
	ld a, $e
	ld bc, $304
	call Mansion2ReplaceBlock
	ld a, $e
	ld bc, $808
	call Mansion2ReplaceBlock
	ret

Mansion4Script_Switches::
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	xor a
	ldh [hJoyHeld], a
	ld a, TEXT_POKEMONMANSIONB1F_SWITCH
	ldh [hSpriteIndexOrTextID], a
	jp DisplayTextID

; SCRIPT_POKEMONMANSIONB1F_DEFAULT originally referred directly to CheckFightingMapTrainers
PokemonMansionB1F_ScriptPointers:
	def_script_pointers
	dw_const PokemonMansionB1F_DefaultScript,       SCRIPT_POKEMONMANSIONB1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_POKEMONMANSIONB1F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_POKEMONMANSIONB1F_END_BATTLE
	dw_const PokemonMansionB1F_MewPostBattle,       SCRIPT_POKEMONMANSIONB1F_MEW_POST_BATTLE

PokemonMansionB1F_ResetScripts:
; Called if the player lost the battle to reset the current scripts back to
; the defaults
	xor a
	ld [wJoyIgnore], a
	ld [wPokemonMansionB1FCurScript], a
	ld [wCurMapScript], a
	ret

PokemonMansionB1F_DefaultScript:
; If you already captured Mew, there's no Mew left to challenge
	CheckEventHL EVENT_CAPTURED_POKEMONMANSIONB1F_MEW
	jp nz, CheckFightingMapTrainers
; Check whether we triggered an encounter with Mew. If so, reset the event
; so we can try again if we fail to capture
	CheckEventReuseHL EVENT_ENCOUNTER_POKEMONMANSIONB1F_MEW
	ResetEventReuseHL EVENT_ENCOUNTER_POKEMONMANSIONB1F_MEW
	jp z, CheckFightingMapTrainers
; Announce what's coming
	ld a, TEXT_POKEMONMANSIONB1F_MEW_APPROACHED
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
; Queue up a battle with a level 30 Mew
	ld a, MEW
	ld [wCurOpponent], a
	ld a, 30
	ld [wCurEnemyLVL], a
; Queue up the post-battle script
	ld a, SCRIPT_POKEMONMANSIONB1F_MEW_POST_BATTLE
	ld [wPokemonMansionB1FCurScript], a
	ld [wCurMapScript], a
	ret

PokemonMansionB1F_MewPostBattle:
; Check whether the player lost the battle
	ld a, [wIsInBattle]
	cp $ff
	jr z, PokemonMansionB1F_ResetScripts
; Check whether the player caught Mew
	ld a, [wBattleResult]
	cp $2
	jr z, .caught_mew
; If the player didn't catch Mew, display a message
	ld a, TEXT_POKEMONMANSIONB1F_MEW_RAN
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
; Congrats
.caught_mew:
	SetEvent EVENT_CAPTURED_POKEMONMANSIONB1F_MEW
	call Delay3
	ld a, SCRIPT_POKEMONMANSIONB1F_DEFAULT
	ld [wPokemonMansionB1FCurScript], a
	ld [wCurMapScript], a
	ret

PokemonMansionB1F_TextPointers:
	def_text_pointers
	dw_const PokemonMansionB1FBurglarText,   TEXT_POKEMONMANSIONB1F_BURGLAR
	dw_const PokemonMansionB1FScientistText, TEXT_POKEMONMANSIONB1F_SCIENTIST
	dw_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_RARE_CANDY
	dw_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_FULL_RESTORE
	dw_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_TM_BLIZZARD
	dw_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_TM_SOLARBEAM
	dw_const PokemonMansionB1FDiaryText,     TEXT_POKEMONMANSIONB1F_DIARY
	dw_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_SECRET_KEY
	dw_const PokemonMansion2FSwitchText,     TEXT_POKEMONMANSIONB1F_SWITCH ; This switch uses the text script from the 2F.
	dw_const PokemonMansionB1FMewApproached, TEXT_POKEMONMANSIONB1F_MEW_APPROACHED
	dw_const PokemonMansionB1FMewRan,        TEXT_POKEMONMANSIONB1F_MEW_RAN

Mansion4TrainerHeaders:
	def_trainers
Mansion4TrainerHeader0:
	trainer EVENT_BEAT_MANSION_4_TRAINER_0, 0, PokemonMansionB1FBurglarBattleText, PokemonMansionB1FBurglarEndBattleText, PokemonMansionB1FBurglarAfterBattleText
Mansion4TrainerHeader1:
	trainer EVENT_BEAT_MANSION_4_TRAINER_1, 3, PokemonMansionB1FScientistBattleText, PokemonMansionB1FScientistEndBattleText, PokemonMansionB1FScientistAfterBattleText
	db -1 ; end

PokemonMansionB1FBurglarText:
	text_asm
	ld hl, Mansion4TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PokemonMansionB1FScientistText:
	text_asm
	ld hl, Mansion4TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

PokemonMansionB1FBurglarBattleText:
	text_far _PokemonMansionB1FBurglarBattleText
	text_end

PokemonMansionB1FBurglarEndBattleText:
	text_far _PokemonMansionB1FBurglarEndBattleText
	text_end

PokemonMansionB1FBurglarAfterBattleText:
	text_far _PokemonMansionB1FBurglarAfterBattleText
	text_end

PokemonMansionB1FScientistBattleText:
	text_far _PokemonMansionB1FScientistBattleText
	text_end

PokemonMansionB1FScientistEndBattleText:
	text_far _PokemonMansionB1FScientistEndBattleText
	text_end

PokemonMansionB1FScientistAfterBattleText:
	text_far _PokemonMansionB1FScientistAfterBattleText
	text_end

PokemonMansionB1FDiaryText:
	text_far _PokemonMansionB1FDiaryText
	text_end

PokemonMansionB1FMewApproached:
	text_far _PokemonMansionB1FMewApproached
	text_end

PokemonMansionB1FMewRan:
	text_far _PokemonMansionB1FMewRan
	text_end
