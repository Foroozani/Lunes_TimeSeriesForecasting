Sy = 2008; % starting year of data in the file ;
v=08; % due cifre per l'anno
mese=01; % mese di inizio delle osservazioni 
g=01; % giorno di inizio delle osservazioni
Sj = 01;  % starting julian day of data in the file;
Sh = 0;  % starting hour (GMT) of data in the file;
Ey = 2008; % ending year of data in the file ;
Ej = 366;  % ending julian day of data in the file;
Eh = 12; % ending hour (GMT) of data in the file;
topp = 500 ; % top pressure level of data in the file
datatype = 1; % original file data (1 or 2)
delimit = 1; % delimiter used (1=/ 2= , )
Id = 16044; %Id stazione
nodatav=9999;  %valore da inserire del nodata nel file di ingresso


fid2= fopen('campoform.txt','r'); % file upper air arpa con solo dati senza testo iniziale estratto da rds_newx.txt
A = fscanf(fid2,'%f %f %f %f %f %f %f %f %f %f %f ', [11 inf] ); 
dd= size (A);
A=A';
t=dd(1,2);
t1=t/40;
A(:,3)= A(:,3)+273.15; %conversione temperatura da Celsius a Kelvin
A(:,8)= A(:,8)*0.514444; %conversione velocità del vento da nodi a m/s 1852/3600

            
fid = fopen ('up.txt','w') %apertura fle in scrittuta
z= [Sy Sj Sh Ey Ej Eh topp datatype delimit];
fprintf(fid,'UP.DAT          2.0             Header structure with coordinate parameters\n');
fprintf(fid,'   1\n');
fprintf(fid,'Produced by \n');
fprintf(fid,'NONE\n');
fprintf(fid,'%6.0f   %02.0f   %02.0f%5.0f %4.0f   %2.0f%#5.0f%5.0f%5.0f \n',z) % formattazione dati
fprintf(fid,'     F'); % sounding level eliminated if height missing? (T=yes, F=no) 
fprintf(fid,'    F'); % sounding level eliminated if temperature missing? (T=yes, F=no)
fprintf(fid,'    F'); % sounding level eliminated if wind direction missing? (T=yes, F=no)
fprintf(fid,'    F\n'); % sounding level eliminated if wind speed missing? (T=yes, F=no)

i=1;
z1=1;
z2=4;
n=0;
s=0;
hh=Sh;


while i<dd(1,2)

xx=0
    while (A(i,2)<10000)&& (s<40)
        i=i+1;
        cont=i;
        s=s+1;
    end
t=cont-(z1);
    f= [9999 Id v mese g hh 40 t];
fprintf(fid,'   %d     %d     %02.0f%02.0f%02.0f%02.0f     %d                               %d\n',f);
     
while (z1<cont) 
    
for i=z1:z2

    if i<cont
        if A(i,1)==nodatav
            A(i,1)=-99.9;
        end
        if A(i,2)==nodatav
            A(i,2)=9999;
        end
        if A(i,3)==nodatav
            A(i,3)=999.9;
        end
        if A(i,7)==nodatav
            A(i,7)=999;
        end
        if A(i,8)==nodatav
            A(i,8)=999;
        end 
fprintf(fid,'%9.1f/', A(i,1)); %pressure mb cioè millibar=hPa
fprintf(fid,'%#5.0f/', A(i,2)); %height
fprintf(fid,'%4.1f/', A(i,3));   %temperature K
fprintf(fid,'%3.0f/', A(i,7));    % wind direction
fprintf(fid,'%3.0f', A(i,8));    %wind speed m/s
    end

end
fprintf(fid,'\n');
z1=z2+1;
z2=z2+4;
end

n=n+1;

i=40*n+1;
z1=40*n+1;
z2=z1+3;
s=0;
if hh==0
    hh=12;
else
    hh=00;
    if mese==11 || mese==4 || mese==6 || mese==9 
       if g<30
       g=g+1;
       else
        mese=mese+1;
        g=1;
        xx=1;
       end
    end
       if mese==2 
       if g<29
       g=g+1;
       else
        mese=mese+1;
        g=1;
        xx=2;
       end
        if xx==1
            g=g-1;
        end
     end
    
if mese==1 || mese==3 || mese==5 || mese==7 ||  mese==8 ||  mese==10 || mese==12 
       if g<31
      g=g+1;
       else
       mese=mese+1;
        g=1;
       end
      if xx==1 || xx==2
            g=g-1;
        end
    end


end
end

