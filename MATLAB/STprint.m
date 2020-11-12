%% VARIOUS ASSIGNMENTS
clear;
clc;
%clf;
nlay=12;    % number of vertical layers
froglay=2;  % jump for vertical layers visualization
frogt=3;    % time jump for visualization
% background images
bg1=imread('F:\LT\baseLT.bmp');
bg2=imread('F:\LT\bingLT.bmp');

%% READ FILENAMES FROM PRTMET OUTPUT
% gridfiles of VELOCITIES components (U,V,W) from SNAPFILES
%       ordered name format needed: VX_LyyHzz where
%              X=component (U,V,W)
%              yy=layer (2 digits)
%              zz=timestep (2 digits)
% vector VEC files of horizontal WIND (for Surfer)
%       (wind speed and orientation N clockwise)
% gridfiles of TEMPERATURE calculated values from SNAPFILES
%       ordered name format needed: TM_LyyHzz where
%              yy=layer (2 digits)
%              zz=timestep (2 digits)
% gridfiles of MIXING HEIGHT from SNAPFILES
%       ordered name format needed: MH_LyyHzz where
%              yy=layer (2 digits)
%              zz=timestep (2 digits)
%   nb: non c'è bisogno dei diversi layer ma va meglio per fare snap.m
%   e per usare le stesse funzioni... si può togliere
%   fatto check dopo con
%   for layer=1:12 check1(layer)=isequal(MHdata{1,1},MHdata{layer,1}); end
%   for time=1:24 check2(time)=isequal(MHdata{1,1},MHdata{1,time}); end

cart='F:\LT\00\PRTMET\'; % data dir
filesV=dir(fullfile(cart,'V*'));   % list of vel snapfiles
listV={filesV.name}';   % names
filesD=dir(fullfile(cart,'*vec.csv')); % list of csv
listD={filesD.name}'; % names
filesT=dir(fullfile(cart,'TM*')); % list of temperature snapfiles
listT={filesT.name}'; % names
filesMH=dir(fullfile(cart,'MH*')); % list of temperature snapfiles
listMH={filesMH.name}'; % names


%% READ SNAPFILES DATA
sizeV=size(filesV,1)/3;
sizet=sizeV/nlay;   % timeperiods
% (preallocation for calc speed increasing?)
Udata=cell(nlay,sizet);
Vdata=cell(nlay,sizet);
Wdata=cell(nlay,sizet);
Tdata=cell(nlay,sizet);
MHdata=cell(nlay,sizet);
% data reading loop
% array: datafile={layer,timeperiod}
for layer=1:nlay
    for period=1:sizet
%         % test to be sure:
%         Utest{layer,period}=listV{(layer-1)*sizet+period};
%         Vtest{layer,period}=listV{sizeV+(layer-1)*sizet+period};
%         Wtest{layer,period}=listV{2*sizeV+(layer-1)*sizet+period};
        Ufile=fullfile(cart,listV{(layer-1)*sizet+period});
        Udata{layer,period}=gridfile(Ufile);
        Udata{layer,period}=flipud(Udata{layer,period});
        Vfile=fullfile(cart,listV{sizeV+(layer-1)*sizet+period});
        Vdata{layer,period}=gridfile(Vfile);
        Vdata{layer,period}=flipud(Vdata{layer,period});
        Wfile=fullfile(cart,listV{2*sizeV+(layer-1)*sizet+period});
        Wdata{layer,period}=gridfile(Wfile);
        Wdata{layer,period}=flipud(Wdata{layer,period});
        Tfile=fullfile(cart,listT{(layer-1)*sizet+period});
        Tdata{layer,period}=gridfile(Tfile);
        Tdata{layer,period}=flipud(Tdata{layer,period});
        MHfile=fullfile(cart,listMH{(layer-1)*sizet+period});
        MHdata{layer,period}=gridfile(MHfile);
        MHdata{layer,period}=flipud(MHdata{layer,period});
    end
end
MHdata=MHdata(1,:); %just first row because MH isn't layer-dependent

%% DEFINE COORDINATES
% there must be at least 1 vector file!
% (you can read parameters from the first rows of snapfiles instead)
sizeD=length(listD);
tper=sizeD/nlay;
f1=fullfile(cart,listD{1});
F1=first2(f1,2);
Xl=F1(:,1);
Yl=F1(:,2);
Xs=unique(Xl);
Ys=unique(Yl);
[x,y]=meshgrid(Xs,Ys);
Xmin=min(min(x)); Xmax=max(max(x));
Ymin=min(min(y)); Ymax=max(max(y));
% read z data
zlay=[0.,20.,50.,100.,150.,200.,250.,300.,400.,500.,600.,800.,1000.];
for layer=1:nlay zlayc(layer)=(zlay(layer)+zlay(layer+1))/2; end
Zfile=fullfile(cart,'qaterr.asc');
z=gridfile(Zfile);
z=flipud(z);
for layer=1:nlay zl{layer}=z+(zlay(layer)+zlay(layer+1))/2; end

%% VISUAL SIMPLIFICATION SETUP
% simlified matrix setup
frogx=5; % spatial step x dir
frogy=4; % spatial step y dir
startx=max(round((size(x,2)-floor(size(x,2)/frogx)*frogx)/2),1);
starty=max(round((size(x,1)-floor(size(x,1)/frogy)*frogy)/2),1);
xr=x(starty:frogy:size(x,1),startx:frogx:size(x,2)); % simplified x coord matrix
yr=y(starty:frogy:size(y,1),startx:frogx:size(y,2)); % simplified y coord matrix
% definizione subplot
m=round(sqrt(nlay/froglay)); n=nlay/froglay/m;
col=max(m,n); row=min(m,n);

%% READ VEC DATA (OPTIONAL)
numy=length(F1);    % vec data length
% (preallocation for calc speed increasing?)
WS=zeros(numy,sizeD);
D=zeros(numy,sizeD);
% data reading loop (maybe an array will be better...)
% matrix: data(layer,timeperiod)=XXX!!!
for i=1:sizeD
    f=fullfile(cart,listD{i});
    Fi=last2(f,2);
    WS(:,i)=Fi(:,2);
    D(:,i)=Fi(:,1);
end
% components calculation
D=-D;
Ucdata=-WS.*sind(D);
Vcdata=-WS.*cosd(D);

%% GENERAL DATA SAVING
save data.mat cart x y Udata Vdata Wdata Tdata MHdata Xl Yl D WS

%% VECTORS AND STREAM PLOT DIVERSI LIVELLI
fig(1)=figure('Name','Layers comparison');
fig(1).WindowStyle='docked';
fig(1).PaperOrientation='portrait';
fig(1).PaperUnits='normalized';
fig(1).PaperPosition=[.05 .05 .90 .90];
% printing loop
h=1;
for layer=1:froglay:nlay
    k=1;
    clf;
    for period=1:frogt:tper
        % set background
        if k==1
        img = bg1;
            imagesc([Xmin Xmax], [Ymin Ymax], flipud(img));
            set(gca,'ydir','normal'); hold on;
        end
        % wind components matrix definition and simplification
        u=Udata{layer,period};
        v=Vdata{layer,period};
        ur=u(starty:frogy:size(u,1),startx:frogx:size(u,2)); % simplified u matrix
        vr=v(starty:frogy:size(v,1),startx:frogx:size(v,2)); % simplified v matrix
        % quiver and slice printing
        P(k)=quiver(xr,yr,ur,vr,0.5,...
            'DisplayName',strcat(num2str(period-1)));
        P(k).LineWidth=1.5;
        Q=streamslice(xr,yr,ur,vr,'noarrows');
        set(Q,'LineWidth',.3,'Color',P(k).Color);
%         if k==1
%             wfr=sqrt(ur.^2+vr.^2);
%             R=contourf(x,y,wfr);
%         end
        hold on;
        title(strcat('Layer ',num2str(layer))); grid on;
        %axis([Xmin Xmax Ymin Ymax]);
        axis equal; axis tight;
        k=k+1;
    end
    leg1=legend(P(:),'Location','northoutside');
    legt1 = text(...
                'Parent', leg1.DecorationContainer, ...
                'String', 'Ore:', ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'bottom', ...
                'Position', [0.5, 1.05, 0], ...
                'Units', 'normalized');
    
    if h==1
    print('-dpsc','-r600','-painters','out.ps');
    else print('-append','-dpsc','-r600','-painters','out.ps');
    end
    %pause;
    h=h+1;
end
clear P;

%% VECTOR AND STREAM PLOT DIVERSI TEMPI
fig(2)=figure('Name','Timeperiods comparison');
fig(2).WindowStyle='docked';
fig(2).PaperOrientation='portrait';
fig(2).PaperUnits='normalized';
fig(2).PaperPosition=[.05 .05 .90 .90];
% printing loop
h=1;
for period=1:frogt:tper
    k=1;
    clf;
    for layer=1:froglay:nlay
        % set background
        if k==1
        img = bg1;
            imagesc([Xmin Xmax], [Ymin Ymax], flipud(img));
            set(gca,'ydir','normal'); hold on;
        end
        % wind components matrix definition and simplification
        u=Udata{layer,period};
        v=Vdata{layer,period};
        ur=u(starty:frogy:size(u,1),startx:frogx:size(u,2)); % simplified u matrix
        vr=v(starty:frogy:size(v,1),startx:frogx:size(v,2)); % simplified v matrix
        % quiver and slice printing
        name=char(strcat(num2str(layer),{': '},...
            num2str(zlayc(layer)),'m'));
        P(k)=quiver(xr,yr,ur,vr,0.5,...
            'DisplayName',name);
        P(k).LineWidth=2;
        Q=streamslice(xr,yr,ur,vr,'noarrows');
        set(Q,'LineWidth',.5,'Color',P(k).Color);
        hold on;
        title(strcat({'Ore '},num2str(period-1),':00')); grid on;
        %axis([Xmin Xmax Ymin Ymax]);
        axis equal; axis tight;
        k=k+1;
    end
    leg2=legend(P(:),'Location','northoutside');
    legt2 = text(...
                'Parent', leg2.DecorationContainer, ...
                'String', 'Layer:', ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'bottom', ...
                'Position', [0.5, 1.05, 0], ...
                'Units', 'normalized');
    %pause;
    print('-append','-dpsc','-r600','-painters','out.ps');
    h=h+1;
end
clear P;

%% 3D VECTOR PLOT DIVERSI TEMPI
fig(3)=figure('Name','3D vector field');
fig(3).WindowStyle='docked';
fig(3).PaperType='a3';
fig(3).PaperOrientation='landscape';
fig(3).PaperUnits='normalized';
fig(3).PaperPosition=[.05 .05 .90 .90];
% WindowAPI(fig(3),'maximize'); MATLABCENTRAL (don't work on my ws)
% printing loop
h=1;
for period=1:frogt:tper
    k=1;
    clf;
    for layer=1:froglay:nlay
        % dominio verticale (scala 1:1000 rispetto a x e y per enfatizzare)
        % xrm=xr*1000; % stessa scala
        % yrm=yr*1000; % stessa scala
        zz=zl{layer};
        zr=zz(starty:frogy:size(u,1),startx:frogx:size(u,2)); % simplified z matrix
        % wind components matrix definition and simplification
        u=Udata{layer,period};
        v=Vdata{layer,period};
        w=Wdata{layer,period};
        ur=u(starty:frogy:size(u,1),startx:frogx:size(u,2)); % simplified u matrix
        vr=v(starty:frogy:size(v,1),startx:frogx:size(v,2)); % simplified v matrix
        wr=w(starty:frogy:size(u,1),startx:frogx:size(u,2)); % simplified w matrix
        % quiver3
        name=char(strcat(num2str(layer),{': '},...
        num2str(zlayc(layer)),'m'));
        P(k)=quiver3(xr,yr,zr,ur,vr,wr,0.04,...
            'DisplayName',name);
        P(k).LineWidth=1.5;
        hold on;
        title(strcat({'Ore '},num2str(period-1),':00')); grid on;
        %axis equal;
        axis tight;
        view(-60,45);
        k=k+1;
    end
    axis([Xmin Xmax Ymin Ymax 0 1000]);
    % set background
    % imagesc([Xmin Xmax], [Ymin Ymax], flipud(bg2)); hold on;
    surf(x,y,z,flipud(bg2),...
        'FaceColor','texturemap',...
        'EdgeColor','none',...
        'CDataMapping','direct');
    % set mixing height surface
    mh=MHdata{period}+z;
    mesh(x,y,mh,...
       'EdgeColor',[1/2 1/2 1/2],'EdgeAlpha',.5,...
       'facecolor','none');
    % set legend
    leg3=legend(P(:),'Location','northeast');
    legt3 = text(...
                'Parent', leg3.DecorationContainer, ...
                'String', 'Layer:', ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'bottom', ...
                'Position', [0.5, 1.05, 0], ...
                'Units', 'normalized');
    %pause;
    print('-append','-dpsc','-r600','-opengl','out.ps');
    h=h+1;
end
clear P;

%% CONEPLOT DIVERSI TEMPI
% fig(4)=figure('Name','3D vector field');
% fig(4).WindowStyle='normal';
% fig(4).PaperOrientation='landscape';
% fig(4).PaperUnits='normalized';
% fig(4).PaperPosition=[.05 .05 .90 .90];
% % WindowAPI(fig(3),'maximize'); MATLABCENTRAL (don't work on my ws)
% % printing loop
% h=1;
% for period=1:frogt:tper
%     k=1;
%     clf;
%     for layer=1:froglay:nlay
%         % defining
%         % xrm=xr*1000;
%         % yrm=yr*1000;
%         zz=zl{layer};
%         zr=zz(starty:frogy:size(u,1),startx:frogx:size(u,2)); % simplified z matrix
%         % wind components matrix definition and simplification
%         u=Udata{layer,period};
%         v=Vdata{layer,period};
%         w=Wdata{layer,period};
%         ur=u(starty:frogy:size(u,1),startx:frogx:size(u,2)); % simplified u matrix
%         vr=v(starty:frogy:size(v,1),startx:frogx:size(v,2)); % simplified v matrix
%         wr=w(starty:frogy:size(u,1),startx:frogx:size(u,2)); % simplified w matrix
%         % coneplot
%         name=char(strcat(num2str(layer),{': '},...
%         num2str(zlayc(layer)),'m'));
%         P(k)=coneplot(xr,yr,zr,ur,vr,wr,'nointerp',...
%             'DisplayName',name);
%         P(k).LineWidth=1;
%         %Q=streamslice(xr,yr,ur,vr);
%         %set(Q,'LineWidth',.5,'Color',P(k).Color);
%         hold on;
%         title(strcat({'Ore '},num2str(period-1),':00')); grid on;
%         %axis([Xmin*1000 Xmax*1000 Ymin*1000 Ymax*1000 0 zlay(nlay+1)]);
%         %axis equal;
%         axis tight;
%         k=k+1;
%     end
%     % set background
%     img = bg2;
%     imagesc([Xmin Xmax], [Ymin Ymax], flipud(img));
%     set(gca,'ydir','normal'); hold on;
%     surf(x,y,z,img,...
%         'FaceColor','texturemap',...
%         'EdgeColor',[1/2 1/2 1/2],...
%         'CDataMapping','direct');
%     % set legend
%     leg3=legend(P(:),'Location','bestoutside');
%     legt3 = text(...
%                 'Parent', leg3.DecorationContainer, ...
%                 'String', 'Layer:', ...
%                 'HorizontalAlignment', 'center', ...
%                 'VerticalAlignment', 'bottom', ...
%                 'Position', [0.5, 1.05, 0], ...
%                 'Units', 'normalized');
% %     if h==1
% %         print('-dpsc','-r600','-painters','lay.ps');
% %     else print('-append','-dpsc','-r600','-painters','lay.ps');
% %     end
%     %pause;
%     print('-append','-dpsc','-r600','-opengl','out.ps');
%     h=h+1;
% end

%% WIND SPEED PLOT DIVERSI TEMPI
fig(5)=figure('Name','Wind Speed intensity');
fig(5).WindowStyle='docked';
fig(5).PaperOrientation='landscape';
fig(5).PaperType='a3';
fig(5).PaperUnits='normalized';
fig(5).PaperPosition=[.05 .05 .90 .90];
% printing loop
h=1;
for period=1:frogt:tper
    clf;
    k=1;
    for layer=1:froglay:nlay
        subplot(row,col,k)
        % wind speed contour plot
        u=Udata{layer,period};
        v=Vdata{layer,period};
        w=Wdata{layer,period};
        ws=sqrt(u.^2+v.^2+w.^2);
        contourf(x,y,ws,'LineStyle','none');
        colorbar
        grid on; axis equal; axis tight;
        hold on;
        % set background
        img=imagesc([Xmin Xmax], [Ymin Ymax], flipud(bg1));
        alpha(img,.5);
        % quiver plot
%         quiver(x,y,u,v,0.8,'LineWidth',.3);
        ur=u(starty:frogy:size(u,1),startx:frogx:size(u,2)); % simplified u matrix
        vr=v(starty:frogy:size(v,1),startx:frogx:size(v,2)); % simplified v matrix
        quiver(xr,yr,ur,vr,0.8,'LineWidth',.3,'Color','k');
        % set title
        name=char(strcat({'WIND SPEED - Layer '},num2str(layer),{': '},...
        num2str(zlayc(layer)),'m',...
        {' - Ore '},num2str(period-1),':00'));
        title(name);
        k=k+1;
    end
    print('-append','-dpsc','-r600','-opengl','out.ps');
    h=h+1;
end

%% TEMPERATURE PLOT DIVERSI TEMPI
fig(6)=figure('Name','Temperature');
fig(6).WindowStyle='docked';
fig(6).PaperOrientation='landscape';
fig(6).PaperType='a3';
fig(6).PaperUnits='normalized';
fig(6).PaperPosition=[.05 .05 .90 .90];
% printing loop
h=1;
for period=1:frogt:tper
    clf;
    k=1;
    for layer=1:froglay:nlay
        subplot(row,col,k)
        % celsius temperature contour plot
        T=Tdata{layer,period}-273.15;
        contourf(x,y,T,'LineStyle','none');
        colorbar
        grid on; axis equal; axis tight;
        hold on;
        % set background
        img=imagesc([Xmin Xmax], [Ymin Ymax], flipud(bg1));
        alpha(img,.4);
        % set title
        name=char(strcat({'TEMPERATURE - Layer '},num2str(layer),{': '},...
        num2str(zlayc(layer)),'m',...
        {' - Ore '},num2str(period-1),':00'));
        title(name);
        k=k+1;
    end
    print('-append','-dpsc','-r600','-opengl','out.ps');
    h=h+1;
end

%% CREATE AND OPEN PDF FILE
ps2pdf('psfile', 'out.ps', 'pdffile', 'out.pdf', 'gspapersize', 'a4')%,...
%    'gscommand','C:\Program Files (x86)\gs\gs9.16\bin\gswin32.exe')%...
%     'gsfontpath', 'C:\Program Files (x86)\gs\gs9.16\fonts', ...
%     'gslibpath', 'Program Files (x86)\gs\gs9.16\lib'));
%  FOUND IN MATLABCENTRAL AND MODIFIED
open out.pdf
