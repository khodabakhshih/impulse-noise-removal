function[eI]=gilexpand(I,hks)
[Ny,Nx]=size(I);
   if (hks>1)
      xL=mean(I(:,1:hks)')'; xR=mean(I(:,Nx-hks+1:Nx)')';
   else
      xL=I(:,1); xR=I(:,Nx);
   end
   eI=[xL*ones(1,hks) I xR*ones(1,hks)];
   if (hks>1)
      xU=mean(eI(1:hks,:)); xD=mean(eI(Ny-hks+1:Ny,:));  
   else
   	xU=eI(1,:); xD=eI(Ny,:);   
   end
	eI=[ones(hks,1)*xU; eI; ones(hks,1)*xD];