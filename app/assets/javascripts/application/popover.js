function preparePopover() {
    $('[data-toggle="popover"]').popover({trigger: 'hover', html: true});
}

mumukiLoad(preparePopover);
