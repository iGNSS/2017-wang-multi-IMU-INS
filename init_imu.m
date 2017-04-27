function imu = init_imu(name,Acc,Gyr,w_dot,p,rot0,rotm)
    fprintf('   Initializing IMU: %s\n',name)
    % Create a structure containing IMU information
    imu = struct;
    imu.name = name; % name of IMU
    imu.gyro = Gyr'; % gyro reading
    imu.x0 = rot0*p; % starting coordinates in the global frame
    imu.p = p; % position coordinates on IMU in the foot frame
    imu.rotm = rotm; % relative rotation of IMU with respect to the foot frame
    
    n = size(Acc,1);
    imu.acc = zeros(3,n);
    for i = 1:n
        % Rotate to foot frame and Add additional lever arm acceration components to foot
        % acceleration
        imu.acc(:,i) = rotm'*(Acc(i,:)' + cross(w_dot(i,:)',p) + cross(Gyr(i,:)',cross(Gyr(i,:)',p)));
        % Rotate gyro readings from foot frame to IMU frame
        imu.gyro(:,i) = rotm'*imu.gyro(:,i);
    end
    