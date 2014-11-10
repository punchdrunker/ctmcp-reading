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