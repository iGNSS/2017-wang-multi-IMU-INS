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

function imu_new = openShoe_INS(imu)
    fprintf('   Preforming ZUPT INS on IMU: %s\n',imu.name);
    imu_new = imu;

    %% Loads the algorithm settings and the IMU data
    disp('      Loading IMU data into OpenShoe')
    u = [imu.rotm*imu.acc ; imu.rotm*imu.gyro];

    %% Run the zero-velocity detector
    disp('      Running the zero velocity detector')
    [imu_new.zupt, imu_new.T]=zero_velocity_detector(u);


    %% Run the Kalman filter
    disp('      Running the filter')
    [imu_new.x_h, imu_new.cov]=ZUPTaidedINS(u,imu_new.zupt,imu_new.x0);
    
     % But into upright frame (switch z pointing down to z pointing up)
    imu_new.x_h([2 3 5 6 8 9],:) = -imu_new.x_h([2 3 5 6 8 9],:); 
    
    
    %% Print the horizontal error and spherical error at the end of the
    %% trajectory
    fprintf('      Horizontal error = %0.5g , Spherical error = %0.5g\n',sqrt(sum((imu_new.x_h(1:2,end)).^2)), sqrt(sum((imu_new.x_h(1:3,end)).^2)))


    %% View the result
    %disp('Views the data')
    %view_data;

