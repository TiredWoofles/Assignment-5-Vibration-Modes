%plots the modal analysis graphs
function modal_analysis()
epsilon = 0.01;
[J_approx,V_eq] = plot_eq_states(epsilon);
Q = J_approx(4:6,1:3);
[U_mode, eigvals] = eigs(Q);
omega_n = sqrt(-diag(eigvals));
[~,~,~,my_rate_func] = simulate_box();
tspan = [0 6];

for i = 1:3
    Umode = U_mode(:,i);
    omega = (omega_n(i));
    V0 = V_eq + epsilon.*[Umode;0;0;0];
    % Non linear sim
    %[tlist_nonlinear,Vlist_nonlinear,~,~] = simulate_box();
    [tlist_nonlinear,Vlist_nonlinear] = ode45(my_rate_func,tspan,V0);
    % Analytical modal solution
    x_modal = V_eq(1) + epsilon*Umode(1)*cos(omega*tlist_nonlinear);
    y_modal = V_eq(2) + epsilon*Umode(2)*cos(omega*tlist_nonlinear);
    theta_modal = V_eq(3) + epsilon*Umode(3)*cos(omega*tlist_nonlinear);

    % Plots 
    figure('Position',[100 100 1000 850]);
    tiledlayout(3,1,'TileSpacing','compact','Padding','loose');
    
    % X horizontal
    ax(1) = nexttile;
    plot(tlist_nonlinear,Vlist_nonlinear(:,1),'b-','LineWidth',1.5);
    hold on;
    plot(tlist_nonlinear,x_modal,'r--','LineWidth',1.5);
    ylabel('$x$ (m)','Interpreter','latex','FontSize',14);
    grid on;

    % Y vertical
    ax(2) = nexttile;
    plot(tlist_nonlinear,Vlist_nonlinear(:,2),'b-','LineWidth',1.5);
    hold on;
    plot(tlist_nonlinear,y_modal,'r--','LineWidth',1.5);
    ylabel('$y$ (m)','Interpreter','latex','FontSize',14);
    grid on;

    % theta angular
    ax(3) = nexttile;
    plot(tlist_nonlinear,Vlist_nonlinear(:,3),'b-','LineWidth',1.5);
    hold on;
    plot(tlist_nonlinear,theta_modal,'r--','LineWidth',1.5);
    ylabel('$\theta$ (rad)','Interpreter','latex','FontSize',14);
    xlabel('Time (s)','Interpreter','latex','FontSize',14);
    grid on;

    lgd = legend(ax(1),{'Nonlinear Simulation','Analytical Modal Solution'}, ...
        'Interpreter','latex','FontSize',12, ...
        'Orientation','horizontal');
    lgd.Layout.Tile = 'north';
    set(ax,'TickLabelInterpreter','latex');
    set(ax,'FontSize',12);

    sgtitle(sprintf('Mode %d: Analytical Modal Solution vs Nonlinear Simulation, omega = %.3f rad/s',...
    i,omega), 'Interpreter','latex','FontSize',17);
end
end







