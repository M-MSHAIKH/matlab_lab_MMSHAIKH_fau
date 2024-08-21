%%Task 2 (LOADING.....)
[file,path] = uigetfile;
load_file= load(file, "-mat");
conn = load_file.conn;
coord = load_file.coord;
bearing = load_file.bearing;
F = load_file.F;

%% Task 3 (PLOTTING)
% defining the numbers of the elements
num_nodes = size(coord,1);
num_bearings = size(bearing,1);
num_bars = size(conn,1);
num_forces = size(F,1);
%Potting nodes
figure
hold on
for i =1: num_nodes
    x = coord(i,1);
    y = coord(i,2);
    plot(x,y, "o", "Color","black");
end


%plotting the bars
for i = 1: num_bars
    node_num1 = conn (i,1);
    node_num2 = conn(i,2);
    x1i = coord(node_num1,1);
    x2i = coord(node_num2,1);
    y1i = coord(node_num1,2);
    y2i = coord(node_num2,2);
    plot([x2i, x1i], [y2i, y1i], "-", "Color","black");
end

% plotting the bearing
for i = 1: num_bearings
    node_at_bearing = bearing(i,1);
    x = coord(node_at_bearing, 1);
    y = coord(node_at_bearing,2);
    dof_bearing = bearing(i,2);
    if dof_bearing == 1
        p2 = plot(x-0.1, y, ">", "Color","red");
    else
        plot(x, y-0.1 ,"^", "Color","red");
    end
end

%plotting force
for i = 1:num_forces
    node_num = F(i,1);
    x = coord(node_num, 1);
    y = coord(node_num, 2);
    p3 = quiver(x, y,F(i,2), F(i, 3), "MaxHeadSize", 1/norm(F(i, 2:3)),"Color","green" );
end
axis equal
hold off

%% Task 4
f = 2 * num_nodes - (num_bars  + num_bearings);
fa = 3 - num_bearings;
if (f > 0 || fa > 0)
    error("The neccessity and sufficient conditions for the rigidity and the load bearing conditons not satisfied");
elseif f == 0
    disp("Statically determined");
else
    disp("statically undetermined");
end 
%% Task 5
%Calculating the angle alpha
angles = zeros(num_bars, 2);
for i = 1:num_bars
    node_num1 = conn(i,1);
    node_num2 = conn(i,2);
    x1 = coord(node_num1,1);
    x2 = coord(node_num2,1);
    y1 = coord(node_num1,2);
    y2 = coord(node_num2,2);
    dy = y2 -y1;
    dx = x2 - x1;
    angles(i,1) = atan(dy/dx);
    angles(i,2) = atan2(dy, dx);
end

%% Task 6 
%formulating the linear syste of equations
% Ar = F
% initializing all matrices
n = 2*num_nodes;
A = zeros(n, n);
r = zeros(n,1);
F_vector = zeros(n,1);

% Calculating the matrix A
% calculating the first 3 coulumn bearing force
for i = 1: num_bearings
    %bearing force in which directions
    % if bearing(i,2) == 1
    %     x_direction = 1;
    % else 
    %     y_direction = 2;
    % end
    % if bearing(i,2) == 1
    %    bearing_force_xy_contri = 2*bearing(i-1,1);
    % else
    %     bearing_force_xy_contri = 2*bearing(i,1);
    % end

    bearing_force_xy_contri = 2 * (bearing(i,1) - 1) + bearing(i,2);
        A(bearing_force_xy_contri,i) = 1;
end

%Calculation for the other columns
%ALl this things is about how to find the row and cloumn to place the value
for i = 1:num_bars
    bar_force_knot = conn(i,1);
    bar_force_line = 2*(bar_force_knot -1) +1;
    bar_force_coloumn = i + num_bearings;

    A(bar_force_line, bar_force_coloumn) = cos(angles(i,1));
    A(bar_force_line + 1, bar_force_coloumn) = sin(angles(i,1));

    bar_force_knot = conn(i,2);
    bar_force_line = 2*(bar_force_knot -1) +1;
    bar_force_coloumn = i + num_bearings;

    A(bar_force_line, bar_force_coloumn) = cos(angles(i,1));
    A(bar_force_line + 1, bar_force_coloumn) = sin(angles(i,1));
end 





