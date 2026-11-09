%plots the modal analysis graphs
function modal_analysis()
epsilon = 0.01;
[J_approx,V_eq] = plot_eq_states(epsilon);
Q = J_approx(4:6,1:3);

[U_mode, eigvals] = eigs(Q);
omega_n = diag(sqrt(eigvals));
V_eq [1 x 6]
U_mode [3 x 3]
V0 = V_eq + epsilon.*[U_mode;0;0;0];







