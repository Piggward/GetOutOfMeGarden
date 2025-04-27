extends AudioStreamPlayer

var goal_volume: float
var fade_in: bool = false

func start_fade_in():
	goal_volume = self.volume_db
	self.volume_db = -40
	self.play()
	fade_in = true
	
func _process(delta):
	if fade_in:
		self.volume_db += 10 * delta
		if self.volume_db >= goal_volume:
			fade_in = false
		print(self.volume_db)
