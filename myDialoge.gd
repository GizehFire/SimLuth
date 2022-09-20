extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var OpenButton = $InfoBox/VBoxContainer/OpenButton
onready var MSG_Text = $InfoBox/InfoMSG

var aes = AESContext.new()
var my_password:String

# Called when the node enters the scene tree for the first time.
func _ready():
	
	OpenButton.grab_focus()
	
	# Bestimmte Datei Erweiterung (.txt) voreinstellen.
	
	$OpenDialog.add_filter("*.txt")
	$SaveDialog.add_filter("*.txt")
	
	var key = "My secret key!!!" # Key must be either 16 or 32 bytes.
	var data = "My secret text!!" # Data size must be multiple of 16 bytes, apply padding if needed.
	
	# Encrypt ECB
	aes.start(AESContext.MODE_ECB_ENCRYPT, key.to_utf8())
	var encrypted = aes.update(data.to_utf8())
	aes.finish()
	print(encrypted.get_string_from_ascii())
		
	# Decrypt ECB
	aes.start(AESContext.MODE_ECB_DECRYPT, key.to_utf8())
	var decrypted = aes.update(encrypted)
	aes.finish()
	# Check ECB
	assert(decrypted == data.to_utf8())
	print(decrypted.get_string_from_ascii())

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
		
	var MyKey = $KeyFieldLine.text 			# Key must be either 16 or 32 bytes.
	var MyText = $InputText.text		# Info/Text/Message
# warning-ignore:unused_variable
	var myEncrypted
	
	# Daten (MyText) mit MyKey (Password) verschluesseln
	
	aes.start(AESContext.MODE_ECB_ENCRYPT, MyKey.to_utf8())
	myEncrypted = aes.update(MyText.to_utf8())
	aes.finish()
	
	$InputText.text = ""	# Text Feld leeren
	
	
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
