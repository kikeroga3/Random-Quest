	sdim sumbf,256000
	bload "grpsum.bin",sumbf

	;変数grp_noに画像の番号を指定
	grp_no=0 :gosub *draw
	stop

*draw
	;データヘッダ検索
	adr=0 :n=0
	if grp_no>0 {
		repeat 256000
			p=peek(sumbf,cnt) :if p=0 :break
			n=n+(p=250)
			if grp_no=n :adr=cnt+1 :break
		loop
	}
	title "grp_no."+n+" adr:"+adr

	;ヘッダから描画を開始
	redraw 0
	color :boxf 0,0,639,479
	color 255,255,255 :boxf 1,2,478,478
	repeat
		p=peek(sumbf,adr)
		if (p=0) or (p=250) :break
		if p=253 {
			c_r=peek(sumbf,adr+1)-1 :c_g=peek(sumbf,adr+2)-1 :c_b=peek(sumbf,adr+3)-1
			adr=adr+4
			color abs(16*c_r-1),abs(16*c_g-1),abs(16*c_b-1)
			continue
		}
		if p=254 {
			x3=peek(sumbf,adr+1)-1 :y3=peek(sumbf,adr+2)-1
			adr=adr+3
			paint x3*2,y3*2
			continue
		}
		if p=255 {
			x1=peek(sumbf,adr+1)-1 :y1=peek(sumbf,adr+2)-1
			adr=adr+3
		} else {
			x2=peek(sumbf,adr)-1 :y2=peek(sumbf,adr+1)-1
			adr=adr+2
			line x1*2,y1*2,x2*2,y2*2
			x1=x2 :y1=y2
		}
	loop
	redraw 1
	return
