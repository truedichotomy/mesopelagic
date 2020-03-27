if ~exist('LON')
    load MOCHA_vars.mat
end %if

if ~exist('fishfall')
    fishfall = load('MABfish_fall.mat');
    fishspring = load('MABfish_spring.mat')
end
