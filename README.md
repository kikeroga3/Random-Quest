# Random-Quest

[Mast_Dat]
NPC:HP,AP,DF,AG,Name 16*64(1024)Byte
MON:HP,AP,DF,AG,Name 16*64(1024)Byte
ITM:HP,AP,DF,AG,Name 16*64(1024)Byte

[Fact_Dat]
NPC:No,X,Y,HP,AP,DF,AG,ITM_No     16*64
MON:No,X,Y,HP,AP,DF,AG,ITM_No     16*256
ITM:No,X,Y                        4*32

実際のXYから
画面上のXYに変換し
画面上のXYを使用してコリジョン判定をおこなう
---
・移動(NPC,MON,カベがあると移動できない。ITMがあれば重なってゲット)
・会話(Talk
・攻撃(Atack
・投げる(throw
---
MAP
  自動で黒と青のところは壁になる
  4x4の16分割されランダムに8マスのエリアにMが配置される
    8エリアにはレベル属性があり、強さで分けて配置される
  MがいないマスにはNPCがランダム配置される
  M/N属性は手動設定も可

NPCは音声(Wav)台詞設定可能

Item
  拾うかM倒すと入手

Magic
  Nに教えてもらう
  MP消費する。MPがないと使えない

パラメタ
AP,DF,AG,HP,MP

移動
　Mいたら攻撃
　Nなら会話

Z押すItem選択→2マス
□
□□
■□□

X押すMagic選択→3マス
□
□□□
□□□
■□□□

