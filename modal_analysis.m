%plots the modal analysis graphs
function modal_analysis()
epsilon = 0.01;
[J_approx,V_eq] = plot_eq_states(epsilon);
Q = J_approx(4:6,1:3);

[U_mode, eigvals] = eigs(Q);
omega_n = diag(sqrt(eigvals));


for i = 1:3
    mode = U_mode(:,i);
    V0 = V_eq + epsilon.*[mode;0;0;0];
    [tlist,Vlist,~,~] = simulate_box(V0)

end







