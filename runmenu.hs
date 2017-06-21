;runmenu.hs

	font "tiny_en.ttf",30

	sdim fnm,16,16
	sdim ttl,32,16

	fnm(0)="start"    :ttl(0)="TINY PAINT"
	fnm(1)="rndstar"  :ttl(1)="RANDOM STARS"
	fnm(2)="maze"     :ttl(2)="THE MAZE"
	fnm(3)="rpgmap"   :ttl(3)="RPG MAP"
	fnm(4)="kakiget"  :ttl(4)="GET PERSIMMON"
	fnm(5)="landing"  :ttl(5)="LANDING"
	fnm(6)="pakmen"   :ttl(6)="PAK-MEN"
	fnm(7)="ufo_atk"  :ttl(7)="UFO ATTACK"
	fnm(8)="tinytrek" :ttl(8)="TINY TREK"
	fnm(9)="ex_start" :ttl(9)="EXTRA HELLO WORLD"
	fnm(10)="ex_broad":ttl(10)="BINARY ROAD"
	fnm(11)="ex_music":ttl(11)="BEEP MUSIC"

	title "Please select the program and click on it."

	color 80,80,255 :boxf 0,0,640,480
	color 255,255,255
	repeat 12
		pos 40,30+30*cnt :mes ttl(cnt)
	loop

	repeat
		wait 10 :stick k
		n=mousey/30
		if n>0 and n<13 {
			redraw 0
			color 80,80,255 :boxf 0,0,39,480
			color 255,255,255 :pos 10,30*n :mes "->"
			redraw 1
			if k=256 :break
		}
	loop

	wait 30
	boxf 0,0,640,480 :color
	run fnm(n-1)+".hs"
