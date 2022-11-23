extends Control

onready var OpenButton = $InfoBox/VBoxContainer/OpenButton
onready var MSG_Text = $InfoBox/InfoMSG

var aes = AESContext.new()
var my_password:String

const Divider16: int = 16
const Divider32: int = 32

# Called when the node enters the scene tree for the first time.

func _ready():
	
	OpenButton.grab_focus()
	
	# Bestimmte Datei Erweiterung (.txt) voreinstellen.
	
	$OpenDialog.add_filter("*.txt")
	$SaveDialog.add_filter("*.txt")	
	
	pass
	
func Date_Encrypt():
	
	var aes_two = AESContext.new()
	
	var MyKey = $KeyFieldLine.text 			# Key must be either 16 or 32 bytes.
	var MyText = $InputText.text			# Info/Text/Message
	
	# Daten (MyText) mit MyKey (Password) verschluesseln
	
	print(MyKey)
	print(MyText)
		
	aes_two.start(AESContext.MODE_ECB_ENCRYPT, MyKey.to_utf8())
	var myEncrypted = aes_two.update(MyText.to_utf8())
	aes_two.finish()
	
	print(myEncrypted)
	
	pass
	
func _on_OpenButton_pressed():
	
	MSG_Text.text = "Pressed 'Open'"
	
	$OpenDialog.popup()
	
	pass # Replace with function body.

func _on_SaveButton_pressed():
	
	MSG_Text.text = "Pressed 'Save'"
	$SaveDialog.popup()
	
	pass # Replace with function body.

func _on_ResetButton_pressed():
	
	MSG_Text.text = "'Reset': Clear"
	
	# # # Alles zurueck setzen!
	
	# Textfeld leeren
	$InputText.text = ""
	# Passwordfeld leeren
	$KeyFieldLine.text = ""
	# Das Feld verdecken als "*" anzeigen
	$KeyFieldLine.secret = true
	# Schalte umsetzen
	$CheckButton.pressed = false
	# Textfeld (Ausgabefeld) leeren
	$Output.text =""
	
	pass # Replace with function body.

func _on_ExitButton_pressed():
	
	MSG_Text.text = "Pressed 'Exit'"
	
	#  Exit Program	
	get_tree().quit() 
	
func _on_OpenDialog_file_selected(path):
	
	var f = File.new()
	f.open(path,1)
	$InputText.text = f.get_as_text()
	f.close()

func _on_SaveDialog_file_selected(path):
	
	var f = File.new()
	f.open(path,2)
	f.store_string($InputText.text)
	f.close()

func _on_EnCryptButton_pressed():
	
	if $InputText.text == "" and $KeyFieldLine.text == "":
		
		$MsgDialog.dialog_text = "Keine Nachricht und Password eingegeben - Bitte beide ausfuellen"
		$MsgDialog.popup()
		
		return 
	
	if $InputText.text == "":
		
		$MsgDialog.dialog_text = "Nachricht Feld - Bitte ausfuellen"
		$MsgDialog.popup()
		
		return 
	
	if $KeyFieldLine.text == "":
		
		$MsgDialog.dialog_text = "Kein Password eingegeben. Bitte eingeben."
		$MsgDialog.popup()
		
		return
	
	Date_Encrypt()
	
	pass # Replace with function body.

func _on_CheckButton_pressed():
	
	# $MsgDialog.dialog_text = "Pressed"
	# $MsgDialog.popup()
	
	# Password - Feld nicht anzeigen, stattdessen als "*" anzeigen
	
	if $CheckButton.pressed == false:
		
		$KeyFieldLine.secret = true
		
		return
	
	# Password - Feld anzeigen
	
	if $CheckButton.pressed == true:
		
		$KeyFieldLine.secret = false
		
		return
	
	pass # Replace with function body.

func _on_CounterButton_pressed():
	
	var Length_Counter_Text:int
	var Length_Counter_Pass_Key:int
	var Lenght_Char:String
	
	# Zeichenlaenge fuer Inhalt
	Lenght_Char = $InputText.text
	Length_Counter_Text = Lenght_Char.length()
	
	# Zeichenlaenge fuer Passwort
	Lenght_Char = $KeyFieldLine.text
	Length_Counter_Pass_Key = Lenght_Char.length()
	
	# Zeichenlaenge für Inhalt und Passwort auf dem Dialogsfeld
	# anzeigen:
	
	$MsgDialog.dialog_text = "TextLaenge: " + str(Length_Counter_Text) \
	+ "\n" + "PasswordLaenge: " + str(Length_Counter_Pass_Key) + "\n"
	
	$MsgDialog.popup()
	
	pass # Replace with function body.
	
func fuellung(var counter_char:int):
	
	# von "!" bis "~"
	# 21h (33d) - 7Eh (126d) Ascii - Code (UTF8)
	
	var input_text:String
	var myChar:int = 33  
	var random = RandomNumberGenerator.new()
	
	for myCounter in range(counter_char):
		
		random.randomize()
		myChar = myChar + random.randi() % 93
		
		input_text = input_text + char(myChar)		
		myChar = 33
	
	return input_text
	
func _on_AutoFillButton_pressed():
	
	$KeyFieldLine.text = fuellung(16)
	$InputText.text = fuellung(128)
	
	pass # Replace with function body.


func _on_DetailsButton_pressed():
	
	$DetailsDialog.popup()
	
	pass # Replace with function body.


func _on_HSlider_value_changed(value):
	
	var werte:int
	
	werte = $HSlider.value
	
	$HSlider/TextEditHSliderCounter.text = str(werte)
	
	pass # Replace with function body.


func _on_TextEditHSliderCounter_text_changed():
	
	var counter_last_char:int
	var tastencode:int
	var textswap:String
	var textswap2:String
	
	var myKeyPr = InputEventKey.new()
	
	#counter_last_char = $HSlider/TextEditHSliderCounter.text.length()
	#textswap = $HSlider/TextEditHSliderCounter.text
	
	#if not $HSlider/TextEditHSliderCounter.text.is_valid_integer():
		
		#textswap.erase(counter_last_char-1,1)
		#$HSlider/TextEditHSliderCounter.text = textswap
		#$HSlider/TextEditHSliderCounter.undo()
	
	#if myKeyPr.scancode() == 0:
	
	#print(Input.get_scancode())
	
	# print("Log: " + str(counter_last_char) + " " + str(tastencode))
	
	#for _tastencode in range(52):
		
	#if Input.is_key_pressed(48) in range(52):
	# print("Log: " + "Pressed Number 0")
	
	if Input.is_key_pressed(48 - 57):
		_input(42)
	
	pass # Replace with function body.
	
func _input(ev):
	
	var tastencode:String
	
	if ev is InputEventKey:
		if ev.scancode >= 48 and ev.scancode <= 57:
			#print("Taste 0 bis 9")
			print(char(ev.scancode))
	pass
