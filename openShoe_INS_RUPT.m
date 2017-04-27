%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%>
%> @file Main.m
%>                                                                           
%> @brief This is the skeleton file for processing data from a foot mounted
%> IMU. The data is processed using a Kalman filter based zero-velocity 
%> aided inertial navigation system algorithm.
%> 
%> @details This is the skeleton file for processing data data from a foot
%> mounted inertial measurement unit (IMU). The data is processed using a 
%> Kalman filter based zero-velocity aided inertial navigation system. The
%> processing is done in the following order. 
%> 
%> \li The IMU data and the settings controlling the Kalman filter is loaded.
%> \li The zero-velocity detector process all the IMU data.
%> \li The filter algorithm is processed.
%> \li The in data and results of the processing is plotted.
%>
%> @authors Isaac Skog, John-Olof Nilsson
%> @copyright Copyright (c) 2011 OpenShoe, ISC License (open source)
%>
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [imu_new,imu] = openShoe_INS_RUPT(imu)
    global simdata;
    n = length(imu);
    
    imu_new = struct; 
    imu_new.name = 'Central';
    imu_new.x0 = [0 0 0]';
    imu_new.p = [0 0 0]';
    imu_new.acc = imu{1}.acc;
    imu_new.gyro = imu{1}.gyro;
    imu_new.rotm = eye(3);
    imu_new.zupt = imu{1}.zupt;
    imu_new.acc_bias = simdata.acc_bias_driving_noise;
    imu_new.gyro_bias = simdata.gyro_bias_driving_noise;

    u = cell(n,1);
    for i = 1:n
        %% Loads the algorithm settings and the IMU data
        disp('      Loading IMU data into OpenShoe')
        u{i} = [imu{i}.rotm*imu{i}.acc ; imu{i}.rotm*imu{i}.gyro];
    end

    %% Run the Kalman filter
    disp('      Running the filter')
    [x_h, imu_new.cov] = ZUPTaidedINS_RUPT(u,imu);
    
    disp('      Combine All Readings')
    imu_new.x_h = zeros(size(x_h{1},1),size(x_h{1},2));
    for i = 1:n
        for j = 1:size(x_h{1},2)
            % final foot pos = x_w - R_w,b * p_b
            imu_new.x_h(1:3,j) = imu_new.x_h(1:3,j) + x_h{i}(1:3,j) - eul2rotm(x_h{i}([6 5 4],j)')*imu{i}.p; 
            imu_new.x_h(4:end,j) = imu_new.x_h(4:end,j) + x_h{i}(4:end,j);
        end
        imu{i}.x_h = x_h{i};
        imu{i}.x_h([2 3 5 6 8 9],:) = -imu{i}.x_h([2 3 5 6 8 9],:); 
    end

    % average the n IMU readings
    imu_new.x_h= imu_new.x_h./n;
    
     % But into upright frame (switch z pointing down to z pointing up)
    imu_new.x_h([2 3 5 6 8 9],:) = -imu_new.x_h([2 3 5 6 8 9],:); 
    
    
    %% Print the horizontal error and spherical error at the end of the
    %% trajectory
    fprintf('      Horizontal error = %0.5g , Spherical error = %0.5g\n',sqrt(sum((imu_new.x_h(1:2,end)).^2)), sqrt(sum((imu_new.x_h(1:3,end)).^2)))


    %% View the result
    %disp('Views the data')
    %view_data;

