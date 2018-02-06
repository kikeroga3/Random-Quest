;PON

	bx=320 :by=240 :bdx=-4 :bdy=4
	px=320 :py=450

*main
	redraw 0
	color 0,0,0 :boxf 8,8,632,480
	color 255,255,255
	circle bx-2,by-2,bx+2,by+2
	boxf px-16,py-3,px+16,py+3
	redraw 1 :wait 8

	bx=bx+bdx :by=by+bdy
	stick k
	if k=1 and px>0 :px=px-4
	if k=4 and px<639 :px=px+4

	if bx<0 or bx>639 :bdx=-bdx
	if by<0 :bdy=-bdy
	if abs(px-bx)<32 and abs(py-by)<8 {
		bdy=-bdy
	}

	goto *main

