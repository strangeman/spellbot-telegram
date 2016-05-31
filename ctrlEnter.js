jQuery(document).ready(function($) {
  $.ctrlEnter = function(callback, args) {
      $(document).keydown(function(e) {
          if(!args) args=[]; // IE barks when args is null 
          if((e.keyCode == 10 || e.keyCode == 13)  && e.ctrlKey) {
              callback.apply(this, args);
              return false;
          }
      });        
  };

  function manipulateSelection() {
    if (window.getSelection) {  // all browsers, except IE before version 9
      var selection = window.getSelection ();
      if (selection.rangeCount > 0) {
        var range = selection.getRangeAt (0);
        var content = range.toString();
        var url = $(location).attr('href');
        $.post( "https://yourbot.com/spell", url + "\n" + content);
      }
    }    
  }

  $.ctrlEnter(function() {
      manipulateSelection();
  });
});