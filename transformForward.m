function transformedPoints = transformForward(img_points,A)
    transformedPoints = [(A(1,1:2)*img_points'+A(1,3))./(A(3,1:2)*img_points'+A(3,3));...
        (A(2,1:2)*img_points'+A(2,3))./(A(3,1:2)*img_points'+A(3,3))]';
end