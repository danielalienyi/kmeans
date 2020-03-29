% Eaxmple 1
data = load('data.mat');
data = data.data;
k = 4;
clusterCenters = Kmeans(data,k);
disp(clusterCenters)

% Example 2
data = load('data2.mat');
data = data.data;
k = 9;
clusterCenters = Kmeans(data,k);
disp(clusterCenters)

