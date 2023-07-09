function[Id,PSNR,mssim]=Wu(I,method,N,dt,hw,th,Iorig)
%Based on:
%[26]	J. Wu, and C. Tang, “PDE-Based Random-Valued Impulse Noise Removal
%Based on New Class of Controlling Functions”, IEEE Transactions on Image Processing., Vol. 20, No. 9, pp. 2428–2438, 2011

%NOTE: this function contains internal "ENI" and "gilexpand" funciton
% hw=2; half window size
% th=30;
%the higher the noise level(density) is, the larger hw is and the smaller th is
%The appropriate value of w is 2 or 3, and th  is somewhere between 10 and 35
%N=10 seems to be okey

I=double(I);
Iorig=double(Iorig);
I0=I;
[Ny,Nx]=size(I); 
NN=(2*hw+1)^2-1;

for i=1:N;   
	% calculate gradient in all directions (N,S,E,W)
	I_x = (I(:,[2:Nx Nx])-I(:,[1 1:Nx-1]))/2;
	I_y = (I([2:Ny Ny],:)-I([1 1:Ny-1],:))/2;
	I_xx = I(:,[2:Nx Nx])+I(:,[1 1:Nx-1])-2*I;
	I_yy = I([2:Ny Ny],:)+I([1 1:Ny-1],:)-2*I;

	% calculate diffusion coefficients in all directions according to method
    [eni]=ENI(I,hw,th);
	 C=0.5+0.5*cos(2*pi*eni/NN);
     C_x =(C(:,[2:Nx Nx])-C(:,[1 1:Nx-1]))/2;
	 C_y =(C([2:Ny Ny],:)-C([1 1:Ny-1],:))/2;
   % Next Image I
   if (method == 'nalv')
    %npm of the Exact Exact implementation of paper
    
    ep2=0.001;ny=Ny;nx=Nx;
    grad=(I_x.^2+I_y.^2).^0.5; 
    Dp = I([2:ny ny],[2:nx nx])+I([1 1:ny-1],[1 1:nx-1]);
	Dm = I([1 1:ny-1],[2:nx nx])+I([2:ny ny],[1 1:nx-1]);
	I_xy = (Dp-Dm)/4;
    
   % compute flow, Uncom later
   Num = I_xx.*I_y.^2-2*I_x.*I_y.*I_xy+I_yy.*I_x.^2;
   Den = ep2+I_x.^2+I_y.^2; 
   I=I+dt*(C.*(Num./Den));  %% evolve image by dt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
         
      PSNR(i)=10*log10(255*255*Ny*Nx/(sum(sum((I-Iorig).^2))));
      [mssim(i), ssim_map]=ssim(Iorig,real(I));

     elseif (method == 'nalP')%npm of the Exact Exact implementation of paper
    lam=0.25-0.25*cos(pi*eni/NN); 
%      lam=0.01;
    ep2=1;ny=Ny;nx=Nx;
    Dp = I([2:ny ny],[2:nx nx])+I([1 1:ny-1],[1 1:nx-1]);
	Dm = I([1 1:ny-1],[2:nx nx])+I([2:ny ny],[1 1:nx-1]);
	I_xy = (Dp-Dm)/4;
   % compute flow
   Num = I_xx.*(ep2+I_y.^2)-2*I_x.*I_y.*I_xy+I_yy.*(ep2+I_x.^2);
   Den = ep2+I_x.^2+I_y.^2; 
   I=I+dt*(C.*(Num./Den))+dt*lam.*(I0-I);  %% evolve image by dt
      
      PSNR(i)=10*log10(255*255*Ny*Nx/(sum(sum((I-Iorig).^2))));

   end
end; % for i

Id = I;



 