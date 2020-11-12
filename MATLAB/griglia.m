function [u,v] = griglia (U,V,sizex,sizey)
for i=1:sizey
    for j=1:sizex
        u(i,j)=U((i-1)*sizex+j);
        v(i,j)=V((i-1)*sizex+j);
    end
end
end

