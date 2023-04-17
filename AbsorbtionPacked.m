%%%% made by: Ayman Abdalla A19ET4021 %%%%
%%% Linkedin %%%
%%% https://www.linkedin.com/in/ayman-abdalla-b55634203 %%%

% Example on how to use :
% XA = 

function []= AbsorbtionPacked(XA,YA,yAG,xAL)
A=input('for non-straight equilibrium line enter 1, for both straight enter 2 : ')
switch A
    case 1 %non-straight EL
        A=['poly' num2str(length(XA)-1)];
        EL=fit(XA',YA',A);
        B=input('for film enter 1, for overall enter 2 : ');
        switch B
            case 1 %film
                ky=input('k`y = ');
                kx=input('k`x = ');
                D=input('for equimolar counter-diffusion enter 1, for non-diffusing liquids enter 2');
                switch D 
                    case 1 %equimolar
                        PM=-ky/kx;
                        OL=@(y) y/PM;
                        x_line=[xAL OL(0.01)];
                        y_line=[yAG 0.01];
                    case 2 %nondiff B
                        
                end
                
                
            case 2 % overall
                C=input('if overall coeffecient given enter 1, if film coeffecient given enter 2 : ');
                
                switch C
                    case 1
                        Ky=input('K`y = ');
                        Kx=input('K`x = ');
                    case 2 %calculating overall
                        ky=input('k`y = ');
                        kx=input('k`x = ');
                end
        end
        
    case 2 %straight 
end

end