function transformedImage = transformImageForward(img,A)
    tform = affine2d(A');
    transformedImage = imwarp(img,tform);
    %imshow(transformedImage)    
end
