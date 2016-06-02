var myFields = [];
$(document).ready(function() {


  $('.add-field').click(function() {
    var id = $(this).attr('id');
    if (fields[id]) {
      var input = fields[id]();
      $('#mainform').append(input);
      myFields.push(input);
    }
  })

  $('#check').click(function() {
    check(myFields);
  })
})

function check(fields) {
  var sentence = $( "#sentence" );
  var sentence_type = $( "#sentence_type" );
  var data = {};

  for (var i=0; i<fields.length; i++) {
    if (fields[i].attr('name')=='author[]'){
      if (data[fields[i].attr('name')]) {
        data[fields[i].attr('name')].push(fields[i].val());
      } else {
        data[fields[i].attr('name')] = [fields[i].val()];
      }
    } else {
      data[fields[i].attr('name')] = fields[i].val();
    }
  }


  console.log(data);
  var request = $.ajax({
    url: "/proc",
    method: "POST",
    data: data
  });

  request.done(function( msg ) {
    // sentence_type.val(msg)
    // alert(msg['type'])
    // alert(msg['fields'])
    // alert(msg['result'])
    $( "#result" ).text(msg['result'])
    switch ( msg['type'] ) {
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
        sentence.text('Вы хотите создать ссылку для отдельного тома многотомного издания?');
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
          generateFields(msg['fields'])
        break;
      default:
        alert('default ' + msg['fields'])
    }

  });

  request.fail(function( jqXHR, textStatus ) {
    alert( "Request failed: " + textStatus );
  });
}

function generateFields(p) {
  // if(p[0] == 1){ alert('author') }
  // if(p[2] == 1){ alert('title') }
  // if(p[3] == 1){ alert('title_info') }
  // if(p[4] == 1){ alert('editor') }
  // if(p[5] == 1){ alert('compiler') }
  // if(p[6] == 1){ alert('organizations') }
  // if(p[7] == 1){ alert('year') }
  // if(p[8] == 1){ alert('publisher') }
  // if(p[9] == 1){ alert('volume') }
  // if(p[10] == 1){ alert('volume_tome') }
  // if(p[11] == 1){ alert('volume_tome') }
  // if(p[12] == 1){ alert('city') }
  // if(p[13] == 1){ alert('edition_number') }
  // if(p[14] == 1){ alert('number') }
  // if(p[15] == 1){ alert('position') }
  // if(p[16] == 1){ alert('article_title') }
  // if(p[17] == 1){ alert('url') }
  // if(p[18] == 1){ alert('release_date') }
  // if(p[19] == 1){ alert('accessing_resource') }
}

var fields = {
  'add_author': function() {
    return $('<input class="form-control" id="author" name="author[]" type="text" placeholder="Автор">');
  },
  'add_title': function() {
    return $('<input class="form-control" id="title" name="title" type="text" placeholder="Заголовок">');
  },
  'add_title_info': function() {
    return $('<input class="form-control" id="title_info" name="title_info" type="text" placeholder="Сведения, относящиеся к заглавию">');
  },
  'add_editor': function() {
    return $('<input class="form-control" id="editor" name="editor" type="text" placeholder="Редактор">');
  },
  'add_compiler': function() {
    return $('<input class="form-control" id="compiler" name="compiler" type="text" placeholder="Составитель">');
  },
  'add_organizations': function() {
    return $('<input class="form-control" id="organizations" name="organizations" type="text" placeholder="Наименование учреждения">');
  },
  'add_year': function() {
    return $('<input class="form-control" id="year" name="year" type="text" placeholder="Год издания">');
  },
  'add_publisher': function() {
    return $('<input class="form-control" id="publisher" name="publisher" type="text" placeholder="Издательство">');
  },
  'add_volume': function() {
    return $('<input class="form-control" id="volume" name="volume" type="text" placeholder="Количество страниц">');
  },
  'add_volume_tome': function() {
    return $('<input class="form-control" id="volume_tome" name="volume_tome" type="text" placeholder="Количество томов">');
  },
  'add_tome_number': function() {
    return $('<input class="form-control" id="tome_number" name="tome_number" type="text" placeholder="Номер тома">');
  },
  'add_city': function() {
    return $('<input class="form-control" id="city" name="city" type="text" placeholder="Место издания (город)">');
  },
  'add_edition_number': function() {
    return $('<input class="form-control" id="edition_number" name="edition_number" type="text" placeholder="Номер издания">');
  },
  'add_number': function() {
    return $('<input class="form-control" id="number" name="number" type="text" placeholder="Номер выпуска">');
  },
  'add_position': function() {
    return $('<input class="form-control" id="position" name="position" type="text" placeholder="Место размещения статьи (страницы)">');
  },
  'add_article_title': function() {
    return $('<input class="form-control" id="article_title" name="article_title" type="text" placeholder="Название статьи">');
  },
  'add_url': function() {
    return $('<input class="form-control" id="url" name="url" type="text" placeholder="Интернет-ресурс">');
  },
  'add_release_date': function() {
    return $('<input class="form-control" id="release_date" name="release_date" type="text" placeholder="Дата выпуска">');
  },
  'add_accessing_resource': function() {
    return $('<input class="form-control" id="accessing_resource" name="accessing_resource" type="text" placeholder="Дата обращения">');
  }
}

// function generateAuthor() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="author" name="author[]" type="text" placeholder="Автор">')
// }
//
// function generateTitle() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="title" name="title" type="text" placeholder="Заголовок">')
// }
//
// function generateTitleInfo() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="title_info" name="title_info" type="text" placeholder="Сведения, относящиеся к заглавию">')
// }
//
// function generateEditor() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="editor" name="editor" type="text" placeholder="Редактор">')
// }
//
// function generateCompiler() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="compiler" name="compiler" type="text" placeholder="Составитель">')
// }
//
// function generateOrganizations() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="organizations" name="organizations" type="text" placeholder="Наименование учреждения">')
// }
//
// function generateYear() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="year" name="year" type="text" placeholder="Год издания">')
// }
//
// function generatePublisher() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="publisher" name="publisher" type="text" placeholder="Издательство">')
// }
//
// function generateVolume() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="volume" name="volume" type="text" placeholder="Количество страниц">')
// }
//
// function generateVolumeTome() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="volume_tome" name="volume_tome" type="text" placeholder="Количество томов">')
// }
//
// function generateTomeNumber() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="tome_number" name="tome_number" type="text" placeholder="Номер тома">')
// }
//
// function generateCity() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="city" name="city" type="text" placeholder="Место издания (город)">')
// }
//
// function generateEditionNumber() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="edition_number" name="edition_number" type="text" placeholder="Номер издания">')
// }
//
// function generateNumber() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="number" name="number" type="text" placeholder="Номер выпуска">')
// }
//
// function generatePosition() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="position" name="position" type="text" placeholder="Место размещения статьи (страницы)">')
// }
//
// function generateArticleTitle() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="article_title" name="article_title" type="text" placeholder="Название статьи">')
// }
//
// function generateUrl() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="url" name="url" type="text" placeholder="Интернет-ресурс">')
// }
//
// function generateReleaseDate() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="release_date" name="release_date" type="text" placeholder="Дата выпуска">')
// }
//
// function generateAccessingResource() {
//   var mainform = $("#mainform");
//   mainform.append('<input class="form-control" id="accessing_resource" name="accessing_resource" type="text" placeholder="Дата обращения">')
// }
