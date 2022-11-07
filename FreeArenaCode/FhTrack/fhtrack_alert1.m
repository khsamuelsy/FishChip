amp=1; 
fs=20500;  % sampling frequency
duration=0.05;
freq=720;
values=0:1/fs:duration;
a=amp*sin(2*pi* freq*values);
sound(a);
