function slidercb(layer)        
[ur,vr,wr]=simply(Udata,Vdata,Wdata,frogx,frogy,layer,period);
% quiver and slice printing
P=quiver(xr,yr,ur,vr,0.5,'DisplayName',num2str(period-1));
P.LineWidth=2;
Q=streamslice(xr,yr,ur,vr);
set(Q,'LineWidth',.5,'Color',P(k).Color);
hold on;
title(strcat('Layer ',num2str(layer))); grid on;
axis equal; axis tight;