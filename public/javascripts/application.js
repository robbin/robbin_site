// Put your application scripts here
$(function(){
  $('button.close').click(function() {
    $('div.box').hide();
  });
  
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