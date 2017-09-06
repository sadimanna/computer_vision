%%Feature extraction using BoW
pkg load image
imagepath = "/home/username/octave/image_folder_name/";
file = dir([imagepath,'*.png']);
nframes = length(file);
bow = [];
for i=1:nframes
  img = imread(strcat([imagepath,file(i).name]));
  [h,w,numColor] = size(img);
  if numColor>1
    img = rgb2gray(img);
  endif
  scaleinvpts = harris_laplace(img,i);
  affineinvpts = harris_affine(img,scaleinvpts)
  lenpts = length(scaleinvpts);
  allpts = [scaleinvpts(:,1:2);affineinvpts];
  lenpts = length(allpts);
  for j=1:lenpts
    pt = scaleinvpts(j,:);
    if pt(1)>3 && pt(2)>3 && pt(1)<h-2 && pt(2)<w-2
      W = img(pt(1)-3:pt(1)+3,pt(2)-3:pt(2)+3);
      bow = [bow;calculatehog(W)];
    endif
  endfor
  save -4 bowdata.mat bow
  system('python /home/username/octave/kmeansppclustering.py /home/username/octave/bowdata.mat')
  %%Prepared Dataset
  visual_words = load('/home/username/octave/classified_data.mat','-4')
  
endfor

