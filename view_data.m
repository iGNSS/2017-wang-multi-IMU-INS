%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%> @file view_data.m  
%>
%> @brief Script for plotting the data from the zero-velocity aided inertial
%> navigations system.
%>
%> @authors Isaac Skog, John-Olof Nilsson
%> @copyright Copyright (c) 2011 OpenShoe, ISC License (open source)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function view_data(imu,truth)
    global simdata;
    name = imu.name;
    u = [imu.acc; imu.gyro];
    x_h = imu.x_h;
    cov = imu.cov;
    zupt = imu.zupt;
    
    % Close all windows
    %close all

    % Generate a vector with the time scale
    N=size(x_h,2);
    t=0:simdata.Ts:(N-1)*simdata.Ts;



    %% Plot the trajectory in the horizontal plane
    figure
    clf
    plot3(x_h(2,:),x_h(1,:),x_h(3,:),truth(:,2),truth(:,1),truth(:,3))
    hold
    plot3(x_h(2,1),x_h(1,1),x_h(3,1),'rs')
    title(['Trajectory - ' name])
    legend('Trajectory','Ground Truth','Start point')
    xlabel('x [m]')
    ylabel('y [m]')
    grid on
    box on

    %% Plot Error
    if isfield(imu,'error')
        figure
        clf
        plot(t,imu.error(4,:));
        title(['Position Error - ' name])
        xlabel('Time [s]')
        ylabel('Error [m]')
        grid on
        box on
    end
    



