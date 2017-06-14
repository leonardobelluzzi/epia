classdef KFoldCrossValidation
    %K-Fold Cross Validation
    %Classe para executar a cross validation por meio do K-Fold
    properties
        K;
        MLP;
        DataLocation;
    end
    
    methods
        function obj = KFoldCrossValidation(k, mLP, dataLocation)
            obj.K = k;
            obj.MLP = mLP;
            obj.DataLocation = dataLocation;
        end
        
        function ExecuteCrossValidation(obj, alpha, alphaDecai, erroMin, maxEpocas)
            
            %-----------Pegar os arquivos de entrada e dividir entre os K folds
            files = dir(obj.DataLocation);%Pegar todos os arquivos da pasta especificada
            numFiles = size(files, 1) - 2;%Remover as duas pastas padroes que sempre vem junto
            usedFiles = zeros(numFiles);
            fold = 1;
            r = randi([1 numFiles],1,2*numFiles);
            Folds = strings(obj.K, round(numFiles/obj.K) + 1);%Inicializacao dos folds
            for i = 1:numFiles
                file = r(i);%Pegar um arquivo aleatoriamente
                while usedFiles(file) ~= 0 || files(file).isdir == 1%Verificar se e uma pasta ou se ja foi usado
                    file = file + 1;%ir para o proximo arquivo
                    if(file > numFiles + 2)%verificar se passou o tamanho do vetor de arquivos
                        file = 1;%voltar para o primeiro arquivo
                    end
                end
                Folds(fold, round(i/obj.K) + 1) = (strcat(files(file).folder,'\',files(file).name));%atribuir o arquivo para um dos K folds
                usedFiles(file) = 1;%marcar o arquivo como ja usado
                fold = mod((fold+1), obj.K) + 1;%deixar o proximo fold a espera de um arquivo
            end
            
            %-----------Inicializacao de variaveis para guardar valores de erro
            Erros = obj.K;
            ErroMedio = 0;
            
            %-----------Executar o K-Fold Cross Validation
            fileID = fopen('error.txt', 'w');
            fprintf(fileID, strcat("Execucao em: ", datestr(now), "\r\n"));
            for i = 1:obj.K%i corresponde ao fold que sera usado para testar a rede
                
                fprintf(fileID, strcat(num2str(i-1), ";"));
                obj.MLP = Treinar(obj.MLP, Folds, i,maxEpocas,alpha,alphaDecai,erroMin,obj.K, fileID);%se nao for o fold de teste, treina a rede com os seus dados de entrada
                Erros(i) = Teste(obj.MLP, Folds, i);%testa a rede contra o fold de teste
                ErroMedio = Erros(i) + ErroMedio;%guardar erro
                fprintf(fileID, strcat(num2str(ErroMedio),'\r\n'));
                
            end
            fclose(fileID);
            %-----------Calculo da media e desvio padrao
            ErroMedio = ErroMedio / obj.K;
            DesvioPadrao = 0;
            for i = 1:obj.K
                DesvioPadrao = DesvioPadrao + ((ErroMedio-Erros(i))^2);
            end
            DesvioPadrao = DesvioPadrao/obj.K;
            DesvioPadrao = DesvioPadrao^(1/2);
            
            %-----------Geracao dos arquivos
            
            fileID1 = fopen('config.txt', 'w');
            fprintf(fileID1,strcat("Execucao em: )", datestr(now), "\r\nMLP_SPECIFICATION: (\'layer 0', ", num2str(obj.MLP.p), ", 'sigmoid', 'mse')\r\n"));
            fprintf(fileID1,strcat("MLP_SPECIFICATION: (\'layer 1', ", num2str(obj.MLP.k), ", 'sigmoid', 'mse')\r\n"));
            Decai = num2str(alphaDecai);
            if(alphaDecai == 1)
                Decai = "FIX";
            end
            fprintf(fileID1,strcat("MLP_OPERATION_ETA_METHOD : ", Decai, "\r\n"));
            fprintf(fileID1,strcat("MLP_OPERATION_ETA_PARAMS : ", num2str(alpha), "\r\n"));
            fprintf(fileID1,strcat("MLP_OPERATION_ETA_INITIALISATION : ", '???', "\r\n"));
            fprintf(fileID1,strcat("MLP_OPERATION_MAX_EPOCHS : ", num2str(maxEpocas), "\r\n"));
            fprintf(fileID1,strcat("MLP_OPERATION_MIN_EPOCHS : ", "1", "\r\n"));
            fprintf(fileID1,strcat("MLP_OPERATION_STOP_WINDOW : ", num2str(erroMin), "\r\n"));
            fclose(fileID1);
            
            fileID2 = fopen('model.dat', 'w');
            fprintf(fileID2,strcat("entrada: ",num2str(obj.MLP.n),"\r\n"));
            fprintf(fileID2,strcat("escondida: ",num2str(obj.MLP.p),"\r\n"));
            fprintf(fileID2,"\t%d\r\n",(obj.MLP.pesoEscondida));
            fprintf(fileID2,strcat("saida: ",num2str(obj.MLP.k),"\r\n"));
            fprintf(fileID2,"\t%d\r\n",(obj.MLP.pesoSaida));
            fclose(fileID2);
        end
    end
    
end

