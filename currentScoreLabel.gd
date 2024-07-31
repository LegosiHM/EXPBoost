extends RichTextLabel

var default_text = "0"

func _process(delta):
	var text = str(str(DamageNumbers.current_score))
	self.text = (text)
