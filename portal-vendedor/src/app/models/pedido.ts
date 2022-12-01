export interface Pedidos {
    data: PedidoItem[];
    total: number;
}

export interface PedidoItem {
    C5_FILIAL?: string;
    C5_NUM: string;
    C5_EMISSAO: string;
    C5_CONDPAG: string;
    E4_DESCRI: string;
    C5_CLIENTE: string;
    C5_LOJACLI: string;
    A1_NOME?: string;
    A1_NREDUZ?: string;
    A1_MUN?: string;
    A1_EST?: string;
    produtos: Produto[];
}

export interface Produto {
    C6_ITEM?: string;
    C6_PRODUTO?: string;
    C6_DESCRI?: string;
    C6_UM?: string;
    C6_QTDVEN?: number;
    C6_PRCVEN?: number;
    C6_VALOR?: number;
    C6_TES?: string;
    C6_CF?: string;
    AUTDELETA?: string;
}
