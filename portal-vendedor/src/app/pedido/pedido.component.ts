import { Component } from '@angular/core';
import { DisplayedColumn, Page } from '../models/display';

@Component({
  selector: 'app-pedido',
  templateUrl: './pedido.component.html',
  styleUrls: ['./pedido.component.css']
})
export class PedidoComponent {

  page: Page = {
    title: 'Pedido de Venda',
    navForm: 'pedidoform',
    id: 'row.C5_NUM',
    endpoint: 'pedido',
    btnInsert: true,
    btnView: true,
    btnEdit: true,
    btnDelete: true
  }

  displayedColumns: DisplayedColumn[] = [
    { field: 'C5_NUM', display: 'Número' },
    { field: 'C5_EMISSAO', display: 'Emissão' },
    { field: 'E4_DESCRI', display: 'Cond.Pagto.' },
    { field: 'A1_NOME', display: 'Cliente Nome' },
    { field: 'A1_NREDUZ', display: 'Cliente Nome Reduzido' },
    { field: 'A1_MUN', display: 'Município' },
    { field: 'A1_EST', display: 'Estado' }
  ];

  constructor() { }

}
