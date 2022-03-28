function [hat_y] = runOGD_general(Y,X,Opt,id_list)

model.w      = zeros(1,size(X,2));
model.alpha  = Opt.alpha;
model.window = Opt.windows;
model.step   = Opt.lambda;
model.t      = 1;
model.gd     = zeros(model.window,size(X,2));


for t = 1:length(id_list)
    
    ID  = id_list(t);
    x_t = X(ID,:);
    y_t = Y(ID);
    [model, hat_y_t] = tsOGD_general(y_t, x_t, model);
    hat_y(t) = hat_y_t;
    
end
hat_y = hat_y';