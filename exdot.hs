;Extra Dot Character Draw

	;変数bf_chrにファイル内容を読込み
	sdim bf_chr,64000
	bload "chr2.bin",bf_chr		;chr1～3.binを指定
	title "strsize="+strsize

	redraw 0 :color :boxf 0,0,640,480

	repeat 20

		;p1=キャラクター番号
		;p2,p3=表示するX,Y座標
		;p4=1ドットのサイズ

		p1=cnt\4 :p2=rnd(640) :p3=rnd(480) :p4=5 :gosub *chrput
	loop

	redraw 1
	stop

;キャラクター表示ルーチン
*chrput
	xs=peek(bf_chr,0) :m=xs*(xs/7) :adr=p1*(m*2+8)

	;RGB色情報ゲット
	repeat 3
		a=peek(bf_chr,adr+1+cnt)&63
		r(cnt)=80*(a/16)+15 :g(cnt)=80*((a&12)/4)+15 :b(cnt)=80*(a&3)+15
	loop

	;ビット計算＆キャラクター表示
	i=0
	repeat m
		c1=peek(bf_chr,adr+4+cnt) :c2=peek(bf_chr,adr+4+m+cnt)
		a=64
		repeat 7
			xx=p2-(xs*p4/2)+(i\xs)*p4 :yy=p3-(xs*p4/2)+(i/xs)*p4
			c=((c1&a)>0)+2*((c2&a)>0)
			if c>0 {
				color r(c-1),g(c-1),b(c-1)
				boxf xx,yy,xx+p4-1,yy+p4-1
			}
			a=a/2 :i=i+1
		loop
	loop
	return
