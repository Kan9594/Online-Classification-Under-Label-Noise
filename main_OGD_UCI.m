clear all
addpath(genpath('.'));


%% Load Data
FileName = 'bc_mushroom';
load([FileName,'.mat'])
X = data;
Y = labels;
MissLabelIndex = 1:5:length(Y);%20% symmetric noise labels

%% Options
Options.alpha   = 'Adapt';%alpha<=0,
Options.windows = 5;
Options.lambda  = 0.3;


%% Run
for iter = 1:10
    id_list = randperm((length(Y)));
    X_iter = X(id_list,:);
    Y_iter = Y(id_list);
    Y_iter(MissLabelIndex) = -Y_iter(MissLabelIndex);
    X_iter = NormalizeData(X_iter,1);
    
    %% Online Learning
    tic
    Predict_R = runOGD_general(Y_iter,X_iter,Options,1:length(Y_iter));
    RUMTIME(iter) = toc;
    
    %% Result
    Y_iter(MissLabelIndex) = [];%only predict correct samples
    Predict_R(MissLabelIndex) = [];
    ConMat = cfmatrix(Y_iter,Predict_R);
    [RPA.AUC(iter),auc_x,auc_y] = plot_roc(Predict_R, Y_iter);
    RPA.ACC(iter) = sum(Y_iter==Predict_R)/length(Y_iter);
    RPA.PRE(iter) = ConMat(2,2)/(ConMat(2,2)+ConMat(2,1));
    RPA.RECALL(iter) = ConMat(2,2)/(ConMat(2,2)+ConMat(1,2));
    RPA.F(iter) = 2*RPA.PRE(iter)*RPA.RECALL(iter)/(RPA.PRE(iter)+RPA.RECALL(iter));
    RPA.GMEANS(iter) = sqrt((ConMat(1,1)/(ConMat(1,1)+ConMat(2,1)))*(ConMat(2,2)/(ConMat(2,2)+ConMat(1,2))));

end
R.r(1,:) = [mean(RPA.ACC), mean(RPA.PRE),mean(RPA.RECALL),mean(RPA.F),mean(RPA.AUC),mean(RPA.GMEANS)];
R.r(2,:) = [std(RPA.ACC), std(RPA.PRE),std(RPA.RECALL),std(RPA.F),std(RPA.AUC),std(RPA.GMEANS)];


fprintf(1,'Acc=%f, Pre=%f, Recall=%f, F=%f, AUC=%f GMEANS=%f \n', R.r(1,1:6));
fprintf(1,'+/-%f, +/-%f, +/-%f, +/-%f, +/-%f +/-%f\n', R.r(2,1:6));


