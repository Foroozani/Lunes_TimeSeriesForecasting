clear;
clc;
format shortG;
load data.mat;
load checkstations.mat;
load SURF.mat;
coord=[Xl Yl];
nlay=12;

for i=1:length(CSx)
    xf=CSx(i);
    yf=CSy(i);
    tmpx=abs(Xl-xf); [idx idx]=min(tmpx); xn=Xl(idx);
    tmpy=abs(Yl-yf); [idy idy]=min(tmpy); yn=Yl(idy);
    id=find(coord(:,1)==xn & coord(:,2)==yn);
    idCS(i,1)=id;
    CSxn(i,1)=xn; CSyn(i,1)=yn;
    
end
% clear xf yf idx idy xn yn id i

structCS.Name=CSn;
structCS.realX=CSx;
structCS.realY=CSy;
structCS.vecID=idCS;
structCS.nearX=CSxn;
structCS.nearY=CSyn;
tabCS=struct2table(structCS);
tabCS.Properties.RowNames = tabCS.Name;
tabCS.Name=[];
tabCS

% ciclo per dati stazioni SURF
% for i=1:24
%     SURFdata{i}=SURF(16*(i-1)+2:16*(i-1)+16,:);
% end

fig=figure('Name','Checkstat distance from SURFstat');
fig.WindowStyle='normal';
fig.PaperOrientation='landscape';
fig.PaperUnits='normalized';
fig.PaperPosition=[.05 .05 .90 .90];
for i=1:length(CSx)
    DELTAx{i}=SURFstat(:,2)-CSxn(i);
    DELTAy{i}=SURFstat(:,3)-CSyn(i);
    DELTA{i}=sqrt(DELTAx{i}.^2+DELTAy{i}.^2);
    subplot(2,3,i)
    % compass(u(j),v(j),'DisplayName',num2str(idSURF(j));
    comp=compass(DELTAx{i},DELTAy{i});
    colors = colormap(jet(15));
    for j=1:length(comp)
        name=char(strcat(num2str(idSURF(j)),{': '},...
            num2str(round(DELTA{i}(j),1)),{'km'}));
        set(comp(j),'color',colors(mod(j-1,length(colors))+1,:));
        set(comp(j),'LineWidth',mean(DELTA{i})/DELTA{i}(j));
        set(comp(j),'DisplayName',name);
    end
    title(CSn{i});
    legend(comp(:),'Location','bestoutside');
end
% clear name comp i j fig

for period=1%:24
for i=1%:length(CSx)
for layer=1%:nlay
    %id=idCS(i);
    ws=WSdata{layer,period}(1:50)%(idCS(i));
    d=DdataNcw{layer,period}(idCS(i));
    u=-ws.*sind(d)
    v=-ws.*cos(d)
    
    
end
end
end



