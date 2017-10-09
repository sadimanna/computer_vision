function transformedImage = transformImageBackWard(img,A)
    iA = inv(A);
    tform = projective2d(iA');
    transformedImage = imwarp(img,tform);
    %imshow(transformedImage)    
end
