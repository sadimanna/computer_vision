function imgwxy = calcimgxy(W0,sigmaI,sigmaD)
  Lwy = [-1,0,1]'*fspecial('gaussian',[1 3],sigmaD);
  Lwx = fspecial('gaussian',[3 1],sigmaD)*[-1,0,1];
  gw = fspecial('gaussian',[3 3],sigmaI);
  imgwx = conv2(W0,Lwx,'same');
  imgwy = conv2(W0,Lwy,'same');
  imgwxy = imgwx.*imgwy;
  imgwxy = conv2(imgwxy,gw,'same');
endfunction