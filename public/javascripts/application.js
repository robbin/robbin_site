// Put your application scripts here
$(function(){
  $('button.close').click(function() {
    $('div.box').hide();
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