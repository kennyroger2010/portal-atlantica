export interface Titulos {
    data: TituloItem[];
    total: number;
}

export interface TituloItem {
    E1_PREFIXO?: string;
    E1_NUM?: string;
    E1_PARCELA?: string;
    E1_TIPO: string;
    E1_NATUREZ?: string;
    ED_DESCRIC?: string;
    E1_EMISSAO?: string;
    E1_VENCREA?: string;
    E1_VALOR?: number;
    E1_SALDO?: number;
}
