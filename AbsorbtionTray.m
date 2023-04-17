%%%% made by: Ayman Abdalla A19ET4021 %%%%
%%% Linkedin %%%
%%% https://www.linkedin.com/in/ayman-abdalla-b55634203 %%%

% Example on how to use :
% VB = 97.8; (moles of inert B) 
% LC = 0; (moles of inert) %% (Lc = 0 for min calculation)
% YA1 = 0.002244; (exiting gas mole fraction of A) %% (if not given, YA1=[];)
% YAN_1 = 0.022; (entering gas mole fraction of A) %% (if not given, YAN_1=[];)
% XAo = 0; (entering liquid mole fraction of A) %% (if not given, XAo=[];)
% XAN = []; (exiting liquid mole fraction of A) %% (if not given, XAN=[];)
% m = 0.68; (slope of equilibrium line)
% >> AbsorbtionTray(VB,LC,YA1,YAN_1,XAo,XAN,m); 

function []= AbsorbtionTray(VB,LC,YA1,YAN_1,XAo,XAN,m)
% if isempty(m)
%     XA=input('enter the value of X array : ');
%     YA=input('enter the value of Y array : ');
%     A=['poly' num2str(length(XA)-1)];
%     m=fit(XA',YA',A);
%     p=coeffvalues(m);
%     syms x
%     y=0;
%     for i=1:length(p);
%     y=y+p(i)*x^(length(p)-i);
%     end
%     eqn= 1==18/(y);
% end
if LC==0
    syms LCmin
    XANmax=YAN_1/m;
    fprintf('--------------------------------------------------------------------------------------------------------------------\nXANmax : %11.4g\n',XANmax);
    eqn=(LCmin*((XAo)/(1-XAo)))+(VB*((YAN_1)/(1-YAN_1)))==(LCmin*((XANmax)/(1-XANmax)))+(VB*((YA1)/(1-YA1)));
    LCmin=solve(eqn,LCmin);
    LCmin=double(LCmin);
    fprintf('--------------------------------------------------------------------------------------------------------------------\nLCmin : %11.4g\n',LCmin);
    ratio=input('enter the ratio L/Lmin : ');
    LC=LCmin*ratio;
    fprintf('--------------------------------------------------------------------------------------------------------------------\nLC : %11.4g\n',LC);
    syms XAN
    eqn=(LC*((XAo)/(1-XAo)))+(VB*((YAN_1)/(1-YAN_1)))==(LC*((XAN)/(1-XAN)))+(VB*((YA1)/(1-YA1)));
    XAN=solve(eqn,XAN);
    XAN=double(XAN);
    fprintf('--------------------------------------------------------------------------------------------------------------------\nXAN : %11.4g\n',XAN);
end
if isempty(VB)
    syms VB
    eqn=(LC*((XAo)/(1-XAo)))+(VB*((YAN_1)/(1-YAN_1)))==(LC*((XAN)/(1-XAN)))+(VB*((YA1)/(1-YA1)));
    VB=solve(eqn,VB);
    VB=double(VB);
    fprintf('--------------------------------------------------------------------------------------------------------------------\nVB : %11.4g\n',VB);
elseif isempty(LC)
    syms LC
    eqn=(LC*((XAo)/(1-XAo)))+(VB*((YAN_1)/(1-YAN_1)))==(LC*((XAN)/(1-XAN)))+(VB*((YA1)/(1-YA1)));
    LC=solve(eqn,LC);
    LC=double(LC);
    fprintf('--------------------------------------------------------------------------------------------------------------------\nLC : %11.4g\n',LC);
elseif isempty(YA1)
    syms YA1
    eqn=(LC*((XAo)/(1-XAo)))+(VB*((YAN_1)/(1-YAN_1)))==(LC*((XAN)/(1-XAN)))+(VB*((YA1)/(1-YA1)));
    YA1=solve(eqn,YA1);
    YA1=double(YA1);
    fprintf('--------------------------------------------------------------------------------------------------------------------\nYA1 : %11.4g\n',YA1);
elseif isempty(YAN_1)
    syms YAN_1
    eqn=(LC*((XAo)/(1-XAo)))+(VB*((YAN_1)/(1-YAN_1)))==(LC*((XAN)/(1-XAN)))+(VB*((YA1)/(1-YA1)));
    YAN_1=solve(eqn,YAN_1);
    YAN_1=double(YAN_1);
    fprintf('--------------------------------------------------------------------------------------------------------------------\nYAN_1 : %11.4g\n',YAN_1);
elseif isempty(XAN)
    syms XAN
    eqn=(LC*((XAo)/(1-XAo)))+(VB*((YAN_1)/(1-YAN_1)))==(LC*((XAN)/(1-XAN)))+(VB*((YA1)/(1-YA1)));
    XAN=solve(eqn,XAN);
    XAN=double(XAN);
    fprintf('--------------------------------------------------------------------------------------------------------------------\nXAN : %11.4g\n',XAN);
end 
Lo=LC/(1-XAo);
LN=Lo/(1-XAN);
VN1=VB/(1-YAN_1);
V1=VB/(1-YA1);
fprintf('--------------------------------------------------------------------------------------------------------------------\nV(N+1) : %8.5g    Y(AN+1) : %11.5g\nL(N) : %11.5g   X(AN) : %11.5g\nV(1) : %11.5g   Y(A1) : %11.5g\nL(0) : %11.5g   X(A0) : %11.5g\n',VN1,YAN_1,LN,XAN,V1,YA1,Lo,XAo);
A1=Lo/(m*V1);
AN=LN/(m*VN1);
A=sqrt(AN*A1);
fprintf('--------------------------------------------------------------------------------------------------------------------\nA1 : %8.5g    AN : %11.5g    A : %11.5g\n',A1,AN,A);
if round(A,1)==1
    N=(YAN_1-YA1)/(YA1-(m*XAo));
else
    N=log(((YAN_1-(m*XAo))/(YA1-(m*XAo)))*(1-(1/A))+(1/A))/log(A);
end
fprintf('--------------------------------------------------------------------------------------------------------------------\nN : %8.5g\n',N);
end