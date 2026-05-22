extends AudioStreamPlayer


func boss_start_mus():
	if playing == true:
		return
	play()

func boss_stop_mus():
	stop()
