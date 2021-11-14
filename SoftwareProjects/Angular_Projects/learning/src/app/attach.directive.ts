import { Directive, Input, OnDestroy, OnInit, TemplateRef } from "@angular/core";
import { PortalService } from "./portal.service";

@Directive({
    selector: '[tpAttachTo]'
})

export class AttachToDirective implements OnInit, OnDestroy {
    @Input('tpAttachTo') targetName: string;

    constructor(
        private teleporterComponent: PortalService,
        private templateRef: TemplateRef<any>
    ) {}

    ngOnInit(): void {
        this.teleporterComponent.attach(this.targetName, this.templateRef);
    }

    ngOnDestroy(): void {
        this.teleporterComponent.clear(this.targetName);
    }
}