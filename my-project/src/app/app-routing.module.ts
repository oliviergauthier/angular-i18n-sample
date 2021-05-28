import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { MessageComponent } from './message/message.component';
import { NotfoundComponent } from './notfound/notfound.component';

const routes: Routes = [
  { path : '', redirectTo: 'login', pathMatch: 'full'},
  { path : 'login', component : LoginComponent },
  { path : 'message', component : MessageComponent },
  { path : '**', component: NotfoundComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
