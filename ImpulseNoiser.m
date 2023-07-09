function imnoisy =ImpulseNoiser(im,ND)
%                  Random-Valued Impulse noise
%% im is input image, ND is noise density, imnoisy is noisy image
%% Example: imnoisy = impulsenoise(im,0.4,0);
%% This code has been approve by H.Kh. Rafsanjani in Feb3, 2018.

Narr = rand(size(im));


    N = Narr;
    N(N>=ND)=0;
    N1 = N;
    N1 = N1(N1>0);%put the values greater than zero to the vector N1, so the output N1 is an vector.
    Imn=min(N1(:));
    Imx=max(N1(:));
    N=(((N-Imn).*(255-0))./(Imx-Imn));% bring the selected values by noise to the range of [0-255]; which has assumed an 8-bit image.
    im(Narr<ND) = N(Narr<ND);
    imnoisy=im;

