function saida = calculaChute(x, y, xprox, grau, factor)
% calculaChute
% recebe as tres cordenadas (x,y) e extrapola e 
% calcula o chute para a proxima iteracao (xprox).
%
if nargin < 5,
    factor = 0.9999;% supondo que o siguente paso dara um indice efectivo maior.
    if nargin < 4,
        grau = 1;
    end
end
saida = 0;

% dimensoes dos vetores
% dim=length(x);
% assert(dim == length(y),'calculaChute: os primeiros dois argumentos devem ser vetores da mesma dimensao');

% verifica se tem zeros em 'x' e em 'y'
xp = x(find(x,1,'first'):find(x,1,'last'));
yp = y(find(y,1,'first'):find(y,1,'last'));

% dimensoes real dos vetores
dim=length(xp);

assert(dim == length(yp),'calculaChute: x e y nao tem o mesmo numero de zeros');

  % dim0 indica o ponto de partida da interpolacao. Nem sempre eh bom usar
  % todos os pontos. Mais ainda quando a interpolacao eh linear.
  if dim>3 && grau==1
      pos0=dim-2;
  else
      pos0=1;
  end
  % se a quantidade de dados (dim) e' menor que grau+1, entao a
  % interpolacao e feita usando dim-1 
  if dim < grau+1
     if dim == 1
        saida = yp(1)*factor;
     elseif dim > 1
        pol = polyfit(xp(pos0:dim), real(yp(pos0:dim)), dim-1);
        saida=polyval(pol,xprox);
     else
        error(['dim=' num2str(dim) ' nao concorda com as dimensoes esperadas dos vetores de entrada']);
     end
  else
      pol = polyfit(xp(pos0:dim), real(yp(pos0:dim)), grau);
      saida=polyval(pol,xprox)+0.0015;
  end

% DEBUG:
% [~,msgId] = lastwarn;
% if strcmp(msgId,'MATLAB:polyfit:RepeatedPointsOrRescale')
%      fprintf('dim=');disp(dim);
fprintf('chute =');disp(saida);
%     fprintf(['real(x(i))=' num2str(real(x(i))) ...
%         ',\t real(y(i))' num2str(real(y(i))) '\n']);
% end
  
end
