	bx=320 :by=240 :bdx=-4 :bdy=4
	p1x=8 :p1y=240
	p2x=632 :p2y=240

*main
	redraw 0
	color 0,0,0 :boxf 0,8,639,472
	color 255,255,255
	circle bx-2,by-2,bx+2,by+2
	boxf p1x-3,p1y-16,p1x+3,p1y+16
	boxf p2x-3,p2y-16,p2x+3,p2y+16
	redraw 1 :wait 8

	bx=bx+bdx :by=by+bdy
	stick k
	if k=2 and p2y>0 :p2y=p2y-4
	if k=8 and p2y<479 :p2y=p2y+4
	if mousey<p1y :p1y=p1y-4
	if mousey>p1y :p1y=p1y+4

	if by<0 or by>479 :bdy=-bdy

	if abs(p1y-by)<32 and abs(p1x-bx)<8 {
		bdx=-bdx
	}

	if abs(p2y-by)<32 and abs(p2x-bx)<8 {
		bdx=-bdx
	}

	goto *main
