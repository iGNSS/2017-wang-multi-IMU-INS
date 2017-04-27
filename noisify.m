% This function take and IMU reading and adds noise to it
function imu_new = noisify(imu)
    
    global simdata;
    
    imu_new= imu; % create new IMU
    
    for k = 1:length(imu)
        fprintf('   Adding noise to IMU: %s\n',imu{k}.name);
        n = size(imu{k}.acc,2);
        
        % variables to save bias values
        imu_new{k}.acc_bias = zeros(3,n); 
        imu_new{k}.gyro_bias = zeros(3,n);

        % Terms for IMU bias
        bias_acc = simdata.sigma_initial_acc_bias;
        bias_gyro = simdata.sigma_initial_acc_bias;

        for i = 1:n
            % Add Guasssian noise and bias to each IMU
            imu_new{k}.acc(:,i) = imu{k}.acc(:,i) + simdata.sigma_acc.*randn(3,1) + bias_acc;
            imu_new{k}.gyro(:,i) = imu{k}.gyro(:,i) + simdata.sigma_gyro.*randn(3,1) + bias_gyro;
            
            % Save bias for reference
            imu_new{k}.acc_bias(:,i) = bias_acc;
            imu_new{k}.gyro_bias(:,i) = bias_gyro;
            
            % Random walk process 
            bias_acc = bias_acc + simdata.acc_bias_driving_noise.*randn(3,1)*simdata.Ts;
            bias_gyro = bias_gyro + simdata.gyro_bias_driving_noise.*randn(3,1)*simdata.Ts;
        end
    end

   