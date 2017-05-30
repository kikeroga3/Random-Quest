	title "LinePaint"
	font "tiny_en.ttf",20

	lfnm=""				;ロードするファイル名(""なら新規)
	sfnm="grp001.bin"	;セーブするファイル名

	menu(0)="LINE" :menu(1)="PAINT"

*reload
	color 255,255,255 :boxf 0,0,480,480
;	pos 0,0 :picload "sketch.png"

	mode=0 :und=0 :adr=0
	spt=0 :x1=-1 :y1=-1
	c_r=0 :c_g=0 :c_b=0
	o_r=1 :o_g=1 :o_b=1

	sdim linbf,64000

	if lfnm!"" {
		bload lfnm,linbf :gosub *draw
	}

	gosub *ope_pnl

;メインルーチン
	repeat
		stick key
		if key=256 {
			if mousex<480 { gosub *rgb_set
				if mode { gosub *col_set } else { gosub *lin_set }
			} else {
				n=mousey/20
				if n=1 :mode=1-mode :wait 20
				if n=4 :c_r=(c_r+1)\17
				if n=5 :c_g=(c_g+1)\17
				if n=6 :c_b=(c_b+1)\17
				if n=8 {
					color 255,255,255 :boxf 0,0,480,480
					adr=0 :gosub *draw
				}
				if n=10 :break
				if n=12 {
					bsave sfnm,linbf
					title "SAVE:"+sfnm+" BYTES:"+adr
					if lfnm="" :lfnm=sfnm
				}
			}
			gosub *ope_pnl
		}
		if key=512 {
			mode=0 :gosub *ope_pnl :x1=-1
			title "LINE START"
		}
		if key=128 :n=-1 :break
		wait 10
	loop
	if n=10 :goto *reload
	end

;サイドパネル表示
*ope_pnl
	redraw 0
	color :boxf 480,0,639,479
	color 255,255,255
	pos 500,20 :mes "[MODE] "+menu(mode)
	pos 500,60 :mes "Current Color"
	pos 560,80
	mes "[R] "+c_r
	mes "[G] "+c_g
	mes "[B] "+c_b
	pos 500,160 :mes "[UNDO]"
	pos 500,200 :mes "[LOAD]"
	if lfnm="" { mes "- Newly -" } else { mes lfnm }
	pos 500,260 :mes "[SAVE]"
	mes sfnm
	color abs(16*c_r-1),abs(16*c_g-1),abs(16*c_b-1)
	boxf 500,80,550,130
	redraw 1
	return

;線をひく
*lin_set
	x2=mousex/2 :y2=mousey/2
	if x1=-1 {
		adr=adr-3*spt :x1=x2 :y1=y2
		poke linbf,adr,255
		poke linbf,adr+1,x1+1 :poke linbf,adr+2,y1+1
		und=adr :adr=adr+3 :spt=1
		title "LINE:"+(x1*2)+","+(y1*2)
	}
	if (x1!x2) or (y1!y2) {
		line x1*2,y1*2,x2*2,y2*2
		poke linbf,adr,x2+1 :poke linbf,adr+1,y2+1
		und=adr :adr=adr+2 :spt=0
		title "LINE:"+(x1*2)+","+(y1*2)+"-"+(x2*2)+","+(y2*2)
		x1=x2 :y1=y2
	}
	return

;色を塗る
*col_set
	x3=mousex/2 :y3=mousey/2
	paint x3*2,y3*2
	poke linbf,adr,254
	poke linbf,adr+1,x3+1 :poke linbf,adr+2,y3+1
	und=adr :adr=adr+3
	return

;色情報をセット
*rgb_set
	if (o_r!c_r) or (o_g!c_g) or (o_b!c_b) {
		poke linbf,adr,253
		poke linbf,adr+1,c_r+1 :poke linbf,adr+2,c_g+1 :poke linbf,adr+3,c_b+1
		o_r=c_r :o_g=c_g :o_b=c_b
		und=adr :adr=adr+4
	}
	return

;データを読み込んで描画する
*draw
	redraw 0
	repeat
		p=peek(linbf,adr) :if p=0 :break
		if (und!0) and (adr>=und) :break
		if p=253 {
			c_r=peek(linbf,adr+1)-1 :c_g=peek(linbf,adr+2)-1 :c_b=peek(linbf,adr+3)-1
			adr=adr+4
			color abs(16*c_r-1),abs(16*c_g-1),abs(16*c_b-1)
			continue
		}
		if p=254 {
			x3=peek(linbf,adr+1)-1 :y3=peek(linbf,adr+2)-1
			adr=adr+3
			paint x3*2,y3*2
			continue
		}
		if p=255 {
			x1=peek(linbf,adr+1)-1 :y1=peek(linbf,adr+2)-1
			adr=adr+3
		} else {
			x2=peek(linbf,adr)-1 :y2=peek(linbf,adr+1)-1
			adr=adr+2
			line x1*2,y1*2,x2*2,y2*2
			x1=x2 :y1=y2
		}
	loop
	redraw 1
	return
