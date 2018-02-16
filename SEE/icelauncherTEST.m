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
    
    %Moon surface Components
    disk_radius = 50;                  %m        (Defined by design/sim)
    center_bearing_r = 3;              %m        (Defined by design/sim)
    cart_start_r0 = 3.5;               %m        (Defined by design/sim)
    disk_inertia = 3.616859785177E+09; %kg       (Defined by design/sim)
    gravityMoon = 1.622;               %m/s^2    (Ref. Google)
    sled_mass = 7;                     %kg       (Defined by design/sim)
    sled_static_cof = 0.15; %steel on steel      (Ref. Engineer's Handbook)
    sled_sliding_cof = 0.014; %steel on steel    (Ref. Engineer's Handbook)
    

%Inputs-Variable
%%cargo_mass = input('Mass of cargo to be launched [kg]:  ');
    cargo_mass = 10; %kg,                        THIS LINE ONLY FOR TESTING
mass_sys = cargo_mass+sled_mass; %kg
%%spool_t = input('Expected time of disk at rest to full speed [s]:  ');
    %%spool_t = 1800; %s, approx. 30 mins.         THIS LINE ONLY FOR TESTING

%Calculate velocity required at sled catch

v_req = 2.5E+03; %m/s

omega = 
t_req = log(v_req/cart_start_r0/omega/sqrt(2))/omega;
omega = omega/(2*pi);

%Plot
plot(omega,t_req)
