% 1.1 計算機
% ↓の行を選択し、 Oz > Feed Region を選択し、実行してみる
% (ショートカットはC-. r)
{Browse 9999*9999}

% 1.2 変数
% 宣言をすると変数が利用できる
% 同じ名前の変数を宣言する事もできるが、以前の変数とは別のものになってしまう
declare
V=9999*9999

{Browse V*V}

% 1.3 関数
% 変数に関数を束縛する事ができる
{Browse 1*2*3*4*5*6*7*8*9*10}

% 再帰
% 精度はメモリ量に制限される
declare
fun {Fact N}
   if N==0 then 1 else N*{Fact N-1}end
end

{Browse {Fact 10}}
% 100だと、0に。。。
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
% main
declare Pascal AddList ShiftLeft ShiftRight
fun {Pascal N}
   if N==1 then [1]
   else
      {AddList {ShiftLeft {Pascal N-1}} {ShiftRight {Pascal N-1}}}
   end
end

% 補助関数
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

% 実行
{Browse {Pascal 20}}

% ソフトウェアのトップダウン開発
% 1. 手でどのように計算するかを理解する
% 2. 補助関数は既知であるとしてメイン関数を作る
% 3. 補助関数を作る

% 1.6 プログラムの正しさ
% プログラムの正しさを証明するには...
% semantics:
%    プログラミング言語の操作が何をすべきかを定義する数学的モデルが必要
% specification:
%    プログラムに何をしてもらいたいかを定義する必要がある
%    入力と出力の数学的定義
% 意味を考慮しながら数学的技法を使ってプログラムに関して推論する。
% プログラムが仕様を満たしていることを証明したい。(test?)

% 数学的帰納法
% 1. プログラムが簡単な場合に正しい事を示す
% 2. プログラムがある場合に出しければ、その次の場合にも正しいことを示す
%    最終的にすべての場合を尽せることが確かであれば、プログラムは常に正しいと言える
% この技法は整数とリストに適用できる

% 1.7 計算量
% 1.5で実装した関数だと、例えば{Pascal 30}を実行すると約5億回のPascalが実行されてしまう
% {Pascal N}を呼ぶと{Pascal N-1}が2回実行され、{Pascal N-2}が4回と、なってしまう
% 局所的変数を利用し、{Pascal N-1}が呼ばれる回数を1回にすることができる
declare
fun {FastPascal N}
   if N==1 then [1]
   else L in
      L={FastPascal N-1}
      {AddList {ShiftLeft L} {ShiftRight L}}
   end
end
{Browse {FastPascal 20}}
{Browse {Pascal 20}}

% 実行時間の現実性
% 
% プログラムの実行時間を入力の大きさの関数と見るとき、
% その関数をプログラムの時間計算量(time complexity)という
% {Pascal N}の時間計算量は2^nに比例する
% 時間計算量が低次の多項式であるプログラムは実用的である(計算量が少い)

% 1.8 遅延計算
%
% 性急計算: 呼ばれるとすぐに計算を行う
% 遅延計算: 結果が必要になった時に初めて計算が行われる

declare
fun lazy {Ints N}
   N|{Ints N+1}
end
L={Ints 0}
% Broseは遅延関数の実行を指示しない
{Browse L}
% 必要になった時だけ実行される
{Browse L.1}

% 3が出力されるけど、この行だけ2回実行するとcrashする...
case L of A|B|C|_ then {Browse A+B+C} end

% パスカルの三角形の遅延計算
declare
fun lazy {PascalList Row}
   Row|{PascalList
	{AddList {ShiftLeft Row} {ShiftRight Row}}}
end

declare
L={PascalList [1]}
{Browse L}
{Browse L.1}
{Browse L.2.1}

declare
fun {PascalList2 N Row}
   if N==1 then [Row]
   else
      Row|{PascalList2 N-1
	   {AddList {ShiftLeft Row} {ShiftRight Row}}}
   end
end
{Browse {PascalList2 10 [1]}}

% 1.9 高階プログラミング
%
% パスカルの三角形の変種を想定した実装を考えてみる
% (足すだけじゃなく、引いてみるとか偶数だけ対象にするとか)
% 特殊化するための関数を引数として渡してやれば可能になる(高階プログラミング)

declare
fun {GenericPascal Op N}
   if N==1 then [1]
   else L in
      L={GenericPascal Op N-1}
      {OpList Op {ShiftLeft L} {ShiftRight L}}
   end
end
fun {OpList Op L1 L2}
   case L1 of H1|T1 then
      case L2 of H2|T2 then
	 {Op H1 H2}|{OpList Op T1 T2}
      end
   else nil end
end

% パスカルの三角形の変種
% もともとのパスカルの三角形
declare
fun {Add X Y} X+Y end
fun {FastPascal N} {GenericPascal Add N} end
{Browse {FastPascal 3}}

%別の関数 排他的論理和
declare
fun {Xor X Y} if X==Y then 0 else 1 end end
fun {FastPascal N} {GenericPascal Xor N} end
{Browse {FastPascal 1}}
{Browse {FastPascal 2}}
{Browse {FastPascal 3}}
{Browse {FastPascal 4}}

% 1.10 並列性
thread P in
   P={Pascal 20}
   {Browse P}
end
{Browse 99*99}

% 1.11 データフロー
%
% ある操作がまだ束縛されていない変数を利用しようとしたとき
% その変数が束縛されるまで待つ
declare X in
thread {Delay 5000} X=99 end
{Browse start} {Browse X*X}

% データフロー実行は常に同じ結果を与える
declare X in
thread {Browse start} {Browse X*X} end
{Delay 5000} X=99

% 詳細は4章で

% 1.12 明示的状態
%
% 関数が過去から学ぶためには、内部にメモリを持たせる必要がある(明示的状態)l
% memory cell:
%    memory cellとは何でも投げこめる箱のようなものである.
%    プログラミングでの変数ではなく、値の別名に過ぎない
% := セルに値を入れる
% @  セルの値を読み出す

% 例：初期内容0のセルCを生成し、内容に1を加え、表示する
declare
C={NewCell 0}
C:=@C+1
{Browse @C}

% FastPascalにメモリセルを追加する
% (FastPascalが何回呼ばれたかを数えさせる)
declare
C={NewCell 0}
fun {FastPascal N}
    C:=@C+1
    {GenericPascal Add N}
end
{Browse {FastPascal 30}}

% 1.13 オブジェクト
%
% 内部メモリを持つ関数をオブジェクトと呼ぶ
% BumpとReadが出来るオブジェクトを実装する

declare
% localは新しい変数を宣言するが、endまでの間でしか利用できない
local C in
   C={NewCell 0}
   fun {Bump}
      C:=@C+1
      @C
   end
   fun {Read}
      @C
   end
end
{Browse {Bump}}
{Browse {Bump}}
% 実行する度にカウントが増えるのがわかる
% BumpをFastPascalでも利用してみる
declare
fun {FastPascal N}
   %  C:=@C+1 だったところを修正
   {Browse {Bump}}
   {GenericPascal Add N}
end

% 1.14 クラス
%
% 複数のカウンタが必要なら、カウンタを生産できる工場を作ろう
declare
fun {NewCounter}
   C Bump Read in
   C={NewCell 0}
   fun {Bump}
      C:=@C+1
      @C
   end
   fun {Read}
      @C
   end
   % ラベルcountと、bumpとreadの2つのフィールドを持つレコードを返す
   counter(bump:Bump read:Read)
end

% 2つのカウンターを生成する
declare
Ctr1={NewCounter}
Ctr2={NewCounter}
% ドット演算子を用いて、Bump関数、Read関数にアクセスすることができる
{Browse {Ctr1.bump}}
{Browse {Ctr1.read}}
{Browse {Ctr2.bump}}
{Browse {Ctr2.read}}

% オブジェクト指向プログラミングに向けて
%
% クラス内部で定義される操作はメソッドと呼ぶ
% クラスを利用するといくらでもオブジェクトを生成できる
% それらのオブジェクトは同じメソッドを共有するが、
% 内部メモリはオブジェクトごとに別々である
% クラスとオブジェクトを用いてプログラミングすることをオブジェクトベースプログラミングと呼ぶ
% さらに継承を導入するとオブジェクト指向プログラミングになる
% 継承:
% 既存のクラスとの違いを記述するだけで、既存のクラスから新しいクラスを定義すること
% 詳細は7章で


% 1.15 非決定性と時間
%
% プログラムに並列性と明示的状態を同時に加えるとどうなるか?
% スレッドが明示的状態にアクセスする順序が実行のたびに違うと違う結果を出すことがあるので危険だ
% このように一定しないことを非決定性という(nondeterminism)
% 基本操作が実行される正確な時刻をわれわれが知らないから、非決定性は生じる
% スレッドが独立である以上、防ぐことはできない
% すでに並列性において、非決定性は出てきている。
% 非決定性そのものが問題ではない
% 非決定性が観測可能になると、困難が生じる
% => 観測可能な非決定性は競合条件と言われることがある
declare
C={NewCell 0}
thread
   C:=1
end
thread
   C:=2
end
% ここでBrowseすると、0,1,2のどれかになる可能性がある
{Browse @C}

% もっと厄介な例
declare
C={NewCell 0}
thread I in
   I=@C
   C:=I+1
end
thread J in
   J=@C
   C:=J+1
end
% 2が出力されるが、各スレッドでの@C参照が同時であれば、1になる可能性もある?
{Browse @C}

% インタリーブ
%
% スレッドの実行はインタリーブされる(交互に少しずつ実行される)ので上記の結果が1になる事もあり得る
% Iへの代入>Jへの代入>Cへの代入
% という順序で実行されるとどちらのCも1になってしまう

% 1.16 原子性
%
% 原子的操作を用いると並列性と明示的状態を一緒に利用することが容易になる
% 原子的操作を構築するために、ロックという新しい言語実態を導入する
% ロックには内側と外側があり、プログラマは内側の命令を定義する
% ロックにはその内部を実行できるスレッドは一時に1つという性質があるので、
% 別のスレッドが内部に入ろうとしても、最初のスレッドが出て行くまで待たされる
% 故にロック内部で行われることは原子的である
%
% ロックに関する操作は2つ必要である
% 1.ロックを生成するNewLock
% 2.ロック L 内部を定義する lock L then ... end
% これらを用いてカウンタの欠陥を修正できる

declare
C={NewCell 0}
L={NewLock}
thread
   lock L then I in
      %{Browse 1}
      I=@C
      C:=I+1
      %{Browse 2}
   end
end
thread
   lock L then J in
      %{Browse 3}
      J=@C
      C:=J+1
      %{Browse 4}
   end
end
{Browse @C}

% どちらのスレッド本体も同じロックで守るべきである
% さもないとインターリーブがやはり起きる
% =>  (同一のロックでないと同じ内部の操作を制御できないから?)
declare
C={NewCell 0}
L={NewLock}
L2={NewLock}
thread
   lock L then I in
      {Browse 1}
      I=@C
      C:=I+1
      {Browse 2}
   end
end
thread
   lock L2 then J in
      {Browse 3}
      J=@C
      C:=J+1
      {Browse 4}
   end
end
{Browse @C}
{Browse @C}
{Browse @C}
{Browse @C}

% 1.17 ここからどこへ行くのか?
%
% 宣言的モデル
% 宣言的並列モデル
% 宣言的遅延モデル
% 状態ありモデル
% オブジェクト指向モデル
% 状態共有並列モデル