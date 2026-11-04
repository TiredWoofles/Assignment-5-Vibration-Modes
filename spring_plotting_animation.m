function spring_plotting_example()
    mypath1 = 'C:\Users\kyue\OneDrive - Olin College of Engineering\Documents\MATLAB\Numerical Methods\Assignment-5-Vibration-Modes';
    fname='vibration_animation.avi';
    input_fname = [mypath1,fname];
        
    %create a videowriter, which will write frames to the animation file
    writerObj = VideoWriter(input_fname);
        
    %must call open before writing any frames
    open(writerObj);
    % initialize the current figure and save as object
    clf
    fig1 = figure(1);
    
    box_params = simulate_box();
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
    theta = 0
        for i = 1:spring_n
            P1 = P_box(i);
            P2 = P_world(i);
            update_spring_plot(spring_structs(i),P1,P2)
        end
        drawnow;
    %end

    %capture a frame (what is currently plotted)
            current_frame = getframe(fig1);
            %write the frame to the video
            writeVideo(writerObj,current_frame);
                %must call close after all frames are written to save the video
                close(writerObj);
           
end


