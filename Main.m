mlp = MLP();
kFold = KFoldCrossValidation(5,mlp,'C:\Users\raulg\OneDrive\Documentos\GitHub\epia\IA');
ExecuteCrossValidation(kFold,0.0001,1,0.01,100);