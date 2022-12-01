export interface ReadParam {
    endpoint: string;
    pageIndex: number;
    pageSize: number;
    sortField?: string;
    sort?: string;
    search?: string;
    id?: string;
}

export interface SaveParam {
    endpoint: string;
    action: string;
    body?: any;
    method?: string;
}