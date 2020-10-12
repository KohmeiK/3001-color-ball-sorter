cam = Camera();

%outputs a transformation Matrix
cam.cam_pose = cam.getCameraPose();
randompoint = pointsToWorld(cam.params.Intrinsics, cam.cam_pose(1:3,1:3), cam.cam_pose(1:3,4), [100 100]);
basePose = cam.cam_pose * cam.check2base;

