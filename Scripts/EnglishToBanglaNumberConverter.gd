# utils.gd

extends Node

# Example: Convert English number to Bangla
func convert_number_to_bangla(number: int) -> String:
	var bangla_digits = {
		"0": "০", "1": "১", "2": "২", "3": "৩", "4": "৪",
		"5": "৫", "6": "৬", "7": "৭", "8": "৮", "9": "৯"
	}
	var english_str = str(number)
	var bangla_str = ""
	for char in english_str:
		if bangla_digits.has(char):
			bangla_str += bangla_digits[char]
		else:
			bangla_str += char
	return bangla_str
