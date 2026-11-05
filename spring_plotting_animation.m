function spring_plotting_example()
    mypath1 = 'C:\Users\kyue\OneDrive - Olin College of Engineering\Documents\MATLAB\Numerical Methods\Assignment-5-Vibration-Modes';
    %'C:\Users\sli2\OneDrive - Olin College of Engineering\MechE Math\Assignment-5-Vibration-Modes';
    %'C:\Users\kyue\OneDrive - Olin College of Engineering\Documents\MATLAB\Numerical Methods\Assignment-5-Vibration-Modes':
    fname='vibration_animation.avi';
    input_fname = [mypath1,fname];
        
    %create a videowriter, which will write frames to the animation file
    writerObj = VideoWriter(input_fname);
        
    %must call open before writing any frames
    open(writerObj);
    % initialize the current figure and save as object
    clf
    fig1 = figure(1);
    
    [tlist,Vlist,box_params] = simulate_box();
    P_box = box_params.P_box;
    P_world = box_params.P_world;
    %number of springs
    spring_n = length(box_params.P_world);
    num_zigs = 5;
    w = .1;
    hold on;

    %initialize array of spring structs
    spring_structs = zeros(springs,n)
    for i = 1:spring_n
    spring_structs(i) = initialize_spring_plot(num_zigs,w);
    end
    box_plot = plot(boundary_pts(1,:),boundary_pts(2,:),'k','linewidth',2);

    axis equal; axis square;
    axis([-3,3,-3,3]);
    xlabel("$X$ Position (-)", Interpreter="latex");
    ylabel("$Y$ Position (-)", Interpreter="latex");
    title("Vibration Simulation", Interpreter="latex")
    set(gca,'TickLabelInterpreter','latex')
    fontsize(scale=2)
    % forces the video to be high-quality
    set(fig1,'units','pixels','position',[0 0 1440 1080])

    %for theta=linspace(0,6*pi,1000)
    t = linspace(tlist(1),tlist(2),500);
    V = interp1(tlist,Vlist,t_uniform);

    for j = 1:length(t)
        x = V(j,1); y = V(j, 2);, theta = V(j,3);

        boundary_pts = compute_rbt(x,y,theta,box_params.boundary_pts);
        set(box_plot,'xdata',boundary_pts(1,:),'ydata',boundary_pts(2,:));
        for i = 1:spring_n
            P1 = box_params.P_world(i);

            P2 = compute_rbt(x,y,theta,box_params.P_box(:,i));
            update_spring_plot(spring_structs(i),P1,P2)
        end
        axis equal;
        axis square
        axis([-15 15 -15 15])
        drawnow;
    %end

    %capture a frame (what is currently plotted)
            current_frame = getframe(fig1);
            %write the frame to the video
            writeVideo(writerObj,current_frame);
                %must call close after all frames are written to save the video
                close(writerObj);
    end
           
end


