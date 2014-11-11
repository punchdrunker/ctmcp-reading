% 3.6.2 ループ抽象
% 
% 制御抽象を用いれば簡潔にループを定義できる

% 整数ループ
% Iを整数として{P I}を呼ぶ.
% Iは Aから始まり、間隔SでBまで続く
declare
proc {For A B S P}
   proc {LoopUp C}
      if C=<B then {P C} {LoopUp C+S} end
   end
   proc {LoopDown C}
      if C>=B then {P C} {LoopDown C+S} end
   end
in
   if S>0 then {LoopUp A} end
   if S<0 then {LoopDown A} end
end

% 試しに実行してみる
declare
proc {MyProc I}
   {Browse I}
end
{For 1 1 3 MyProc}


% リストループ
% あるリスト:Lの全要素にある操作:Pを繰り返す
declare
proc {ForAll L P}
   case L
   of nil then skip
   [] X|L2 then
      {P X}
      {ForAll L2 P}
   end
end
proc {MyProc2 I}
   {Browse I}
end
{ForAll [1 2 3] MyProc2}

% アキュムレータループ
% 状態を保持するためにアキュムレータを追加し、ループを実装してみる
declare
proc {ForAcc A B S P In ?Out}
   proc {LoopUp C In ?Out}
   Mid in
      if C=<B then {P In C Mid} {Browse In#C#Mid} {LoopUp C+S Mid Out}
      else In=Out end
   end
   proc {LoopDown C In ?Out}
   Mid in
      if C>=B then {P In C Mid} {LoopDown C+S Mid Out}
      else In=Out end
   end
in
   if S>0 then {LoopUp A In Out} end
   if S<0 then {LoopDown A In Out} end
end
% ForAccを実行してみる
declare
proc {MyProc3 In C ?Mid}
   Mid=In+C
end
declare Hoge in
{ForAcc 1 50 3 MyProc3 1 Hoge}
{Browse Hoge}

declare
proc {ForAllAcc L P In ?Out}
   case L
   of nil then In=Out
   [] X|L2 then Mid in
      {P In X Mid}
      {Browse Mid}
      {ForAllAcc L2 P Mid Out}
   end
end
% 1を初期値としてリストの要素を全部掛けていく
% ForAccを実行してみる
declare
proc {MyProc4 In C ?Mid}
   Mid=In*C
end
declare Fuga in
{ForAllAcc [1 3 5 7] MyProc4 1 Fuga}
{Browse Fuga}


% リストの挟み込み
% リスト上のアキュムレータループは
% 中間演算子をリストの要素で挟み込んでいると言う事もできる

% 挟み込みの反復的定義
declare
fun {FoldL L F U}
   case L
   of nil then U
   [] X|L2 then
      {Browse X}
      {FoldL L2 F {F U X}}
   end
end
declare
fun {SumList L}
   {FoldL L fun {$ X Y} X+Y end 0}
end
{Browse {SumList [1 2 5]}}

% FoldLを使ってみた
declare
fun {FoldR L F U}
   {FoldL {Reverse L} fun {$ X Y} {F Y X} end U}
end
declare
fun {SumList L}
   {FoldR L fun {$ X Y} X-Y end 0}
end
{Browse {SumList [1 2 5]}}


declare
fun {FoldR L F U}
   fun {Loop L U}
      case L
      of nil then U
      [] X|L2 then
	 {Browse X#U}
	 {Loop L2 {F X U}}
      end
   end
in
   {Loop {Reverse L} U}
end
declare
fun {SumList L}
   {FoldR L fun {$ X Y} X-Y end 0}
end
%{SumList [1 2 5]}
{Browse {SumList [1 2 5]}}