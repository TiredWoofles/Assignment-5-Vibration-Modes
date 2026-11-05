%Computes the linear and angular acceleration of the box
%given its current position and orientation
%INPUTS:
%x: current x position of the box
%y: current y position of the box
%theta: current orientation of the box
%box_params: a struct containing the parameters that describe the system
%Fields:
%box_params.m: mass of the box
%box_params.I: moment of inertia w/respect to centroid
%box_params.g: acceleration due to gravity
%box_params.k_list: list of spring stiffnesses
%box_params.l0_list: list of spring natural lengths
%box_params.P_world: 2 x n list of static mounting
% points for the spring (in the world frame)
%box_params.P_box: 2 x n list of mounting points
% for the spring (in the box frame)
%
%OUTPUTS
%ax: x acceleration of the box
%ay: y acceleration of the box
%atheta: angular acceleration of the box
function [ax,ay,atheta] = compute_accel(x,y,theta,box_params)

%Turn mounting points from box frame to world frame rigid body
%transformation eq
Plist_world = compute_rbt(x,y,theta,box_params.P_box);

%Initalize total force (linear momentum eq) & torque (angular momentum)
F_total = [0;-box_params.m*box_params.g];
tau_total = 0;

% # Springs
n = size(box_params.P_box,2);

% per spring 
for i = 1:n
    % Fixed spring mounting pts
    PA = box_params.P_world(:,i);
    % Moving Spring mounting pts
    PB = Plist_world(:,i);
    % Spring Force from assignment eq ki (stiffness) - length over unit
    % vector A to B
    Fi = compute_spring_force(box_params.k_list(i),box_params.l0_list(i),PA,PB);
    % Total forces
    F_total = F_total + Fi;
    % Position from COM (Pc) to mounting pt/lenght
    r = PB - [x;y];
    % Find total Torque
    tau_total = tau_total + r(1)*Fi(2) - r(2)*Fi(1);
end

% acclerations (horizontal & vertical) F=MA or y or x = F/M
% torque = Inertia * angular acceleration
ax = F_total(1)/box_params.m;
ay = F_total(2)/box_params.m;
atheta = tau_total/box_params.I;

end
