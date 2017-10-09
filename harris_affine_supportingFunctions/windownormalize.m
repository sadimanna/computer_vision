function window = windownormalize(window)
  maxval = max(max(window));
  minval = min(min(window));
  rangeval = maxval-minval;
  window = ((window-minval)*255)/rangeval;
endfunction
