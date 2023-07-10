%%%Based on: Rafsanjani, Hossein Khodabakhshi, Hossein Noori, and Nasibe Naseri. "Diffusion based method for impulse noise removal using residual feedback."
%%Computers & Mathematics with Applications 107 (2022): 45-56.
clear all
close all
clc
tic

%%%%%%%%%%%%Start of Partameter Setting
hw=2;th=20;
N_pm=100;N_a=50;N_c=50;N_eni=15;
NoiseLevel=0.3;%Noise Level
%%%%%%%%%%%%End of Partameter Setting


I=imread('lena.gif');%original image
I=I(:,:,1);
I0 = ImpulseNoiser(I,NoiseLevel);%noisy input image
I=double(I);I0=double(I0);



%%%Finding the best number of iteration for initial run. In practice, we should find the best iteration using methods such as correlation.
[Jd_dumy1,PSNR_dumy,MSSIM_dumy]=Wu(I0,'nalv',N_eni,0.5,hw,th,I);
[PSNR_dumy_max,Initial_Iteration]=max(PSNR_dumy);

%%%Applying Wu filter
[Iwu,PSNRdumy,MSSIM_dumy]=Wu(I0,'nalv',Initial_Iteration,0.5,hw,th,I); %Eq(3)
PSNR1=PSNRdumy(end)

%%%calculating the residue of Wu filter
Ir=I0-Iwu; %Eq(5)

%%%Denoising the Wu residue
[Ird,PSNRdum2,MSSIMdum2]=Wu(Ir,'nalv',0.7*Initial_Iteration,0.5,hw,th*0.5,I0);%N,th --- %Eq(6)

%%%adding denoised residue to the output of Wu filter
Irdwu=Iwu+Ird; % %Eq(7)
PSNR2=10*log10(255*255*size(I0,1)*size(I0,2)/(sum(sum((double(Irdwu)-double(I)).^2))))

%%%running the Wu filter for one interation on the output of the previous step
[I1,PSNRdum2_2,MSSIMdum2_2]=Wu(Irdwu,'nalv',2,0.5,hw,th*0.5,I); %Eq(8)
PSNR2_2=PSNRdum2_2(end)

%%%%%%%%%%%%%%%%%Second Trick
Iad=abs(I0-I1);%%% calculating the absolute according to Fig. 5 --- %Eq(9)
q=reshape(Iad,[1,numel(I0)]);
qq=sort(q);
Tb=qq( round((1-NoiseLevel)*numel(I0)) ); %%% finding the threshold according to Eq(10)
indicator=zeros(size(Iad));
indicator(Iad<Tb)=1; %Eq(11)

%%%Final denoised image.
Iout=indicator.*I0+double( not(logical(indicator)) ).*I1; %Eq(14)
PSNR3=10*log10(255*255*512*512/(sum(sum((double(Iout)-double(I)).^2))))
[MSSIM3, ssim_map]=ssim(I,real(Iout));
toc%%%end of Run

imshow(I,[]),title('Original Image')
figure,imshow(I0,[]),title('Noisy Image')
figure,imshow(Iout,[]),title('Denoised Image')









