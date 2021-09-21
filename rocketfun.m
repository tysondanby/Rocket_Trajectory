function xdot = rocketfun(t,x)
%MODELS A ROCKET FLYING THROUGH THE ATMOSPHERE
%   state variables:
%1-3: x,y,z position
%4-6: x,y,z velocity
%7: Rocket mass
    
    global tOld tNew tFinal R GM rho c A Isp endMass Tmax omega stage beginMass mass
    
 %%%%THINGS YOU CAN CONTROL%%%%--------------------------------------------
    

    if norm(x(4:6))<350 && (norm(x(1:3))-R)<15000%first ascent
        T=1;%base thrust. Between 0-1.
        %0 is up. 90 is horizontal.
        pitch=pi/2;
        %yaw direction, 0 is east. 90 is north.
        yaw=0;
    elseif (norm(x(1:3))-R)<15000 
        T=1;%base thrust. Between 0-1.
        
        pitch=pi/2;
        %yaw direction, 0 is east. 90 is north.
        yaw=0;
    elseif 15000<(norm(x(1:3))-R)<1000000% && norm(x(4:6))<6000%Gravity turn
        T=1;%base thrust. Between 0-1.
        
        pitch=pi/2-pi/1997000*(norm(x(1:3))-R-10000);
        %yaw direction, 0 is east. 90 is north.
        yaw=0;%-22.2+.000222*(norm(x(1:3))-R);
%     elseif 10000<(norm(x(1:3))-R)<100000 %avoid overshoot
%         T=0;%base thrust. Between 0-1. 
%         pitch=pi*10/18-pi/180000*(norm(x(1:3))-R);
%         %yaw direction, 0 is east. 90 is north.
%         yaw=0;%-22.2+-.000222*(norm(x(1:3))-R);
    elseif norm(x(4:6))<10000%Get into orbit
        T=1;%base thrust. Between 0-1.
        
        pitch=0;
        %yaw direction, 0 is east. 90 is north.
        yaw=0;
    else                        %Cut power
        T=0;%base thrust. Between 0-1.
        
        pitch=0;
        %yaw direction, 0 is east. 90 is north.
        yaw=0;
    end

 %%%%END THINGS YOU CAN CONTROL%%%%----------------------------------------
    
    %SET thrust
    if mass<endMass(stage)
        T=0;
    else
        T=T*Tmax(stage);
    end
 
    %initialization
    %x=zeros(7,1);
    xdot=zeros(6,1);
    
    %Atmosphere air velocity
    airV=[-x(2);x(1);0].*omega;
    
    %position is first 3 state variables
    position=x(1:3);
    posDot=dot(position,position);
    
    %heading without considering pitch

    yawhdg=rotationMatrix(position,yaw)*airV;
    
    %complete heading (i.e. THE VECTOR REPRESENTING WHERE THE ROCKET POINTS)
    hdg=rotationMatrix(cross(yawhdg,position),pitch)*yawhdg;
    hdg=hdg./norm(hdg);
    velocity=x(4:6);
    
    
    
    rhoH = rho*.0787^(.012539*(norm(position)-R));%atmospheric density at altitude.
    
    %calculate velocity (z1-z3)dot
    xdot(1:3)=x(4:6);%i.e. the position's derivitive is the current velocity.
    
    %calculate acceleration (z4-z6)dot
    airResistance =[0;0;0];%-(c*A(stage)*rhoH*norm(velocity-airV)/mass).*(velocity-airV)
    thrust= (T/mass).*hdg;
    gravity=-position./norm(position).*(GM/posDot);
%     if isnan(thrust(1)) ||isnan(thrust(2)) ||isnan(thrust(3))
%         thrust=[0;0;0];
%     end
    xdot(4:6)=gravity+airResistance+thrust;
    
    if t==0
        tOld=0;
    end
    
    %calculate mass
    if mass<endMass(stage) 
        if stage<length(Isp)%only increases stage if there is another
            stage=stage+1;
            mass=beginMass(stage);%sets mass for next stage
        end
    else
        mass=mass-(T/(Isp(stage)*9.81))*(t-tOld);
    end
    for i=1:1:6
        if isnan(xdot(i))
            xdot(i)=0;
        end
    end
    tOld=t;
    x
end