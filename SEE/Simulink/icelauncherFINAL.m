%{
Alan Moorman, Elaine Adams, Karl Siebold
Embry-Riddle Aeronautical University
SEE Program
Ice Launcher Computations

Date Created: 3-2-2017
Date Last Modified: 3-2-2017
Author's Notes: All units are SI
%}

%Clean-up Workspace
clc
clear
close all

%Define constant values of scenario

    %Orbital Components
    mueMoon = 4904.8695;               %km^3/s^2 (https://en.wikipedia.org/wiki/Standard_gravitational_parameter)
    gravityMoon = 1.622;               %m/s^2    (Ref. Google)
    
    %Moon surface Components
    disk_radius = 50;                  %m        (Defined by design/sim)
    ramp_radius = 15;                  %m        (Defined by desing/sim)
    ramp_displacement = ramp_radius*(pi/2);  %m        (Defined by design/sim)
    cart_start_r0 = 1;                 %m        (Defined by design/sim)
    model.Izz = 3.465E+16/1000/1000^2; %kg m^2       (Defined by design/sim)
    sled_mass = 7;                     %kg       (Defined by design/sim)
    sled_static_cof = 0.15; %steel on steel      (Ref. Engineer's Handbook)
    sled_sliding_cof = 0.014; %steel on steel    (Ref. Engineer's Handbook)
    
%Inputs
    cargo_mass = 10; %kg,                        
    model.m = cargo_mass+sled_mass; %kg

%Calculate velocity required at launch and release from disk center
    v_req = 2.5E+03; %m/s
    v_release = sqrt((2/model.m)*(sled_static_cof*model.m*gravityMoon*cart_start_r0)); %m/s velocity after static friction is overcome
    
%Calculate omega required at launch
    work = 0.5*(model.m)*v_req^2 + sled_sliding_cof*(model.m)*gravityMoon*((disk_radius+ramp_displacement)-cart_start_r0);
    omega_req = sqrt(2*work/model.Izz);   %Radians/sec
    omega_rps = omega_req/(2*pi);         %Revolutions/sec
    
%Minimize Omega required to achieve acceleration
    omega_initial = linspace(35,30);
    omega_initial = omega_initial';
    
    f1 = 'Initial_Omega';
    f2 = 'Time';
    f3 = 'Position';
    f4 = 'Velocity';
    f5 = 'Omega';
    
    omegaStruct = struct(f1,omega_initial,f2,[],f3,[],f4,[],f5,[]);
    
    model.r = ramp_displacement + disk_radius;
    
    %model = [model.m model.Izz model.r model.v];
    opts_1 = odeset('Events',@positionstop);
    %opts_2 = odeset('Events',@velocitystop);
    options = odeset(opts_1,'Maxstep',0.0005);
    
  for k = 1:numel(omega_initial)
    
    results = ode45(@(t,s)lunardisk(t,s,model),[0 1],[cart_start_r0 v_release omega_initial(k)],options);
    
    if results.y(2,end) >= v_req
            time = results.x;
            r    = results.y(1,:);
            v    = results.y(2,:);
            w    = results.y(3,:);

            omegaStruct(k).Initial_Omega = omega_initial;
            omegaStruct(k).Time = time;
            omegaStruct(k).Position = r;
            omegaStruct(k).Velocity = v;
            omegaStruct(k).Omega = w;

            subplot(4,1,1)
            plot(time,r)
            hold on
            grid on
            xlabel('t(s)')
            ylabel('Position(m)')

            subplot(4,1,2)
            plot(time,v)
            hold on
            grid on
            xlabel('t(s)')
            ylabel('Velocity(m/s)')

            subplot(4,1,3)
            plot(time,w)
            hold on
            grid on
            xlabel('t(s)')
            ylabel('Omega(rad/s)')

            subplot(4,1,4)
            plot(r,v)
            hold on
            grid on
            xlabel('Position(m)')
            ylabel('Velocity(m/s)')

           
    end
    
   end

%Calculate resultant forces
    alpha = 2*model.m*1*0.6976*34.0404/(model.Izz+model.m*1);
    Torque = model.Izz*alpha;
    
%Display values
    %fprintf('\nOmega: %.5f rad/s\nOmega: %.5f RPS\nTorque Applied: %13.2f N*m\n',omega,omega_rps,Torque)
