function transformedImage = transformImageBackward(img,A)
    iA = inv(A);
    tform = affine2d(iA');
    transformedImage = imwarp(img,tform);
    %imshow(transformedImage)    
end