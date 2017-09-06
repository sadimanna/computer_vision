function xwk = spatialloc(xw,sigmaI,sigmaD,W0)
  %disp('spatialloc')
  xw = xw;
  si = sigmaI;
  sd = sigmaD;
  W = W0;
  R = harrismeasure_spatloc(W,si,sd);
  R = R(2:4,2:4);
  maxR = max(R);
  maxRx = ceil(maxR/3)-2;
  maxRy = mod(maxR,3)-2;
  xwk = [maxRx+xw(1);maxRy+xw(2)];
endfunction