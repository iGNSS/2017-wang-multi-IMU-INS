function vimu = acc_fusion(imu)    
% This function projects the acceleration onto a single frame and produces a
% virtual IMU

global simdata;

n = length(imu);
l = size(imu{1}.acc,2);

% Check for multiple IMU
if n <= 1
    display('error: Multiple IMU fusion requires 2 or more IMUs')
    return
end

% initialize new IMU
vimu = struct; 
vimu.name = 'VIMU';
vimu.x0 = [0 0 0]'; % starting position
vimu.p = [0 0 0]'; % IMU placement vector (on the foot  frame)
vimu.acc = zeros(3,l);
vimu.gyro = zeros(3,l);
vimu.rotm = eye(3);
vimu.acc_bias = simdata.acc_bias_driving_noise;
vimu.gyro_bias = simdata.gyro_bias_driving_noise;

for i = 1:n
    display(['   Incorporation IMU: ' imu{i}.name]);
    omega_dot = bdiff(imu{i}.gyro,simdata.Ts); % 1st order backwards finite differentiation is used
    rotm = imu{i}.rotm;
    for j = 1:l
        vimu.gyro(:,j) = vimu.gyro(:,j) + rotm*imu{i}.gyro(:,j)./n; % average all gyro readings
        acci = imu{i}.acc(:,j);
        omegai = imu{i}.gyro(:,j);
        p = rotm'*imu{i}.p; % IMU placement expressed in the IMU frame
        vimu.acc(:,j) = vimu.acc(:,j) + rotm*(acci - cross(omega_dot(:,j),p) - cross(omegai,cross(omegai,p)))./n; % average all accelerations (accounting lever arm effect)
    end
end