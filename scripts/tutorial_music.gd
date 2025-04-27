extends AudioStreamPlayer

var fade_out: bool = false

func _ready():
	Global.game_start.connect(func(): fade_out = true)
	
func _process(delta):
	if fade_out:
		self.volume_db -= 10 * delta
		print(self.volume_db)
		if self.volume_db <= -30:
			self.stop()
			fade_out = false
