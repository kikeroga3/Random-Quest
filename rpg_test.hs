;RPG

	sdim moj_bf,150
	bload "moj.bin",moj_bf

	sdim map_bf,65536
	bload "map.bin",map_bf

	sdim chr_bf,64000
	bload "rpg.bin",chr_bf

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
	if r<4 {
		goto *duel
	}

	redraw 1

	repeat
		wait 15 :stick k
		if k=1 and cel(23)<3 :px=px-1
		if k=4 and cel(25)<3 :px=px+1
		if k=2 and cel(17)<3 :py=py-1
		if k=8 and cel(31)<3 :py=py+1
		if k!0 :break
	loop
	goto *mapdraw

stop



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
		if p1>64 :p1=p1-65 :else :p1=p1-48+26
		p2=p1*4
		p3=16777216*peek(moj_bf,p2)+65536*peek(moj_bf,p2+1)+256*peek(moj_bf,p2+2)+peek(moj_bf,p2+3)
		p4=16777216
		repeat 25
			if (p3&p4) {
				p_x=moj_x+moj_sz*(cnt\5)-(moj_sz*5/2)
				p_y=moj_y+moj_sz*(cnt/5)-(moj_sz*5/2)
				boxf p_x,p_y,p_x+moj_sz,p_y+moj_sz
			}
			p4=p4/2
		loop
*spc
		moj_x=moj_x+(moj_sz*5)+2
	loop
	moj_x=p5 :moj_y=moj_y+(moj_sz*5)+4
	return

*duel
	redraw 1
	s1="MONSTER APPEAR" :gosub *mojput
	wait 100
		p_no=6+cel(24)*2+(r\2)
		color 0,0,0 :circle 300,10,630,160
		color 30,30,30 :boxf 300,170,630,290
		p_x=460 :p_y=80 :p_sz=10 :gosub *chrput

		moj_sz=3 :moj_x=310 :moj_y=180
		color 255,255,255
		s1="LV1 HP10" :gosub *mojput
		moj_y=moj_y+20
		s1=" VERTICAL SLASH" :gosub *mojput
		s1=" SPINNING SLASH" :gosub *mojput
		s1=" STAB WITH A SWORD" :gosub *mojput
		s1=" RUNAWAY" :gosub *mojput




s1="LOCKING SWORD TO SWORD AND PUSHING"
s1="HERO ATTACK"
s1="DAMAGE"
s1="AVOIDED"
s1="MONSTER DIED"
s1="SLIME"
s1="GHOST"
s1="MAGE"
s1="OCTOPUS"
s1="BANSHEE"
s1="SKULL"
s1="RED DRAGON"

stop
