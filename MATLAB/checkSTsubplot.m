clear;
clc;
format shortG;
load data.mat;
load checkstations.mat;
load SURF.mat;
coord=[Xl Yl];
nlay=12;    % number of vertical layers
froglay=1;  % jump for vertical layers visualization
frogt=3;    % time jump for visualization


for i=1:length(CSx)
    xf=CSx(i);
    yf=CSy(i);
    tmpx=abs(Xl-xf); [idx idx]=min(tmpx); xn=Xl(idx);
    tmpy=abs(Yl-yf); [idy idy]=min(tmpy); yn=Yl(idy);
    idx=find(unique(x)==xn);
    idy=find(unique(y)==yn);
    idxCS(i)=idx; idyCS(i)=idy;
    CSxn(i)=xn; CSyn(i)=yn;
    
end
clear xf yf idx idy xn yn id i

structCS.Name=CSn;
structCS.realX=CSx;
structCS.realY=CSy;
structCS.vecIDx=idxCS';
structCS.vecIDy=idyCS';
structCS.nearX=CSxn';
structCS.nearY=CSyn';
tabCS=struct2table(structCS);
tabCS.Properties.RowNames = tabCS.Name;
tabCS.Name=[];
tabCS

% ciclo per dati stazioni SURF
% for i=1:24
%     SURFdata{i}=SURF(16*(i-1)+2:16*(i-1)+16,:);
% end

%% CHECKSTATIONS DISTANCE FROM SURFSTATIONS
fig=figure('Name','CHECKstat distance from SURFstat');
fig.WindowStyle='normal';
fig.PaperOrientation='landscape';
fig.PaperType='a3';
fig.PaperUnits='normalized';
fig.PaperPosition=[.02 .02 .98 .98];
for i=1:length(CSx)
    DELTAx{i}=SURFstat(:,2)-CSxn(i);
    DELTAy{i}=SURFstat(:,3)-CSyn(i);
    DELTA{i}=sqrt(DELTAx{i}.^2+DELTAy{i}.^2);
    subplot(2,3,i)
    % compass(u(j),v(j),'DisplayName',num2str(idSURF(j));
    comp=compass(DELTAx{i},DELTAy{i});
    colors = linspecer(8,'qualitative'); %colormap(jet(15));
    for j=1:length(comp)
        name=char(strcat(num2str(idSURF(j)),{': '},...
            num2str(round(DELTA{i}(j),1)),{'km'}));
        set(comp(j),'color',colors(mod(j-1,length(colors))+1,:));
        set(comp(j),'LineWidth',mean(DELTA{i})/DELTA{i}(j));
        set(comp(j),'DisplayName',name);
    end
    title(CSn{i});
    leg=legend(comp(:),'Location','bestoutside');
    set(leg,'FontSize',8);
end
    print('-dpsc','-r600','-opengl','wind.ps');
clear name comp i j fig leg ha

%% WIND COMPARISON

for period=15%:sizet
fig=figure('Name','WIND COMPARISON');
fig.WindowStyle='normal';
fig.PaperType='a2';
fig.PaperOrientation='landscape';
fig.PaperUnits='normalized';
fig.PaperPosition=[.01 .01 .99 .99];
ha=tight_subplot(3,4,[.01 .03],[.1 .01],[.01 .01]);
for layer=1:froglay:nlay/2
    subplot(3,2,layer)
    for i=1:length(CSx)
        U(i)=Udata{layer,period}(idyCS(i),idxCS(i));
        V(i)=Vdata{layer,period}(idyCS(i),idxCS(i));
        WS(i)=sqrt(U(i)^2+V(i)^2);
        % [ws d u v]
    end
    ws=SURF{period}(:,1);
    d=SURF{period}(:,2);
    u=ws.*(-sind(d));
    v=ws.*(-cosd(d));
    comp=compass([U';u],[V';v]);
    colors = linspecer(length(CSx)); % colormap(jet(length(CSx)));
    for i=1:length(CSx)
        name=char(strcat(CSn{i},{': '},...
            num2str(round(WS(i),2)),{'m/s'}));
        set(comp(i),'DisplayName',name);
        set(comp(i),'LineWidth',2);
        set(comp(i),'Color',colors(mod(i-1-length(CSx),length(colors))+1,:));
    end
    colors = linspecer(8,'qualitative'); % colormap(jet(15));
    for j=length(CSx)+1:length(comp)
        name=num2str(idSURF(j-length(CSx)));
        set(comp(j),'color',colors(mod(j-1-length(CSx),length(colors))+1,:));
        
        set(comp(j),'DisplayName',name);
    end
    title(num2str(layer));
    %title(CSn{i});
    leg=legend(comp(:),'Location','best');
    set(leg,'FontSize',8);
end
print('-append','-dpsc','-r600','-opengl','wind.ps')
end
%clear name comp i j fig leg

%% CREATE AND OPEN PDF FILE
ps2pdf('psfile', 'wind.ps', 'pdffile', 'wind.pdf')%, 'gspapersize', 'a4')%,...
%    'gscommand','C:\Program Files (x86)\gs\gs9.16\bin\gswin32.exe')%...
%     'gsfontpath', 'C:\Program Files (x86)\gs\gs9.16\fonts', ...
%     'gslibpath', 'Program Files (x86)\gs\gs9.16\lib'));
%  FOUND IN MATLABCENTRAL AND MODIFIED
open wind.pdf



