% 1.1 計算機
% ↓の行を選択し、 Oz > Feed Region を選択し、実行してみる
% (ショートカットはC-. r)
{Browse 9999*9999}

% 1.2 変数

declare
V=9999*9999

{Browse V*V}

% 1.3 関数
{Browse 1*2*3*4*5*6*7*8*9*10}

% 再帰
declare
fun {Fact N}
   if N==0 then 1 else N*{Fact N-1}end
end

{Browse {Fact 10}}
{Browse {Fact 100}}

% 組み合わせ
declare
fun {Comb N K}
   {Fact N} div ({Fact K}*{Fact N-K})
end
{Browse {Comb 10 3}}

% 1.4 リスト
% パスカルの三角形

{Browse [5 6 7 8]}

declare
H=5
T=[6 7 8]
{Browse H|T}

declare
L=[5 6 7 8]
{Browse L.1}
{Browse L.2}

% パターンマッチング
declare
L=[5 6 7 8]
case L of H|T then {Browse H} {Browse T} end

% 1.5 リストについての関数
% 行を1つずらしたものと右に1つずらしたものを足し合わせると次の行を作ることができる
declare Pascal AddList ShiftLeft ShiftRight
fun {Pascal N}
   if N==1 then [1]
   else
      {AddList {ShiftLeft {Pascal N-1}} {ShiftRight {Pascal N-1}}}
   end
end

fun {ShiftLeft L}
   case L of H|T then
      H|{ShiftLeft T}
   else [0] end
end

fun {ShiftRight L} 0|L end

fun {AddList L1 L2}
   case L1 of H1|T1 then
      case L2 of H2|T2 then
	 H1+H2 |{AddList T1 T2}
      end
   else nil end
end

{Browse {Pascal 20}}
