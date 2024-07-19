## A fazer
- 00. Modelo  
  > [!cite] Chronos, um guia (quase) perfeito
  > # índice
  >  > [!example] Partes
  >  
  > > [!Info] Sobre o livro
  >
  > ```
  <iframe
    src="
  <!DOCTYPE html>
  <html lang="pt-br">
  <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=10">
      <title>Taxa de Cumprimento</title>
  </head>
  <body>
      <table border="4444">
          <tr>
              <th>Total</th>
              <th>Cumprido</th>
              <th>Taxa de Cumprimento</th>
          </tr>
          <tr>
              <td contenteditable="true" id="total">100</td>
              <td contenteditable="true" id="cumprido">75</td>
              <td id="taxa"></td>
          </tr>
      </table>
      <script>
          const totalCell = document.getElementById('total');
          const cumpridoCell = document.getElementById('cumprido');
          const taxaCell = document.getElementById('taxa');
          function calcularTaxa() {
              const total = parseFloat(totalCell.innerText);
              const cumprido = parseFloat(cumpridoCell.innerText);
              if (!isNaN(total) && !isNaN(cumprido)) {
                  const taxa = (cumprido / total) * 100;
                  taxaCell.innerText = `${taxa.toFixed(3)}%`;
              } else {
                  taxaCell.innerText = 'Insira números válidos';
              }
          }
          totalCell.addEventListener('input', calcularTaxa);
          cumpridoCell.addEventListener('input', calcularTaxa);
      </script>
  </body>
  </html>
  "
    style="width:100%;height:auto;aspect-ratio:1/1.4"
    scrolling="no">
  </iframe>
  ```

## Feito

## Fazendo