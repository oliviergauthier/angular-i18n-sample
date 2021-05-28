import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, ActivatedRouteSnapshot, RouteConfigLoadEnd } from '@angular/router';

@Component({
  selector: 'app-message',
  templateUrl: './message.component.html',
  styleUrls: ['./message.component.scss']
})
export class MessageComponent implements OnInit {

  content: String = ""

  constructor(
    private route : ActivatedRoute
  ) { }

  ngOnInit(): void {
    this.route.queryParamMap.subscribe((queryParams) => {
      this.content = queryParams.get("content") || ""
    });
  }

}
