title "5x5 Dot Editor"

	dim ch,25
	r=1 :g=2 :b=3 :sz=20

	font "tiny.ttf",sz
	pos sz*5,sz :mes "↑クリックで色変更"
	mes "←クリックでドットを描く"
	mes "[ESC]でドットを数値化"

*start

	repeat
		redraw 0
		color 0,0,0 :boxf 0,0,sz*5,sz*5
		color 80*r+15,80*g+15,80*b+15
		boxf sz*5+2,0,sz*8,sz

		repeat 25 :x=cnt\5 :y=cnt/5
			if ch(cnt) {
				boxf sz*x+1,sz*y+1,sz*x+sz-1,sz*y+sz-1
			}
		loop

		color 0,0,0
		pos sz*5+2,0 :mes "R"+r
		pos sz*6+2,0 :mes "G"+g
		pos sz*7+2,0 :mes "B"+b

		stick key
		if key=128 :break
		if key&256 {
			x=mousex/sz :y=mousey/sz
			r=r+(x=5) :g=g+(x=6) :b=b+(x=7)
			r=r\4 :g=g\4 :b=b\4
			if x<5 and y<5 {
				i=5*y+x :ch(i)=1-ch(i)
			}
		}
		wait 10
		redraw 1
	loop

;キャラクタービット計算
	a=0 :bit=1
	repeat 25
		if ch(24-cnt) :a=a+bit
		bit=bit+bit
	loop
;カラー値を加算
	c=33554432*(16*r+4*g+b)

	title "ch="+str(c+a)
	wait 30
	goto *start

