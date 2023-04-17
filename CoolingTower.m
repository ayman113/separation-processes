%%%% made by: Ayman Abdalla A19ET4021 %%%%
%%% Linkedin %%%
%%% https://www.linkedin.com/in/ayman-abdalla-b55634203 %%%

% Example on how to use : ( need cf function )
% H = 0.0165; (humidity)
% L = 1.356; (water flow rate)
% G = 1.356; (gas flow rate) %% (G=0 for minimum calculation)
% TL1 = 29.4; (outlet water temperature)
% TL2 = 43.3; (inlet water temperature)
% TG1 = 29.4; (inlet air temperature)
% slope = -4.187*10^4; (j/kg.k) %% (slope = 0 for overall calculation)
% TL = [29.4 32.5 35.1 38 40.8 43.3]; (interval from TL1 to TL2)
% >> CoolingTower(H,L,G,TL1,TL2,TG1,slope,TL)

function []= CoolingTower(H,L,G,TL1,TL2,TG1,slope,TL)
i=5;
clear figure
a =2.233e+04  ;
b =0.05021 ;
EL =@(T) a.*exp(b.*T);
cL=4187; %J/Kg.K
Hy1=(1.005+H*1.88)*(10^3)*(TG1)+((2.501*H)*(10^6));
% TL=[TL1:(TL2-TL1)/(i):TL2];
if G==0
    t = linspace(20,50);
    x = t;
    y = EL(t);                 % x,y  describe the curve;
    
    x0 = TL1; y0 = Hy1;                           % given point
    
    xe = [x0, x]; ye = [y0, y];               % put all points together
    cvx = convhull(xe,ye);                    % find convex hull
    
    x1 = xe(cvx(2)); y1=ye(cvx(2));           % one neighbor of (x0,y0)
    x2 = xe(cvx(end-1)); y2=ye(cvx(end-1));   % another neighbor
    s = linspace(0,2);
    plot(x,y,'b')
    hold on
    plot(x0+s*(x1-x0), y0+s*(y1-y0), 'r')     % plot the lines
    [Tmax,Hy2max]=polyxpoly(round(x0+s*(x1-x0),3),round(y0+s*(y1-y0),3),round(x,3),round(y,3));
    Hy2max=Hy2max(1);
    fprintf('--------------------------------------------------------------------------------------------------------------------\nHymax : %11.3g\n',Hy2max);
    
    Gmin=((L.*cL.*(TL2-TL1)))./(Hy2max-Hy1);
    ratio=input('enter  G / Gmin ratio : ');
    fprintf('--------------------------------------------------------------------------------------------------------------------\nGmin : %11.3g\n',Gmin);
    
    G=Gmin*ratio;
    fprintf('--------------------------------------------------------------------------------------------------------------------\nG : %11.3g\n',G);
    
    Hy2=((L.*cL.*(TL2-TL1))./(G))+Hy1;
    fprintf('--------------------------------------------------------------------------------------------------------------------\nHy: %11.3g\n',Hy2);
    
else
    Hy2=((L*cL*(TL2-TL1))/(G))+Hy1;
end
OL=cf([TL1,TL2],[Hy1 Hy2],1);
Hy=OL(TL);
if slope~=0
    Tyi(6)=0;
    Hyi(6)=(slope*(-TL2+Tyi(6)))+Hy2;
    for i=5:-1:1
        Hyi(i)=(slope*(-TL(i)+Tyi(i)))+Hy(i);
    end
    plot([20:1:45],EL(20:1:45),'b');hold on ;plot(TL,OL(TL),'b');hold on
    for i=1:6
        
        x_line = [TL(i) Tyi(i)];
        y_line = [Hy(i) Hyi(i)];
        x_curve = [15.6 26.7 29.4 32.2 35 37.8 40.6 43.3 46.1 60];
        y_curve = [43.68 84 97.2 112.1 128.9 148.2 172.1 197.2 224.5 461.5]*10^3;
        b_line = polyfit(x_line, y_line,1);                     % Fit ‘line’
        y_line2 = polyval(b_line, x_curve);                     % Evaluate ‘line’ At ‘x_curve’
        x_int = interp1((y_line2-y_curve), x_curve, 0);         % X-Value At Intercept
        y_int = polyval(b_line,x_int);
        Hyi(i)=y_int;                            % Y-Value At Intercept
        figure(1)
        plot(x_line, y_line,'--g')
        hold on
        plot(x_curve, y_curve)
        plot(x_int, y_int, '+r')                                % Plot Intercept Point
    end
    Hyi_Hy=Hyi-Hy;
    l_Hyi_Hy=1./Hyi_Hy;
    DHy=Hy(2:end)-Hy(1:end-1);
    l_ave=(l_Hyi_Hy(2:end)+l_Hyi_Hy(1:end-1))./2;
    DHyL=DHy.*l_ave;
    area=sum(DHyL);
    DHy(i)=0;l_ave(i)=0;DHyL(i)=0;
    table=[TL' Hyi' Hy' Hyi_Hy' l_Hyi_Hy' DHy' l_ave' DHyL'];
    fprintf('TL             Hyi              Hy              Hyi-Hy          1/(Hyi-Hy)         dHy            (1/(Hyi-Hy)ave     dHy x (1/(Hyi-Hy)ave\n');
    format short e
    fprintf('%.3f %15.4g %15.4g %16.4g %16.4g %17.4g %19.4g %20.3f\n',table');
    fprintf('--------------------------------------------------------------------------------------------------------------------\nsum : %11.3f\n',area);
    hold off
else
    Hyi=EL(TL);
    plot([20:1:45],EL(20:1:45),'b');hold on ;plot(TL,OL(TL),'b');hold on
    for i=1:6
        
        x_line = [TL(i) TL(i)];
        y_line = [Hy(i) Hyi(i)];
        x_curve = [15.6 26.7 29.4 32.2 35 37.8 40.6 43.3 46.1 60];
        y_curve = [43.68 84 97.2 112.1 128.9 148.2 172.1 197.2 224.5 461.5]*10^3;
        b_line = polyfit(x_line, y_line,1);                     % Fit ‘line’
        y_line2 = polyval(b_line, x_curve);                     % Evaluate ‘line’ At ‘x_curve’
        x_int = interp1((y_line2-y_curve), x_curve, 0);         % X-Value At Intercept
        figure(1)
        plot(x_line, y_line,'--g')
        hold on
        plot(x_curve, y_curve,'b')
        plot(x_int, Hyi(i), '+r')                                % Plot Intercept Point
    end
    Hyi_Hy=Hyi-Hy;
    l_Hyi_Hy=1./Hyi_Hy;
    DHy=Hy(2:end)-Hy(1:end-1);
    l_ave=(l_Hyi_Hy(2:end)+l_Hyi_Hy(1:end-1))./2;
    DHyL=DHy.*l_ave;
    area=sum(DHyL);
    DHy(i)=0;l_ave(i)=0;DHyL(i)=0;
    table=[TL' Hyi' Hy' Hyi_Hy' l_Hyi_Hy' DHy' l_ave' DHyL'];
    fprintf('TL             Hyi              Hy              Hyi-Hy          1/(Hyi-Hy)         dHy            (1/(Hyi-Hy)ave     dHy x (1/(Hyi-Hy)ave\n');
    format short e
    fprintf('%.3f %15.4g %15.4g %16.4g %16.4g %17.4g %19.4g %20.3f\n',table');
    fprintf('--------------------------------------------------------------------------------------------------------------------\nsum : %11.3f\n',area);
    hold off
    
end
end