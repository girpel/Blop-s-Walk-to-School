extends "label_item.gd"

const ITEMS_VOWLES := "aeiou"

const ITEMS_TEXT_ARTICLE_EMPTY := [
	"nothing", 
	"toilet paper", 
	"canned pizza", 
	"dentures",
	"root beer",
	"disguise glasses",
	"extra spicy instant noodles",
	"running shoes",
	"mini Billy",
	"cosmic pickles",
	"bottled cosmos",
	"alien currency",
	"Bob",
	"contained chi",
	"aether",
	"the vending machine"
]

func text_set(value: String) -> void:
	
	var text_article := " a"
	
	if value in ITEMS_TEXT_ARTICLE_EMPTY:
		text_article = ''
	
	else:
		for character in ITEMS_VOWLES:
			if value[0] == character:
				text_article = " an"
				break
	
	super(text_article)
	
	return
