clear;
clc;
clf;
layers=12;
tstep=3;
cart='F:\Universita\Idraulica Ambientale II\ST\00\MATLAB';
files=dir(fullfile(cart,'*.csv'));
lista={files.name}';
numx=size(lista,1);
tper=numx/layers;
f1=fullfile(cart,lista{1});
F1=first2(f1,2);
X=F1(:,1);
Y=F1(:,2);
xx=unique(X);
yy=unique(Y);
[x,y]=meshgrid(xx,yy);
Xmin=min(X); Xmax=max(X);
Ymin=min(Y); Ymax=max(Y);
numy=size(F1,1);
WS=zeros(numy,numx);
D=zeros(numy,numx);
for i=1:numx
    f=fullfile(cart,lista{i});
    Fi=last2(f,2);
    WS(:,i)=Fi(:,2);
    D(:,i)=Fi(:,1);
end
%
%Di=mod(-90-D,360)
D=-D;
U=-WS.*sind(D);
V=-WS.*cosd(D);

saltax=5;
saltay=5;
Ue=U(1:saltax:;
Ve=V;

%definizione subplot
m=round(sqrt(layers)); n=layers/m;
col=max(m,n); row=min(m,n);

% DIVERSI LIVELLI SU UN FOGLIO (subplot)
for i=1:layers
    k=1;
    for j=1:tstep:tper
        subplot(row,col,i)
        P(i,k)=quiver(X,Y,Ue(:,layers*(j-1)+i),Ve(:,layers*(j-1)+i),...
            'DisplayName',num2str(j-1));
        title(strcat('Liv. ',num2str(i))); grid on;
        axis([Xmin,Xmax,Ymin,Ymax]); axis equal; axis tight;
        hold on;
        k=k+1;
    end
    legend(P(i,:),'Location','best');
end

% % PLOT UNICO DIVERSI TEMPI CON PAUSA LIVELLI
% for i=1:layers
%     k=1;
%     clf;
%     for j=1:tstep:tper
%         P(i,k)=quiver(X,Y,Ue(:,layers*(j-1)+i),Ve(:,layers*(j-1)+i),...
%             'DisplayName',num2str(j-1));
%         title(strcat('Liv. ',num2str(i))); grid on;
%         axis([Xmin,Xmax,Ymin,Ymax]); axis equal; axis tight;
%         hold on;
%         k=k+1;
%     end
%     legend(P(i,:),'Location','best');
%     pause;
% end

% % PLOT UNICO DIVERSI LIVELLI CON PAUSA TEMPI
% k=1;
% for j=1:tstep:tper
%     clf;
%     img = imread('CTRN25st.bmp');
%     imagesc([Xmin Xmax], [Ymin Ymax], flipud(img));
%     set(gca,'ydir','normal'); hold on;
%     for i=1:layers
%         P(k,i)=quiver(X,Y,Ue(:,layers*(j-1)+i),Ve(:,layers*(j-1)+i),...
%             'DisplayName',num2str(i));
%         title(strcat('ore',' ',num2str(j-1))); grid on;
%         axis([Xmin,Xmax,Ymin,Ymax]); axis equal; axis tight;
%         hold on;
%     end
%     legend(P(k,:),'Location','best');
%     k=k+1;
%     pause;
% end

% % PLOT UNICO DIVERSI LIVELLI CON PAUSA TEMPI
% k=1;
% for j=1:tstep:tper
%     clf;
%     img = imread('CTRN25st.bmp');
%     imagesc([Xmin Xmax], [Ymin Ymax], flipud(img));
%     set(gca,'ydir','normal'); hold on;
%     for i=1:layers
%         [u,v]=griglia(Ue(:,layers*(j-1)+i),Ve(:,layers*(j-1)+i),...
%             size(xx,1),size(yy,1));
%         P(k,i)=quiver(x,y,u,v,1,'DisplayName',num2str(i));
%         sx = xx(3:3:size(xx,1));
%         sy = yy(3:3:size(yy,1));
%         startx = vertcat(sx,Xmin*ones(size(sy)),sx,Xmax*ones(size(sy)));
%         starty = vertcat(Ymin*ones(size(sx)),sy,Ymax*ones(size(sx)),sy);
%         if i==1
%             hl1=streamslice(x,y,u,v,'DisplayName',num2str(i));
%             set(hl1,'LineWidth',2,'Color','r');
%         end
%         if i==6
%             hl2=streamslice(x,y,u,v,'DisplayName',num2str(i));
%             set(hl2,'LineWidth',2,'Color','g');
%         end
%         if i==12
%             hl3=streamslice(x,y,u,v,'DisplayName',num2str(i));
%             set(hl3,'LineWidth',2,'Color','c');
%         end
% %         streamslice(x,y,u,v,startx,starty);
% %         z=zeros(size(x)); w=zeros(size(u));
% %         P(k,i)=coneplot(x,y,z,u,v,w,'quiver');
%         title(strcat('ore',' ',num2str(j-1))); grid on;
%         axis([Xmin,Xmax,Ymin,Ymax]); axis equal; axis tight;
%         hold on;
%     end
%     %legend(hl1,hl2,hl3,'Location','best');
%     k=k+1;
%     pause;
% end
