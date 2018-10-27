function B=my_boundaries_2(image)
I = imread(image);%读入图像

BW = im2bw(I, graythresh(I));%转换成2进制图像
%[B,L] = bwboundaries(BW,'noholes');%寻找边缘，不包括孔
%目前假设前景为白色，背景为黑色

[h,w]=size(BW);
bw_tag=bwlabel(BW); %用连通区域来辅助标记
%如果该图形已经被边界跟踪处理了，那么将该图形在bw_tag对应的区域全部置0

%B=cell()
%搜索元胞数组的添加方法a=[1 2 2]; B=[B a]
B=cell(0,1);
%方向为顺时针，左方（west）为1
%          1      2      3      4     5     6      7     8 
direction=[-1  -1; 0, -1; 1  -1; 1  0; 1  1; 0  1; -1  1; -1  0];

%起始记录：起始点，以及起点下一个边界点（当循环到同一个起始点且下一个边界点相同时，此边界跟踪完成）
flag=[];
judge_flag=[];

for i=1:h
    for j=1:w
        if bw_tag(i,j)>=1           
            flag=[i j -100 -100];
            brush_tag=bw_tag(i,j);
            start_point = 1;%起始搜索方向                      
            point_set=[i, j;];%用来存放坐标点
            judge_flag=[-100 -100 -100 -100];
            get_point = 0 ;%是否获取到起始点后的下一个边界点       
            center_x = i;
            center_y = j;
       
            while(~isequal(flag, judge_flag))    
                k=start_point;
                is_noise = 0;  %用来判断一个点是否是孤立的一个像素点
                while(1)                       
                    %(x,y)为周围的相邻像素坐标
                    x = center_x + direction(k,1);
                    y = center_y + direction(k,2);
                    %判断坐标是否越界
                    if x >0  && x <= h && y > 0 && y <= w
                        if bw_tag(x , y )==brush_tag %找到下一个边界点
                            center_x=x;
                            center_y=y;
                            point_set=[point_set; [x,y]]; 
                            judge_flag=[i j x y];
                            if get_point == 0 %确定起始点及其方向
                                flag(3)=x;
                                flag(4)=y;
                                get_point = 1;
                                judge_flag=[];
                            end              
                            break;%已经找到边界点，跳出点周围搜索，进行下一点的边界点搜索
                        else 
                            is_noise=is_noise+1;
                        end
                    else
                        is_noise=is_noise+1;
                    end
                    k=mod( k, 8)+1;
                    
                    if is_noise==9 %搜索了完整的一周都没有遇到相邻的像素点，所以这个点是一个孤立的像素点，于是选择跳过
                        break;
                    end
                end      
                
                
                if is_noise==9
                    break;
                end
                %下一个边界点的搜索方向
                start_point=mod((k+4), 8) + 1;
            end
            
            B=[B point_set];
            
            bw_tag=bw_tag-(bw_tag==brush_tag)*brush_tag;      
        end
    end
end

imshow(label2rgb(BW, @jet, [.5 .5 .5]))%显示图像
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end%整个循环表示的是描边
end
