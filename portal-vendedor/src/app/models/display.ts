export interface Page {
    title?: string,
    subTitle?: string[],
    navGrid?: string,
    navForm?: string,
    id?: string,
    endpoint?: string,
    action?: string,
    btnInsert?: boolean,
    btnView?: boolean,
    btnEdit?: boolean,
    btnDelete?: boolean,
    btnSelect?: boolean,
    queryDetail?: string,
    method?: string,
    model?: string,
    delete?: any[]
}

export interface DisplayedColumn {
    field: string,
    display: string
}

export interface DisplayedFields {
    row: Field[];
}

export interface Field {
    label: string,
    name: string,
    disabled: any,
    type: string,
    varType: string,
    dataset: any,
    query: string,
    trigger?: string,
    increment?: boolean,
    init?: string,
    search?: boolean,
    click?: string
}