%% 3a (planar)
config = '3a';

p_imu1 = [0 0 0]'; %In foot frame
rot_imu1 = eul2rotm([0 0 0]); %Rfoot<-imu

p_imu2 = [0.01 0 0]';
rot_imu2 = eul2rotm([0 0 0]); 

p_imu3 = [-0.01 0 0]';
rot_imu3 = eul2rotm([0 0 0]); 

%% 3b (optimal)
config = '3b';

p_imu1 = [0 0.01 0]'; %In foot frame
rot_imu1 = eul2rotm([pi/2 0 0]); %Rfoot<-imu

p_imu2 = [0 0 0.01]';
rot_imu2 = eul2rotm([0 pi/2 0]); 

p_imu3 = [0.01 0 0]';
rot_imu3 = eul2rotm([0 0 pi/2]); 



%% 4a (planar)
config = '4a';

p_imu1 = [0.01 0.01 0]'; %In foot frame
rot_imu1 = eul2rotm([0 0 0]); %Rfoot<-imu

p_imu2 = [-0.01 0.01 0]';
rot_imu2 = eul2rotm([0 0 0]); 

p_imu3 = [-0.01 -0.01 0]';
rot_imu3 = eul2rotm([0 0 0]); 
 
p_imu4 = [0.01 -0.01 0]';
rot_imu4 = eul2rotm([0 0 0]); 


%% 4b (optimal)
config = '4b';

ang = -acos(1/3);
p = [0.01 0 0]';

rot_imu1 = eul2rotm([pi ang 0]); %Rfoot<-imu
p_imu1 = rot_imu1*p;

rot_imu2 = eul2rotm([-pi/3 ang 0]); 
p_imu2 = rot_imu2*p;

rot_imu3 = eul2rotm([pi/3 ang 0]); 
p_imu3 = rot_imu3*p;

rot_imu4 = eul2rotm([0 pi/2 0]); 
p_imu4 = rot_imu4*p;

%% 5a (optimal)
config = '5a';
ang = -35.2644*pi/180;
p = [0.01 0 0]';

rot_imu1 = eul2rotm([0 ang 0]); %Rfoot<-imu
p_imu1 = rot_imu1*p;

rot_imu2 = eul2rotm([2*pi/5 ang 0]); 
p_imu2 = rot_imu2*p;

rot_imu3 = eul2rotm([2*2*pi/5 ang 0]); 
p_imu3 = rot_imu3*p;

rot_imu4 = eul2rotm([3*2*pi/5 ang 0]); 
p_imu4 = rot_imu4*p;

rot_imu5 = eul2rotm([4*2*pi/5 ang 0]); 
p_imu5 = rot_imu5*p;

%% 5b (optimal)
config = '5b';
ang = -48.1895*pi/180;
p = [0.01 0 0]';

rot_imu1 = eul2rotm([0 0 0]); %Rfoot<-imu
p_imu1 = rot_imu1*p;

rot_imu2 = eul2rotm([pi/2 0 0]); 
p_imu2 = rot_imu2*p;

rot_imu3 = eul2rotm([pi ang 0]); 
p_imu3 = rot_imu3*p;
 
rot_imu4 = eul2rotm([pi/3 ang 0]); 
p_imu4 = rot_imu4*p;

rot_imu5 = eul2rotm([-pi/3 ang 0]); 
p_imu5 = rot_imu5*p;