Starty=2008;
st_Jday=1; %204
st_h=1; %GMT  0
Endyear=2008;
end_Jday=366; %205
end_h=22;  %GMT  %0
rifUTC=0;
num_staz_lette=0;
tot=(366*24)-1;  %25

ga= 366; % tot giorni anno considerato

l=[1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 20 21 22 24 25 26 27 29 51 52 90 91 98]; %totale stazioni-la 13 è Trieste che occupa la posizione 12
conto=[0 0 0 0 0 1 0 1 0 1 1 1 1 0 0 0 1 1 0 0 0 0 0 0 0 1 0 0 0 0]; %1 se i dati della stazione sono da tenere 0 se i dati della stazione i vengono scartati

for z=1:30
    if conto(z)==1
       num_staz_lette=num_staz_lette+1;
    end
end 

num_staz_lette=num_staz_lette+6; 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    here is the input files from diffrent stations 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid= fopen('centraline_friuli.txt','r'); % 
A = fscanf(fid,'%f %f %f %f %f %f %f %f %f %f %f %f', [12 inf] ); 
A=A';
dd= size (A);
t=dd(1,1);

fid3=fopen('copertura_nuvTS08_1.txt','r'); 
CTs = fscanf(fid3,'%f %f %f %f %f %f', [6 inf] );
CTs = CTs';

fid4=fopen('cloud_cover_bilje3.txt','r'); 
CB = fscanf(fid4,'%f %f %f %f %f %f', [6 inf] );
CB = CB';

fid5=fopen('cloud_cover_portorose3.txt','r'); 
CP = fscanf(fid5,'%f %f %f %f %f %f', [6 inf] );
CP = CP';

fid6=fopen('centraline_SLO.txt','r');
Slov = fscanf(fid6,'%f %f %f %f %f %f %f %f %f %f %f', [11 inf] );
Slov = Slov';
dd1=size(Slov);
t1=dd1(1,1);

for i=1:t
    for j=1:12
        if A(i,j)==-99    %no data value Friuli
            A(i,j)=9999;  %no data value surf.dat
        end
    end
end

for i=1:t1
    for j=1:11
        if A(i,j)==-999    %no data value Slovenia
            A(i,j)=9999;  %no data value surf.dat
        end
    end
end

%****************************************************
% writing out puts in precip.txt and surf.txt files 
% ***************************************************
fid1=fopen('precip.txt','w');
fid2=fopen('surf.txt','w');
% ****************************************************
% here is the header strucure 
fprintf(fid1,'PRECIP.DAT      2.0               Header structure with coordinate parameters\n')
fprintf(fid2,'SURF.DAT        2.0               Header structure with coordinate parameters\n')
fprintf(fid1,' 1\n');
fprintf(fid2,' 1\n');
fprintf(fid1,' Prodotto da ignoti\n');
fprintf(fid2,' Prodotto da ignoti\n');
fprintf(fid1,'NONE\n');
fprintf(fid2,'NONE\n');
header1 =[Starty st_Jday st_h Endyear end_Jday end_h rifUTC num_staz_lette];
fprintf(fid1,'%6.0f%4.0f%4.0f%6.0f%4.0f%4.0f%5.0f%5.0f\n',header1);
fprintf(fid2,'%6.0f%4.0f%4.0f%6.0f%4.0f%4.0f%5.0f%5.0f\n',header1);
% ***************************************************

for z=1:30
    if conto(z)==1
       fprintf(fid1,'% 1.0f\n',(l(z)+30000));
       fprintf(fid2,'% 1.0f\n',(l(z)+30000));
    end
end

fprintf(fid1,'% 1.0f\n',(30243));
fprintf(fid2,'% 1.0f\n',(243+30000));
fprintf(fid1,'% 1.0f\n',(1132+30000));
fprintf(fid2,'% 1.0f\n',(1132+30000));
fprintf(fid1,'% 1.0f\n',(1396+30000));
fprintf(fid2,'% 1.0f\n',(1396+30000));
fprintf(fid1,'% 1.0f\n',(245+30000));
fprintf(fid2,'% 1.0f\n',(245+30000));
fprintf(fid1,'% 1.0f\n',(1168+30000));
fprintf(fid2,'% 1.0f\n',(1168+30000));
fprintf(fid1,'% 1.0f\n',(1047+30000));
fprintf(fid2,'% 1.0f\n',(1047+30000));


nrstaz = 24*ga; %numero righe per stazione


s=0;
i=1;
t=1;

f=[Starty st_Jday st_h]; 
g=st_Jday;
hh=st_h;
nodv=9999;
jk=1;

while t<tot   % se mettessi t<2 stamperebbe solo i dati della prima ora

f=[Starty g hh];
fprintf(fid1,'%4.0f%4.0f%4.0f',f)
fprintf(fid2,'%4.0f%4.0f%4.0f\n',f)
    for z=1:11                              % STAZIONI FRIULI
    if conto(z)==1
    fprintf(fid1,'%9.3f',A((z-1)*nrstaz+i,6));  % PRECIPITAZIONE .. nel file precip.dat
    fprintf(fid2,'%9.3f',A((z-1)*nrstaz+i,10));  % WIND SPEED (m/s)
    fprintf(fid2,'%9.3f',A((z-1)*nrstaz+i,9));  % WIND DIRECTION (degrees)
    fprintf(fid2,'%5.0f',nodv);     %CEILING HEIGHT (altezza nuvole)
    fprintf(fid2,'%5.0f',nodv);     % OPAQUE SKY COVER
    if A((z-1)*nrstaz+i,7)==9999
        fprintf(fid2,'%9.3f',9999);
    else
    fprintf(fid2,'%9.3f',(A((z-1)*nrstaz+i,7)+273.15));  % AIR TEMPERATURE (k)
    end
    fprintf(fid2,'%5.0f',A((z-1)*nrstaz+i,8));  %RELATIVE UMIDITY
    fprintf(fid2,'%9.3f',A((z-1)*nrstaz+i,11));  % PRESSURE (mb=hPa)
    if A((z-1)*nrstaz+i,6)==0   %tipo di precipitazione nel file surf dat
        fprintf(fid2,'%5.0f',0);  % no precipitation  (colonna opzionale)
    else
        if A((z-1)*nrstaz+i,7)==9999 || A((z-1)*nrstaz+i,6)==9999
            fprintf(fid2,'%5.0f',9999)
        end
        if A((z-1)*nrstaz+i,7)<0.5
            fprintf(fid2,'%5.0f',30); % 19-45 frozen precipitation
        else
            fprintf(fid2,'%5.0f',10); % 1-18 liquid precipitation
        end
    end
    fprintf(fid2,'\n');
    s=s+1;
    if s>9
          fprintf(fid1,'\n            ');
          s=0;
    end
    end
    end
    
    if conto(12)==1  %STAZIONE TRIESTE
    fprintf(fid1,'%9.3f',A(11*nrstaz+i,6));  % PRECIPITAZIONE .. nel file precip.dat
    fprintf(fid2,'%9.3f',A(11*nrstaz+i,10));  % WIND SPEED (m/s)
    fprintf(fid2,'%9.3f',A(11*nrstaz+i,9));  % WIND DIRECTION (degrees)
    if CP(i+1,5)==9999 || CTs(i+2,6)==9999   % i file di copertura partono da 0 quindi sono sfasati per questo i+1
        fprintf(fid2,'%5.0f',9999)
        fprintf(fid2,'%5.0f',9999)     
    else                               
    fprintf(fid2,'%5.0f',((CP(i+1,5))/(0.3048*100)));%CEILING HEIGHT (altezza nuvole)(da metri a hundred feet)  (PORTOROSE)
    fprintf(fid2,'%5.0f',((CTs(i+2,6))*10/8))    %OPAQUE SKY COVER ( in decimi (i dati in input sono in ottavi)  (COPERTURA TS)
    end
    if A((z-1)*nrstaz+i,7)==9999
        fprintf(fid2,'%9.3f',9999);
    else
    fprintf(fid2,'%9.3f',(A(11*nrstaz+i,7)+273.15));  % AIR TEMPERATURE (k)
    end
    fprintf(fid2,'%5.0f',A(11*nrstaz+i,8));  %RELATIVE UMIDITY
    fprintf(fid2,'%9.3f',A(11*nrstaz+i,11));  % PRESSURE (mb=hPa)
    if A(11*nrstaz+i,6)==0   %tipo di precipitazione nel file surf dat
        fprintf(fid2,'%5.0f',0);  % no precipitation  (colonna opzionale)
    else
        if A(11*nrstaz+i,7)==9999 || A(11*nrstaz+i,6)==9999
            fprintf(fid2,'%5.0f',9999)
        end

        if A(11*nrstaz+i,7)<0.5
            fprintf(fid2,'%5.0f',30); 
        else
            fprintf(fid2,'%5.0f',10); 
        end
    end
    fprintf(fid2,'\n');
    s=s+1;
    if s>9
          fprintf(fid1,'\n            ');
          s=0;
    end
    end
    
    for z=13:30                              % STAZIONI FRIULI
    if conto(z)==1
    fprintf(fid1,'%9.3f',A((z-1)*nrstaz+i,6));  % PRECIPITAZIONE .. nel file precip.dat
    fprintf(fid2,'%9.3f',A((z-1)*nrstaz+i,10));  % WIND SPEED (m/s)
    fprintf(fid2,'%9.3f',A((z-1)*nrstaz+i,9));  % WIND DIRECTION (degrees)
    fprintf(fid2,'%5.0f',nodv);     %CEILING HEIGHT (altezza nuvole)
    fprintf(fid2,'%5.0f',nodv);     % OPAQUE SKY COVER
    if A((z-1)*nrstaz+i,7)==9999
        fprintf(fid2,'%9.3f',9999);
    else
    fprintf(fid2,'%9.3f',(A((z-1)*nrstaz+i,7)+273.15));  % AIR TEMPERATURE (k)
    end
    fprintf(fid2,'%5.0f',A((z-1)*nrstaz+i,8));  %RELATIVE UMIDITY
    fprintf(fid2,'%9.3f',A((z-1)*nrstaz+i,11));  % PRESSURE (mb=hPa)
    if A((z-1)*nrstaz+i,6)==0   %tipo di precipitazione nel file surf dat
        fprintf(fid2,'%5.0f',0);  % no precipitation  (colonna opzionale)
    else
        if A((z-1)*nrstaz+i,7)==9999 || A((z-1)*nrstaz+i,6)==9999
            fprintf(fid2,'%5.0f',9999)
        end
        if A((z-1)*nrstaz+i,7)<0.5
            fprintf(fid2,'%5.0f',30); 
        else
            fprintf(fid2,'%5.0f',10); 
        end
    end
    fprintf(fid2,'\n');
    s=s+1;
    if s>9
          fprintf(fid1,'\n            ');
          s=0;
    end
    end
    end

i=i+1; %invece di mettere l'incremento alla fine lo metto prima dlle stazione slovene per tenere conto dello sfasamento dei tempi

    %NOVA GORIZA
    fprintf(fid1,'%9.3f',Slov(i,8));  % PRECIPITAZIONE .. nel file precip.dat
    fprintf(fid2,'%9.3f',Slov(i,11));  % WIND SPEED (m/s)
    fprintf(fid2,'%9.3f',Slov(i,10));  % WIND DIRECTION (degrees)
    fprintf(fid2,'%5.0f',nodv);     %CEILING HEIGHT (altezza nuvole)
    fprintf(fid2,'%5.0f',nodv);     % OPAQUE SKY COVER
    if Slov(i,6)==9999
        fprintf(fid2,'%9.3f',9999);
    else
    fprintf(fid2,'%9.3f',(Slov(i,6)+273.15));  % AIR TEMPERATURE (k)
    end
    fprintf(fid2,'%5.0f',Slov(i,7));  %RELATIVE UMIDITY
    fprintf(fid2,'%9.3f',Slov(i,9));  % PRESSURE (mb=hPa)
    if Slov(i,8)==0   %tipo di precipitazione nel file surf dat
        fprintf(fid2,'%5.0f',0);  % no precipitation  (colonna opzionale)
    else
        if Slov(i,8)==9999 || Slov(i,6)==9999
            fprintf(fid2,'%5.0f',9999)
        end
        if Slov(i,6)<0.5
            fprintf(fid2,'%5.0f',30); 
        else
            fprintf(fid2,'%5.0f',10); 
        end
    end
    fprintf(fid2,'\n');
    s=s+1;
    if s>9
          fprintf(fid1,'\n            ');
          s=0;
    end
 
    for z=3:4  %  KOPER - KOPER2
    fprintf(fid1,'%9.3f',Slov((z-1)*nrstaz+i,8));  % PRECIPITAZIONE .. nel file precip.dat
    fprintf(fid2,'%9.3f',Slov((z-1)*nrstaz+i,11));  % WIND SPEED (m/s)
    fprintf(fid2,'%9.3f',Slov((z-1)*nrstaz+i,10));  % WIND DIRECTION (degrees)
    if CP(i+1,5)==9999 || CP(i+1,6)==9999  % i+1 perchè i dati di copertura partono da 0
        fprintf(fid2,'%5.0f',9999)
        fprintf(fid2,'%5.0f',9999)    
      else
    fprintf(fid2,'%5.0f',((CP(i+1,5))/(0.3048*100)));%CEILING HEIGHT (altezza nuvole)(da metri a hundred feet)  (PORTOROSE)
    fprintf(fid2,'%5.0f',((CP(i+1,6))*10/8))  % OPAQUE SKY COVER
    end
    if Slov((z-1)*nrstaz+i,6)==9999
        fprintf(fid2,'%9.3f',9999);
    else
    fprintf(fid2,'%9.3f',(Slov((z-1)*nrstaz+i,6)+273.15));  % AIR TEMPERATURE (k)
    end
    fprintf(fid2,'%5.0f',Slov((z-1)*nrstaz+i,7));  %RELATIVE UMIDITY
    fprintf(fid2,'%9.3f',Slov((z-1)*nrstaz+i,9));  % PRESSURE (mb=hPa)
    if Slov((z-1)*nrstaz+i,8)==0   %tipo di precipitazione nel file surf dat
        fprintf(fid2,'%5.0f',0);  % no precipitation  (colonna opzionale)
    else
        if Slov((z-1)*nrstaz+i,8)==9999 || Slov((z-1)*nrstaz+i,6)==9999
            fprintf(fid2,'%5.0f',9999)
        end
        if Slov((z-1)*nrstaz+i,6)<0.5
            fprintf(fid2,'%5.0f',30); % 
        else
            fprintf(fid2,'%5.0f',10); % 
        end
    end
    fprintf(fid2,'\n');
    s=s+1;
    if s>9
          fprintf(fid1,'\n            ');
          s=0;
    end
    end
    
    
    % BILJE
    fprintf(fid1,'%9.3f',Slov(4*nrstaz+i,8));  % PRECIPITAZIONE .. nel file precip.dat
    fprintf(fid2,'%9.3f',Slov(4*nrstaz+i,11));  % WIND SPEED (m/s)
    fprintf(fid2,'%9.3f',Slov(4*nrstaz+i,10));  % WIND DIRECTION (degrees)
    if CB(i+1,5)==9999 || CB(i+1,6)==9999
        fprintf(fid2,'%5.0f',9999)
        fprintf(fid2,'%5.0f',9999)    
      else
    fprintf(fid2,'%5.0f',((CB(i+1,5))/(0.3048*100)));%CEILING HEIGHT (altezza nuvole)(da metri a hundred feet)  (PORTOROSE)
    fprintf(fid2,'%5.0f',((CB(i+1,6))*10/8))  % OPAQUE SKY COVER
    end
    if Slov(4*nrstaz+i,6)==9999
        fprintf(fid2,'%9.3f',9999);
    else
    fprintf(fid2,'%9.3f',(Slov(4*nrstaz+i,6)+273.15)); % AIR TEMPERATURE (k)
    end
    fprintf(fid2,'%5.0f',Slov(4*nrstaz+i,7));  %RELATIVE UMIDITY
    fprintf(fid2,'%9.3f',Slov(4*nrstaz+i,9));  % PRESSURE (mb=hPa)
    if Slov(4*nrstaz+i,8)==0   %tipo di precipitazione nel file surf dat
        fprintf(fid2,'%5.0f',0);  % no precipitation  (colonna opzionale)
    else
        if Slov(4*nrstaz+i,8)==9999 || Slov(4*nrstaz+i,6)==9999
            fprintf(fid2,'%5.0f',9999)
        end
        if Slov(4*nrstaz+i,6)<0.5
            fprintf(fid2,'%5.0f',30); % 1-18 liquid precipitation
        else
            fprintf(fid2,'%5.0f',10); % 19-45 frozen precipitazion
        end
    end
    fprintf(fid2,'\n');
    s=s+1;
    if s>9
          fprintf(fid1,'\n            ');
          s=0;
    end
      
    
    % SKOCJAN (2a)
    fprintf(fid1,'%9.3f',Slov(nrstaz+i,8));  % PRECIPITAZIONE .. nel file precip.dat
    fprintf(fid2,'%9.3f',Slov(nrstaz+i,11));  % WIND SPEED (m/s)
    fprintf(fid2,'%9.3f',Slov(nrstaz+i,10));  % WIND DIRECTION (degrees)
    fprintf(fid2,'%5.0f',nodv);     %CEILING HEIGHT (altezza nuvole)
    fprintf(fid2,'%5.0f',nodv);     % OPAQUE SKY COVER
    if Slov(nrstaz+i,6)==9999
        fprintf(fid2,'%9.3f',9999);
    else
    fprintf(fid2,'%9.3f',(Slov(nrstaz+i,6)+273.15)); % AIR TEMPERATURE (k)
    end
    fprintf(fid2,'%5.0f',Slov(nrstaz+i,7));  %RELATIVE UMIDITY
    fprintf(fid2,'%9.3f',Slov(nrstaz+i,9));  % PRESSURE (mb=hPa)
    if Slov(nrstaz+i,8)==0   %tipo di precipitazione nel file surf dat
        fprintf(fid2,'%5.0f',0);  % no precipitation  (colonna opzionale)
    else
        if Slov(nrstaz+i,8)==9999 || Slov(nrstaz+i,6)==9999
            fprintf(fid2,'%5.0f',9999)
        end
        if Slov(nrstaz+i,6)<0.5
            fprintf(fid2,'%5.0f',30);  
        else
            fprintf(fid2,'%5.0f',10); 
        end
    end
    fprintf(fid2,'\n');
    s=s+1;
    if s>9
          fprintf(fid1,'\n            ');
          s=0;
    end


    % PORTOROSE
    fprintf(fid1,'%9.3f',Slov(5*nrstaz+i,8));  % PRECIPITAZIONE .. nel file precip.dat
    fprintf(fid2,'%9.3f',Slov(5*nrstaz+i,11));  % WIND SPEED (m/s)
    fprintf(fid2,'%9.3f',Slov(5*nrstaz+i,10));  % WIND DIRECTION (degrees)
    if CP(i+1,5)==9999 || CP(i+1,6)==9999
        fprintf(fid2,'%5.0f',9999)
        fprintf(fid2,'%5.0f',9999)    
      else
    fprintf(fid2,'%5.0f',((CP(i+1,5))/(0.3048*100)));%CEILING HEIGHT (altezza nuvole)(da metri a hundred feet)  (PORTOROSE)
    fprintf(fid2,'%5.0f',((CP(i+1,6))*10/8))  % OPAQUE SKY COVER
    end
    if Slov(5*nrstaz+i,6)==9999
        fprintf(fid2,'%9.3f',9999);
    else
    fprintf(fid2,'%9.3f',(Slov(5*nrstaz+i,6)+273.15)); % AIR TEMPERATURE (k)
    end
    fprintf(fid2,'%5.0f',Slov(5*nrstaz+i,7));  %RELATIVE UMIDITY
    fprintf(fid2,'%9.3f',Slov(5*nrstaz+i,9));  % PRESSURE (mb=hPa)
    if Slov(5*nrstaz+i,8)==0   %tipo di precipitazione nel file surf dat
        fprintf(fid2,'%5.0f',0);  % no precipitation  (colonna opzionale)
    else
        if Slov(5*nrstaz+i,8)==9999 || Slov(5*nrstaz+i,6)==9999
            fprintf(fid2,'%5.0f',9999)
        end
        if Slov(5*nrstaz+i,6)<0.5
            fprintf(fid2,'%5.0f',30); % 1-18 liquid precipitation
        else
            fprintf(fid2,'%5.0f',10); % 19-45 frozen precipitazion
        end
    end
    fprintf(fid2,'\n');
    s=s+1;
    if s>9
          fprintf(fid1,'\n            ');
          s=0;
    end
      
    
%i=i+1;

if hh<23
    hh=hh+1;
else
    g=g+1;
    hh=0;
end
t=t+1;
fprintf(fid1,'\n');
s=0;
end


