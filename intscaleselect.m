function scale = intscaleselect(W)
  ki = 1.2;
  scale = [];
  Wlog = [];
  for k=1:10
    sigma = ki^(k-1);
    Wlog(:,:,k) = uint8(abs(conv2(conv2(W,fspecial('gaussian',[3 3],sigma),'same'),fspecial('log',[3 3],sigma),'same')));
  endfor
  logvalvec = [];
  for k=1:10
    logval = Wlog(3,3,k);
    logvalvec = [logvalvec,logval];
  endfor
  for n=2:9
    if logvalvec(n)==max(logvalvec) && logvalvec(n)~=0
      scale = ki^(n-1);
    endif
  endfor
  if length(scale)==0
    scale = 1;
  endif
endfunction
