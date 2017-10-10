function imgwyy = calcimgyy(W,sigmaI,sigmaD)
  [~,Lwy] = gradient(fspecial('gaussian',5,sigmaD));
  gw = fspecial('gaussian',5,sigmaI);
  imgwy = conv2(W,Lwy,'same');
  imgwyy = imgwy.^2;
  imgwyy = conv2(imgwyy,gw,'same');
end
