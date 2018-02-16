function [ sdot ] = lunardisk( t,s,model )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

m   = model.m;
Izz = model.Izz;

sdot1 = s(2);
sdot2 = s(3)^2*s(1);
sdot3 =-2*m*s(1)*s(2)*s(3)/(Izz+m*s(1));

sdot = [sdot1 sdot2 sdot3]';
end

