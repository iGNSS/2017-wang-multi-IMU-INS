function v = cdiff(x,dt)

    % Fourth order central finite difference
    v = zeros(size(x,1),3);
    for i = 3:size(x,1)-2
        v(i,:) = (-x(i+2,:)+8*x(i+1,:)-8*x(i-1,:)+x(i-2,:))/(12*dt);
    end
