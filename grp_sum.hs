;LinPaint用データ連結プログラム

	sdim linbf,64000
	sdim sumbf,256000

;以下repeatの回数には連結するデータファイル数を指定。
;例えば10と指定すればgrp000～009.binを連結しgrpsum.binとして保存する。

	repeat 6
		p1=cnt :p2=2 :gosub *strf
		bload "grp"+refstr+".bin",linbf	;連結元ファイル読み込み
		sz=strsize
		repeat sz
			poke sumbf,adr,peek(linbf,cnt)
			adr=adr+1
		loop
		poke sumbf,adr,250	;連結部コード
		adr=adr+1
	loop
	bsave "grpsum.bin",sumbf	;連結後ファイル保存
	stop

;指定した桁数の0(ゼロ)を付加する
*strf
	p3=int(powf(10,p2)) :s1=str(p1)
	repeat p2
		if p1<p3 :s1="0"+s1
		p3=p3/10
	loop
	return s1
