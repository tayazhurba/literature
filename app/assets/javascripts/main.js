var myFields = [];
$(document).ready(function() {


  $('.add-field').click(function() {
    if (!($(this).attr('id') == 'add_author') && $(this).hasClass('added')) return false;

    var id = $(this).attr('id');
    if (fields[id]) {
      var input = fields[id]();
      $('#mainform').append(input);
      myFields.push($(input).find('input'));
      console.log(myFields);
      if (!($(this).attr('id') == 'add_author')) $(this).addClass('added');
    }
  })

  $('body').on('click', '.remove-field', function(e) {
    var $parent = $(e.target).parent();
    var index = $parent.index();
    var id = '#' + $parent.find('input').attr('rel');
    $(id).removeClass('added');
    $parent.remove();
    myFields.splice(index, 1);
  })

  $('#check').click(function() {
    check(myFields);
  })

  $('.selectpicker').change(function(){
    var id = $('.choose-type:selected').attr('id');
    typeChoose(id);
  })

  $('body').on('click', '.save-record', function() {
    saveRecord(myFields);
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
    sentence.unbind();
    sentence.click(function() {
      generateFields(msg.fields);
    })
    // sentence_type.val(msg)
    // alert(msg['type'])
    // alert(msg['fields'])
    // alert(msg['result'])
    if (!(msg['result'] == null)) {
      $('#save-record-icon').addClass('save-record');
    } else msg['result'] = "Здесь будет выведена библиографическая запись. Но мы не смогли определить тип источника. Пожалуйста, заполните ещё поля либо воспользуйтесь автоматически определёным типом."



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
          // generateFields(msg['fields'])
        break;
      default:
        alert('default ' + msg['fields'])
    }
  });

  request.fail(function( jqXHR, textStatus ) {
    alert( "Request failed: " + textStatus );
  });
}

function typeChoose(id) {
  var request = $.ajax({
    url: "/typeChoose/" + id,
    method: "GET"
  });
  request.done(function( msg ) {
    msg = JSON.parse(msg);
    generateFields(msg);
  });
  request.fail(function( jqXHR, textStatus ) {
    alert( "Request failed: " + textStatus );
  });
}

function saveRecord(fields) {
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
    url: "/save_record/",
    method: "POST",
    data: {'fields': data}
  });
  request.done(function( msg ) {
    alert(msg);
  });
  request.fail(function( jqXHR, textStatus ) {
    alert( "Request failed: " + textStatus );
  });
}


function generateFields(p) {
  // console.log(JSON.parse(p));
  // console.log(JSON.parse("[1, 2, 3]"));
  // console.log(Array.isArray(p))
  // alert(p);
  // alert(p.length);
  if (p[0] == 1 && !$('input[name="author[]"]').length) {
    $('#add_author').trigger('click');
  }

  for (var i=0; i<p.length; i++) {
  // alert(i+"p="+p[i]);
  // alert(p[i]);
    if (p[i] == 1) {

      var $addField = $($('.add-field')[i-1]);
      if (!$addField.hasClass('added')) {
        $addField.trigger('click');
      }
    }
  }
}

var fields = {
  'add_author': function() {
    return $('<div class="form-group"><input class="form-control field" id="author" rel="add_author" name="author[]" type="text" placeholder="Автор"><span class="remove-field"></span></div>');
  },
  'add_title': function() {
    return $('<div class="form-group"><input class="form-control field" id="title" rel="add_title" name="title" type="text" placeholder="Заголовок"><span class="remove-field"></span></div>');
  },
  'add_title_info': function() {
    return $('<div class="form-group"><input class="form-control field" id="title_info" rel="add_title_info" name="title_info" type="text" placeholder="Сведения, относящиеся к заглавию"><span class="remove-field"></span></div>');
  },
  'add_editor': function() {
    return $('<div class="form-group"><input class="form-control field" id="editor" rel="add_editor" name="editor" type="text" placeholder="Редактор"><span class="remove-field"></span></div>');
  },
  'add_compiler': function() {
    return $('<div class="form-group"><input class="form-control field" id="compiler" rel="add_compiler" name="compiler" type="text" placeholder="Составитель"><span class="remove-field"></span></div>');
  },
  'add_organizations': function() {
    return $('<div class="form-group"><input class="form-control field" id="organizations" rel="add_organizations" name="organizations" type="text" placeholder="Наименование учреждения"><span class="remove-field"></span></div>');
  },
  'add_year': function() {
    return $('<div class="form-group"><input class="form-control field" id="year" rel="add_year" name="year" type="text" placeholder="Год издания"><span class="remove-field"></span></div>');
  },
  'add_publisher': function() {
    return $('<div class="form-group"><input class="form-control field" id="publisher" rel="add_publisher" name="publisher" type="text" placeholder="Издательство"><span class="remove-field"></span></div>');
  },
  'add_volume': function() {
    return $('<div class="form-group"><input class="form-control field" id="volume" rel="add_volume" name="volume" type="text" placeholder="Количество страниц"><span class="remove-field"></span></div>');
  },
  'add_volume_tome': function() {
    return $('<div class="form-group"><input class="form-control field" id="volume_tome" rel="add_volume_tome" name="volume_tome" type="text" placeholder="Количество томов"><span class="remove-field"></span></div>');
  },
  'add_tome_number': function() {
    return $('<div class="form-group"><input class="form-control field" id="tome_number" rel="add_tome_number" name="tome_number" type="text" placeholder="Номер тома"><span class="remove-field"></span></div>');
  },
  'add_city': function() {
    return $('<div class="form-group"><input class="form-control field" id="city" rel="add_city" name="city" type="text" placeholder="Место издания (город)"><span class="remove-field"></span></div>');
  },
  'add_edition_number': function() {
    return $('<div class="form-group"><input class="form-control field" id="edition_number" rel="add_edition_number" name="edition_number" type="text" placeholder="Номер издания"><span class="remove-field"></span></div>');
  },
  'add_number': function() {
    return $('<div class="form-group"><input class="form-control field" id="number" rel="add_number" name="number" type="text" placeholder="Номер выпуска"><span class="remove-field"></span></div>');
  },
  'add_position': function() {
    return $('<div class="form-group"><input class="form-control field" id="position" rel="add_position" name="position" type="text" placeholder="Место размещения статьи (страницы)"><span class="remove-field"></span></div>');
  },
  'add_article_title': function() {
    return $('<div class="form-group"><input class="form-control field" id="article_title" rel="add_article_title" name="article_title" type="text" placeholder="Название статьи"><span class="remove-field"></span></div>');
  },
  'add_url': function() {
    return $('<div class="form-group"><input class="form-control field" id="url" rel="add_url" name="url" type="text" placeholder="Интернет-ресурс"><span class="remove-field"></span></div>');
  },
  'add_release_date': function() {
    return $('<div class="form-group"><input class="form-control field" id="release_date" rel="add_release_date" name="release_date" type="text" placeholder="Дата выпуска"><span class="remove-field"></span></div>');
  },
  'add_accessing_resource': function() {
    return $('<div class="form-group"><input class="form-control field" id="accessing_resource" rel="add_accessing_resource" name="accessing_resource" type="text" placeholder="Дата обращения"><span class="remove-field"></span></div>');
  }
}
