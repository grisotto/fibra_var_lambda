%% Analise modal de um sensor SMS com fibra GRIN afinada.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%  Calculo SMF + GRIN %%%%%%%%%%%%%%%%%%%%%%%%%% 
% HISTORICO
%  06/08/2013 se faz uso do comando mphload, que tem algumas vantagens
%             sobre carregar o arquivo .m , entre elas esta a de nao ter
%             arquivos duplicados e a deshabilitacao automatica do
%             historico.
%  09/08/2013 Se guarda a1?? e a2?? em vez de a1 e a2. Tambem se guarda
%             deltaBetas em vez de beta1 e beta2.
%  18/18/2013 Varias correcoes foram feitas por causa das interfazes que
%             sao escaladas cada vez que M muda. Para monitorar isto, foi criada uma
%             rotina `muestraMateria` que mostra a distribuicao de indice de refracao
%             cada vez que M muda.
%  18/18/2013 Agora sao calculadas duas projecoes para os modos de alta ordem para 
%			  poder estudar qual e o seu efeito na distribuicao de potencia.
%				a2: LP01 -> LP02 (esta projecao nao faz sentido para um taper adiabatico, segundo Brambilla em seu review de tapers.
%       		a2p: LP02 -> LP02
%  31/10/2013 No calculo de aa1 e aa2, agora usa-se projecao*conj(projecao) 
%             em vez de projecao^2 
%  19/11/2013 Guardo uma figura .fig do grafico Fractional_Modal_Power vs lambda             
%  19/12/2013 Varias mudan??as feitas para melhorar o uso da memoria.

clc
clear
close all
casa = '/Users/paulogomestl/Documents/Dropbox/Profissional/Jatai/2014/Pesquisa/Grisotto/Comsol/2014/05_Maio/4Paulo';
%%%%% Importa
ModelUtil.clear()
model = mphload(fullfile(casa,'TripathiModel_v43b.mph'));
%%%% Calculo
tic
diary('diary_tripathi')
fprintf('>>>>>>>>>>>>>> Calculo SMF + GRIN <<<<<<<<<<<<<<\n');
%   constantes
integrand = 'conj(data1(emw.Ex))*data2(emw2.Ex)+conj(data1(emw.Ey))*data2(emw2.Ey)+conj(data1(emw.Ez))*data2(emw2.Ez)';
neigs = length(mphglobal(model,'emw.beta'));
fase = '0';
model.param.set('fase',fase);
limiar = 0.1;
%
lmbs = 0.7:0.02:1.6;

ll = length(lmbs);
next=1;
lN = length(next);
M = 1;% neste modelo M sempre sera igual a 1. So GRINt (no outro script, vai ser escalado)
lM = length(M);
%
% Ponto de troca de fibra SMF
[~,troca]=sort(abs(lmbs-0.98));
troca=troca(1);
%
posLP02 = 2; % posicao do modo LP02 nos resultados;
dimChute = 3;% dimensao dos vetores onde sao guardados os chutes.

%   loop
for contN = 1:lN
    
    fprintf(['========= next = ' num2str(next(contN)) ' ==========\n']);
    model.param.set('next',next(contN));
    clear projecao chuteG normaG
    
    chuteM = zeros(1,dimChute);
    % nao precisa de chuteN porque quando N cambia o diametro e muito grande e
    
    for contM = 1:lM
        fprintf(['======= M = ' num2str(M(contM)) ' ========\n']);
        if contM == 1
            chuteM(dimChute) =  1.483666; % chute para lambda = 0.7um e M=1, modo fdtal.
% 
            chuteS = 1.4578;% chute para FS-V, lambda=1.1um e M=0.12, modo fdtal.
            model.param.set('chuteS',chuteS);
        end
        
        chuteG = zeros(1,dimChute);% reinicia chuteG a cada loop de M
        chuteG(dimChute) = chuteM(dimChute); % inicializa chuteG
        
        for contL = 1:ll
            
% En Tripathi JLT2009 nunca se cambia la fibra. Esto es mas para el
% experimento de Claudecir.
%
%             % troca fibra?
%             if contL==1 && lmbs(contL)<lmbs(troca)
%                 % Modela uma FS-V
%                 model.param.set('dCore','4[um]');
%                 fprintf('Usando fibra monomodo FS-V\n');
%             elseif contL==troca
%                 % Modela uma SMF28
%                 model.param.set('dCore','8.2[um]');
%                 fprintf('Troca para fibra monomodo SMF28\n');
%             end
            
            %   calcula para o proximo lambda
            fprintf(['Calcula os modos para lambda = ' num2str(lmbs(contL),6) '\n']);
            model.param.set('lamb',lmbs(contL));
            model.param.set('chuteG',chuteG(dimChute));
            model.study('std1').run()

            % Mostra a distribuicao do indice refrativo
            if contL == 1 || contL == 2
                label = ['Next=' num2str(next(contN),5) ' ~ M=',num2str(M(contM)),' ~ \lambda=',num2str(lmbs(contL),5),'\mum'];
                nome = [ 'Materia_SMF_GRIN_Next=' num2str(next(contN),'%.5f') '_M=' num2str(M(contM),'%.2f') '_lmb=' num2str(lmbs(contL),'%.4f') ];% nome do arquivo
                muestraMateria(model,label,nome);
                clear nome label
            end
%
            % calcula a potencia no nucleo do modo LP02 , pq o modo LP02? e
            % nao o LP01?
            nucleoLP02 = mphinterp(model,'emw.Poavz','dataset','dset1','solnum',posLP02,'CoordErr','on','coord',[0; 0])/mphmax(model,'emw.Poavz','surface','dataset','dset1','solnum',posLP02);
%             
%             if M(contM) > 0.1
%                 limiar = 1e10;
%             else
%                 limiar = 1e9;
%             end
            
            if nucleoLP02 < limiar
                warning(['Potencia dentro do nucleo para o modo ' num2str(posLP02) ' igual a ' num2str(nucleoLP02,'%.3e') '\n' ]);
                nome = [ 'buscaLPs_SMF_GRIN_Next=' num2str(next(contN),'%.5f') '_M=' num2str(M(contM),'%.3f') '_lmb=' num2str(lmbs(contL),'%.4f') ];% nome do arquivo
%                 posLP02 = buscaLP02( model, 'dset1', [0 1e-7], posLP02, limiar, neigs, nome, true );
                posLPs = buscaLPs( model, 'dset1', [0 0], M(contM), 2, limiar, neigs, nome );
                posLP02 = posLPs(2);
                clear nome posLPs
            end
            
            %   guarda uma imagem dos modos selecionados
           % label = ['Next=' num2str(next(contN),5) ' ~ M=',num2str(M(contM)),' ~ \lambda=',num2str(lmbs(contL),5),'\mum'];
            %nome = [ 'Fibra3_SMF_GRIN_Next=' num2str(next(contN),'%.5f') '_M=' num2str(M(contM),'%.3f') '_lmb=' num2str(lmbs(contL),'%.4f') ];% nome do arquivo
            %guardaImagem(model,1,[ 1 3 ],{'pg2' 'pg1' 'pg1'},[ neigs posLP02 neigs ],label,nome,2);
            
            %   calcula a1
            flag1 = true;
            flag2 = true;
            while flag1
                model.result.dataset('join1').set('solnum', neigs);
                model.result.dataset('join1').set('solnum2', neigs);
                projecao = mphint2(model,integrand,'surface','dataset','join1');
                % en la normalizacion la raiz va por fuera de la integral. Ver
                % sec. E.B.1. Overlap Integrals del Manual Rsoft CAD
                normaG = mphint2(model, 'emw.normE^2','surface','solnum',neigs,'dataset','dset1');% norma ao quadrado
                normaS = mphint2(model, 'emw2.normE^2','surface','solnum',neigs,'dataset','dset2');% norma ao quadrado
                aa1 = projecao*conj(projecao)/(normaG*normaS);% a1^2
                clear projecao normaG normaS
                if aa1 < 0.5
                    assert(flag2,'Ja mudou de fase duas vezes e aa1 segue sendo muito baixo');
                    if strcmp(fase,'0')
                        fase = '90';
                    elseif strcmp(fase,'90')
                        fase = '0';
                    else
                        error('O parametro fase eh um valor diferente a 0 e 90 deg.');
                    end
                    fprintf(['A fase do dset2 eh agora igual a ' fase '.\n']);
                    model.param.set('fase',fase);
                else
                    flag1 = false; % aa1 has a reasonable value, then stop while
                end
                flag2 = false; % flag2 = false indica que j?? mudou uma vez de fase. Se isso nao dar certo, deve mostrar uma mensagem de erro.
            end
            
            %     fprintf(['A projecao eh igual a : ' num2str(projecao) '\n']);
            %     fprintf(['A normaG eh igual a: ' num2str(normaG) '\n']);
            %     fprintf(['A normaS eh igual a: ' num2str(normaS) '\n']);
            fprintf(['a1^2 = ' num2str(aa1) '\n']);
            
            %   calcula a2 (proje??ao dos modos LP01-LP02 da SMF para a GRIN
            model.result.dataset('join1').set('solnum', posLP02);
            model.result.dataset('join1').set('solnum2', neigs);
            projecao = mphint2(model,integrand,'surface','dataset','join1');
            normaG = mphint2(model, 'emw.normE^2','surface','solnum',posLP02,'dataset','dset1');% norma ao quadrado
            normaS = mphint2(model, 'emw2.normE^2','surface','solnum',neigs,'dataset','dset2');% norma ao quadrado
            aa2 = projecao*conj(projecao)/(normaG*normaS);% a2^2
            fprintf(['a2^2 = ' num2str(aa2) '\n']);
            clear projecao normaG normaS
            
            %   guarda betas e neffs
            betas = mphglobal(model,'emw.beta','Dataset','dset1');
            neffs = mphglobal(model,'emw.neff','Dataset','dset1');
            
            betas1 = betas(neigs);
            betas2 = betas(posLP02);
            
            deltaBetas = (betas1 - betas2)*1e-6;% betas esta em metros, passamos a um
            
            deltaNeff = neffs(neigs)-neffs(posLP02);
            clear betas betas1 betas2 neffs
            
            % atualiza chuteG
            chuteG(dimChute) = mphglobal(model,'emw.neff','dataset','dset1','solnum',neigs);
            % atualiza chuteM
            if contL == 1
                chuteM(dimChute) = chuteG(dimChute);
            end
            % calcula o proximo chute
            if contL~=ll
                if contL > dimChute
                    pos0 = contL - dimChute + 1;
                else
                    pos0 = 1;
                end
                chuteG(1) = calculaChute(lmbs(pos0:contL),chuteG,lmbs(contL+1));
                chuteG = circshift(chuteG,[0 -1]);
            end
            
            %Cria o arquivo de registro junto com uma explicacao nas primeras linhas.
            if contL == 1
                nomeR = fullfile( ['resultadosSMF_GRIN_Next=' num2str(next(contN),'%.5f') '_M=' num2str(M(contM),'%.3f'),'.txt']);
            end
            dados = [lmbs(contL); aa1; aa2; deltaBetas; deltaNeff]';
            cabeca = 'lambda\t\t\t\t A1^2\t\t\t\t A2^2\t\t\t\t deltaBetas\t\t\t deltaNeff';
            guardaResultados(nomeR,dados,M(contM),next(contN),ll,cabeca);
            clear cabeca dados aa1 aa2 deltaBetas deltaNeff
            
        end % fim do contL
        %
        dados = dlmread(nomeR,'\t',3,0);
        
        % (a1^2,a2^2) vs lambda
        figure(3+contN)
        clf
        hold on
        plot(lmbs,dados(:,2),'r')
        plot(lmbs,dados(:,3),'b')
        hold off
        box on
        xlabel('Wavelength [\mum]')
        ylabel('Modal Power')
        title(['M=', num2str(M(contM)),' e next=', num2str(next(contN))]);
        legend('A1^2','A2^2');
        saveas(gcf,['imagem/modal_power_SMF_GRIN_next=' num2str(next(contN),'%.5f') '_M=' num2str(M(contM),'%.3f'),'.fig']);
        
        clear nomeR dados
        
        % calcula o proximo chute
        if contM ~= lM
            if (contM - dimChute + 1 > 0)
                pos0 = contM - dimChute + 1;
            else
                pos0 = 1;
            end
            chuteM(1) = calculaChute(M(pos0:contM),chuteM,M(contM+1));
            chuteM = circshift(chuteM,[0 -1]);
        end
                
    end % fim do M
end % fim do Next
tempo = toc;
fprintf('Tempo decorrido: %dh:%dm:%2.2fs\n',floor(tempo/60/60),floor(mod(tempo/60,60)),mod(tempo,60))

diary off
