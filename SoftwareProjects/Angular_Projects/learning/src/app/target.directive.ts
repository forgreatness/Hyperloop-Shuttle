import { Directive, Input, OnInit, ViewContainerRef } from "@angular/core";
import { PortalService } from './portal.service';

@Directive({
    selector: '[tpTarget]'
})
export class TargetDirective implements OnInit {
    @Input('tpTarget') name;

    constructor(
        private teleporterComponent: PortalService,
        private viewContainerRef: ViewContainerRef
    ) {}

    ngOnInit(): void {
        this.teleporterComponent.addTarget(this.name, this.viewContainerRef);
    }
}