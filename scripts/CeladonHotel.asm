CeladonHotel_Script:
	jp EnableAutoTextBoxDrawing

CeladonHotel_TextPointers:
	def_text_pointers
	dw_const CeladonHotelGrannyText,        TEXT_CELADONHOTEL_GRANNY
	dw_const CeladonHotelBeautyText,        TEXT_CELADONHOTEL_BEAUTY
	dw_const CeladonHotelSuperNerdText,     TEXT_CELADONHOTEL_SUPER_NERD
	dw_const CeladonHotelAlakazamaniacText, TEXT_CELADONHOTEL_ALAKAZAMANIAC

CeladonHotelGrannyText:
	text_far _CeladonHotelGrannyText
	text_end

CeladonHotelBeautyText:
	text_far _CeladonHotelBeautyText
	text_end

CeladonHotelSuperNerdText:
	text_far _CeladonHotelSuperNerdText
	text_end

CeladonHotelAlakazamaniacText:
	text_asm
	ld a, TRADE_FOR_ALAKAZAM
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	jp TextScriptEnd
