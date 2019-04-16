clear all;
clc;
a = imaqhwinfo;
vid = videoinput('winvideo',1);
set(vid,'FramesPerTrigger',Inf);
set(vid,'ReturnedColorspace','rgb');
vid.FrameGrabInterval= 5;
start(vid);
while(vid.FramesAcquired<=50)
    data = getsnapshot(vid);
    diff_im=imsubtract(data(:,:,1),rgb2gray(data));
    diff_im=medfilt2(diff_im,[3 3]);
    diff_im=imbinarize(diff_im,0.18);
    diff_im=bwareaopen(diff_im,300);
    bw=bwlabel(diff_im,8);
    stats=regionprops(bw, 'BoundingBox', 'Centroid');
    imshow(data)
    hold on
    for object= 1:length(stats)
        bb=stats(object).BoundingBox;
        bc=stats(object).Centroid;
        rectangle('position',bb,'EdgeColor','r','LineWidth',2)
        plot(bc(1),bc(2),'-m+');
        a=text(bc(1)+15,bc(2),strcat('X: ',num2str(round(bc(1))),'  Y: ', num2str(round(bc(2)))));
        set(a, 'fontname', 'Arial', 'Fontweight', 'bold','Fontsize', 12,'color','yellow');
        disp('forward')
    end
hold off
end
stop(vid);
flushdata(vid);
sprintf('%s','that was all about image an it is definitely going over my head')