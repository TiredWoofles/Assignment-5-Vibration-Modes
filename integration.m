% Function to plot global truncation error against step size or function
% count for various Runge-Kutta method.
%INPUTS (all optional):
% var_test: a string that calls function count or step size calculations;
%           defaults to step size
% func: a function handle that defines a rate function to approximate
% sol: a function handle that defines the solution of func
% t_span: a two-value list containing the first and final values desired of
%         the relevant time span
% num_iter: the number of iterations/datapoints desired
% h_ref: a starting h-value (timestep size)
% growth_limit: the maximum factor that h is allowed to grow by
%OUTPUTS:
% None
function [t_list,x_list] = integration

method = ["Fehlberg"];
var_test = "Fun Count";
num_iter = 50;
func = @box_rate_func;
t_span = [0, 30];
error_span = [-13, 1];
h_ref = 1e-2;
growth_limit = 8;

    % set initial x guess, timestep size, a filter based on the timestep
    % size (for calculating p), and loop iterations
    X0 = box_params.V0';
    e_list = logspace(error_span(1),error_span(2),num_iter);
    e_list = e_list(end:-1:1);
    iter = 0;

    % Loop through the three RK method
    for j = 1:length(method)
        % set up the Butcher tableau corresponding to the current method
        % loop: BT, p-value, and filter bounds
        [BT_struct,p,~] = init_BT(method(j),var_test);
        % set up empty lists for storing data this loop
        fun_count = zeros(num_iter,1);
        failure_list = zeros(num_iter,1);
        h_avg_list = zeros(num_iter,1);

        % loop through different step sizes and calculate the truncation
        % errors for each one
        for i = 1:num_iter
            error_desired = e_list(i);
            [t_list,x_list,~, ~,~] = explicit_RK_variable_step_integration ...
                (func,t_span,X0,h_ref,BT_struct,p,error_desired,growth_limit);
            h_avg_list(i) = h_avg;
            fun_count(i) = evals;
            failure_list(i) = failure_rate;
            % % print iterations for troubleshooting
            iter = iter + 1;
        end
    end
end