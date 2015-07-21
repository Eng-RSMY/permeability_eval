function plot_ellipse(xa, ya, a, b, angle, linespec)
%PLOT_ELLIPSE plots an ellipse based on given data
%
    %#  @param xa      x coordinate
    %#  @param ya      y coordinate
    %#  @param a       Semimajor axis
    %#  @param b       Semiminor axis
    %#  @param angle   Angle of the ellipse (in degrees)

hold on;

p = calculateEllipse(xa, ya, a, b, angle);
plot(p(:,1), p(:,2), linespec);
% p1=[1.1*(-a), 1.1*a]; p2=[0, 0];
% q1= p1*cos(angle*pi/180) - p2*sin(angle*pi/180); q2 = p1*sin(angle*pi/180) + p2*cos(angle*pi/180);
% u1=q1+2*sin(angle*pi/180); u2=q2-4+4*cos(angle*pi/180);
% plot(u1,u2, '-.', 'Color', 'red'); 
axis equal;

end