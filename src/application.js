(function ($) {
  "use strict";

  var $link = $("#currentLink-url"),
      $clone = $link.clone(),
      $embedWrapper = $("#embedWrapper");

  // Embedly will automatically generate a card due to this class
  $clone.prop("id", "").
      addClass("embedly-card");
  $embedWrapper.append($clone);

})(window.jQuery || window.Zepto || window.$);
