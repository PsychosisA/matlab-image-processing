function L=count_rice()
I = imread('rice.png');
[width,height] = size(I);
J = edge(I,'canny');
%figure,imshow(J);
K = imfill(J,'holes');
%figure,imshow(K);
SE = strel('disk',3);%用于膨胀腐蚀及开闭运算等操作的结构元素对象
%对图像实现开运算，开运算一般能平滑图像的轮廓，消弱狭窄的部分，去掉细的突出。
L = imopen(K,SE);
figure,imshow(L);
L = uint16(L);%把L由logic类型转化为uint8类型---uint16
%flag可能大于255，不应该用uint8来存flag
for i = 1:height
    for j = 1:width
        if L(i,j) == 1
            L(i,j) = 255;%把白色像素点像素值赋值为255
        end
    end
end
MAXLABEL=999999;
find=zeros(MAXLABEL,1)-1;
flag=0;

%采用回溯法标记连通区域
%连通区域分割（4连通）
for i=1:height
    for j=1:width
        if L(i,j)==255
            if j-1>0  %对是否有左边像素进行判断
                temp_j=L(i,j-1);  %有，则保存其连通标记
            else
                temp_j=0;  %无，则保持其标记为零
            end
            if i-1>0  %对是否有上边像素进行判断
                temp_i=L(i-1,j);
            else
                temp_i=0;
            end
            
            if temp_j==0&&temp_i==0  %如果左边和上边都没有标记，那么为（i,j）做一个新标记
                flag=flag+1;
                L(i,j)=flag;
                find(flag)=0;
            elseif (temp_j~=0&&temp_i==0) || (temp_j==0&&temp_i~=0) %左边和上边其中一个有标记
                L(i,j)=temp_j+temp_i; %其中一个为零，所以将它们相加，减少一步判断语句，直接进行赋值
            elseif temp_j~=0&&temp_i~=0&&temp_j==temp_i %左边和上边都有标记，且标记相同
                L(i,j)=temp_j;
            elseif temp_j~=0&&temp_i~=0&&temp_j~=temp_i %左边和上边都有标记，但标记不同
                if temp_j<temp_i
                    L(i,j)=temp_j;
                    find(temp_i)=temp_j;
                else
                    L(i,j)=temp_i;
                    find(temp_j)=temp_i;
                end              
            end
        end
    end
end
flag

%给所有标记赋上其根节点的值
for i=1:height
    for j=1:width
        if L(i,j)~=0
            label=L(i,j);
            temp_find=find(L(i,j));
            while(temp_find~=0) %使用并查集找根节点
                label=temp_find;
                temp_find=find(temp_find); 
            end
            L(i,j)=label;
        end        
    end
end

%依次给连通区域标上序号
true_flag=0;
for index=1:flag+1
    if find(index)==0
        true_flag=true_flag+1;
        for i=1:height
            for j=1:width
                if L(i,j)==index
                    L(i,j)=true_flag;
                end
            end
        end
    end
end

L=uint8(L); 
end
