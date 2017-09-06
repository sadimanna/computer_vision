function imgwyy = calcimgyy(W0,sigmaI,sigmaD)
  Lwy = [-1,0,1]'*fspecial('gaussian',[1 3],sigmaD);
  gw = fspecial('gaussian',[3 3],sigmaI);
  imgwy = conv2(W0,Lwy,'same');
  imgwyy = imgwy.^2;
  imgwyy = conv2(imgwyy,gw,'same');
endfunction