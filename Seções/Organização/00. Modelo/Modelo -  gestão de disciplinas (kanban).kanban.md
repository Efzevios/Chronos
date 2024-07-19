## A fazer
- 00. Modelo  
  > [!cite] Chronos, um guia (quase) perfeito
  > # índice
  >  > [!example] Partes
  >  
  > > [!Info] Sobre o livro
  ´´´
  function matrizEisenhower(tarefas) {
      const quadrantes = {
          importanteUrgente: [],
          importanteNaoUrgente: [],
          naoImportanteUrgente: [],
          naoImportanteNaoUrgente: []
      };
  
      tarefas.forEach((tarefa) => {
          const { importante, urgente } = tarefa;
          if (importante && urgente) {
              quadrantes.importanteUrgente.push(tarefa);
          } else if (importante) {
              quadrantes.importanteNaoUrgente.push(tarefa);
          } else if (urgente) {
              quadrantes.naoImportanteUrgente.push(tarefa);
          } else {
              quadrantes.naoImportanteNaoUrgente.push(tarefa);
          }
      });
  
      return quadrantes;
  }
  
  // Exemplo de uso:
  const tarefas = [
      { descricao: 'Responder e-mails importantes', importante: true, urgente: true },
      { descricao: 'Estudar para o exame final', importante: true, urgente: false },
      { descricao: 'Fazer compras no mercado', importante: false, urgente: true },
      { descricao: 'Assistir a série de TV', importante: false, urgente: false }
  ];
  
  const resultado = matrizEisenhower(tarefas);
  console.log('Importante e urgente:', resultado.importanteUrgente);
  console.log('Importante, mas não urgente:', resultado.importanteNaoUrgente);
  console.log('Não importante, mas urgente:', resultado.naoImportanteUrgente);
  console.log('Não importante e não urgente:', resultado.naoImportanteNaoUrgente);
  ´´´
  

## Feito

## Fazendo