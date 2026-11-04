function simulate_box()
%box_params.m: mass of the box
%box_params.I: moment of inertia w/respect to centroid
%box_params.g: acceleration due to gravity
%box_params.k_list: list of spring stiffnesses
%box_params.l0_list: list of spring natural lengths
%box_params.P_world: 2 x n list of static mounting
% points for the spring (in the world frame)
%box_params.P_box: 2 x n list of mounting points
% for the spring (in the box frame)

    %define system parameters
    box_params = struct();
    box_params.m = 5; % kg
    box_params.I = 20; % kg*m^2
    box_params.g = 9.81; % m/s^2
    box_params.k_list = 50*(ones(1,6)); % N/m
    box_params.l0_list = 10*(ones(1,6)); % m
    box_params.P_world = %your code here
    box_params.P_box = %your code here
%load the system parameters into the rate function
%via an anonymous function
    my_rate_func = @(t_in,V_in) box_rate_func(t_in,V_in,box_params);
    x0 = %your code here
    y0 = %your code here
    theta0 = %your code here
    vx0 = %your code here
    vy0 = %your code here
    vtheta0 = %your code here
    V0 = [x0;y0;theta0;vx0;vy0;vtheta0];
    tspan = %your code here
%run the integration
% [tlist,Vlist] = your_integrator(my_rate_func,tspan,V0,...)
end
