function ima_transf=transf_deform (ima,DeltaX,DeltaY,liste_points)
[X,Y]=size(liste_points);
[Xima,Yima]=size(ima);
ima_transf=zeros(1+(X-1)*DeltaX,1+(Y-1)*DeltaY);
for x=0:(X-1)*DeltaX-1
    for y=0:(Y-1)*DeltaY-1
        n_x=floor(x/DeltaX);n_y=floor(y/DeltaY);
        ponder_x=x/DeltaX-n_x;ponder_y=y/DeltaY-n_y;
        coord_prime=...
            liste_points{n_x+1,n_y+1}*(1-ponder_x)*(1-ponder_y)+...
            liste_points{n_x+2,n_y+1}*ponder_x*(1-ponder_y)+...
            liste_points{n_x+1,n_y+2}*(1-ponder_x)*ponder_y+...
            liste_points{n_x+2,n_y+2}*ponder_x*ponder_y;
        x_0=floor(coord_prime(1));y_0=floor(coord_prime(2));
        ponder_x0=coord_prime(1)-x_0;ponder_y0=coord_prime(2)-y_0;
        if((x_0>=0) && (y_0>=0))
            if((x_0<(Xima-1)) && (y_0<(Yima-1)))
                ima_transf(x+1,y+1)=...
                    ima(x_0+1,y_0+1)*(1-ponder_x0)*(1-ponder_y0)+...
                    ima(x_0+2,y_0+1)*ponder_x0*(1-ponder_y0)+...
                    ima(x_0+1,y_0+2)*(1-ponder_x0)*ponder_y0+...
                    ima(x_0+2,y_0+2)*ponder_x0*ponder_y0;
            elseif((x_0==(Xima-1)) && (y_0<(Yima-1)))
                ima_transf(x+1,y+1)=...
                    ima(x_0+1,y_0+1)*(1-ponder_y0)+...
                    ima(x_0+1,y_0+2)*ponder_y0;
            elseif((x_0<(Xima-1)) && (y_0==(Yima-1)))
                ima_transf(x+1,y+1)=...
                    ima(x_0+1,y_0+1)*(1-ponder_x0)+...
                    ima(x_0+2,y_0+1)*ponder_x0;
            end
        end
    end
end
x=(X-1)*DeltaX;
n_x=X-1;
for y=0:(Y-1)*DeltaY-1
    n_y=floor(y/DeltaY);
    ponder_y=y/DeltaY-n_y;
    coord_prime=...
        liste_points{n_x+1,n_y+1}*(1-ponder_y)+...
        liste_points{n_x+1,n_y+2}*ponder_y;
    x_0=floor(coord_prime(1));y_0=floor(coord_prime(2));
    ponder_x0=coord_prime(1)-x_0;ponder_y0=coord_prime(2)-y_0;
    if((x_0>=0) && (y_0>=0))
        if((x_0<(Xima-1)) && (y_0<(Yima-1)))
            ima_transf(x+1,y+1)=...
                ima(x_0+1,y_0+1)*(1-ponder_x0)*(1-ponder_y0)+...
                ima(x_0+2,y_0+1)*ponder_x0*(1-ponder_y0)+...
                ima(x_0+1,y_0+2)*(1-ponder_x0)*ponder_y0+...
                ima(x_0+2,y_0+2)*ponder_x0*ponder_y0;
        elseif((x_0==(Xima-1)) && (y_0<(Yima-1)))
            ima_transf(x+1,y+1)=...
                ima(x_0+1,y_0+1)*(1-ponder_y0)+...
                ima(x_0+1,y_0+2)*ponder_y0;
        elseif((x_0<(Xima-1)) && (y_0==(Yima-1)))
            ima_transf(x+1,y+1)=...
                ima(x_0+1,y_0+1)*(1-ponder_x0)+...
                ima(x_0+2,y_0+1)*ponder_x0;
        end
    end
end
y=(Y-1)*DeltaY;
n_y=Y-1;
for x=0:(X-1)*DeltaX-1
    n_x=floor(x/DeltaX);
    ponder_x=x/DeltaX-n_x;
        coord_prime=...
            liste_points{n_x+1,n_y+1}*(1-ponder_x)+...
            liste_points{n_x+2,n_y+1}*ponder_x;
    x_0=floor(coord_prime(1));y_0=floor(coord_prime(2));
    ponder_x0=coord_prime(1)-x_0;ponder_y0=coord_prime(2)-y_0;
    if((x_0>=0) && (y_0>=0))
        if((x_0<(Xima-1)) && (y_0<(Yima-1)))
            ima_transf(x+1,y+1)=...
                ima(x_0+1,y_0+1)*(1-ponder_x0)*(1-ponder_y0)+...
                ima(x_0+2,y_0+1)*ponder_x0*(1-ponder_y0)+...
                ima(x_0+1,y_0+2)*(1-ponder_x0)*ponder_y0+...
                ima(x_0+2,y_0+2)*ponder_x0*ponder_y0;
        elseif((x_0==(Xima-1)) && (y_0<(Yima-1)))
            ima_transf(x+1,y+1)=...
                ima(x_0+1,y_0+1)*(1-ponder_y0)+...
                ima(x_0+1,y_0+2)*ponder_y0;
        elseif((x_0<(Xima-1)) && (y_0==(Yima-1)))
            ima_transf(x+1,y+1)=...
                ima(x_0+1,y_0+1)*(1-ponder_x0)+...
                ima(x_0+2,y_0+1)*ponder_x0;
        end
    end
end
x=(X-1)*DeltaX;
y=(Y-1)*DeltaY;
n_x=X-1;
n_y=Y-1;
coord_prime=liste_points{n_x+1,n_y+1};
x_0=floor(coord_prime(1));y_0=floor(coord_prime(2));
ponder_x0=coord_prime(1)-x_0;ponder_y0=coord_prime(2)-y_0;
if((x_0>=0) && (y_0>=0))
    if((x_0<(Xima-1)) && (y_0<(Yima-1)))
        ima_transf(x+1,y+1)=...
            ima(x_0+1,y_0+1)*(1-ponder_x0)*(1-ponder_y0)+...
            ima(x_0+2,y_0+1)*ponder_x0*(1-ponder_y0)+...
            ima(x_0+1,y_0+2)*(1-ponder_x0)*ponder_y0+...
            ima(x_0+2,y_0+2)*ponder_x0*ponder_y0;
    elseif((x_0==(Xima-1)) && (y_0<(Yima-1)))
        ima_transf(x+1,y+1)=...
            ima(x_0+1,y_0+1)*(1-ponder_y0)+...
            ima(x_0+1,y_0+2)*ponder_y0;
    elseif((x_0<(Xima-1)) && (y_0==(Yima-1)))
        ima_transf(x+1,y+1)=...
            ima(x_0+1,y_0+1)*(1-ponder_x0)+...
            ima(x_0+2,y_0+1)*ponder_x0;
    end
end


