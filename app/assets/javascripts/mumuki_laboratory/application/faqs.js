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
      const $navItem = this._createNavbarItem($faqsNavbar, faqGroup)
      const $faqGroup = $(faqGroup);
      this._configureClickFor($navItem, $faqGroup, $faqsNavbar)
    });
  }

  _createNavbarItem($faqsNavbar, faqGroup) {
    const $newLink = $('<a></a>').attr("href",`#${faqGroup.id}`)
      .html(`${faqGroup.children[0].textContent}`);
    const $navItem = $('<li></li>').html($newLink);
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
      $(group).wrapAll(`<div class='mu-faqs-group' id='mu-faqs-group-${index}'>`)
    });
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
      previousNodeName = elem.nodeName
    });

    elemsGroups.push(newGroup);

    return elemsGroups;
  }

};

mumuki.load(() => {
  new mumuki.faqs().load();
});
