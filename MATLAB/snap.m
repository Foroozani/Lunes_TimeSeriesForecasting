k=0;
for j=0:23
    for i=1:12
        fprintf('! FILESNAP = VU_L%02iH%02i  ! \n',i,j);
        fprintf('! UVEL     =   %i,     %i   !  !END! \n',i,j+1);
        fprintf('! FILESNAP = VV_L%02iH%02i  ! \n',i,j);
        fprintf('! VVEL     =   %i,     %i   !  !END! \n',i,j+1);
        fprintf('! FILESNAP = VW_L%02iH%02i  ! \n',i,j);
        fprintf('! WVEL     =   %i,     %i   !  !END! \n',i,j+1);
        fprintf('! FILESNAP = TM_L%02iH%02i  ! \n',i,j);
        fprintf('! TEMP     =   %i,     %i   !  !END! \n',i,j+1);
        fprintf('! FILESNAP = MH_L%02iH%02i  ! \n',i,j);
        fprintf('! MIXH     =   %i,     %i   !  !END! \n',i,j+1);
        k=k+1;
    end
end
k*5