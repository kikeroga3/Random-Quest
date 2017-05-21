title "LinePaint"

sdim mds,16,16
mds(0)="LINE"
mds(1)="PSET"
mds(2)="PAINT"
mds(3)="COLOR"
mds(4)="BOXF"
mds(5)="CIRCLE"

sdim bf,64000

poke bf,0,248	;F8

mode=255 :i=1
old_r=0 :old_g=0:old_b=0
col_r=0 :col_g=0:col_b=0

old_x = -1
old_y = -1
now_x = 0
now_y = 0

color :boxf 480,0,639,479


bload "cg001.bin",bf :gosub *draw

;pos 10,10:picload "monster.png"
;redraw 1

repeat
	stick key
	if key & 256 {
		gosub *btn_r
	}
	if key & 512 {
		gosub *btn_l
	}
	if key=128 {
		bsave "cg001.bin",bf
	}
	wait 5
	title "i="+i
loop

stop

*btn_r
	if mode=255 {
		if old_x=-1 {
			old_x = mousex
			old_y = mousey
			poke bf,i,255
			poke bf,i+1,old_x/2
			poke bf,i+2,old_y/2
			i=i+3
		} else {
			now_x = mousex
			now_y = mousey
			if (old_x ! now_x) or (old_y ! now_y) {
			line old_x, old_y, now_x, now_y
			old_x = now_x
			old_y = now_y
			poke bf,i,now_x/2
			poke bf,i+1,now_y/2
			i=i+2
			}
		}
	}

return



*btn_l
	if mode=255 :old_x=-1

return


*draw
	i=1
	repeat
		a=peek(bf,i)
		if a=0 :stop
		if a=255 {
			x1=peek(bf,i+1)*2
			y1=peek(bf,i+2)*2
			i=i+3
		} else {
			x2=peek(bf,i)*2
			y2=peek(bf,i+1)*2
			line x1,y1,x2,y2
			x1=x2 :y1=y2
			i=i+2
		}
	loop
