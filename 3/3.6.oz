% 3.6 高階プログラミング
% 3.6.1 基本操作
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

declare RS X1 X2 in
{QuadraticEquation 1.0 3.0 2.0 RS X1 X2}
{Browse RS#X1#X2}

% 汎用性
declare
fun {SumList L}
   case L
   of nil then 0
   [] X|L1 then X+{SumList L1}
   end
end

declare
fun {FoldR L F U}
   case L
   of nil then U
   [] X|L1 then {F X {FoldR L1 F U}}
   end
end

declare
fun {SumList L}
   {FoldR L fun {$ X Y} X+Y end 0}
end

declare
fun {ProductList L}
   {FoldR L fun {$ X Y} X*Y end 1}
end

declare
fun {Some L}
   {FoldR L fun {$ X Y} X orelse Y end false}
end

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

declare
fun {GenericMergeSort F Xs}
   fun {Merge Xs Ys}
      case Xs # Ys
      of nil # Ys then Ys
      [] Xs # nil then Xs
      [] (X|Xr) # (Y|Yr) then
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

% 具体化
declare
fun {MakeSort F}
   fun {$ L}
      {Sort L F}
   end
end
{Browse {{MakeSort Value.'>'} [2 5 3]}}