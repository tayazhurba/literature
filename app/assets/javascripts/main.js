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
      case 'book_author_1to3':
          sentence.text('Вы хотите создать ссылку для книги с 1-3 акторами?');
        break;
      case 'book_author_from4':
          sentence.text('Вы хотите создать ссылку для книги с четырьмя и более авторами?');
        break;
      case 'digest':
          sentence.text('Вы хотите создать ссылку для сборника?');
        break;
      case 'tome':
          sentence.text('Вы хотите создать ссылку для многотомника?');
        break;
      case 'tome_single':
          sentence.text('Вы хотите создать ссылку для отдльного тома многотомного издания?');
        break;
      case 'book_article_1to3':
          sentence.text('Вы хотите создать ссылку для статьи из книги с 1-3 авторами?');
        break;
      case 'book_article_from4':
          sentence.text('Вы хотите создать ссылку для статьи из книги с четырьмя и более авторами?');
        break;
      case 'digest_article':
          sentence.text('Вы хотите создать ссылку для статьи из сборника?');
        break;
      case 'magazines_article':
          sentence.text('Вы хотите создать ссылку для статьи из журнала?');
        break;
      case 'papers_article':
          sentence.text('Вы хотите создать ссылку для статьи из газеты?');
        break;
      case 'internet_resourse':
          sentence.text('Вы хотите создать ссылку для интернет ресурса?');
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

function generateTitleInfo() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="title_info" name="title_info" type="text" placeholder="Сведения, относящиеся к заглавию">')
}

function generateEditor() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="editor" name="editor" type="text" placeholder="Редактор">')
}

function generateCompiler() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="compiler" name="compiler" type="text" placeholder="Составитель">')
}

function generateOrganizations() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="organizations" name="organizations" type="text" placeholder="Наименование учреждения">')
}

function generateYear() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="year" name="year" type="text" placeholder="Год издания">')
}

function generatePublisher() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="publisher" name="publisher" type="text" placeholder="Издательство">')
}

function generateVolume() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="volume" name="volume" type="text" placeholder="Количество страниц">')
}

function generateVolumeTome() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="volume_tome" name="volume_tome" type="text" placeholder="Количество томов">')
}

function generateTomeNumber() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="tome_number" name="tome_number" type="text" placeholder="Номер тома">')
}

function generateCity() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="city" name="city" type="text" placeholder="Место издания (город)">')
}

function generateEditionNumber() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="edition_number" name="edition_number" type="text" placeholder="Номер издания">')
}

function generateNumber() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="number" name="number" type="text" placeholder="Номер выпуска">')
}

function generatePosition() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="position" name="position" type="text" placeholder="Место размещения статьи (страницы)">')
}

function generateArticleTitle() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="article_title" name="article_title" type="text" placeholder="Название статьи">')
}

function generateUrl() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="url" name="url" type="text" placeholder="Интернет-ресурс">')
}

function generateReleaseDate() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="release_date" name="release_date" type="text" placeholder="Дата выпуска">')
}

function generateAccessingResource() {
  var mainform = $("#mainform");
  mainform.append('<input class="form-control" id="accessing_resource" name="accessing_resource" type="text" placeholder="Дата обращения">')
}
