function [X Y] = calculateEllipse(xa, ya, a, b, angle, steps)
    %# This functions returns points to draw an ellipse
    %#
    %#  @param x     X coordinate
    %#  @param y     Y coordinate
    %#  @param a     Semimajor axis
    %#  @param b     Semiminor axis
    %#  @param angle Angle of the ellipse (in degrees)
    %#

    error(nargchk(5, 6, nargin));
    if nargin<6, steps = 36; end

    beta = angle * (pi / 180);
    sinbeta = sin(beta);
    cosbeta = cos(beta);

    delta = linspace(0, 360, steps)' .* (pi / 180);
    sindelta = sin(delta);
    cosdelta = cos(delta);

    X = xa + (a * cosdelta * cosbeta - b * sindelta * sinbeta);
    Y = ya + (a * cosdelta * sinbeta + b * sindelta * cosbeta);

    if nargout==1, X = [X Y]; end
end

