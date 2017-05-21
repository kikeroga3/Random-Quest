;Tiny RPG

	sdim nm,16,16
	nm(1)="SLIME"
	nm(2)="GHOST"
	nm(3)="MAGE"
	nm(4)="OCTOPUS"
	nm(5)="BANSHEE"
	nm(6)="SKULL"
	nm(7)="RED DRAGON"

	ex(0)=0:hp(0)=10:ap(0)=3 :df(0)=0
	ex(1)=1:hp(1)=3 :ap(1)=2 :df(1)=0
	ex(2)=2:hp(2)=5 :ap(2)=3 :df(2)=1
	ex(3)=3:hp(3)=8 :ap(3)=5 :df(3)=2
	ex(4)=4:hp(4)=10:ap(4)=6 :df(4)=3
	ex(5)=5:hp(5)=15:ap(5)=8 :df(5)=5
	ex(6)=6:hp(6)=20:ap(6)=9 :df(6)=8
	ex(7)=8:hp(7)=30:ap(7)=13:df(7)=8

	sdim moj_bf,180
	bload "ascii.bin",moj_bf

	sdim map_bf,65536
	bload "map.bin",map_bf

	sdim chr_bf,64000
	bload "rpg.bin",chr_bf

	sdim mon_bf,64000
	bload "monster.bin",mon_bf

	bm=40 :tb=0
	dim tbx,bm :dim tby,bm
	repeat bm
		tbx(cnt)=rnd(256) :tby(cnt)=rnd(256)
		if peek(map_bf,256*tby+tbx)<4 :tb=tb+1
	loop

	dim cel,50
	px=96:py=96:p_sz=5
	color 15,15,15 :boxf 0,0,640,480

*mapdraw
	redraw 0
	cel(24)=-1:p_sz=5
	repeat 49
		p_x=30+40*(cnt\7) :p_y=30+40*(cnt/7)
		x=px-3+(cnt\7) :y=py-3+(cnt/7) :i=x+256*y
		p_no=peek(map_bf,i)-1
		if cel(cnt)!p_no {
			color 48,32,0 :boxf p_x-20,p_y-20,p_x+20,p_y+20
			cel(cnt)=p_no :gosub *chrput
		}
	loop

	p_no=4+(px+py)\2 :p_x=150 :p_y=150 :gosub *chrput

	r=rnd(20)
	if r<4 :gosub *duel

	repeat bm
	if px=tbx(cnt) and py=tby(cnt) {
		title "T-Box!" :gosub *tbox
	}
	loop

	redraw 1

	repeat
		wait 10 :stick k
		if k=1 and cel(23)<3 :px=px-1
		if k=4 and cel(25)<3 :px=px+1
		if k=2 and cel(17)<3 :py=py-1
		if k=8 and cel(31)<3 :py=py+1
		if k!0 :break
	loop
	goto *mapdraw



*duel

	redraw 1
	s1="MONSTER APPEAR" :moj_x=100:moj_y=100:gosub *mojput
	wait 100
		p_no=cel(24)*2+(r\2)
		color 0,0,0 :circle 300,10,630,160
		color 30,30,30 :boxf 300,170,630,290
		p_x=460 :p_y=80 :p_sz=6 :gosub *monput

		moj_sz=3 :moj_x=310 :moj_y=180
		color 255,255,255
		s1="LV1 HP10" :gosub *mojput
		moj_y=moj_y+20
		s1=" ROCK ATTACK:" :gosub *mojput
		s1=" SCISSORS SLASH<=>@" :gosub *mojput
		s1=" PAPER STORM;" :gosub *mojput
		s1=" RUNAWAY?" :gosub *mojput





	e_nm=nm(p_no)
	e_ex=ex(p_no):e_hp=hp(p_no):e_ap=ap(p_no):e_df=df(p_no)


	i=0
	repeat
		color 30,30,30 :boxf 300,170,320,290
		color 0,0,200 ::circle 300,170+20*i,320,190+20*i
		wait 15 :stick k
		i=i-(k=2)+(k=8)
		if i<0 :i=3
		i=i\4 :if k!0 :break
	loop

	if i=3 :title "Run!"


	



;あいこ
s1="LOCKING SWORD TO SWORD AND PUSHING"



s1="HERO ATTACK"
a=ap-e_df:if a<1 :a=1
e_hp=e_hp-a
s1=e_nm+" DAMAGE "+(ap-e_df)

if e_hp<1 {
	s1="MONSTER DIED"
	ex=ex+e_ex(p_no)
}

	return

;SLIME
;GHOST
;ORK
;MAGE
;OCTPUS
;BANSHEE
;SKULL
;GOLEM
;WYVERN
;RED DRAGON
;T-BOX


*tbox

	if tb<5 :s1="RED DRAGON"



	s1="TREASURE BOX FOUND"

	s1="OPEN"
	s1="DISPOSE"





	s1="GET SWORD AP UP"
	s1="GET ARMOR DF UP"
	s1="GET FOOD HP UP"

	s1="MONSTER APPEAR"
	s1="TOOK TO TRAP HP DOWN"




	return



*lvlchk
	lv=ex/10:ap=lv+3:df=lv
	return


*monput
	p_xs=peek(mon_bf,0) :p1=p_xs*(p_xs/7) :p_ln=p1*2+8 :p_ad=p_no*p_ln
	repeat 3
		p2=peek(mon_bf,p_ad+1+cnt)&63
		p_r(cnt)=80*(p2/16)+15 :p_g(cnt)=80*((p2&12)/4)+15 :p_b(cnt)=80*(p2&3)+15
	loop
	p3=0
	repeat p1
		p_c1=peek(mon_bf,p_ad+4+cnt) :p_c2=peek(mon_bf,p_ad+4+p1+cnt)
		p2=64
		repeat 7
			p_xx=p_x-(p_xs*p_sz/2)+(p3\p_xs)*p_sz :p_yy=p_y-(p_xs*p_sz/2)+(p3/p_xs)*p_sz
			p_c3=((p_c1&p2)>0)+2*((p_c2&p2)>0)
			if p_c3>0 {
				color p_r(p_c3-1),p_g(p_c3-1),p_b(p_c3-1)
				boxf p_xx,p_yy,p_xx+p_sz-1,p_yy+p_sz-1
			}
			p2=p2/2 :p3=p3+1
		loop
	loop
	return


*chrput
	p_xs=peek(chr_bf,0) :p1=p_xs*(p_xs/7) :p_ln=p1*2+8 :p_ad=p_no*p_ln
	repeat 3
		p2=peek(chr_bf,p_ad+1+cnt)&63
		p_r(cnt)=80*(p2/16)+15 :p_g(cnt)=80*((p2&12)/4)+15 :p_b(cnt)=80*(p2&3)+15
	loop
	p3=0
	repeat p1
		p_c1=peek(chr_bf,p_ad+4+cnt) :p_c2=peek(chr_bf,p_ad+4+p1+cnt)
		p2=64
		repeat 7
			p_xx=p_x-(p_xs*p_sz/2)+(p3\p_xs)*p_sz :p_yy=p_y-(p_xs*p_sz/2)+(p3/p_xs)*p_sz
			p_c3=((p_c1&p2)>0)+2*((p_c2&p2)>0)
			if p_c3>0 {
				color p_r(p_c3-1),p_g(p_c3-1),p_b(p_c3-1)
				boxf p_xx,p_yy,p_xx+p_sz-1,p_yy+p_sz-1
			}
			p2=p2/2 :p3=p3+1
		loop
	loop
	return

*mojput
	p5=moj_x
	repeat
		p1=peek(s1,cnt) :if p1=0 :break
		if p1=32 :goto *spc
		if p1>47 :p1=p1-48
		p2=p1*4
		p3=16777216*peek(moj_bf,p2)+65536*peek(moj_bf,p2+1)+256*peek(moj_bf,p2+2)+peek(moj_bf,p2+3)
		p4=16777216
		repeat 25
			if (p3&p4) {
;				p_x=moj_x+(cnt\5)+5 :p_y=moj_y+(cnt/5)+5

				p_x=moj_x+moj_sz*(cnt\5)-(moj_sz*5/2)
				p_y=moj_y+moj_sz*(cnt/5)-(moj_sz*5/2)
				boxf p_x,p_y,p_x+moj_sz,p_y+moj_sz


;				pset p_x,p_y
			}
			p4=p4/2
		loop
*spc
		moj_x=moj_x+(moj_sz*5)+2
	loop
	moj_x=p5 :moj_y=moj_y+(moj_sz*5)+2
	return

