	title "LinePaint"

	lfnm=""				;ロードするファイル名(""なら新規)
	lfnm="grp001.bin"
	sfnm="grp001.bin"	;セーブするファイル名

	sdim linbf,64000
	mode=0 :und=0 :adr=0
	sta=0 :x1=-1 :y1=-1
	c_r=0 :c_g=0 :c_b=0
	o_r=1 :o_g=1 :o_b=1

	if lfnm!"" {
		bload lfnm,linbf :gosub *draw
	}

	menu(0)="LINE" :menu(1)="PAINT"
	font "tiny_en.ttf",20
	gosub *navi




repeat
	stick key
	if key&256 {

		if mousex<480 {
			gosub *col_chg
			if mode {
				gosub *pai
			} else {
				gosub *lset
			}
		} else {
			a=mousey/20
			if a=1 :mode=1-mode :wait 30
			
			if a=4 :c_r=(c_r+1)\16
			if a=5 :c_g=(c_g+1)\16
			if a=6 :c_b=(c_b+1)\16

			if a=8 {
				color 255,255,255 :boxf 0,0,480,480
				color 16*(c_r+1)-1,16*(c_g+1)-1,16*(c_b+1)-1
				adr=0 :gosub *draw
			}
		}
		gosub *navi

	}

	if key & 512 {
		x1=-1 :title "LINE START"
	}

	if key=128 {
		bsave sfnm,linbf
		title "SAVE "+sfnm+" c_b="+c_b
	}


	wait 10
loop
stop

*lset
	x2=mousex :y2=mousey
	if x1=-1 {
		adr=adr-3*sta
		x1=x2 :y1=y2
		poke linbf,adr,255
		poke linbf,adr+1,x1/3
		poke linbf,adr+2,y1/2
		und=adr :adr=adr+3 :sta=1
		title "LINE:"+x1+","+y1
	}
	if (x1!x2) or (y1!y2) {
		line x1,y1,x2,y2
		poke linbf,adr,x2/3
		poke linbf,adr+1,y2/2
		und=adr :adr=adr+2 :sta=0
		title "LINE:"+x1+","+y1+"-"+x2+","+y2
		x1=x2 :y1=y2
	}
	return




*draw
	repeat

		p=peek(linbf,adr)
		if p=0 :break
		if (und!0) and (adr>=und) :break

		if p=253 {
			c_r=peek(linbf,adr+1)-1
			c_g=peek(linbf,adr+2)-1
			c_b=peek(linbf,adr+3)-1
			adr=adr+4
			color 16*(c_r+1)-1,16*(c_g+1)-1,16*(c_b+1)-1
			continue
		}

		if p=254 {
			x3=peek(linbf,adr+1)*3
			y3=peek(linbf,adr+2)*2
			adr=adr+3
			paint x3,y3
			continue
		}

		if p=255 {
			x1=peek(linbf,adr+1)*3
			y1=peek(linbf,adr+2)*2
			adr=adr+3
		} else {
			x2=peek(linbf,adr)*3
			y2=peek(linbf,adr+1)*2
			line x1,y1,x2,y2
			x1=x2 :y1=y2
			adr=adr+2
		}
	loop
	return





*pai
	x3=mousex :y3=mousey
    paint x3,y3
    poke linbf,adr,254
    poke linbf,adr+1,x3/3
    poke linbf,adr+2,y3/2
    und=adr :adr=adr+3
    return

*col_chg
if (o_r!c_r) or (o_g!c_g) or (o_b!c_b) {
    poke linbf,adr,253
    poke linbf,adr+1,c_r+1
    poke linbf,adr+2,c_g+1
    poke linbf,adr+3,c_b+1
    o_r=c_r :o_g=c_g :o_b=c_b
    und=adr :adr=adr+4
;	color 16*(c_r+1)-1,16*(c_g+1)-1,16*(c_b+1)-1
}
return




*navi
	color :boxf 480,0,639,479
	color 255,255,255
	pos 500,20 :mes "[MODE] "+menu(mode)
	pos 500,60 :mes "Current Color"
	pos 560,80
	mes "[R] "+c_r
	mes "[G] "+c_g
	mes "[B] "+c_b
	pos 500,160 :mes "[UNDO]"
	color 16*(c_r+1)-1,16*(c_g+1)-1,16*(c_b+1)-1
	boxf 500,80,550,130
	return
