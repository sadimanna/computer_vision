function imgwxx = calcimgxx(W0,sigmaI,sigmaD)
  %disp('calcimgxx')
  si = sigmaI;
  sd = sigmaD;
  W = W0;
  Lwx = fspecial('gaussian',[3 1],sd)*[-1,0,1];
  gw = fspecial('gaussian',[3 3],si);
  imgwx = conv2(W,Lwx,'same');
  imgwx_x = imgwx.^2;
  imgwxx = conv2(imgwx_x,gw,'same');
endfunction