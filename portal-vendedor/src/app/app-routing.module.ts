import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AuthGuard } from './auth.guard';
import { ClienteFormComponent } from './cliente-form/cliente-form.component';
import { ClienteComponent } from './cliente/cliente.component';
import { DashboardComponent } from './dashboard/dashboard.component';
import { LoginComponent } from './login/login.component';
import { MenuComponent } from './menu/menu.component';
import { PedidoFormComponent } from './pedido-form/pedido-form.component';
import { PedidoComponent } from './pedido/pedido.component';
import { ProdutoFormComponent } from './produto-form/produto-form.component';
import { ProdutoComponent } from './produto/produto.component';

const routes: Routes = [
  { path: 'login', component: LoginComponent },
  {
    path: '', component: MenuComponent, canActivate: [AuthGuard],
    children: [
      { path: 'dashboard', component: DashboardComponent },
      { path: 'pedido', component: PedidoComponent },
      { path: 'pedidoform/:action/:id', component: PedidoFormComponent },
      { path: 'cliente', component: ClienteComponent },
      { path: 'clienteform/:action/:id', component: ClienteFormComponent },
      { path: 'produto', component: ProdutoComponent },
      { path: 'produtoform/:action/:id', component: ProdutoFormComponent },
      { path: '**', redirectTo: '' }
    ]
  },
  { path: '**', redirectTo: '' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
