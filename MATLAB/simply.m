function [ur,vr,wr]=simply(Udata,Vdata,Wdata,frogx,frogy,layer,period)
u=Udata{layer,period};
v=Vdata{layer,period};
w=Wdata{layer,period};
ur=u(2:frogy:size(u,1),1:frogx:size(u,2)); % simplified u matrix
vr=v(2:frogy:size(v,1),1:frogx:size(v,2)); % simplified v matrix
wr=v(2:frogy:size(w,1),1:frogx:size(w,2)); % simplified w matrix