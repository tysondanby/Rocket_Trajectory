%ASSIGN GLOBAL CONSTANTS
global  R GM rho c A Isp endMass Tmax omega stage beginMass mass tFinal
GM=3.986004418e14;%Gravitational parameter
rho=1.225;%sea level density kg/m^3
R=6370000;%Radius of earth
omega=.0000727221;%rotational speed of earth (rad/s)

%DEFINE THE ROCKET
c=2;%Drag Coeficient
A=[78.53,78.53,23.758];%craft cross sectional area. By stage
Isp=[250,300,400];%rocket engine specific impulse, by stage
beginMass= [6400000,1372000,308000]./2.205;%Mass at beginning of each stage
endMass=[1640700,383380,74667]./2.205;%ending mass of each stage
Tmax=[7616000,1150000,230000].*4.448;%Max thrust of each stage

%DEFINE THE LAUNCH SITE
Latitude=28.605;
Longitude=-80.6026;
Altitude=200;%just an estimation

%DEFINE FLIGHT INFORMATION
tFinal=10000;%number of seconds to simulate.

stage=1; %launch stage is 1

x = (R+Altitude)*cos(Latitude)*cos(Longitude);
y = (R+Altitude)*cos(Latitude)*sin(Longitude);
z = -(R+Altitude)*sin(Latitude);
%determine initial velocity
v =cross([0,0,omega],[x,y,z]);
%evaluate
mass = beginMass(1);
options =odeset('MaxStep',1);
result=ode45(@rocketfun,(0:1:tFinal),[x,y,z,v(1),v(2),v(3)],options);
set(0,'defaultlinelinewidth',1)
plot3(result.y(1,:),result.y(2,:),result.y(3,:),'-r')
xlim([-2*R 2*R])
ylim([-2*R 2*R])
zlim([-2*R 2*R])
hold on
[p,q,r] = sphere;
p = p*R;
q = q*R;
r = r*R;
s=surf(p,q,r);
s.EdgeColor = 'none';
s
% t = 0:pi/500:pi;
% X(1,:) = R.*sin(t).*cos(10*t);
% X(2,:) = R.*sin(t).*cos(12*t);
% X(3,:) = R.*sin(t).*cos(20*t);
% 
% Y(1,:) = R.*sin(t).*sin(10*t);
% Y(2,:) = R.*sin(t).*sin(12*t);
% Y(3,:) = R.*sin(t).*sin(20*t);
% Z = R.*cos(t);
% plot3(X,Y,Z)
