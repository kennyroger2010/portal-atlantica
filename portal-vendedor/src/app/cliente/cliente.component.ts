import { Component } from '@angular/core';
import { DisplayedColumn, Page } from '../models/display';

@Component({
  selector: 'app-cliente',
  templateUrl: './cliente.component.html',
  styleUrls: ['./cliente.component.css']
})
export class ClienteComponent {

  page: Page = {
    title: 'Cadastro de Clientes',
    navForm: 'clienteform',
    id: 'row.A1_COD + row.A1_LOJA',
    endpoint: 'cliente',
    btnInsert: true,
    btnView: true,
    btnEdit: true,
    btnDelete: true    
  }

  displayedColumns: DisplayedColumn[] = [
    { field: 'A1_COD', display: 'Código' },
    { field: 'A1_NOME', display: 'Nome' },
    { field: 'A1_NREDUZ', display: 'Nome Reduzido' },
    { field: 'A1_END', display: 'Endereço' },
    { field: 'A1_MUN', display: 'Município' },
    { field: 'A1_EST', display: 'Estados' }
  ];

  constructor() { }

}
