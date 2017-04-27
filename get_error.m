function imu_new = get_error(imu,Pos)
    display(['   Calculating error for ' imu.name]);
    imu_new = imu;
    
    l = size(imu.x_h,2);
    imu_new.error = zeros(4,l);
    
    % Calculate error for each axis
    imu_new.error(1:3,:) = imu.x_h(1:3,:) - Pos';
    
    % Calculate total error
    imu_new.error(4,:) = sqrt(imu_new.error(1,:).^2 + imu_new.error(2,:).^2 + imu_new.error(3,:).^2);