function [clusterCenters, clusters] = Kmeans(X,k)
rw = size(X,1);
cl = size(X,2);
figure
ax = gca;
hldRndPos = randperm(rw);
startPos = hldRndPos(1:k);
theMeans = X(startPos,:);
posCloserToMean{1,k} = [];
mx = 100;
hardMax = 1000;
totalMinDist = 10^50;
ct = 0;
hardCt = 0;
sm = [];
colList = {'r','b','k','m','c','g',[0.4,0.8,0.1],[0.1,0.7,0.9],[0.4,0.1,0.9],[0.5,0.2,0.5],[0.6,0.7,0.1],[0.0,0.5,0.9],[0.9,0.7,0.1],[0.4,0.2,0.6],[0.9,0.67,0.99],[0.34,0.12,0.2],[0.56,0.32,0.6],[0.8,0.31,0.189]};
while hardCt<=hardMax && ct <= mx
    hardCt = hardCt + 1;
    ct = ct + 1;
    tempSumDist = 0;
    theSDs = zeros(1,k);
    posCloserToMean = {};
    posCloserToMean{1,k} = [];
    for h = 1:rw;
        aSet = repmat(X(h,:),k,1);
        theDist = EuclidDistance(theMeans,aSet);
        [minVal,minPos] = min(theDist);
        tempSumDist = tempSumDist + minVal;
        posCloserToMean{minPos} = [posCloserToMean{minPos},h];
        theSDs(minPos) = theSDs(minPos)+minVal^2;
    end
    sm = [sm,tempSumDist];
    % Checking convergence condition
    
    % Re-computing the means
    hold on
    cttt = 0;
    for t = 1:k;
        oneSet = X(posCloserToMean{t},:);
        if ~isempty(oneSet) && cl==2
            lastMn = theMeans(t,:);
            
            cttt = cttt + 1;
            hplot(cttt) = plot(ax,oneSet(:,1),oneSet(:,2),'*','color',colList{t},'linewidth',2,'markersize',5);
            cttt = cttt + 1;
            hplot(cttt) = plot(ax,lastMn(1),lastMn(2),'o','color',colList{t},'linewidth',2,'markerfacecolor','y','markeredgecolor',colList{t},'markersize',8);
        elseif ~isempty(oneSet) && cl==3
            lastMn = theMeans(t,:);
            cttt = cttt + 1;
            hplot(cttt) = plot3(ax,lastMn(1),lastMn(2),lastMn(3),'o','color',colList{t},'linewidth',2,'markerfacecolor',colList{t},'markersize',9);
            cttt = cttt + 1;
            hplot(cttt) = plot3(ax,oneSet(:,1),oneSet(:,2),oneSet(:,3),'o','color',colList{t},'linewidth',2,'markersize',5);
        end
        
        theMeans(t,:) = mean(oneSet);
        lt = size(oneSet,1);
        if lt>0
            theSDs(t) = sqrt(theSDs(t)/lt);
        end
    end
    hold off
    if cl == 3
        view(-60,30)
        grid on
    end
    pause(0.1)
    theSDs = theSDs + eps;
    % Checking if any mean has no element and then refreshing the process
    if any(isnan(theMeans))
        hldRndPos = randperm(rw);
        startPos = hldRndPos(1:k);
        theMeans = X(startPos,:);
        posCloserToMean = {};
        posCloserToMean{1,k} = [];
        totalMinDist = 10^50;
        ct = 0;
        sm = [];
        cla(gca);
    elseif totalMinDist==tempSumDist
        break;
    else
        totalMinDist = tempSumDist;
        cla(gca);
    end
        
end

if hardCt >= hardMax
    warning('The K-Mean Algorithm failed to generate k means.');
end
figure
plot(1:length(sm),sm)

clusterCenters = theMeans;
clusters = posCloserToMean;

function ret = EuclidDistance(pos1,pos2)
ret = sqrt(sum((pos1-pos2).^2,2));

