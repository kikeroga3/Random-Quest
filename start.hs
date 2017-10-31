;エンコードシナリオ実行プログラム

	sdim fnm,64 :sdim msg,5000 :sdim bf,65500
	dim po_ret,16 :dim sel,16 :dim flg,256 :sdim svdat,5500
	fnm="open.scn"
*restat
	gosub *decod :po=0 :pi=0 :po_ret(pi)=po :sl=0
*main
	tok=peek(bf,po)
	if tok>9 {
		if tok<14 :po=po+1 :goto *main
		;文章の表示
		repeat
			a=peek(bf,po)
			if a<10 :a=0 :po=po-1
			poke msg,cnt,a :po=po+1
			if a=0 :break
		loop
		mes msg
	} else {
		;各コードの処理
		;@END
		if tok=1 :end
		;@INP
		if tok=2 :po=po+1 :gosub *cu_inp
		;@RET
		if tok=3 :pi=pi-(pi>0) :po=po_ret(pi)
		;@SEL Label
		if tok=4 :sel(sl)=peek(bf,po+1) :sl=sl+1 :po=po+2
		;@JMP Label
		if tok=5 :lbn=peek(bf,po+1) :po=po+2 :gosub *po_push :gosub *lb_srch
		;@FLG FlgNo Val
		if tok=6 {
			a=peek(bf,po+1)-1 :b=peek(bf,po+2)-1 :po=po+3
			if b>100 :flg(a)=rnd(b-100)					;乱数をセット
			if b>90 and b<101 :flg(a)=flg(a)-(b-90)		;デクリメント
			if b>80 and b<91 :flg(a)=flg(a)+(b-80)		;インクリメント
			if b<11 :flg(a)=b
		}
		if flg(a)<0 :flg(a)=0
		if flg(a)>254 :flg(a)=254
		;@IF FlgNo Val Label
		if tok=7 {
			a=peek(bf,po+1)-1 :b=peek(bf,po+2)-1 :lbn=peek(bf,po+3) :po=po+4
			if flg(a)=b :gosub *po_push :gosub *lb_srch
		}
		;@RUN Filename
		if tok=8 :p1=po+1 :gosub *getstr :fnm=refstr :goto *restat
		;*Label
		if tok=9 :po=po+2
	}
	goto *main

;Sub Functions

;スタック処理(po_ret)
*po_push
	po_ret(pi)=po :pi=pi+1
	;Deal with stack overflow
	if pi>15 { pi=15
		repeat 15 :po_ret(cnt)=po_ret(cnt+1) :loop
	}
	return

;シナリオデコード(復元化)
*decod
	bload fnm,bf :sz=strsize
	repeat sz
		a=peek(bf,cnt) :if a=0 :a=255
		poke bf,cnt,255-a
	loop
	return

;文字列を数値に変換
*strval
	p1=0
	repeat 8
		a=peek(s1,cnt)-48 :if a<0 :break
		p1=p1*10+a
	loop
	return p1

;指定位置から改行または終端までの文字列を取り出す
*getstr
	sdim s1,256
	repeat 256
		a=peek(bf,p1+cnt)
;		if a=10 or a=13 :a=0
		if a=10 or a=13 or a=32 or a=44 :a=0
		poke s1,cnt,a
		if a=0 :p2=cnt :break
	loop
	return s1

;キー入力待ち
*cu_inp
	input s,2,2
	if s="q" or s="Q" :mes "Quit." :end
	if s="s" or s="S" :mes "Save." :gosub *save :goto *cu_inp
	if s="l" or s="L" :mes "Load." :gosub *load :goto *cu_inp
	if sl=0 :return
	s1=s :gosub *strval :a=stat
	if a>sl or a<1 :goto *cu_inp
	gosub *po_push :lbn=sel(a-1) :gosub *lb_srch
	sl=0 :return

;ラベルサーチ
*lb_srch
	i=0
	repeat sz
		p1=peek(bf,i) :p2=peek(bf,i+1)
		if p1=9 and p2=lbn :po=i+2 :break
		if p1>9 or p1=1 or p1=2 or p1=3 or p1=8 :i=i+1
		if p1=4 or p1=5 or p1=9 :i=i+2
		if p1=6 :i=i+3
		if p1=7 :i=i+4
		if i>sz :break
	loop
	return

;データセーブ
*save
	repeat 5300 :poke svdat,cnt,255 :loop
	;シナリオファイル名
	repeat 16
		a=peek(fnm,cnt) :if a=0 :break
		poke svdat,cnt,a
	loop
	;シナリオ実行中ポジション
	p1=po\128 :p2=(po/128)&127 :p3=po/16384
	poke svdat,16,p1+128
	poke svdat,17,p2+128
	poke svdat,18,p3+128
	;シナリオ復帰変数(po_ret)のスタックNo.
	poke svdat,19,pi+1
	;シナリオ復帰ポジション(@RET)
	repeat 16 :a=po_ret(cnt) :b=cnt*3
		p1=a\128 :p2=(a/128)&127 :p3=a/16384
		poke svdat,b+20,p1+128
		poke svdat,b+21,p2+128
		poke svdat,b+22,p3+128
	loop
	;選択肢数
	poke svdat,68,sl+1
	;選択肢飛び先(ラベルNo.)
	repeat sl
		poke svdat,69+cnt,sel(cnt)
	loop
	;フラグ
	repeat 250
		poke svdat,85+cnt,flg(cnt)+1
	loop
	;直前の文章
	repeat 5000
		a=peek(msg,cnt) :poke svdat,336+cnt,a
		if a=0 :break
	loop
	bsave "save.dat",svdat
	return

;データロード
*load
	bload "save.dat",svdat
	;シナリオファイル名
	repeat 16
		a=peek(svdat,cnt) :if a=255 :a=0
		poke fnm,cnt,a :if a=0 :break
	loop
	gosub *decod
	;シナリオ実行中ポジション
	p1=peek(svdat,16)-128
	p2=peek(svdat,17)-128
	p3=peek(svdat,18)-128
	po=16384*p3+128*p2+p1
	;シナリオ復帰変数(po_ret)のスタックNo.
	pi=peek(svdat,19)-1
	;シナリオ復帰ポジション(@RET)
	repeat 16 :b=cnt*3
		p1=peek(svdat,b+20)-128
		p2=peek(svdat,b+21)-128
		p3=peek(svdat,b+22)-128
		po_ret(cnt)=16384*p3+128*p2+p1
	loop
	;選択肢数
	sl=peek(svdat,68)-1
	;選択肢飛び先(ラベルNo.)
	repeat sl
		sel(cnt)=peek(svdat,69+cnt)
	loop
	;フラグ
	repeat 250
		flg(cnt)=peek(svdat,85+cnt)-1
	loop
	;直前の文章
	repeat 5000
		a=peek(svdat,336+cnt) :poke msg,cnt,a
		if a=0 :break
	loop
	mes msg
	return
