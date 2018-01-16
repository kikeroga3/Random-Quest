; Correct Numbers

	nums="0123456789" :tc=0

	; Shake
	repeat 5
		rc=rnd(9)+2 :gosub *invert
	loop

*main
	mes nums
	if nums="0123456789" {
		mes "Clear!"
		if tc<5 :mes "Congratulations!"
		end
	}
	input a,2,2
	rc=int(a) :gosub *invert :tc=tc+1
	goto *main

*invert
	repeat rc/2
		p1=peek(nums,cnt)
		p2=peek(nums,rc-1-cnt)
		poke nums,rc-1-cnt,p1
		poke nums,cnt,p2
	loop
	return
