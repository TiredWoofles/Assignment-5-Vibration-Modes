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
    V0 = [x0;y0;theta0;vx0;vy0;vtheta0];
    tspan = linspace(0, 6*pi, 1000);

method = ["Fehlberg"];
error_span  = [-13, 1];
h_ref = 1e-2;
growth_limit = 8;

e_list = logspace(error_span(1),error_span(2),num_iter);
e_list = e_list(end:-1:1);
iter = 0;

    % Loop through the three RK method
    for j = 1:length(method)
        % set up the Butcher tableau corresponding to the current method
        % loop: BT, p-value, and filter bounds
        [BT_struct,p,~] = init_BT(method(j),var_test);
        % set up empty lists for storing data this loop
        error = zeros(num_iter,1);
        fun_count = zeros(num_iter,1);
        failure_list = zeros(num_iter,1);
        h_avg_list = zeros(num_iter,1);

        % loop through different step sizes and calculate the truncation
        % errors for each one
        for i = 1:num_iter
            error_desired = e_list(i);
            [~,x_list,h_avg, evals,failure_rate] = explicit_RK_variable_step_integration ...
                (func,t_span,X0,h_ref,BT_struct,p,error_desired,growth_limit);
            x_true = sol(t_span(end));
            
            error(i) = norm(x_list(end,:).' - x_true);
            h_avg_list(i) = h_avg;
            fun_count(i) = evals;
            failure_list(i) = failure_rate;
            
            % % print iterations for troubleshooting
            iter = iter + 1;
        end
    end

%run the integration
[t_list,X_list,h_avg,fun_count,failure_rate] = explicit_RK_variable_step_integration ...
(box_rate_func,tspan,V0,h_ref,BT_struct,p,error_desired,growth_limit);

end
