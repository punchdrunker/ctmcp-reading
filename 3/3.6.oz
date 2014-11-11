% 3.6 高階プログラミング
% 
% 手続きに渡される手続きの入れ子の階層を複数重ねることを高階と言う
%
% 3.6.1 基本操作
%
% 以下4つが基本操作となる
% 1. 手続き抽象
% 2. 汎用性
% 3. 具体化
% 4. 埋め込み
%
% 手続き抽象
% procを用いると、手続きをパッケージ化できる
% 
% 2次方程式の解の公式を使った計算を例に手続きをパッケージ化し、実行する
declare
local A=1.0 B=3.0 C=2.0 D RealSol X1 X2 in
   D=B*B-4.0*A*C
   if D>=0.0 then
      RealSol=true
      X1=(~B+{Sqrt D}) / (2.0*A)
      X2=(~B-{Sqrt D}) / (2.0*A)
   else
      RealSol=false
      X1=~B/(2.0*A)
      X2={Sqrt ~D}/(2.0*A)
   end
   {Browse RealSol#X1#X2}
end

declare
proc {QuadraticEquation A B C ?RealSol ?X1 ?X2}
   D=B*B-4.0*A*C
in
   if D>=0.0 then
      RealSol=true
      X1=(~B+{Sqrt D}) / (2.0*A)
      X2=(~B-{Sqrt D}) / (2.0*A)
   else
      RealSol=false
      X1=~B/(2.0*A)
      X2={Sqrt ~D}/(2.0*A)
   end
end

% 実際に呼んでみる
declare RS X1 X2 in
{QuadraticEquation 1.0 3.0 2.0 RS X1 X2}
{Browse RS#X1#X2}


% 手続き抽象の制限された形
% 
% CやPascalでは手続きを入れ子にできなかったり、変数のスコープが制限されたりして、
% 多くの高階プログラミング技法が使えない
% これは、文脈環境が宙ぶらりんの参照を持たないようにするため、手続き値の生成に制限を加えているせいだけど、
% 手続き値の役割はオブジェクト指向言語によって実現可能



% 汎用性
% 本体の中の任意の特定の実態をその関数の引数にすると、
% 関数を汎用的にすることができる
% 
% リストの要素の合計値を出すSumList
declare
fun {SumList L}
   case L
   of nil then 0
   [] X|L1 then X+{SumList L1}
   end
end

% nilだった場合の値0を整数U、演算子(+)を手続値Fとして、引数にすると
% 汎用的な関数を作ることができる
declare
fun {FoldR L F U}
   case L
   of nil then U
   [] X|L1 then {F X {FoldR L1 F U}}
   end
end

% FoldRを利用して、SumListを実装する
declare
fun {SumList L}
   {FoldR L fun {$ X Y} X+Y end 0}
end
{Browse {SumList [1 2 5]}}

% 要素の積を求めるProductListを実装
declare
fun {ProductList L}
   {FoldR L fun {$ X Y} X*Y end 1}
end
{Browse {ProductList [2 6 8]}}

% リストに1つでもtrue があれば、trueを返すSome
declare
fun {Some L}
   {FoldR L fun {$ X Y} X orelse Y end false}
end
{Browse {Some [false true]}}


% 汎用化したMergeSort
% 事前準備： 古いSplit
declare
proc {Split Xs ?Ys ?Zs}
   case Xs
   of nil then Ys=nil Zs=nil
   [] [X] then Ys=[X] Zs=nil
   [] X1|X2|Xr then Yr Zr in
      Ys=X1|Yr
      Zs=X2|Zr
      {Split Xr Yr Zr}
   end
end
% 比較関数'<'を引数として渡すことで汎用化できる
declare
fun {GenericMergeSort F Xs}
   fun {Merge Xs Ys}
      case Xs # Ys
      of nil # Ys then Ys
      [] Xs # nil then Xs
      [] (X|Xr) # (Y|Yr) then
	 % 渡された手続きの結果に従って、Mergeする
	 if {F X Y} then X|{Merge Xr Ys}
	 else Y|{Merge Xs Yr} end
      end
   end
   fun {MergeSort Xs}
      case Xs
      of nil then nil
      [] [X] then [X]
      else Ys Zs in
	 {Split Xs Ys Zs}
	 {Merge {MergeSort Ys} {MergeSort Zs}}
      end
   end
in {MergeSort Xs}
end
fun {MergeSort Xs}
   {GenericMergeSort fun {$ A B} A<B end Xs}
end
{Browse {MergeSort [3 5 1 4 5 7]}}

% 試しに逆にしてみる
declare
fun {MergeSortVise Xs}
   {GenericMergeSort fun {$ A B} A>B end Xs}
end
{Browse {MergeSortVise [3 5 1 4 5 7]}}


% 具体化
declare
fun {MakeSort F}
   fun {$ L}
      {Sort L F}
   end
end
{Browse {{MakeSort Value.'>'} [2 5 3 1]}}
{Browse {{MakeSort Value.'<'} [2 5 3 1]}}

% 埋め込み
% 手続き値をデータ構造に入れることができる
%
% 明示的遅延計算：
% 一度に完全なデータ構造を作らず、必要に応じて作る
%
% モジュール：
% 関連する操作の集合をレコードとして扱える
%
% ソフトウェアコンポーネント：
% モジュールの集合を入力引数とし、新しいモジュールを返す
% あるモジュールをそれが必要とするモジュールによって規定する