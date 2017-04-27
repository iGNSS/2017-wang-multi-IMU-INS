function fimu = pos_fusion(imu)    
% This function is the federated fusion method for multiple IMU
global simdata;

n = length(imu);

fimu = imu{1};
fimu.name = 'Federated';
fimu.p = [0 0 0];
fimu.x0 = [0 0 0];
fimu.acc_bias = simdata.acc_bias_driving_noise;
fimu.gyro_bias = simdata.gyro_bias_driving_noise;

pos = zeros(3,size(imu{1}.x_h,2));

% translate all estimated imu positions to the center of the foot frame
display('   Moving each estimated IMU position to origin of foot frame')
for i = 1:n
    for j = 1:size(imu{i}.x_h,2)
        % final pos = x_w - R_w,b * p_b
        pos(:,j) = pos(:,j) + imu{i}.x_h(1:3,j) - eul2rotm(imu{i}.x_h([6 5 4],j)')*imu{i}.p; 
    end
end

% average the n IMU readings
pos = pos./n;

fimu.x_h(1:3,:) = pos;
