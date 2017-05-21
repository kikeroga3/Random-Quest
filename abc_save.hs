sdim bf,145+28

no=0

;ï∂éö "0"Å`"9"
ch=2127120972:gosub *dot5
ch=2118520974:gosub *dot5
ch=2127106334:gosub *dot5
ch=2127106636:gosub *dot5
ch=2118538180:gosub *dot5
ch=2145939548:gosub *dot5
ch=2129162828:gosub *dot5
ch=2145456392:gosub *dot5
ch=2127114828:gosub *dot5
ch=2127116364:gosub *dot5

;ï∂éö ":"Å`"@"
ch=2118258692:gosub *dot5
ch=2113999120:gosub *dot5
ch=2116165762:gosub *dot5
ch=2114388416:gosub *dot5
ch=2122451080:gosub *dot5
ch=2128678916:gosub *dot5
ch=2114074752:gosub *dot5

;ï∂éö "A"Å`"Z"
A=2127133266:ch=A:gosub *dot5
B=2143908444:ch=B:gosub *dot5
C=2129150478:ch=C:gosub *dot5
D=2143898204:ch=D:gosub *dot5
E=2145942046:ch=E:gosub *dot5
F=2145939984:ch=F:gosub *dot5
G=2129156686:ch=G:gosub *dot5
H=2133424722:ch=H:gosub *dot5
I=2128744590:ch=I:gosub *dot5
J=2116094540:ch=J:gosub *dot5
K=2133484178:ch=K:gosub *dot5
L=2131247646:ch=L:gosub *dot5
M=2132661809:ch=M:gosub *dot5
N=2132596337:ch=N:gosub *dot5
O=2127120972:ch=O:gosub *dot5
P=2143908368:ch=P:gosub *dot5
Q=2127121101:ch=Q:gosub *dot5
R=2143908498:ch=R:gosub *dot5
S=2129145948:ch=S:gosub *dot5
T=2146570372:ch=T:gosub *dot5
U=2133412428:ch=U:gosub *dot5
V=2132329796:ch=V:gosub *dot5
W=2132334250:ch=W:gosub *dot5
X=2132087121:ch=X:gosub *dot5
Y=2132086916:ch=Y:gosub *dot5
Z=2146504991:ch=Z:gosub *dot5

bsave "ascii.bin",bf
stop

*dot5
	p1=(ch&4278190080)/16777216
	p2=(ch&16711680)/65536
	p3=(ch&65280)/256
	p4=ch&255
	poke bf,no,p1
	poke bf,no+1,p2
	poke bf,no+2,p3
	poke bf,no+3,p4
	no=no+4
	return

