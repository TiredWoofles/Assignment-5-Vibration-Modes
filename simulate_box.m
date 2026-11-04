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

    %define per spring
    box_params.spring_number = 6;
    box_params.LG = 1.5; %m this is the length of spring compressed by gravity
    box_params.l0 = box_params.LG * 1.5;
    box_params.k_list = 50*(ones(1,box_params.spring_number)); % N/m
    box_params.l0_list = box_params.compressed_length(ones(1,box_params.spring_number)); % m

    %define box parameters
    box_params.LW = 10; %m
    box_params.LH = 10; %m

    %define box boundaries
    box_params.Pbl_box = [-box_params.LW; -box_params.LH];
    box_params.Pbr_box = [ box_params.LW; -box_params.LH];
    box_params.Ptl_box = [-box_params.LW;  box_params.LH];
    box_params.Ptr_box = [ box_params.LW;  box_params.LH];
    box_params.boundary_pts = [box_params.Pbl_box, box_params.Pbr_box,...
           box_params.Ptr_box, box_params.Ptl_box, box_params.Pbl_box];

    box_params.Pbl1_world = box_params.Pbl_box + [-box_params.LG;-box_params.LG];
    box_params.Pbl2_world = box_params.Pbl_box + [box_params.LG;-box_params.LG];
    box_params.Pbr1_world = box_params.Pbr_box + [0;-l0];
    box_params.Pbr2_world = box_params.Pbr_box + [l0;0];

    box_params.P_world = [box_params.Pbl1_world,box_params.Pbl2_world,...
        box_params.Pbr1_world,box_params.Pbr2_world];
    box_params.P_box = [box_params.Pbl_box,box_params.Pbl_box,...
        box_params.Pbr_box,box_params.Pbr_box];

%load the system parameters into the rate function
%via an anonymous function
    my_rate_func = @(t_in,V_in) box_rate_func(t_in,V_in,box_params);
    box_params.x0 = 0;
    box_params.y0 = 0;
    box_params.theta0 = 0;
    vx0 = 1.5; % m/s
    vy0 = 1.5; % m/s
    vtheta0 = 1.5; % m/s
    box_params.V0 = [x0;y0;theta0;vx0;vy0;vtheta0];
    box_params.tspan = linspace(0, 6*pi, 1000);

[t_list,V_list] = integration;

end
