function xwk = spatialloc(xwkm1,sigmaI,sigmaD,W)
  %disp('spatialloc')
  si = sigmaI;
  sd = sigmaD;
  R = harrismeasure_spatloc(W,si,sd);
  R = R(2:4,2:4);
  maxR = max(max(R));
  if nnz(R==maxR) > 1
      xwk = xwkm1;
  else
    maxRind = find(R==maxR);
    maxRcol = ceil(maxRind/3)-2;
    maxRrow = mod(maxRind,3)-2;
    if maxRrow==-2
        maxRrow=1;
    end
    xwk = [maxRrow+xwkm1(1),maxRcol+xwkm1(2)];
  end
end
