;シナリオソースエンコードプログラム

	mes "Input Scnario source filename (without extension):"
	input fnm,32,2
	sdim bf,65500 :bload fnm+".txt",bf :sz=strsize

;ラベル一覧
	po=0 :id=0 :sdim lb,32,255
	mes "--- Label listing ---"

*lb_chk

	if peek(bf,po)=42 {
		p1=po+1 :gosub *getstr
		a=0
		repeat id
			if lb(cnt)=s1 :a=1 :break
		loop
		if a=0 {
			lb(id)=s1 :mes ""+(1+id)+":"+lb(id)
			id=id+1
		}
		po=po+1+p2
	}
	po=po+1
	if sz>po :goto *lb_chk

;中間コード化
	po=0 :wp=0 :ids=id :sdim cd,256000
	mes "--- Bytecode conversion ---"

*byt_cnv

	pc=0

	;ラベルコード(09,ID)変換
	if peek(bf,po)=42 {
		p1=po+1 :gosub *getstr
		a=0
		repeat ids
			if lb(cnt)=s1 :a=1 :id=cnt :break
		loop
		if a=1 {
			p(0)=9 :p(1)=1+id :pc=2
			mes "Label:9 "+p(1)
		}
		po=po+p2+1
	}

	;命令コード変換
	p1=po :p2=4 :gosub *strmid :tok=refstr
	if tok="@END" or tok="@end" :mes "End:1" :p(0)=1 :pc=1
	if tok="@INP" or tok="@inp" :mes "Input:2" :p(0)=2 :pc=1
	if tok="@RET" or tok="@ret" :mes "Return:3" :p(0)=3 :pc=1
	if pc=1 :po=po+4

	if tok="@SEL" or tok="@sel" {
		p1=po+5 :gosub *getstr :po=po+5+p2
		a=0
		repeat ids
			if lb(cnt)=s1 :a=1 :id=cnt :break
		loop
		if a=1 {
			p(0)=4 :p(1)=1+id :pc=2
		}
		mes "Select:4 "+(1+id)
	}

	if tok="@JMP" or tok="@jmp" {
		p1=po+5 :gosub *getstr :po=po+5+p2
		a=0
		repeat ids
			if lb(cnt)=s1 :a=1 :id=cnt :break
		loop
		if a=1 {
			p(0)=5 :p(1)=1+id :pc=2
		}
		mes "Jump:5 "+(1+id)
	}

	if tok="@FLG" or tok="@flg" {
		p1=po+5 :gosub *getstr :po=po+5+p2
		gosub *strval :p(1)=stat+1
		p1=po+1 :gosub *getstr :po=po+1+p2
		gosub *strval :p(2)=stat+1
		p(0)=6 :pc=3 :mes "Flag:6 "+p(1)+" "+p(2)
	}

	if tok="@IF " or tok="@if " {
		p1=po+4 :gosub *getstr :po=po+4+p2
		gosub *strval :p(1)=stat+1
		p1=po+1 :gosub *getstr :po=po+1+p2
		gosub *strval :p(2)=stat+1
		p1=po+1 :gosub *getstr :po=po+1+p2
		a=0
		repeat ids
			if lb(cnt)=s1 :a=1 :id=cnt :break
		loop
		if a=1 {
			p(3)=1+id
		}
		p(0)=7 :pc=4 :mes "If:7 "+p(1)+" "+p(2)+" "+p(3)
	}

	if tok="@RUN" or tok="@run" {
		po=po+5 :p(0)=8 :pc=1
		p1=po :gosub *getstr :mes "Run:8 "+refstr
	}

	if pc>0 {
		;ラベル／命令の中間コードをセット
		repeat pc
			poke cd,wp,p(cnt) :wp=wp+1
		loop
		;ラベル／命令直後の改行(CRLF)をスキップ
		repeat
			a=peek(bf,po)
			if a=10 or a=13 { po=po+1 } else { break }
		loop
	} else {
		;ラベル／命令以外の転記
		a=peek(bf,po) :poke cd,wp,a
		po=po+1 :wp=wp+1
	}

	if sz>po :goto *byt_cnv

;簡単な暗号化
	repeat sz
		a=peek(cd,cnt) :if a=0 :a=255
		poke cd,cnt,255-a
	loop
	bsave fnm+".scn",cd
	end

;Sub Functions

;指定位置から指定の長さの文字列を取り出す
*strmid
	sdim s1,p2+1
	repeat p2
		poke s1,cnt,peek(bf,p1+cnt)
	loop
	return s1

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

;文字列を数値に変換
*strval
	p1=0
	repeat 8
		a=peek(s1,cnt)-48 :if a<0 :break
		p1=p1*10+a
	loop
	return p1
