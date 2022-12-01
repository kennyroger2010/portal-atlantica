export interface Produtos {
    data: ProdutoItem[];
    total: number;
}

export interface ProdutoItem {
    B1_FILIAL?: string;
    B1_COD: string;
    B1_DESC?: string;
    B1_TIPO?: string;
    B1_UM?: string;
    B1_LOCPAD?: string;
    B1_GRUPO?: string;
    B1_PRV1?: number;
    BM_DESC?: string;
}
