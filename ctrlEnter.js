/*
# SpellBot-Telegram
#
# Copyright 2016, Anton Markelov
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

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