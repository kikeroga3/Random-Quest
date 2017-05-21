randomize

font "tiny.ttf",25

su(0)=115506852		;クラブ
su(1)=1615297988	;ダイヤ
su(2)=1622146500	;ハート
su(3)=105348238		;スペード

sdim cs,8,16
cs(1)="A" :repeat 9 :cs(2+cnt)=str(2+cnt) :loop :cs(11)="J" :cs(12)="Q" :cs(13)="K"

mx=52
dim cd,52 :repeat 52 :cd(cnt)=16*(cnt/13)+cnt\13+1 :loop

dim p1,12 :dim p2,12
repeat 12 :p1(cnt)=0 :p2(cnt)=0 :loop

color :boxf 0,0,640,480


color 255,255,255
pos 522,362 :picload "bj_0.png"
pos 22,22 :picload "bj_1.png"


repeat 52
	pos 60+40*(cnt\13),140+50*(cnt/13) :mes " "+cd(cnt)
loop

repeat 12
	px=140+40*cnt
	pos px,40 :mes cs((p1(cnt)&15))
	py=60 :ch=su(p1(cnt)/16) :gosub *dot5
	px=44+40*cnt
	pos px,400 :mes cs((p2(cnt)&15))
	py=420 :ch=su(p2(cnt)/16) :gosub *dot5
loop


gosub *hit :p2(0)=a

gosub *hit :p1(0)=a


color 255,255,255
pos 140,80 :mes "もう一枚"
pos 400,400 :mes "ステイ"

title ""+mx

stop

*hit
r=rnd(mx) :i=0
repeat 52
i=i+(cd(cnt)>0)
if (r+1)=i {
	a=cd(cnt): cd(cnt)=0 :mx=mx-1 :break
}
loop
return






*dot5
	sz=2 :a=16777216 :c=ch/33554432
	c1=c/16 :c2=(c&12)/4 :c3=c&3
	color 80*c1+15,80*c2+15,80*c3+15
	repeat 25
		if (ch & a) {
			x=px+sz*(cnt\5)-(sz*5/2)
			y=py+sz*(cnt/5)-(sz*5/2)
			boxf x,y,x+sz,y+sz
		}
		a=a/2
	loop
	return

