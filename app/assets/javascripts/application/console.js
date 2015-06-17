$(document).on('ready page:load', function(){
  console.log('loading console')
  var controller = $('.console').console({
    promptLabel: 'main> ',
    commandValidate:function(line){
      return line != "";
    },
    commandHandle:function(line){
      return [{msg:"=> [12,42]",
        className:"jquery-console-message-value"},
        {msg:":: [a]",
          className:"jquery-console-message-type"}]
    },
    autofocus:true,
    animateScroll:true,
    promptHistory:true,
    charInsertTrigger:function(keycode,line){
      // Let you type until you press a-z
      // Never allow zero.
      return true;
      //!line.match(/[a-z]+/) && keycode != '0'.charCodeAt(0);
    }
  });
});
