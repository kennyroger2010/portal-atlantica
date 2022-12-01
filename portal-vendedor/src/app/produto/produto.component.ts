import { Component } from '@angular/core';
import { DisplayedColumn, Page } from '../models/display';

@Component({
  selector: 'app-produto',
  templateUrl: './produto.component.html',
  styleUrls: ['./produto.component.css']
})
export class ProdutoComponent {

  page: Page = {
    title: 'Cadastro de Produtos',
    navForm: 'produtoform',
    id: 'row.B1_COD',
    endpoint: 'produto',
    btnInsert: true,
    btnView: true,
    btnEdit: true,
    btnDelete: true
  }

  displayedColumns: DisplayedColumn[] = [
    { field: 'B1_COD', display: 'Código' },
    { field: 'B1_DESC', display: 'Descrição' },
    { field: 'B1_TIPO', display: 'Tipo' },
    { field: 'B1_UM', display: 'Unid.Med.' },
    { field: 'BM_DESC', display: 'Grupo' },
    { field: 'B1_PRV1', display: 'Preço de Venda' }
  ];

  constructor() { }
  
}
