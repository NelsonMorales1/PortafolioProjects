function dFds=C2H6_Hyd (s,F)        %s is residence time
%(r1) C2H6 -> C2H4 + H2
%(r2) C2H6 + H2 -> 2CH4
%Fc2h6=F(1); Fc2h4=F(2); Fh2=F(3); Fch4=F(4)

global Fio vo
Fto=Fio(1)+Fio(2)+Fio(3)+Fio(4);    %Total initial total molar flow rate
Cto=Fto/vo;                         %Initial total concentration
Ft=F(1)+F(2)+F(3)+F(4);             %Total Flowrate

%Rate constants
k1=0.0022;
k2=6.27E-15;
kc1=1534.38;
kc2=0.98;      
C=F*Cto/Ft;                         %Concentrations, C(1)=F(1)*Cto/Ft

%Rate laws
r1=k1*(C(1)-((C(2)*C(3))/kc1));
r2=0.5*k2*((C(4)^2)-((C(1)*C(3))/kc2));

%Net rates for each species
R(1)=-r1+r2;
R(2)=r1;
R(3)=r1+r2;
R(4)=-2*r2;

dFds=[R(1);R(2);R(3);R(4)].*vo;      
end 

