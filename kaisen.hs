;Battleship (海戦ゲーム)

dim m,200
dim n,100

repeat 200 :m(cnt)=0 :loop

repeat 5
	mes "SET YOUR SHIP-"+cnt+" POS. X,Y (1 to 9)"
	input s,3,2
	x=peek(s,0)-49 :if x<0 :x=0
	x=x\9
	y=peek(s,2)-49 :if y<0 :y=0
	y=y\9
	m(9*y+x)=1+cnt
loop

repeat 5
	mes "SET COMP SHIP-"+cnt+" POS. X,Y (1 to 9)"
*set_xy
	x=rnd(9) :y=rnd(9)
	if m(100+9*y+x)!0 :goto *set_xy
	m(100+9*y+x)=1+cnt
loop




end

	x1=0:y1=0:x2=10:y2=10
	v1=powf(x2-x1,2)+powf(y2-y1,2)
	gosub *sqrt:mes "dist("+x1+","+y1+")-("+x2+"," +y2+")="+refdval

*sqrt
	v2=v1/2.0:v3=0.0
	repeat
		if v2=v3 :break
		v3=v2:v2=(v2+v1/v2)/2.0
	loop
	return v2

