clear all;
I=imread('lena.jpg');
I=rgb2gray(I);
hi = imhist(I);
plot(hi);

%һά��ɢ���ұ任
N=256;
ft=size(hi);

Cu=1.0;
for u=1:N
    if u==0
          Cu=1.0/sqrt(2);
    end 
    sum=0;
    for x=1:N
        sum=sum + hi(x)*cos((2*x+1)*u*pi/(2*N));
    end    
    temp=Cu * sqrt(2.0/N)*sum;
    ft(u)=temp;
end

ft=int16(ft);
figure,plot(ft);

%Ƶ���˲� 
for u=1:N
     if u>50
         ft(u)=0;
     end
end


new_hi=size(hi);
%����Ҷ���任
for x=1:N
    sum=0;
    if u==0
          Cu=1.0/sqrt(2);
    end 
    
    for u=1:N
        sum=sum + Cu*ft(u)*cos((2*x+1)*u*pi/(2*N));
    end 
    temp=sqrt(2.0/N)*sum;
    new_hi(x)=abs(temp);
end

new_hi=int16(new_hi);
figure,plot(new_hi);title('new hi');