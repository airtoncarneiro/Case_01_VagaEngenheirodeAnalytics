import logging
import requests
import pandas as pd
from itertools import chain




def getDespesasRestAPI()->pd.DataFrame:
   """Faz o GET na página das despesas do Portal da Transparência
      paginando cada grupo de 1000 registros e concatenando-os
      numa lista.

   Returns:
       Dataframe: Da lista gerada retorna seu DataFrame
   """
   url_base = 'https://www.portaldatransparencia.gov.br/'\
         'despesas/recursos-recebidos/resultado?'\
         'paginacaoSimples=true&'\
         'tamanhoPagina={}&'\
         'offset={}&'\
         'direcaoOrdenacao=asc&colunaOrdenacao=mesAno&'\
         'de=01/10/2022&ate=31/10/2022&'\
         'colunasSelecionadas=linkDetalhamento,mesAno,'\
         'favorecido,tipoFavorecido,ufFavorecido,'\
         'municipioFavorecido,orgaoSuperior,orgaoVinculado,'\
         'unidadeGestora,valorRecebido'

   # Por ter mais de 866.100 página (offset)
   # limitei pelas n primeiras páginas.
   # Cada página tem 1.000 registros.

   QTD_DESPESAS_POR_REQUEST = 1000
   LIMITE = 50
   index = 0
   despesas = []
   while True:
      try:
         # chegou no limite para este teste
         if index == LIMITE:
            logging.warning('Atingiu o limite! Saindo...')
            break
         
         iniciar_em = QTD_DESPESAS_POR_REQUEST * index
         url = url_base.format(QTD_DESPESAS_POR_REQUEST, iniciar_em)
         r = requests.get(url=url)
         json_content = r.json()
         
         if r.status_code != 200:
            raise
         # não tem mais registros
         elif json_content['recordsTotal'] == 0:
            logging.info('Fim dos dados. Saindo...')
            break
         
         #dados.append(pd.DataFrame.from_dict(json_content['data']))
         despesas.append(json_content['data'])
         
         index += 1
      except:
         logging.error('Exceção gerada no request!')
         exit(1)

   return pd.DataFrame(list(chain.from_iterable(despesas)))


def salvarDF(df:pd.DataFrame)->None:
   try:
      df.to_csv('despesas.csv', sep='\t', index=False, encoding='utf-8')
   except Exception as err:
      logging.error(err)
      exit(1)



if __name__ == '__main__':
   logging.basicConfig(filename='getDados.log', encoding='utf-8', 
                       level=logging.DEBUG, format='%(asctime)s %(message)s')
   
   df = getDespesasRestAPI()
   salvarDF(df)
   exit(0)
