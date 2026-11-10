%plots the modal analysis graphs
function [tlist,Vlist,box_params] = modal_analysis_for_plot()
epsilon = 0.01;
[J_approx,V_eq] = plot_eq_states(epsilon,0);
Q = J_approx(4:6,1:3);

[U_mode, eigvals] = eigs(Q);
omega_n = diag(sqrt(eigvals));


i=1
    mode = U_mode(:,i);
    V0 = V_eq + epsilon.*[mode;0;0;0]
    [tlist,Vlist,box_params,~] = simulate_box(V0);
end









