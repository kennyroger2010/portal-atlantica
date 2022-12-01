import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { MatDialogRef } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Router } from '@angular/router';
import { ReadParam } from '../../models/params';
import { CrudService } from '../../services/crud.service';

@Component({
  selector: 'app-form-modal',
  templateUrl: './form-modal.component.html',
  styleUrls: ['./form-modal.component.css']
})
export class FormModalComponent implements OnInit {

  @Input() page: any;
  @Input() element: any;
  @Input() displayedFields: any = [];

  title: string = '';
  subTitle: string = '';
  isLoading: boolean = true;
  readParams: ReadParam = { endpoint: '', pageIndex: 0, pageSize: 0 };

  constructor(private crudService: CrudService, private snackBar: MatSnackBar, private router: Router, public dialogRef: MatDialogRef<FormModalComponent>) { }

  ngOnInit(): void {

    for (var i = 0; i < this.displayedFields.length; i++) {
      for (var x = 0; x < this.displayedFields[i].row.length; x++) {
        if (this.displayedFields[i].row[x].query) {
          this.getAuxiliar(i, x, this.displayedFields[i].row[x].query);
        }
      }
    }

    if (this.page.action == '3') {
      this.isLoading = false;
      this.title = "Incluindo " + this.page.title;
    } else if (this.page.action == '4') {
      this.title = "Alterando " + this.page.title;
    } else if (this.page.action == '5') {
      this.title = "Excluindo " + this.page.title;
    } else if (this.page.action == '6') {
      this.title = "Visualizando " + this.page.title;
    }

    this.isLoading = false;

    for (var i = 0; i < this.page.subTitle.length; i++) {
      if (i > 0) {
        this.subTitle += ' - '
      }
      this.subTitle += eval('this.element.' + this.page.subTitle[i]);
    }

  }

  save() {

    if (this.page.action == '4') {
      this.dialogRef.close();
    } else {
      this.dialogRef.close(this.element);
    }

  }

  getAuxiliar(i: number, x: number, query: string) {

    this.readParams.endpoint = 'auxiliar';
    this.readParams.id = query;

    this.crudService.read(this.readParams)
      .subscribe((response) => {
        this.displayedFields[i].row[x].dataset = response.data;
      }, erro => {
        console.error(erro);
        this.snackBar.open(
          (erro.error.message ? erro.error.message : 'Erro desconhecido!'), 'OK',
          { duration: 3000 }
        );
      })

  }

  close() {
    this.dialogRef.close();
  }

  trigger(element: any, field: any, data?: any) {

    let obj = '';

    if (data) {
      obj = data.find((el: any) => el.value === element[field.name]);
    }

    if (field.trigger) {
      eval(field.trigger);
    }

  }

  disabled(e: string) {
    return eval(e);
  }

}
