;バイナリ→テキスト(16進文字列)変換プログラム

	mes "Input *.scn filename (without extension):"
	input fnm,32,2
	sdim bf,65500 :bload fnm+".scn",bf :sz=strsize
	gosub *scn2hex
	bsave fnm+".hex",bf2
	end

*scn2hex

	; バッファを用意(0クリア)
	sdim bf2,sz*2+1
	repeat sz*2+1 :poke bf2,cnt,0 :loop

	; 1バイトづつ16進文字列に変換
	repeat sz
		p1=peek(bf,cnt)
		p2=48+(p1/16) :p2=p2+7*(p2>57)
		p3=48+(p1\16) :p3=p3+7*(p3>57)
		poke bf2,cnt*2,p2
		poke bf2,cnt*2+1,p3
	loop
	return

