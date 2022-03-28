function RPA = ResultCal(Y_iter,Predict_R,Loss,MissLabelIndex)
Y_iter(MissLabelIndex) = [];
Predict_R(MissLabelIndex) = [];
Num = length(Y_iter);
ConMat = cfmatrix(Y_iter,Predict_R);
RPA(5) = plot_roc(Predict_R, Y_iter);%AUC
RPA(1) = sum(Y_iter==Predict_R)/Num;%ACC
RPA(3) = ConMat(2,2)/(ConMat(2,2)+ConMat(2,1));%precision
RPA(2) = ConMat(2,2)/(ConMat(2,2)+ConMat(1,2));%recall
RPA(4) = 2*RPA(3)*RPA(2)/(RPA(2)+RPA(3));%Fscore
RPA(6) = sqrt((ConMat(1,1)/(ConMat(1,1)+ConMat(2,1)))*(ConMat(2,2)/(ConMat(2,2)+ConMat(1,2))));%Gmeans
RPA(8) = sum(Loss);
RPA(7) = sum(Loss(MissLabelIndex));