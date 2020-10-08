clear;
cam = webcam();
dir = "/home/yongxiang/RBE3001_Matlab11/camera_calibration/Image";

for i = 1:20
    img = snapshot(cam);
    pause(3);
    imgName = dir+num2str(i)+".png";
    imwrite(img,imgName);
    disp("Photo "+num2str(i)+" done.")
end

clear cam;

disp("Done! Got "+num2str(i)+" images.")