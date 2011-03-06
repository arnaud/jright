(function($) {
  var obj = $(document);
  var settings = {
    style: 'native', // 'native', 'inherit', 'win.xp', 'mac'...
    parent: document
  };
  var methods = {
    init: function(options) {
      if ( options ) { 
        $.extend(settings, options);
      }
      obj = this;
      // Show the menu when right clicking
      $(document).bind('contextmenu', function(e) {
        settings.parent = $(e.target);
        var x = e.pageX;
        var y = e.pageY;
        methods.show(x, y);
        return false;
      });
      
      // Hide the menu when clicking away
      $('*').not(obj).click(methods.hide);
    },
    // show the menu
    show: function(x, y) {
      obj
        .css('left', x)
        .css('top', y)
        .fadeIn(50)
      ;
      methods.set_style();
      methods.place();
    },
    // hide the menu
    hide: function() {
      obj.fadeOut(150);
    },
    // automatically detect the OS and the browser
    // then determines the appropriate stylesheet
    detect_style: function() {
      var style = '';
      switch($.client.os) {
      case 'Mac':
        return 'mac';
      case 'Windows':
        style = 'win';
        break;
      case 'Linux':
        style = 'lin';
        break;
      }
      style += $.client.browser.toLowerCase();
      return style;
    },
    // set the context menu style
    set_style: function() {
      var style = '';
      switch(settings.style) {
      case 'native':
        style = methods.detect_style();
        break;
      case 'inherit':
        style = $(settings.parent).attr('class');
        break;
      default:
        style = settings.style;
      }
      var style = style || methods.detect_style();
      style = style.replace('.',' ');
      obj.attr('class', 'jright '+style);
    },
    // prevent the context menu from going beyond the visible screen
    place: function() {
      // TODO
      var pos = methods._find_position(obj);
      obj.css('left', pos.x).css('top', pos.y);
      obj.find('ul').each(function() {
        //var pos = methods._find_position($(this));
        //$(this).css('top', pos.y);
      });
    },
    _find_position: function(o) {
      var o_w = o.width() + 5;
      var o_h = o.height() + 5;
      var o_x = o.position().left;
      var o_y = o.position().top;
      var max_width = $(window).width();
      var max_height = $(window).height();
      var x = Math.min(o_x, max_width - o_w);
      var y = Math.min(o_y, max_height - o_h);
      return {x: x, y: y}
    }
  };
  
  $.fn.jright = function(method) {

    // Method calling logic
    if(methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if(typeof method === 'object' || !method) {
      return methods.init.apply(this, arguments);
    } else {
      $.error('Method ' +  method + ' does not exist on jQuery.jright');
    }
  };
} ) (jQuery); // Monkey patch needed to make the Makefile work properly
})(jQuery);
