function imgwxx = calcimgxx(W,sigmaI,sigmaD)
  %disp('calcimgxx')
  si = sigmaI;
  sd = sigmaD;
  Lwx = gradient(fspecial('gaussian',5,sd));
  gw = fspecial('gaussian',5,si);
  imgwx = conv2(W,Lwx,'same');
  imgwx_x = imgwx.^2;
  imgwxx = conv2(imgwx_x,gw,'same');
end
