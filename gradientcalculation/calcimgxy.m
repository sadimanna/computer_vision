function imgwxy = calcimgxy(W,sigmaI,sigmaD)
  [Lwx,Lwy] = gradient(fspecial('gaussian',5,sigmaD));
  gw = fspecial('gaussian',5,sigmaI);
  imgwx = conv2(W,Lwx,'same');
  imgwy = conv2(W,Lwy,'same');
  imgwxy = imgwx.*imgwy;
  imgwxy = conv2(imgwxy,gw,'same');
end
