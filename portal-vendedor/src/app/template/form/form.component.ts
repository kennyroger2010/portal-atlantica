import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Router } from '@angular/router';
import { ReadParam, SaveParam } from '../../models/params';
import { CrudService } from '../../services/crud.service';

@Component({
  selector: 'app-form',
  templateUrl: './form.component.html',
  styleUrls: ['./form.component.css']
})
export class FormComponent implements OnInit {

  @Input() page: any;
  @Input() element: any;
  @Input() displayedFields: any = [];

  @Output() endOfProcess = new EventEmitter;
  @Output() buttonClick = new EventEmitter<{action: string}>();

  title: string = '';
  subTitle: string = '';
  isLoading: boolean = true;
  saveParams: SaveParam = { endpoint: '', action: '' };
  readParams: ReadParam = { endpoint: '', pageIndex: 0, pageSize: 0 };

  constructor(private crudService: CrudService, private snackBar: MatSnackBar, private router: Router, public dialog: MatDialog) { }

  ngOnInit(): void {

    for (var i = 0; i < this.displayedFields.length; i++) {
      for (var x = 0; x < this.displayedFields[i].row.length; x++) {
        if (this.displayedFields[i].row[x].query) {
          this.getAuxiliar(i, x, this.displayedFields[i].row[x].query);
        }
      }
    }

    this.saveParams.endpoint = this.page.endpoint;
    this.readParams.endpoint = this.page.endpoint;

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

    if (this.page.action == '3') {

      this.endOfProcess.emit();

    } else {

      this.readParams.id = this.page.id;

      this.crudService.read(this.readParams)
        .subscribe((response) => {

          this.element = response.data;
          this.isLoading = false;

          for (var i = 0; i < this.page.subTitle.length; i++) {
            if (i > 0) {
              this.subTitle += ' - '
            }
            this.subTitle += eval('this.element.' + this.page.subTitle[i]);
          }

          this.endOfProcess.emit();

        }, erro => {
          this.snackBar.open(
            (erro.error.message ? erro.error.message : 'Erro desconhecido!'), 'OK',
            { duration: 3000 }
          );
          this.isLoading = false;
        })

    }

  }

  save() {

    this.isLoading = true;

    this.saveParams.method = (this.page.method ? this.page.method : false);
    this.saveParams.action = this.page.action;
    this.saveParams.body = this.element;

    this.crudService.save(this.saveParams)
      .subscribe((response) => {
        this.snackBar.open(
          response.mesage, 'OK',
          { duration: 3000 }
        );
        this.isLoading = false;
        this.router.navigate([this.page.navGrid]);
      }, erro => {
        console.error(erro);
        this.snackBar.open(
          (erro.error.errorMessage ? erro.error.errorMessage : 'Erro desconhecido!'), 'OK',
          { duration: 10000 }
        );
        this.isLoading = false;
      })

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

  trigger(element: any, field: any, data?: any) {

    let obj = '';

    if (data) {
      obj = data.find((el: any) => el.value === element[field.name]);
    }

    if (field.trigger) {
      eval(field.trigger);
    }

  }

  click(action: string) {

    this.buttonClick.emit({action});

  }


}
