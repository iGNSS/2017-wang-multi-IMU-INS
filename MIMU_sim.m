
clear all
clc

%% Parameters

% Simulated data set (uncomment the data set to be used)
data_path = 'sim_data/straight walk, 1000 steps.mat';
%data_path = 'sim_data/Closed trajectory, 1 loop.mat';
%data_path = 'sim_data/Closed trajectory, 10 loops.mat';

load(data_path)
display('Simulated data loaded')

global simdata % variable to store everything

% Go to settings.m to change the OpenShoe detector parameters 
% IMU noise characteristics also defined here
settings;

% Positions of IMU in body frame (assume no rotation)

%---- edit here to add more IMUs ----

config = '4a'; % Configuration name

%IMU 1
p_imu1 = [0.01 0.01 0]'; % Position vector of IMU origin expressed in the foot frame
rot_imu1 = eul2rotm([0 0 0]); %Rotation Matrix of IMU with respect to the foot frame

%IMU 2
p_imu2 = [-0.01 0.01 0]';
rot_imu2 = eul2rotm([0 0 0]); 

%IMU 3
p_imu3 = [-0.01 -0.01 0]';
rot_imu3 = eul2rotm([0 0 0]); 
 
%IMU 4
p_imu4 = [0.01 -0.01 0]';
rot_imu4 = eul2rotm([0 0 0]); 

%---- edit here to add more IMUs ----


%% Multi-IMU Initialization
% Assume all IMUs are attached to a rigid body (in this case a foot)
% Get Angular acceleration, to be used in changing IMU frames

w_dot = cdiff(Gyr,simdata.Ts); % 4th order central finite differentiation

% Initialize IMUs
display('Initializing Redundant IMU Reading...');

%---- edit here too add more IMUs (position and rotation have to be defined above before initializing) --
one_imu = {init_imu('ONE',Acc,Gyr,w_dot,[0 0 0]',DCM(:,:,1),eul2rotm([0 0 0]))}; %Single IMU 
imu{1} = init_imu('IMU1',Acc,Gyr,w_dot,p_imu1,DCM(:,:,1),rot_imu1);
imu{2} = init_imu('IMU2',Acc,Gyr,w_dot,p_imu2,DCM(:,:,1),rot_imu2);
imu{3} = init_imu('IMU3',Acc,Gyr,w_dot,p_imu3,DCM(:,:,1),rot_imu3);
imu{4} = init_imu('IMU4',Acc,Gyr,w_dot,p_imu4,DCM(:,:,1),rot_imu4);
%---- edit here too add more IMUs (position and rotation have to be defined above before initializing) --

%% Add Noise (Gaussian Noise + Drift)
display('Adding Guassian Noise and Bias to IMUs');
one_imu = noisify(one_imu);
imu = noisify(imu);

%% Navigation Using Single IMU
one_imu = openShoe_INS(one_imu{1});


%% Method 1: Virtual IMU Method
display('Performing Virtual Fusion Method');
vimu = acc_fusion(imu); % find average measured acceleration and angular rate across all IMU
vimu = openShoe_INS(vimu); % Navigate using Virtual IMU


%% Method 2: Federated Fusion (at Position estimation level)
display('Performing Federationed Fusion Method');

n = length(imu);
for i = 1:n
    imu{i} = openShoe_INS(imu{i}); % Navigate using each IMU
end
fed_imu = pos_fusion(imu); % Fuse all predicted IMU position


%% Method 3: Centralized Fusion (Federated + RUPT)
display('Performing RUPT Federationed Fusion Method');

[cen_imu,~] = openShoe_INS_RUPT(imu); 

%% Error calculation
display('Error calculation');
one_imu = get_error(one_imu,Pos);
vimu = get_error(vimu,Pos);
fed_imu = get_error(fed_imu,Pos);
cen_imu = get_error(cen_imu,Pos);



%% View data
view_data(one_imu,Pos);
view_data(vimu,Pos);
view_data(fed_imu,Pos);
view_data(cen_imu,Pos);