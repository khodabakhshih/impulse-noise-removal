function[ENI]=ENI(im,hw,th)
%NOTE: this function contains internal "gilexpand" funciton
% hw=2; half window size
% th=30;

im=double(im);
[m,n]=size(im);
[eI]=gilexpand(im,hw);% expanding the border of input image--expand Image
ENI=zeros(m,n);
for i=1+hw:m+hw
    for j=1+hw:n+hw
        
        for ii=-hw:hw
            for jj=-hw:hw
        h(ii+hw+1,jj+hw+1)=abs(eI(i-ii,j-jj)-eI(i,j));
        
        if h(ii+hw+1,jj+hw+1)<=th
        hh(ii+hw+1,jj+hw+1)=1;
        else
        hh(ii+hw+1,jj+hw+1)=0;    
        end
        
            end
        end
        hh(hw+1,hw+1)=0;
        ENI(i-hw,j-hw)=sum(sum(hh));
    end
end
               
        
        
