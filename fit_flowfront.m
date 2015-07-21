function [flowfrontfit]= fit_flowfront( perm )
%function flowfrontfit = fit_flowfront( num,exp )
%
% fit_flowfront - finds the best ellipse fit for the given set of points.
%
% Format:   [flowfrontfit] = fit_flowfront( perm )
%
% Input:    perm         - a set of permeabilities in a vector in following format
%                          (Note that the unit of input permeability should be m^2):
%                         1st row: effective numerical permeabilities in 0 orientation
%                         2nd row: effective numerical permeabilities in 90 orientation
%                         3nd row: effective numerical permeabilities in 45 orientation                       
%
% Output:   flowfrontfit - structure that defines the best fit to an ellipse
%                          a           - sub axis (radius) of the X axis
%                          b           - sub axis (radius) of the Y axis
%                          phi         - orientation in radians of the ellipse
%                          X0          - center at the X axis of ellipse
%                          Y0          - center at the Y axis of ellipse 
%                          status      - status of detection of an ellipse
%
% Note:     if an ellipse was not detected (but a parabola or hyperbola), then
%           an empty structure is returned



%% Permeability einlesen
x_p_2 = [perm(1,:), zeros(size(perm(2,:))), perm(3,:)*sin(pi/4)]';
y_p_2 = [zeros(size(perm(1,:))), perm(2,:), perm(3,:)*sin(pi/4)]';

perm = perm.^0.5;
x = perm(1,:);
y = perm(2,:);
xy = sin(pi/4)*perm(3,:);
x_p = [x, zeros(size(y)), xy, -x, zeros(size(y)), -xy]';
y_p = [zeros(size(x)), y, xy, zeros(size(x)), -y, -xy]';

%% Ellipsenregression "fit_ellipse"
flowfrontfit = fit_ellipse(x_p, y_p);
ParGF = [flowfrontfit.X0;flowfrontfit.Y0;flowfrontfit.a^0.5;flowfrontfit.b^0.5;flowfrontfit.phi];

%% Plot
figure(1)
subplot(2,2,1)
hold on
axis equal
title('Ellipse fit')
plot(x_p_2, y_p_2, 'ko')
plot_ellipse(ParGF(1,1),ParGF(2,1),ParGF(3,1)^2,ParGF(4,1)^2,ParGF(5,1)*180/pi,'-r');
grid on
box on

end