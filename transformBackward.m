function transformedPoints = transformBackward(img_points,A)
    iA=inv(A);
    transformedPoints = [(iA(1,1:2)*img_points'+iA(1,3))./(iA(3,1:2)*img_points'+iA(3,3));...
        (iA(2,1:2)*img_points'+iA(2,3))./(iA(3,1:2)*img_points'+iA(3,3))]';
end