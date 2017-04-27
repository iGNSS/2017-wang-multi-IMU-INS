% % Calculate percentage

% clear
% clc
% 
% load('data.mat');
% 
% vimu_score = zeros(6,1);
% fed_score = zeros(6,1);
% rupt_score = zeros(6,1);
% count = 0;
% 
% for i = 1:length(data)
%     for bias = 1:5
%         baseline = mean(data{i}.one_error(bias,:));
%         for trial = 1:15
%             for j = 1:6
%                 count = count + 1;
%                 if data{i}.config{j}.vimu_error(bias,trial) < baseline
%                     vimu_score(j) = vimu_score(j) + 1;
%                 end
%                 if data{i}.config{j}.fed_error(bias,trial) < baseline
%                     fed_score(j) = fed_score(j) + 1;
%                 end
%                 if data{i}.config{j}.rupt_error(bias,trial) < baseline
%                     rupt_score(j) = rupt_score(j) + 1;
%                 end
%             end
%         end 
%     end
% end
% 
% vimu_pscore = vimu_score/(5*15*3);
% fed_pscore = fed_score/(5*15*3);
% rupt_pscore = rupt_score/(5*15*3);
% 
% vimu_success = mean(vimu_pscore);
% fed_success = mean(fed_pscore);
% rupt_success = mean(rupt_pscore);
% 
% 
% config_score = vimu_score + fed_score + rupt_score;
% config_pscore = config_score/(5*15*3*3);
% 
% %% Success and failure
% 
% vimu_improve = zeros(length(data),5,6);
% fed_improve = zeros(length(data),5,6);
% rupt_improve = zeros(length(data),5,6);
% 
% vimu_worse = zeros(length(data),5,6);
% fed_worse = zeros(length(data),5,6);
% rupt_worse = zeros(length(data),5,6);
% 
% for i = 1:length(data)
%     for bias = 1:5
%         baseline = mean(data{i}.one_error(bias,:));
%         for j = 1:6
%             vimu_n = 0;
%             fed_n = 0;
%             rupt_n = 0;
%             for trial = 1:15
%                 if data{i}.config{j}.vimu_error(bias,trial) < baseline
%                     vimu_improve(i,bias,j) = vimu_improve(i,bias,j) + (baseline-data{i}.config{j}.vimu_error(bias,trial))/baseline;
%                     vimu_n = vimu_n + 1;
%                 else
%                     vimu_worse(i,bias,j) = vimu_worse(i,bias,j) + (baseline-data{i}.config{j}.vimu_error(bias,trial))/baseline;
%                 end
%                 if data{i}.config{j}.fed_error(bias,trial) < baseline
%                     fed_improve(i,bias,j) = fed_improve(i,bias,j) + (baseline-data{i}.config{j}.fed_error(bias,trial))/baseline;
%                     fed_n = fed_n + 1;
%                 else
%                     fed_worse(i,bias,j) = fed_worse(i,bias,j) + (baseline-data{i}.config{j}.fed_error(bias,trial))/baseline;
%                 end
%                 if data{i}.config{j}.rupt_error(bias,trial) < baseline
%                     rupt_improve(i,bias,j) = rupt_improve(i,bias,j) + (baseline-data{i}.config{j}.rupt_error(bias,trial))/baseline;
%                     rupt_n = rupt_n + 1;
%                 else
%                     rupt_worse(i,bias,j) = rupt_worse(i,bias,j) + (baseline-data{i}.config{j}.rupt_error(bias,trial))/baseline;
%                 end
%             end
%             if vimu_n ~= 0
%                 vimu_improve(i,bias,j) = vimu_improve(i,bias,j)./vimu_n;
%             end
%             if fed_n ~= 0
%                 fed_improve(i,bias,j) = fed_improve(i,bias,j)./fed_n;
%             end
%             if rupt_n ~= 0
%                 rupt_improve(i,bias,j) = rupt_improve(i,bias,j)./rupt_n;
%             end
%             if vimu_n ~= 15
%                 vimu_worse(i,bias,j) = vimu_worse(i,bias,j)./(15-vimu_n);
%             end
%             if fed_n ~= 15
%                 fed_worse(i,bias,j) = fed_worse(i,bias,j)./(15-fed_n);
%             end
%             if rupt_n ~= 15
%                 rupt_worse(i,bias,j) = rupt_worse(i,bias,j)./(15-rupt_n);
%             end
%         end 
%     end
% end
% 
% vimu_good = reshape(mean(mean(vimu_improve)),6,1);
% fed_good = reshape(mean(mean(fed_improve)),6,1);
% rupt_good = reshape(mean(mean(rupt_improve)),6,1);
% vimu_bad = reshape(mean(mean(vimu_worse)),6,1);
% fed_bad = reshape(mean(mean(fed_worse)),6,1);
% rupt_bad = reshape(mean(mean(rupt_worse)),6,1);
% 
% vimu_expected = vimu_good.*vimu_pscore + vimu_bad.*(1-vimu_pscore);
% fed_expected = fed_good.*fed_pscore + fed_bad.*(1-fed_pscore);
% rupt_expected = rupt_good.*rupt_pscore + rupt_bad.*(1-rupt_pscore);
% 
% figure
% bar([vimu_good, vimu_bad, vimu_expected]*100)
% set(gca,'XTickLabel',{'3a' '3a' '4a' '4b' '5a' '5b'})
% ylim([-100 100])
% 
% figure
% bar([fed_good, fed_bad, fed_expected]*100)
% set(gca,'XTickLabel',{'3a' '3a' '4a' '4b' '5a' '5b'})
% ylim([-100 100])
% 
% figure
% bar([rupt_good, rupt_bad, rupt_expected]*100)
% set(gca,'XTickLabel',{'3a' '3a' '4a' '4b' '5a' '5b'})
% ylim([-100 100])

%% Combine Trials for each bias and configuration 
% clear
% clc
% 
% 
% experiment = {'', '10', '100'};
% b = {'_b' '_b0' '_b00'};
% config = {'3a' '3b' '4a' '4b' '5a' '5b'};
% 
% %data = struct;
% 
% 
% for i = 1:length(experiment)
%     name = experiment{i}
%     bname = b{i};
%     
%     data{i}.one_error = zeros(5,15);
%     data{i}.accbias = zeros(5,1);
%     data{i}.gyrobias = zeros(5,1);
%     for bias = 1:5
%         bias
% 
%         for trial = 1:15
%         	clear one_imu
%         	load(['single' name '/single' bname  num2str(bias) '_t' num2str(trial) '.mat']);
%             data{i}.one_error(bias,trial) = one_imu.error(4,end);
%             data{i}.accbias(bias) = one_imu.acc_bias(1)*3600;
%             data{i}.gyrobias(bias) = one_imu.gyro_bias(1)*3600;
%         end
%     end
%     
%     clear one_imu
%     display('Multi IMU');
%     for j = 1:length(config)
%         conf = config{j}
%         data{i}.config{j}.vimu_error = zeros(5,15);
%         data{i}.config{j}.fed_error = zeros(5,15);
%         data{i}.config{j}.rupt_error = zeros(5,15);
% 
%         for bias = 1:5
%             bias
%             for trial = 1:15
%                 clear vimu f_frame RUPT_frame 
%                 load(['imu' conf name '/imu' conf bname  num2str(bias) '_t' num2str(trial) '.mat']);
%                 data{i}.config{j}.vimu_error(bias,trial) = vimu.error(4,end);
%                 data{i}.config{j}.fed_error(bias,trial) = f_frame.error(4,end);
%                 data{i}.config{j}.rupt_error(bias,trial) = RUPT_frame.error(4,end);
%             end
%         end
%     end
% end

%% Anomaly 

clear all
clc

%load('experimental/experimentalLOOP_t15.mat');

load('imu4b_b5.mat')
load('single_b5.mat')
one_imu = one_imu2;
vimu = vimu2;
f_frame = f_frame2;
RUPT_frame = RUPT_frame2;


N = size(vimu2.x_h,2);
%t=0:0.005:(N-1)*0.005;
t=0:0.01:(N-1)*0.01;

figure
% subplot(4,1,1);
% plot(t,one_imu.error(1,:),t,vimu.error(1,:),t,f_frame.error(1,:),t,RUPT_frame.error(1,:));
% title('Position Error')
% xlabel('Time [s]')
% ylabel('X Error [m]')
% legend('Single IMU','VIMU','Federated','RUPT','Location','northwest','Orientation','horizontal')
% legend('boxoff')
% grid on
% box on
% 
% subplot(4,1,2);
% plot(t,one_imu.error(2,:),t,vimu.error(2,:),t,f_frame.error(2,:),t,RUPT_frame.error(2,:));
% xlabel('Time [s]')
% ylabel('Y Error [m]')
% grid on
% box on
% 
% subplot(4,1,3);
% plot(t,one_imu.error(3,:),t,vimu.error(3,:),t,f_frame.error(3,:),t,RUPT_frame.error(3,:));
% xlabel('Time [s]')
% ylabel('Z Error [m]')
% grid on
% box on
% 
% subplot(4,1,4);
plot(t,one_imu.error(4,:),t,vimu.error(4,:),t,f_frame.error(4,:),t,RUPT_frame.error(4,:));
xlabel('Time [s]')
ylabel('Total Error [m]')
legend('Single IMU', 'VIMU','Federated','RUPT')
grid on
box on

figure
x = [one_imu.x_h(1,:) ; vimu.x_h(1,:) ; f_frame.x_h(1,:) ; RUPT_frame.x_h(1,:)];
y = [one_imu.x_h(2,:) ; vimu.x_h(2,:) ; f_frame.x_h(2,:) ; RUPT_frame.x_h(2,:)];
z = [one_imu.x_h(3,:) ; vimu.x_h(3,:) ; f_frame.x_h(3,:) ; RUPT_frame.x_h(3,:)];
plot3(x(1,:),y(1,:),z(1,:),x(2,:),y(2,:),z(2,:),x(3,:),y(3,:),z(4,:),x(4,:),y(4,:),z(4,:));
legend('Single','VIMU','Federated','RUPT')

%%
% 
% clear all
% clc
% 
% bias_value = zeros(1,15);
% count = 0;
% vimu = zeros(6,15);
% fed = zeros(6,15);
% rupt = zeros(6,15);
% for i = {'3a' '3b' '4a' '4b' '5a' '5b'}
% config = i{1}
% count = count + 1
% for bias = 1:5
% 
% load(['imu' config '_b' num2str(bias) '.mat']);
% bias_value(bias) = vimu2.gyro_bias(1)*3600;
% vimu(count,bias) = vimu2.error(4,end);
% fed(count,bias) = f_frame2.error(4,end);
% rupt(count,bias) = RUPT_frame2.error(4,end);
% 
% end
% for bias = 6:10
% 
% load(['imu' config '_b0' num2str(bias-5) '.mat']);
% bias_value(bias) = vimu2.gyro_bias(1)*3600;
% vimu(count,bias) = vimu2.error(4,end);
% fed(count,bias) = f_frame2.error(4,end);
% rupt(count,bias) = RUPT_frame2.error(4,end);
% 
% end
% for bias = 11:15
% 
% load(['imu' config '_b00' num2str(bias-10) '.mat']);
% bias_value(bias) = vimu2.gyro_bias(1)*3600;
% vimu(count,bias) = vimu2.error(4,end);
% fed(count,bias) = f_frame2.error(4,end);
% rupt(count,bias) = RUPT_frame2.error(4,end);
% 
% end
% end
% 
% for bias = 1:5
% load(['single_b' num2str(bias) '.mat']);
% one_imu(bias) = one_imu2.error(4,end);
% end
% 
% for bias = 6:10
% load(['single_b0' num2str(bias-5) '.mat']);
% one_imu(bias) = one_imu2.error(4,end);
% end
% 
% for bias = 11:15
% load(['single_b00' num2str(bias-10) '.mat']);
% one_imu(bias) = one_imu2.error(4,end);
% end
% 
% [bias_value,I]=sort(bias_value);
% one_imu = one_imu(I);
% vimu = vimu(:,I);
% fed = fed(:,I);
% rupt = rupt(:,I);
% 
% figure 
% plot(bias_value,one_imu,'--',bias_value,vimu(1,:),bias_value,vimu(2,:),bias_value,vimu(3,:),...
%     bias_value,vimu(4,:),bias_value,vimu(5,:),bias_value,vimu(6,:));
% title('Position Error - VIMU')
% xlabel('Bias [rad/hr]')
% ylabel('Total Error [m]')
% legend('Single IMU','3a','3b','4a','4b','5a','5b','Location','northwest')
% grid on
% box on
% 
% handle = gcf;
% saveas(handle,'configBIAS_vimu.png')
% close(handle)
% 
% figure
% plot(bias_value,one_imu,'--',bias_value,fed(1,:),bias_value,fed(2,:),bias_value,fed(3,:),...
%     bias_value,fed(4,:),bias_value,fed(5,:),bias_value,fed(6,:));
% title('Position Error - Federated')
% xlabel('Bias [rad/hr]')
% ylabel('Total Error [m]')
% legend('Single IMU','3a','3b','4a','4b','5a','5b','Location','northwest')
% grid on
% box on
% 
% handle = gcf;
% saveas(handle,'configBIAS_federated.png')
% close(handle)
% 
% figure
% plot(bias_value,one_imu,'--',bias_value,rupt(1,:),bias_value,rupt(2,:),bias_value,rupt(3,:),...
%     bias_value,rupt(4,:),bias_value,rupt(5,:),bias_value,rupt(6,:));
% title('Position Error - RUPT')
% xlabel('Bias [rad/hr]')
% ylabel('Total Error [m]')
% legend('Single IMU','3a','3b','4a','4b','5a','5b','Location','northwest')
% grid on
% box on
% 
% handle = gcf;
% saveas(handle,'configBIAS_RUPT.png')
% close(handle)
% 

