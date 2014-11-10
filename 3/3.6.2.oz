% 3.6.2 ループ抽象

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
{For 1 50 4 MyProc}


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
declare
proc {ForAcc A B S P In ?Out}
   proc {LoopUp C In ?Out}
   Mid in
      if C=<B then {P In C Mid} {LoopUp C+S Mid Out}
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
proc {ForAllAcc L P In ?Out}
   case L
   of nil then In=Out
   [] X|L2 then Mid in
      {P In X Mid}
      {ForAllAcc L2 P Mid Out}
   end
end

% リストの挟み込み
declare
fun {FoldL L F U}
   case L
   of nil then U
   [] X|L2 then
      {FoldL L2 F {F U X}}
   end
end
fun {FoldR L F U}
   fun {Loop L U}
      case L
      of nil then U
      [] X|L2 then
	 {Loop L2 {F X U}}
      end
   end
in
   {Loop {Reverse L} U}
end
