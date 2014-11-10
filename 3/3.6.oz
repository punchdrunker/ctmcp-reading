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

