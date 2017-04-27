function v = bdiff(x,dt)

    % first order backwards finite difference
    v = zeros(3,size(x,2));
    for i = 2:size(x,2)
        v(:,i) = (x(:,i)+x(:,i-1))./dt;
    end