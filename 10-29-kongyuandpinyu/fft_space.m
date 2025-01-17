I=imread('lena.jpg');
I=rgb2gray(I);
figure,
subplot(1,2,1),imshow(I),title('原始灰度图像');

f=double(I);
F=fft2(f);
S=fftshift( log(1+abs(F)) );
subplot(1,2,2),imshow(S,[]),title('该图像的傅里叶谱');

h=fspecial('sobel');
%PQ=paddedsize(size(f));
PQ = 2*size(f);
H=freqz2(h,PQ(1),PQ(2));
H1=ifftshift(H);
figure,
subplot(1,2,1),imshow(abs(H),[]),title('相应于垂直Sobel空间滤波器的频率域滤波器的绝对值');
subplot(1,2,2),imshow(abs(H1),[]),title('经函数ifftshift处理后的同一滤波器');

gs=imfilter(f,h);
gf=dftfilt(f,H1);
figure,
subplot(2,2,1),imshow(gs,[]),title('用垂直Sobel模板在空间域对原始图像滤波的结果');
subplot(2,2,2),imshow(gf,[]),title('用H1滤波器在频率域中得到的结果');

subplot(2,2,3),imshow(abs(gs) ,[]),title('用垂直Sobel模板在空间域对原始图像滤波的结果的绝对值 ');
subplot(2,2,4),imshow( abs(gf) ,[]),title('用H1滤波器在频率域中得到的结果的绝对值');

figure,
subplot(1,2,1),imshow( abs(gs) > 0.2*abs(max(gs(:))) ),title('空域滤波阈值处理后的结果');
subplot(1,2,2),imshow( abs(gf) > 0.2*abs(max(gf(:))) ),title('频域滤波阈值处理后的结果');

d=abs(gs-gf);
max(d(:))
min(d(:))
