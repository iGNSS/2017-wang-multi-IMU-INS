% Combine Trials for each bias and configuration 
% m = 15;
% 
% for i = {'3a' '3b' '4a' '4b' '5a' '5b'}
% config = i{1}
% for bias = 1:5
% bias
% trial = 1;
% clear vimu f_frame RUPT_frame
% load(['imu' config '1000/imu' config '_nob'  num2str(bias) '_t' num2str(trial) '.mat']);
% vimu2 = vimu;
% f_frame2 = f_frame;
% RUPT_frame2 = RUPT_frame;
% for trial = 2:m
%     trial
%     clear vimu f_frame RUPT_frame
%     load(['imu' config '1000/imu' config '_nob'  num2str(bias) '_t' num2str(trial) '.mat']);
%     vimu2.x_h = vimu2.x_h + vimu.x_h;
%     vimu2.error = vimu2.error + vimu.error;
%     f_frame2.x_h = f_frame2.x_h + f_frame.x_h;
%     f_frame2.error = f_frame2.error + f_frame.error;
%     RUPT_frame2.x_h = RUPT_frame2.x_h + RUPT_frame.x_h;
%     RUPT_frame2.error = RUPT_frame2.error + RUPT_frame.error;
% end
% vimu2.x_h = vimu2.x_h./m;
% vimu2.error = vimu2.error./m;
% f_frame2.x_h = f_frame2.x_h./m;
% f_frame2.error = f_frame2.error./m;
% RUPT_frame2.x_h = RUPT_frame2.x_h./m;
% RUPT_frame2.error = RUPT_frame2.error./m;
% save(['imu' config '_nob' num2str(bias) '.mat'],'vimu2','f_frame2','RUPT_frame2')
% end
% end

% % Singles
% m = 15;
% 
% config = 'single'
% for bias = 1:5
% bias
% trial = 1;
% clear vimu f_frame RUPT_frame one_imu
% load([config '1000/' config '_nob'  num2str(bias) '_t' num2str(trial) '.mat']);
% one_imu2 = one_imu;
% 
% for trial = 2:m
%     trial
%     clear vimu f_frame RUPT_frame one_imu
%     load([config '1000/' config '_nob'  num2str(bias) '_t' num2str(trial) '.mat']);
%     one_imu2.x_h = one_imu2.x_h + one_imu.x_h;
%     one_imu2.error = one_imu2.error + one_imu.error;
% end
% one_imu2.x_h = one_imu2.x_h./m;
% one_imu2.error = one_imu2.error./m;
% 
% save([ config '_nob' num2str(bias) '.mat'],'one_imu2')
% end

%%%%%% Plots %%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Error For All CAses
% clear all
% clc
% 
% for bias = 1:5
% load(['single_nob' num2str(bias) '.mat']);
% for i = {'imu3a' 'imu3b' 'imu4a' 'imu4b' 'imu5a' 'imu5b'}
% config = i{1}
% load([config '_nob' num2str(bias) '.mat']);
% N = size(vimu2.x_h,2);
% t=0:0.01:(N-1)*0.01;
% 
% figure
% subplot(4,1,1);
% plot(t,one_imu2.error(1,:),t,vimu2.error(1,:),t,f_frame2.error(1,:),t,RUPT_frame2.error(1,:));
% title('Position Error')
% xlabel('Time [s]')
% ylabel('X Error [m]')
% legend('Single IMU','VIMU','Federated','RUPT','Location','northwest','Orientation','horizontal')
% legend('boxoff')
% grid on
% box on
% 
% subplot(4,1,2);
% plot(t,one_imu2.error(2,:),t,vimu2.error(2,:),t,f_frame2.error(2,:),t,RUPT_frame2.error(2,:));
% xlabel('Time [s]')
% ylabel('Y Error [m]')
% grid on
% box on
% 
% subplot(4,1,3);
% plot(t,one_imu2.error(3,:),t,vimu2.error(3,:),t,f_frame2.error(3,:),t,RUPT_frame2.error(3,:));
% xlabel('Time [s]')
% ylabel('Z Error [m]')
% grid on
% box on
% 
% subplot(4,1,4);
% plot(t,one_imu2.error(4,:),t,vimu2.error(4,:),t,f_frame2.error(4,:),t,RUPT_frame2.error(4,:));
% xlabel('Time [s]')
% ylabel('Total Error [m]')
% grid on
% box on
% 
% handle = gcf;
% saveas(handle,['plotsnob/error_' config '_nob' num2str(bias) '.png'])
% close(handle)
% end
% end

%% Method Error Versus Bias
% clear all
% clc
% figure 
% hold on
% bias_value = zeros(1,5);
% 
% 
% for i = {'3a' '3b' '4a' '4b' '5a' '5b'}
% config = i{1}
% error_value = zeros(4,5);
% 
% for bias = 1:5
% load(['single_nob' num2str(bias) '.mat']);
% 
% load(['imu' config '_nob' num2str(bias) '.mat']);
% bias_value(bias) = vimu2.gyro_bias(1);
% error_value(1,bias) = one_imu2.error(4,end);
% error_value(2,bias) = vimu2.error(4,end);
% error_value(3,bias) = f_frame2.error(4,end);
% error_value(4,bias) = RUPT_frame2.error(4,end);
% 
% end
% plot(bias_value,error_value(1,:),bias_value,error_value(2,:),bias_value,error_value(3,:),bias_value,error_value(4,:));
% title(['Position Error - Config ' config])
% xlabel('Bias [rad/hr]')
% ylabel('Total Error [m]')
% legend('Single IMU','VIMU','Federated','RUPT','Location','northwest')
% grid on
% box on
% hold off
% 
% handle = gcf;
% saveas(handle,['plotsnob/methodBIAS_imu' config '.png'])
% close(handle)
% end

%% Config Error Versus Bias
clear all
clc

bias_value = zeros(1,5);
count = 0;
single = zeros(1,6);
vimu = zeros(6,5);
fed = zeros(6,5);
rupt = zeros(6,5);
for i = {'3a' '3b' '4a' '4b' '5a' '5b'}
config = i{1}
count = count + 1
for bias = 1:5

load(['imu' config '_b00' num2str(bias) '.mat']);
bias_value(bias) = vimu2.gyro_bias(1)*3600;
vimu(count,bias) = vimu2.error(4,end);
fed(count,bias) = f_frame2.error(4,end);
rupt(count,bias) = RUPT_frame2.error(4,end);

end
end

for bias = 1:5
load(['single_b00' num2str(bias) '.mat']);
one_imu(bias) = one_imu2.error(4,end);
end

figure 
plot(bias_value,one_imu,'--',bias_value,vimu(1,:),bias_value,vimu(2,:),bias_value,vimu(3,:),...
    bias_value,vimu(4,:),bias_value,vimu(5,:),bias_value,vimu(6,:));
title('Position Error - VIMU')
xlabel('Bias [rad/hr]')
ylabel('Total Error [m]')
legend('Single IMU','3a','3b','4a','4b','5a','5b','Location','northwest')
grid on
box on

handle = gcf;
saveas(handle,'plots100/configBIAS_vimu.png')
close(handle)

figure
plot(bias_value,one_imu,'--',bias_value,fed(1,:),bias_value,fed(2,:),bias_value,fed(3,:),...
    bias_value,fed(4,:),bias_value,fed(5,:),bias_value,fed(6,:));
title('Position Error - Federated')
xlabel('Bias [rad/hr]')
ylabel('Total Error [m]')
legend('Single IMU','3a','3b','4a','4b','5a','5b','Location','northwest')
grid on
box on

handle = gcf;
saveas(handle,'plots100/configBIAS_federated.png')
close(handle)

figure
plot(bias_value,one_imu,'--',bias_value,rupt(1,:),bias_value,rupt(2,:),bias_value,rupt(3,:),...
    bias_value,rupt(4,:),bias_value,rupt(5,:),bias_value,rupt(6,:));
title('Position Error - RUPT')
xlabel('Bias [rad/hr]')
ylabel('Total Error [m]')
legend('Single IMU','3a','3b','4a','4b','5a','5b','Location','northwest')
grid on
box on

handle = gcf;
saveas(handle,'plots100/configBIAS_RUPT.png')
close(handle)


