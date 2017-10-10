function scale = intscaleselect(W)
  sig0 = 1.0;
  ki = 1.2;
  scale = [];
  Wlog = [];
  for k=1:10
    sigma = sig0*ki^(k-1);
    Wlog(:,:,k) = (sigma^2)*imfilter(conv2(W,fspecial('gaussian',5,sigma),'same'),fspecial('log',5,sigma),'replicate','same','conv');
  end
  logvalvec = [];
  for k=1:10
    logval = Wlog(3,3,k);
    logvalvec = [logvalvec,logval];
  end
  for n=2:9
    if logvalvec(n)>logvalvec(n-1) && logvalvec(n)>logvalvec(n+1)
      scale = ki^(n-1);
    end
    if scale ~= max(logvalvec)
        continue
    else
        break
    end
  end
  if isempty(scale)
    scale = 1;
  end
end
