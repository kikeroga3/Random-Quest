	sdim bf_hex,65500
	bload "open.hex",bf_hex :sz=strsize
	sdim bf,sz/2+1
	repeat sz/2+1 :poke bf,cnt,0 :loop

*hex2bin
	repeat (sz/2)
		p1=peek(bf_hex,cnt*2)
		p2=peek(bf_hex,cnt*2+1)
		p1=p1-48 :p1=p1-7*(p1>16)
		p2=p2-48 :p2=p2-7*(p2>16)
		poke bf,cnt,16*p1+p2
	loop

	bsave "open.bin",bf
