// Put your application scripts here
$(function(){
  // response search query on main nav both mouse click and keyboard return key
  $('button#search-button').click(function() {
    var keyword = $.trim($('input#search-box').val());
    if (keyword != null && keyword != '') {
      $('form#cse-search-box').submit();
    }
  });
  
  $('input#search-box').keyup(function(event) {
    if (event.keyCode == 13) {
      var keyword = $.trim($('input#search-box').val());
      if (keyword != null && keyword != '') {
        $('form#cse-search-box').submit();
      }
    }
  });
});


// add function insertAtCaret which can insert something at cursor in textarea input box.
(function($){ 
  $.fn.extend({
    insertAtCaret: function(myValue) {
      var $t=$(this)[0];
      if (document.selection) {
        this.focus();
        sel = document.selection.createRange();
        sel.text = myValue;
        this.focus();
      } else if ($t.selectionStart || $t.selectionStart == '0') {
          var startPos = $t.selectionStart;
          var endPos = $t.selectionEnd;
          var scrollTop = $t.scrollTop;
          $t.value = $t.value.substring(0, startPos) + myValue + $t.value.substring(endPos, $t.value.length);
          this.focus();
          $t.selectionStart = startPos + myValue.length;
          $t.selectionEnd = startPos + myValue.length;
          $t.scrollTop = scrollTop;
      } else {
        this.value += myValue;
        this.focus();
      }
    }
  })
})(jQuery);

// filter illegal tag, only number, underscore, alphabet and chinese words, add #, + like C#, C++
filterTags = function(tags) {
  var newArray = new Array();
  if (tags != null && tags.length >0) {
    var re_tag = new RegExp("^(?!_)(?!.*?_$)[\+#a-zA-Z0-9_ \u4e00-\u9fa5]+$");
    var tag_list = tags.split(/\s*,\s*/);
    for(var i = 0; i< tag_list.length; i++) {
        if (re_tag.test(tag_list[i])){
          newArray.push(tag_list[i]);
      }
    }
  }
  return newArray;
};