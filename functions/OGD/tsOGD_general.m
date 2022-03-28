function [model, hat_y_t, gd] = tsOGD_general(y_t, x_t, model)

%--------------------------------------------------------------------------
% Initialization
%--------------------------------------------------------------------------
eta_t     = model.step;%
%--------------------------------------------------------------------------
% Prediction
%--------------------------------------------------------------------------
f_t = model.w*x_t';
if (f_t>=0)
    hat_y_t = 1;
else
    hat_y_t = -1;
end
pmargin = y_t*f_t;%prediction confidence
%--------------------------------------------------------------------------
% Making Update
%--------------------------------------------------------------------------
switch model.alpha
    
    case 'Adapt'
        %% Adapt Alpha
        if pmargin<-0.9||pmargin==-0.9
            model.alpha = -inf;
            tao_t = (pmargin-1)*exp(-0.5*(pmargin-1)^2);
            tao  = eta_t*tao_t;
            gd_t  = tao*y_t*x_t;
            if rem(model.t,model.window)
                model.gd(rem(model.t,model.window),:) = gd_t;
            else
                model.gd(model.window,:) = gd_t;
            end
            model.w = model.w - sum(model.gd,1)/model.window;
        elseif pmargin>1||pmargin==1
            model.alpha = 0;
            pmargin=1;
            tao_t = 2*(pmargin-1)/((pmargin-1)^2+2);
            tao  = tao_t*eta_t;
            gd_t  = tao*y_t*x_t;
            if rem(model.t,model.window)
                model.gd(rem(model.t,model.window),:) = gd_t;
            else
                model.gd(model.window,:) = gd_t;
            end
            model.w = model.w - sum(model.gd,1)/model.window;
        else
            model.alpha = log(-4/(pmargin-3)-1);
            temp_b = ((pmargin-1))^2/abs(model.alpha-2)+1;
            tao_t = (pmargin-1)*temp_b^(0.5*model.alpha-1);
            tao  = eta_t*tao_t;
            gd_t  = tao*y_t*x_t;
            if rem(model.t,model.window)
                model.gd(rem(model.t,model.window),:) = gd_t;
            else
                model.gd(model.window,:) = gd_t;
            end
            model.w = model.w - sum(model.gd,1)/model.window;
        end
        model.alpha = 'Adapt';
    
    case 0
       %% Cauchy
        if pmargin>1
           pmargin=1;
        end
        tao_t = 2*(pmargin-1)/((pmargin-1)^2+2);
        tao  = tao_t*eta_t;
        gd_t  = tao*y_t*x_t;
        if rem(model.t,model.window)
            model.gd(rem(model.t,model.window),:) = gd_t;
        else
            model.gd(model.window,:) = gd_t;
        end
        model.w = model.w - sum(model.gd,1)/model.window;
    case -inf
       %% Welsch
       if pmargin>1
           pmargin=1;
       end
       tao_t = (pmargin-1)*exp(-0.5*(pmargin-1)^2);
       tao  = eta_t*tao_t;
       gd_t  = tao*y_t*x_t;
       if rem(model.t,model.window)
           model.gd(rem(model.t,model.window),:) = gd_t;
       else
           model.gd(model.window,:) = gd_t;
       end
       model.w = model.w - sum(model.gd,1)/model.window;
    
    otherwise
        %% other alpha
        if pmargin>1
            pmargin=1;
        end
        temp_b = (pmargin-1)^2/abs(model.alpha-2)+1;
        tao_t = (pmargin-1)*temp_b^(0.5*model.alpha-1);
        tao  = eta_t*tao_t;
        gd_t  = tao*y_t*x_t;
        if rem(model.t,model.window)
            model.gd(rem(model.t,model.window),:) = gd_t;
        else
            model.gd(model.window,:) = gd_t;
        end
        model.w = model.w - sum(model.gd,1)/model.window;
end


model.t = model.t + 1; % iteration no
%THE END