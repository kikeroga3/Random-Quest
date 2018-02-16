; 疑似3D	左手座標系	カメラは原点、カメラベクトルは0, 0, 1（中心から奥を見る）で固定


; 各種初期値　本当は#define等で設定していた値
	PI = 3.14159265358979	; 円周率
	arg1 = 60.0;			; 視野角
	arg2 = 30.0;			; 視野角（半分）
	near = 100.0;			; 近視距離
	far	= 500.0;			; 遠視距離
	scx = 640.0;			; 画面サイズX
	scy = 480.0;			; 画面サイズY
	intscx = 640;			; 画面サイズX（int型）
	intscy = 480;			; 画面サイズY（int型）
	schx = 320.0;			; 画面サイズX（半分）
	schy = 240.0;			; 画面サイズY（半分）
	intschx = 320;			; 画面サイズX（int型半分）
	intschy = 240;			; 画面サイズY（int型半分）

	speed = 2.0;			; 回転速度

	arg = PI * speed / 180.0;		; 回転角度をラジアンに変換

	ddim vector, 3;		; 回転軸ベクトルX, Y, Z
	vector(0) = 0.0;
	vector(1) = 1.0;
	vector(2) = 0.0;

	ddim cbpc, 3;		; 立方体中心座標X, Y, Z
	ddim cbpx, 8;		; 立方体頂点座標X
	ddim cbpy, 8;		; 立方体頂点座標Y
	ddim cbpz, 8;		; 立方体頂点座標Z

	cbpc(0) = 0.0;
	cbpc(1) = 0.0;
	cbpc(2) = 100.0;

	cbpx(0) = -50.0;		; 左上手前 右上手前 右上奥 左上奥 左下手前 右下手前 右下奥 左下奥
	cbpx(1) = 50.0;
	cbpx(2) = 50.0;
	cbpx(3) = -50.0;
	cbpx(4) = -50.0;
	cbpx(5) = 50.0;
	cbpx(6) = 50.0;
	cbpx(7) = -50.0;

	cbpy(0) = 50.0;
	cbpy(1) = 50.0;
	cbpy(2) = 50.0;
	cbpy(3) = 50.0;
	cbpy(4) = -50.0;
	cbpy(5) = -50.0;
	cbpy(6) = -50.0;
	cbpy(7) = -50.0;

	cbpz(0) = 50.0;
	cbpz(1) = 50.0;
	cbpz(2) = 150.0;
	cbpz(3) = 150.0;
	cbpz(4) = 50.0;
	cbpz(5) = 50.0;
	cbpz(6) = 150.0;
	cbpz(7) = 150.0;

	dim cbx, 8;		; 平面座標に変換した立方体頂点座標X
	dim cby, 8;		; 平面座標に変換した立方体頂点座標Y

;	screen 0, intscx, intscy, 0;

*main
	redraw 0;
		color 0, 0, 0: boxf 0,0,640,480;
		color 255, 255, 255;
		gosub *calc_point;
		gosub *draw_cube;
		gosub *rotate_cube;

	redraw 1;
	wait 1;
	goto *main;

; 3Dから2Dへ座標変換
*calc_point
	repeat 8
		p1 = cbpx(cnt);
		p2 = cbpy(cnt);
		p3 = cbpz(cnt);
		gosub *trans3Dto2D;
		cbx(cnt) = dx;
		cby(cnt) = dy;
	loop

	return;

; 立方体描画
*draw_cube
	; 上面
	line cbx(0), cby(0), cbx(1), cby(1);
	line cbx(1), cby(1), cbx(2), cby(2);
	line cbx(2), cby(2), cbx(3), cby(3);
	line cbx(3), cby(3), cbx(0), cby(0);

	; 下面
	line cbx(4), cby(4), cbx(5), cby(5);
	line cbx(5), cby(5), cbx(6), cby(6);
	line cbx(6), cby(6), cbx(7), cby(7);
	line cbx(7), cby(7), cbx(4), cby(4);

	; 側面
	line cbx(0), cby(0), cbx(4), cby(4);
	line cbx(1), cby(1), cbx(5), cby(5);
	line cbx(2), cby(2), cbx(6), cby(6);
	line cbx(3), cby(3), cbx(7), cby(7);

	return;

; 立方体回転
*rotate_cube

	vx = vector(0);
	vy = vector(1);
	vz = vector(2);
	cx = cbpc(0);
	cy = cbpc(1);
	cz = cbpc(2);
	va = arg;
	repeat 8
		x0 = cbpx(cnt);
		y0 = cbpy(cnt);
		z0 = cbpz(cnt);
		gosub *shift_rotate;
		cbpx(cnt) = x1;
		cbpy(cnt) = y1;
		cbpz(cnt) = z1;
	loop

	return;





; 以下モジュール等だったもの



; 3D上の座標(p1,p2,p3)を2D上の座標(dx,dy)へ変換する
;#deffunc trans3Dto2D double p1, double p2, double p3, var dx, var dy
*trans3Dto2D
	per = p3 / near;							; 距離Zと近視距離の比率

	dx = int( p1 / per + schx );
	dy = int( -(p2 / per - schy) );

	return;

; rotate 任意軸周りの空間回転演算 ( x0, y0, z0, vx, vy, vz, cx, cy, cz, va, x1, y1, z1)
; 入力値 x0 y0 z0, 回転軸ベクトル vx vy vz, 回転の中心座標 cx cy cz, 回転角度 va, 出力変数 x1 y1 z1
;#deffunc shift_rotate double x0, double y0, double z0, double vx, double vy, double vz, double cx, double cy, double cz, double va, var x1, var y1, var z1
*shift_rotate
	; 座標の平行移動（回転の中心座標を原点に合わせる）
	mpx = x0 - cx;
	mpy = y0 - cy;
	mpz = z0 - cz;

	; 回転軸の単位ベクトル化
	r = powf(vx*vx + vy*vy + vz*vz, 0.5);
	ax = vx/r : ay = vy/r : az = vz/r;

	; 回転演算
	;sin1   = sin(va);
	;cos1   = cos(va);
	gosub *calc_sin;
	gosub *calc_cos;
	l_cos1 = 1.0 - cos1;

	x1 = (ax*ax*l_cos1+cos1)*mpx + (ax*ay*l_cos1-az*sin1)*mpy + (az*ax*l_cos1+ay*sin1)*mpz;
	y1 = (ax*ay*l_cos1+az*sin1)*mpx + (ay*ay*l_cos1+cos1)*mpy + (ay*az*l_cos1-ax*sin1)*mpz;
	z1 = (az*ax*l_cos1-ay*sin1)*mpx + (ay*az*l_cos1+ax*sin1)*mpy + (az*az*l_cos1+cos1)*mpz;

	; 座標の平行移動（ずらした分を戻す）
	x1 = x1 + cx;
	y1 = y1 + cy;
	z1 = z1 + cz;

	return

; 簡易テイラー展開によるsin値の算出
*calc_sin
	x = va;
	sin1 = x;		; 計算結果が入る
	p = x;
	i = 1;
	repeat 32
		p = p * (-x*x / (2*i*(2*i+1)));
		sin1 = sin1 + p;
		i = i + 1;
	loop

	return;

; 簡易テイラー展開によるcos値の算出
*calc_cos
	x = va;
	cos1 = 1.0;		; 計算結果が入る
	p = 1.0;
	i = 1;
	repeat 32
		p = p * (-x*x / ((2*i-1)*2*i));
		cos1 = cos1 + p;
		i = i + 1;
	loop

	return
