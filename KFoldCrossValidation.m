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
            for i = 1:obj.K%i corresponde ao fold que sera usado para testar a rede
                Treinar(obj.MLP, Folds, i,maxEpocas,alpha,alphaDecai,erroMin,obj.K);%se nao for o fold de teste, treina a rede com os seus dados de entrada
                Erros(i) = Teste(obj.MLP, Folds, i);%testa a rede contra o fold de teste
                ErroMedio = Erros(i) + ErroMedio;%guardar erro
            end
            
            %-----------Calculo da media e desvio padrao
            ErroMedio = ErroMedio / obj.K;
            DesvioPadrao = 0;
            for i = 1:obj.K
                DesvioPadrao = DesvioPadrao + ((ErroMedio-Erros(i))^2);
            end
            DesvioPadrao = DesvioPadrao/obj.K;
            DesvioPadrao = DesvioPadrao^(1/2);
            
            %-----------Geracao do log
            fileID = fopen('log.txt', 'w');
            fprintf(fileID, strcat('Alpha: ',num2str(obj.MLP.alpha)));
            fprintf(fileID, '\r\n');
            fprintf(fileID, strcat('Decaimento do Alpha: ',num2str(obj.MLP.alphaDecai)));
            fprintf(fileID, '\r\n');
            fprintf(fileID, strcat('Descritor: HOG'));
            fprintf(fileID, '\r\n');
            fprintf(fileID, strcat('Média dos erros: ',num2str(ErroMedio)));
            fprintf(fileID, '\r\n');
            fprintf(fileID, strcat('Desvio Padrão dos erros: ',num2str(DesvioPadrao)));
            fprintf(fileID, '\r\n');
            fclose(fileID);
        end
    end
    
end

