function check() {
  var sentence = $( "#sentence" )
  var sentence_type = $( "#sentence_type" )

  var request = $.ajax({
    url: "/proc",
    method: "POST",
    data: {
      "author[]" : "author",
      "title" : "title"
    }
  });

  request.done(function( msg ) {
    sentence_type.val(msg)
    switch ( msg ) {
      case 'internet_resourse':
        sentence.text('Вы хотите ссылку для интернет ресурса?');
        break;
      case 'blablabla':
        break;
      default:
        alert('default')
    }

  });

  request.fail(function( jqXHR, textStatus ) {
    alert( "Request failed: " + textStatus );
  });
}

function generateFields() {

}

function generateAuthor() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="author" name="author[]" type="text" placeholder="Автор">')
}

function generateTitle() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="title" name="title" type="text" placeholder="Заголовок">')
}
