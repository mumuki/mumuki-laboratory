mumuki.faqs = class {

  constructor() {
    this.faqs = $('.mu-faqs');
    this.topHierarchyElem = "H2";
  }

  // ================
  // == Public API ==
  // ================

  /**
   * Actually setup the faqs page
   */
  load() {
    if(!this.faqs) return;
    this._createFaqsGroups();
    this._createNavbar();
  }

  // =================
  // == Private API ==
  // =================

  _createNavbar() {
    const $faqsNavbar = $(".mu-faqs-navbar nav ul");
    $('.mu-faqs-group').each((_index, faqGroup) => {
      const $navItem = this._createNavbarItem($faqsNavbar, faqGroup);
      const $faqGroup = $(faqGroup);
      this._configureClickFor($navItem, $faqGroup, $faqsNavbar);
    });
  }

  _createNavbarItem($faqsNavbar, faqGroup) {
    const $navItem = $(`<li><a href="#${faqGroup.id}">`)
      .html(`${faqGroup.querySelector('h2').textContent}`);
    $faqsNavbar.append($navItem);
    return $navItem;
  }

  _configureClickFor($navItem, $faqGroup, $faqsNavbar) {
    $navItem.click(function(e){
      e.preventDefault();
      $faqsNavbar.find('li').removeClass('active');
      $navItem.addClass('active');
      $('html, body').animate({scrollTop: $faqGroup.offset().top}, 1000);
    });
  }

  _createFaqsGroups() {
    const elemsGroups = this._buildFaqsGroups();
    elemsGroups.forEach((group, index) => {
      $(group).wrapAll(`<div class='mu-faqs-group' id='mu-faqs-group-${index}'>`);
    });
    this._createFaqsIcons();
  }

  _createFaqsIcons() {
    const $faqIcon = $('<i class="mu-faqs-group-icon fas fa-chevron-down">');
    $faqIcon.click(function(e){
      const $elem = $(this);
      $elem.toggleClass('fa-chevron-down fa-chevron-up');
      $elem.closest('.mu-faqs-group').toggleClass('active');
    });
    $('.mu-faqs-group').prepend($faqIcon);
  }

  _buildFaqsGroups() {
    let newGroup = [];
    let elemsGroups = [];
    let previousNodeName;
    $(".mu-faqs-content").children().each((index, elem) => {
      if(elem.nodeName === this.topHierarchyElem && newGroup.length) {
        elemsGroups.push(newGroup);
        newGroup = [];
      }
      newGroup.push(elem);
      previousNodeName = elem.nodeName;
    });

    elemsGroups.push(newGroup);

    return elemsGroups;
  }

};

mumuki.load(() => {
  new mumuki.faqs().load();
});
