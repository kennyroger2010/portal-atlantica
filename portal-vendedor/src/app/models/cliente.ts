export interface Clientes {
  data: ClienteItem[];
  total: number;
}

export interface ClienteItem {
  A1_FILIAL?: string;
  A1_COD: string;
  A1_LOJA?: string;
  A1_NOME: string;
  A1_NREDUZ?: string;
  A1_PESSOA?: string;
  A1_END?: string;
  A1_BAIRRO?: string;
  A1_TIPO?: string;
  A1_EST?: string;
  A1_MUN?: string;
}