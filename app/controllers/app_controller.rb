class AppController < ApplicationController

  def main
  end


  # 1  Автор 1-3
  # 2  Автор 4>
  # 3  Заголовок
  # 4  Сведения, относящиеся к заглавию
  # 5  Редактор
  # 6  Составитель
  # 7  Наименование учреждения
  # 8  Год издания
  # 9  Издательство
  # 10  Количество страниц
  # 11  Количество томов
  # 12  Номер тома
  # 13  Место издания (город)
  # 14  Номер издания
  # 15  Номер выпуска
  # 16  Место размещения статьи (страницы)
  # 17  Название статьи
  # 18  Интернет-ресурс
  # 19  Дата выпуска
  # 20  Дата обращения
def save_record
  # p params
  user = User.find_by(id: 1)
  list = user.lists.find_by(name: "Общий список")
  list = user.lists.create(name: "Общий список") unless list
  record = list.records.create()
  params[:fields].each do |f|
    record.fields.create(name: f[0], value: f[1])
  end
  render text: "кнопочка с сервера пришла!!!"
end




def typeChoose
  # p $vectors[params[:t].to_sym]
  # render text: $vectors[params[:t].to_sym]
  p params[:t]
  case params[:t]
    when "book_author_1to3"
      result = [1,0,1,0,0,0,0,1,1,1,0,0,1,0,0,0,0,0,0,0]
    when "book_author_from4"
      result = [0,1,1,0,0,0,0,1,1,1,0,0,1,0,0,0,0,0,0,0]
    when "digest"
      result = [0,0,1,0,0,0,0,1,1,1,0,0,1,0,0,0,0,0,0,0]
    when "tome"
      result = [0,0,1,0,0,0,0,1,1,0,1,0,1,0,0,0,0,0,0,0]
    when "tome_single"
      result = [0,0,1,1,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0]
    when "book_article_1to3"
      result = [1,0,1,0,0,0,0,1,0,0,0,0,1,0,0,1,1,0,0,0]
    when "book_article_from4"
      result = [0,1,1,0,0,0,0,1,0,0,0,0,1,0,0,1,1,0,0,0]
    when "digest_article"
      result = [0,0,1,1,0,0,0,1,0,0,0,1,1,0,0,1,1,0,0,0]
    when "magazines_article"
      result = [1,0,1,0,0,0,0,1,0,0,0,1,0,0,1,1,1,0,0,0]
    when "papers_article"
      result = [1,0,1,0,0,0,0,1,0,0,0,1,0,0,0,1,1,0,0,0]
    when "internet_resourse"
      result = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1]
    else
      p 'type not found'
    end
  p "============="
  p result
  render text: result
end

  def check
    require 'matrix'

    def field_check(p)
      if p == :author
        if params[:author].nil?
          return 0.to_i
        else
          return params[:author].delete_if{ |e| e.blank? }.size < 4 ? 1 : 0
        end
      end

      if p == :author_many
        if params[:author].nil?
          return 0.to_i
        else
          return params[:author].delete_if{ |e| e.blank? }.size > 3 ? 1 : 0
          # p params[:author].delete_if{ |e| e.blank? }.size > 3 ? 1 : 0
          # p "author_many"
        end
      end
      (params[p].blank? ? 0 : 1).to_i
      # p (params[p].blank? ? 0 : 1).to_i
    end

    vectors = {
      book_author_1to3:   Vector[1,0,1,0,0,0,0,1,1,1,0,0,1,0,0,0,0,0,0,0], # 1 to 3 autors
      book_author_from4:  Vector[0,1,1,0,0,0,0,1,1,1,0,0,1,0,0,0,0,0,0,0], # 3 > author
      digest:             Vector[0,0,1,0,0,0,0,1,1,1,0,0,1,0,0,0,0,0,0,0], # digest
      tome:               Vector[0,0,1,0,0,0,0,1,1,0,1,0,1,0,0,0,0,0,0,0], # tome
      tome_single:        Vector[0,0,1,1,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0], # tome_single
      book_article_1to3:  Vector[1,0,1,0,0,0,0,1,0,0,0,0,1,0,0,1,1,0,0,0], # book_article_1to3
      book_article_from4: Vector[0,1,1,0,0,0,0,1,0,0,0,0,1,0,0,1,1,0,0,0], # book_article_from4
      digest_article:     Vector[0,0,1,1,0,0,0,1,0,0,0,1,1,0,0,1,1,0,0,0], # digest_article
      magazines_article:  Vector[1,0,1,0,0,0,0,1,0,0,0,1,0,0,1,1,1,0,0,0], # magazines_article
      papers_article:     Vector[1,0,1,0,0,0,0,1,0,0,0,1,0,0,0,1,1,0,0,0], # papers_article
      internet_resourse:  Vector[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1]  #internet_resourse
    }


    inner_array = []

    inner_array << field_check(:author)
    inner_array << field_check(:author_many)  #fake many autors
    inner_array << field_check(:title)
    inner_array << field_check(:title_info)
    inner_array << field_check(:editor)
    inner_array << field_check(:compiler)
    inner_array << field_check(:organizations)
    inner_array << field_check(:year)
    inner_array << field_check(:publisher)
    inner_array << field_check(:volume)
    inner_array << field_check(:volume_tome)
    inner_array << field_check(:tome_number)
    inner_array << field_check(:city)
    inner_array << field_check(:edition_number)
    inner_array << field_check(:number)
    inner_array << field_check(:position)
    inner_array << field_check(:article_title)
    inner_array << field_check(:url)
    inner_array << field_check(:release_date)
    inner_array << field_check(:accessing_resource)

    inner_vector = Vector.elements(inner_array)

    puts '############################'
    puts inner_vector
    candidate = vectors.sort_by{ |k,v| (inner_vector - v).to_a.delete_if{ |x| x != -1 }.size }.first
    p "mindef"
    mindefvector = vectors.sort_by{ |k,v| (inner_vector - v).to_a.delete_if{ |x| x != -1 }.size}.first.second
    mindef = (inner_vector - mindefvector).to_a.delete_if{ |x| x != -1 }.size
    mindefvectors = vectors.to_a.delete_if{ |k,v| (inner_vector - v).to_a.delete_if{ |x| x != -1}.size > mindef}
    p "minover"
    candidate = mindefvectors.sort_by{ |k,v| (v - inner_vector).to_a.delete_if{ |x| x != -1 }.size}.first
    p candidate
    p "condidate end"
    result = nil
    case candidate[0]
      when :book_author_1to3
        result = book_author_1to3
      when :book_author_from4
        result = book_author_from4
      when :digest
        result = digest
      when :tome
        result = tome
      when :tome_single
        result = tome_single
      when :book_article_1to3
        result = book_article_1to3
      when :book_article_from4
        result = book_article_from4
      when :digest_article
        result = digest_article
      when :magazines_article
        result = magazines_article
      when :papers_article
        result = papers_article
      when :internet_resourse
        result = internet_resourse
      else
        p candidate[0]
      end
      p "result="
      p result
    if (result == nil) then
      # result = nil
      # result = "Здесь будет выведена библиографическая запись. Но мы не смогли определить тип источника. Пожалуйста, заполните ещё поля либо воспользуйтесь автоматически определёным типом."
    end
    response = {
      type:   candidate[0],
      fields: candidate[1].to_a,
      result: result
     }
    #  p candidate[1].to_a

    render json: response

  end

private

  def book_author_1to3
    unless params[:author].blank? || params[:title].blank? || params[:city].blank? ||  params[:publisher].blank? || params[:year].blank? || params[:volume].blank?

          authors = params[:author].delete_if{ |e| e.blank? }
          authors.map! do |author|
            author = author.split(/[ \.]/).delete_if{ |e| e.blank? }
            (Array(author[0]) << author[1..-1].map{ |e| e[0] }).flatten
          end

          if (authors.size <= 3) then

            if (authors[0][2] == nil) then
              authors_q = "#{authors[0][0]}, #{authors[0][1]}."
              authors_r = "#{authors[0][1]}. #{authors[0][0]}"
              authors[1..-1].each do |author|
                if (author[2] == nil) then
                  authors_r += ", #{author[1]}. #{author[0]}"
                else
                  authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                end
              end
            end

            if (authors[0][2] != nil) then
              authors_q = "#{authors[0][0]}, #{authors[0][1]}. #{authors[0][2]}."
              authors_r = "#{authors[0][1]}. #{authors[0][2]}. #{authors[0][0]}"
              authors[1..-1].each do |author|
                if (author[2] != nil) then
                  authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                else
                  authors_r += ", #{author[1]}. #{author[0]}"
                end
              end
            end

            result = String.new

            result += " #{authors_q} "

            result += "#{params[:title]}"

            if !(params[:title_info].blank?) then
              result += " : #{params[:title_info]}"
            end

            result += " / #{authors_r}"

            if !(params[:editor].blank?) then
                editor = params[:editor].split(/[ \.]/).delete_if{ |e| e.blank? }

                if (editor[2] == nil) then
                  editor_q = "#{editor[1]}. #{editor[0]}"
                else
                  editor_q = "#{editor[1]}. #{editor[2]}. #{editor[0]}"
                end

                result += " ; ред. #{editor_q}"
            end

            if !(params[:organizations].blank?) then
              result += " ; #{params[:organizations]}"
            end

            if !(params[:edition_number].blank?) then
              result += ". — #{params[:edition_number]}"
            end

            result += ". — #{params[:city]} : "

            result += "#{params[:publisher]}, "

            result += "#{params[:year]}. — "

            result += "#{params[:volume]} c."

          end
    end

  end

  def book_author_from4

        unless params[:title].blank? || params[:author].blank? || params[:city].blank? ||  params[:publisher].blank? || params[:year].blank? || params[:volume].blank?

              authors = params[:author].delete_if{ |e| e.blank? }
              authors.map! do |author|
                author = author.split(/[ \.]/).delete_if{ |e| e.blank? }
                (Array(author[0]) << author[1..-1].map{ |e| e[0] }).flatten
              end

          if (authors.size > 3) then

              if (authors[0][2] == nil) then
                authors_q = "#{authors[0][0]}, #{authors[0][1]}."
                authors_r = "#{authors[0][1]}. #{authors[0][0]}"
                authors[1..-1].each do |author|
                  authors_r += ", #{author[1]}. #{author[0]}"
                end
              else
                authors_q = "#{authors[0][1]}. #{authors[0][2]}. #{authors[0][0]}"
                authors_r = "#{authors[0][1]}. #{authors[0][2]}. #{authors[0][0]}"
                authors[1..-1].each do |author|
                  authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                end
              end

              result = String.new

              result += "#{params[:title]} "

              if !(params[:title_info].blank?) then
                result += " : #{params[:title_info]}"
              end

              result += " / #{authors_q} [и др.]"

              if !(params[:editor].blank?) then
                  editor = params[:editor].split(/[ \.]/).delete_if{ |e| e.blank? }

                  if (editor[2] == nil) then
                    editor_q = "#{editor[1]}. #{editor[0]}"
                  else
                    editor_q = "#{editor[1]}. #{editor[2]}. #{editor[0]}"
                  end

                  result += " ; ред. #{editor_q}"
              end

              if !(params[:organizations].blank?) then
                result += " ; #{params[:organizations]}"
              end

              if !(params[:edition_number].blank?) then
                result += ". — #{params[:edition_number]}"
              end

              result += ". — #{params[:city]}: "

              result += "#{params[:publisher]}, "

              result += "#{params[:year]}. — "

              result += "#{params[:volume]} c."

            end

    end

  end

  def digest
        unless params[:title].blank? || params[:city].blank? || params[:publisher].blank? ||  params[:year].blank? || params[:volume].blank?

                  result = String.new

                  result += " #{params[:title]}"

                  if !(params[:title_info].blank?) then
                    result += " : #{params[:title_info]}"
                  end

                  if !(params[:organizations].blank?) then
                    result += " / #{params[:organizations]}"
                  end

                  if !(params[:compiler].blank?) then
                      compiler = params[:compiler].split(/[ \.]/).delete_if{ |e| e.blank? }

                      if (compiler[2] == nil) then
                        compiler_q = "#{compiler[1]}. #{compiler[0]}"
                      else
                        compiler_q = "#{compiler[1]}. #{compiler[2]}. #{compiler[0]}"
                      end

                      result += " ; сост.: #{compiler_q}"
                  end

                  if !(params[:editor].blank?) then
                      editor = params[:editor].split(/[ \.]/).delete_if{ |e| e.blank? }

                      if (editor[2] == nil) then
                        editor_q = "#{editor[1]}. #{editor[0]}"
                      else
                        editor_q = "#{editor[1]}. #{editor[2]}. #{editor[0]}"
                      end

                      result += " ; ред. #{editor_q}"
                  end

                  result += ". — #{params[:city]}"

                  result += " : #{params[:publisher]}"

                  result += ", #{params[:year]}"

                  result += ". — #{params[:volume]} с."

        end
  end

  def tome
      unless params[:title].blank? || params[:volume_tome].blank? || params[:city].blank? ||  params[:publisher].blank? || params[:year].blank?

                  result = String.new

                  authors = params[:author].delete_if{ |e| e.blank? }
                  authors.map! do |author|
                    author = author.split(/[ \.]/).delete_if{ |e| e.blank? }
                    (Array(author[0]) << author[1..-1].map{ |e| e[0] }).flatten
                  end

                  if !(params[:author].blank?) then

                      if (authors[0][2] == nil) then
                        authors_q = "#{authors[0][0]}, #{authors[0][1]}."
                        authors_r = "#{authors[0][1]}. #{authors[0][0]}"
                        authors[1..-1].each do |author|
                          if (author[2] == nil) then
                            authors_r += ", #{author[1]}. #{author[0]}"
                          else
                            authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                          end
                        end
                      end

                      if (authors[0][2] != nil) then
                        authors_q = "#{authors[0][0]}, #{authors[0][1]}. #{authors[0][2]}."
                        authors_r = "#{authors[0][1]}. #{authors[0][2]}. #{authors[0][0]}"
                        authors[1..-1].each do |author|
                          if (author[2] != nil) then
                            authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                          else
                            authors_r += ", #{author[1]}. #{author[0]}"
                          end
                        end
                      end
                      result += " #{authors_q}"
                  end

                  result += " #{params[:title]}"

                  result += " : в #{params[:volume_tome]} т."

                  if !(params[:author].blank?) then
                      result += " / #{authors_r}"
                  end

                  if !(params[:compiler].blank?) then
                      compiler = params[:compiler].split(/[ \.]/).delete_if{ |e| e.blank? }

                      if (compiler[2] == nil) then
                        compiler_q = "#{compiler[1]}. #{compiler[0]}"
                      else
                        compiler_q = "#{compiler[1]}. #{compiler[2]}. #{compiler[0]}"
                      end

                      result += " ; сост.: #{compiler_q}"
                  end

                  if !(params[:editor].blank?) then
                      editor = params[:editor].split(/[ \.]/).delete_if{ |e| e.blank? }

                      if (editor[2] == nil) then
                        editor_q = "#{editor[1]}. #{editor[0]}"
                      else
                        editor_q = "#{editor[1]}. #{editor[2]}. #{editor[0]}"
                      end

                      result += " ; ред. #{editor_q}"
                  end

                  if !(params[:edition_number].blank?) then
                    result += ". — #{params[:edition_number]}-е изд"
                  end

                  result += ". — #{params[:city]}"

                  result += " : #{params[:publisher]}"

                  result += ", #{params[:year]}"

                  result += ". — #{params[:volume_tome]} т."

        # r[:edition_number] = "#{params[:edition_number]}"

        end
      end

  def tome_single

            unless params[:title].blank? || params[:title_info].blank? ||  params[:city].blank? || params[:publisher].blank? || params[:year].blank? || params[:tome_number].blank?

                  result = String.new


                          authors = params[:author].delete_if{ |e| e.blank? }
                          authors.map! do |author|
                            author = author.split(/[ \.]/).delete_if{ |e| e.blank? }
                            (Array(author[0]) << author[1..-1].map{ |e| e[0] }).flatten
                          end

                          if !(params[:author].blank?) then

                              if (authors[0][2] == nil) then
                                  authors_q = "#{authors[0][0]}, #{authors[0][1]}."
                                  authors_r = "#{authors[0][1]}. #{authors[0][0]}"
                                  authors[1..-1].each do |author|
                                    if (author[2] == nil) then
                                       authors_r += ", #{author[1]}. #{author[0]}"
                                    else
                                       authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                                    end
                                  end
                              end

                            if (authors[0][2] != nil) then
                              authors_q = "#{authors[0][0]}, #{authors[0][1]}. #{authors[0][2]}."
                              authors_r = "#{authors[0][1]}. #{authors[0][2]}. #{authors[0][0]}"
                              authors[1..-1].each do |author|
                                  if (author[2] != nil) then
                                      authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                                  else
                                      authors_r += ", #{author[1]}. #{author[0]}"
                                  end
                              end
                            end
                        result += " #{authors_q}"
                        end

                        result += " #{params[:title]}"

                        result += " : в #{params[:volume_tome]} т."

                        if !(params[:author].blank?) then
                              result += " / #{authors_r}"
                        end

                        if !(params[:compiler].blank?) then
                          compiler = params[:compiler].split(/[ \.]/).delete_if{ |e| e.blank? }

                        if (compiler[2] == nil) then
                          compiler_q = "#{compiler[1]}. #{compiler[0]}"
                        else
                          compiler_q = "#{compiler[1]}. #{compiler[2]}. #{compiler[0]}"
                        end

                        result += " ; сост.: #{compiler_q}"
                        end

                        if !(params[:editor].blank?) then
                          editor = params[:editor].split(/[ \.]/).delete_if{ |e| e.blank? }

                        if (editor[2] == nil) then
                              editor_q = "#{editor[1]}. #{editor[0]}"
                        else
                              editor_q = "#{editor[1]}. #{editor[2]}. #{editor[0]}"
                        end

                        result += " ; ред. #{editor_q}"
                        end

                        if !(params[:edition_number].blank?) then
                              result += ". — #{params[:edition_number]}-е изд"
                        end

                        result += ". — #{params[:city]}"

                        result += " : #{params[:publisher]}"

                        result += ". — #{params[:tome_number]} т."

                        result += ". — #{params[:year]}"

                        result += ". — #{params[:volume]} c."


        end
    end

  def book_article_1to3

        unless params[:author].blank? || params[:article_title].blank? || params[:title].blank? || params[:city].blank? ||  params[:year].blank? || params[:position].blank?

              result = String.new

              authors = params[:author].delete_if{ |e| e.blank? }
              authors.map! do |author|
                author = author.split(/[ \.]/).delete_if{ |e| e.blank? }
                (Array(author[0]) << author[1..-1].map{ |e| e[0] }).flatten
              end

              if (authors.size <= 3) then

                if (authors[0][2] == nil) then
                  authors_q = "#{authors[0][0]}, #{authors[0][1]}."
                  authors_r = "#{authors[0][1]}. #{authors[0][0]}"
                  authors[1..-1].each do |author|
                    if (author[2] == nil) then
                      authors_r += ", #{author[1]}. #{author[0]}"
                    else
                      authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                    end
                  end
                end

                if (authors[0][2] != nil) then
                  authors_q = "#{authors[0][0]}, #{authors[0][1]}. #{authors[0][2]}."
                  authors_r = "#{authors[0][1]}. #{authors[0][2]}. #{authors[0][0]}"
                  authors[1..-1].each do |author|
                    if (author[2] != nil) then
                      authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                    else
                      authors_r += ", #{author[1]}. #{author[0]}"
                    end
                  end
                end

              result += " #{authors_q}"

              result += " #{params[:article_title]}"

              result += " / #{authors_r} // "

              result += "#{params[:title]}"

              if !(params[:title_info].blank?) then
                result += " : #{params[:title_info]}"
              end

              if !(params[:compiler].blank?) then
                compiler = params[:compiler].split(/[ \.]/).delete_if{ |e| e.blank? }

              if (compiler[2] == nil) then
                compiler_q = "#{compiler[1]}. #{compiler[0]}"
              else
                compiler_q = "#{compiler[1]}. #{compiler[2]}. #{compiler[0]}"
              end

              result += " ; сост.: #{compiler_q}"
              end


              if !(params[:editor].blank?) then
                  editor = params[:editor].split(/[ \.]/).delete_if{ |e| e.blank? }

              if (editor[2] == nil) then
                  editor_q = "#{editor[1]}. #{editor[0]}"
              else
                  editor_q = "#{editor[1]}. #{editor[2]}. #{editor[0]}"
              end

                result += " ; ред. #{editor_q}"
              end

              result += ". — #{params[:city]}"

              result += ", #{params[:year]}"

              result += ". — C. #{params[:position]}."

            end
        end
  end

  def book_article_from4

          unless params[:author].blank? || params[:article_title].blank? || params[:title].blank? || params[:city].blank? ||  params[:year].blank? || params[:position].blank?

                result = String.new

                              authors = params[:author].delete_if{ |e| e.blank? }
                              authors.map! do |author|
                                author = author.split(/[ \.]/).delete_if{ |e| e.blank? }
                                (Array(author[0]) << author[1..-1].map{ |e| e[0] }).flatten
                              end

              if (authors.size > 3) then

                            if (authors[0][2] == nil) then
                              authors_q = "#{authors[0][0]}, #{authors[0][1]}."
                              authors_r = "#{authors[0][1]}. #{authors[0][0]}"
                              authors[1..-1].each do |author|
                                if (author[2] == nil) then
                                  authors_r += ", #{author[1]}. #{author[0]}"
                                else
                                  authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                                end
                              end
                            end

                            if (authors[0][2] != nil) then
                              authors_q = "#{authors[0][0]}, #{authors[0][1]}. #{authors[0][2]}."
                              authors_r = "#{authors[0][1]}. #{authors[0][2]}. #{authors[0][0]}"
                              authors[1..-1].each do |author|
                                if (author[2] != nil) then
                                  authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                                else
                                  authors_r += ", #{author[1]}. #{author[0]}"
                                end
                              end
                            end


                result += " #{params[:article_title]}"

                result += " / #{authors_r} [и др.] // "

                result += "#{params[:title]}"

                if !(params[:title_info].blank?) then
                  result += " : #{params[:title_info]}"
                end

                if !(params[:compiler].blank?) then
                  compiler = params[:compiler].split(/[ \.]/).delete_if{ |e| e.blank? }

                if (compiler[2] == nil) then
                  compiler_q = "#{compiler[1]}. #{compiler[0]}"
                else
                  compiler_q = "#{compiler[1]}. #{compiler[2]}. #{compiler[0]}"
                end

                result += " ; сост.: #{compiler_q}"
                end


                if !(params[:editor].blank?) then
                    editor = params[:editor].split(/[ \.]/).delete_if{ |e| e.blank? }

                if (editor[2] == nil) then
                    editor_q = "#{editor[1]}. #{editor[0]}"
                else
                    editor_q = "#{editor[1]}. #{editor[2]}. #{editor[0]}"
                end

                  result += " ; ред. #{editor_q}"
                end

                result += ". — #{params[:city]}"

                result += ", #{params[:year]}"

                result += ". — C. #{params[:position]}."

              end
          end
    end

  def digest_article

            unless  params[:article_title].blank? || params[:title].blank? || params[:title_info].blank? || params[:city].blank? || params[:year].blank? || params[:tome_number].blank? || params[:position].blank?

                  result = String.new

                  authors = params[:author].delete_if{ |e| e.blank? }
                  authors.map! do |author|
                    author = author.split(/[ \.]/).delete_if{ |e| e.blank? }
                    (Array(author[0]) << author[1..-1].map{ |e| e[0] }).flatten
                  end

                  if !(params[:author].blank?) then

                      if (authors[0][2] == nil) then
                          authors_q = "#{authors[0][0]}, #{authors[0][1]}."
                          authors_r = "#{authors[0][1]}. #{authors[0][0]}"
                          authors[1..-1].each do |author|
                            if (author[2] == nil) then
                                  authors_r += ", #{author[1]}. #{author[0]}"
                            else
                               authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                            end
                          end
                      end

                    if (authors[0][2] != nil) then
                      authors_q = "#{authors[0][0]}, #{authors[0][1]}. #{authors[0][2]}."
                      authors_r = "#{authors[0][1]}. #{authors[0][2]}. #{authors[0][0]}"
                      authors[1..-1].each do |author|
                          if (author[2] != nil) then
                              authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                          else
                              authors_r += ", #{author[1]}. #{author[0]}"
                          end
                      end
                    end
                result += " #{authors_q}"
                end

                result += " #{params[:article_title]}"

                if !(params[:author].blank?) then
                      result += " / #{authors_r}"
                end


                  result += " // #{params[:title]}"

                  result += " : #{params[:title_info]}"

                  if !(params[:compiler].blank?) then
                    compiler = params[:compiler].split(/[ \.]/).delete_if{ |e| e.blank? }

                  if (compiler[2] == nil) then
                    compiler_q = "#{compiler[1]}. #{compiler[0]}"
                  else
                    compiler_q = "#{compiler[1]}. #{compiler[2]}. #{compiler[0]}"
                  end

                  result += " ; сост.: #{compiler_q}"
                  end


                  if !(params[:editor].blank?) then
                      editor = params[:editor].split(/[ \.]/).delete_if{ |e| e.blank? }

                  if (editor[2] == nil) then
                      editor_q = "#{editor[1]}. #{editor[0]}"
                  else
                      editor_q = "#{editor[1]}. #{editor[2]}. #{editor[0]}"
                  end

                    result += " ; ред. #{editor_q}"
                  end

                  result += ". — #{params[:city]}"

                  result += ", #{params[:year]}"

                  result += ". — № #{params[:number]}"

                  result += ". — C. #{params[:position]}."

        end
      end

  def magazines_article

        unless params[:author].blank? || params[:article_title].blank? || params[:title].blank? || params[:year].blank? || params[:tome_number].blank? || params[:position].blank? || params[:number].blank?

              result = String.new

              if (authors[0][2] == nil) then
                authors_q = "#{authors[0][0]}, #{authors[0][1]}."
                authors_r = "#{authors[0][1]}. #{authors[0][0]}"
                authors[1..-1].each do |author|
                  if (author[2] == nil) then
                    authors_r += ", #{author[1]}. #{author[0]}"
                  else
                    authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                  end
                end
              end

              if (authors[0][2] != nil) then
                authors_q = "#{authors[0][0]}, #{authors[0][1]}. #{authors[0][2]}."
                authors_r = "#{authors[0][1]}. #{authors[0][2]}. #{authors[0][0]}"
                authors[1..-1].each do |author|
                  if (author[2] != nil) then
                    authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                  else
                    authors_r += ", #{author[1]}. #{author[0]}"
                  end
                end
              end


              result += " #{authors_q}"

              result += " #{params[:article_title]} / "

              result += " #{authors_r} // "

              result += "#{params[:title]}. "

              result += ". — #{params[:year]}"

              if !(params[:tome_number].blank?) then
                result += ". — Т. #{params[:tome_number]}"
              end

              result += ". — № #{params[:number]}"

              result += ". — C. #{params[:position]}."

    end
  end

  def papers_article

        unless params[:author].blank? || params[:article_title].blank? || params[:title].blank? || params[:year].blank? || params[:tome_number].blank? || params[:position].blank?

              result = String.new

              if (authors[0][2] == nil) then
                authors_q = "#{authors[0][0]}, #{authors[0][1]}."
                authors_r = "#{authors[0][1]}. #{authors[0][0]}"
                authors[1..-1].each do |author|
                  if (author[2] == nil) then
                    authors_r += ", #{author[1]}. #{author[0]}"
                  else
                    authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                  end
                end
              end

              if (authors[0][2] != nil) then
                authors_q = "#{authors[0][0]}, #{authors[0][1]}. #{authors[0][2]}."
                authors_r = "#{authors[0][1]}. #{authors[0][2]}. #{authors[0][0]}"
                authors[1..-1].each do |author|
                  if (author[2] != nil) then
                    authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                  else
                    authors_r += ", #{author[1]}. #{author[0]}"
                  end
                end
              end


              result += " #{authors_q}"

              result += " #{params[:article_title]} / "

              result += " #{authors_r} // "

              result += "#{params[:title]}. "

              result += ". — #{params[:year]}"

              if !(params[:tome_number].blank?) then
                result += ". — Т. #{params[:tome_number]}"
              end

              if !(params[:number].blank?) then
                result += ". — № #{params[:number]}"
              end

              if !(params[:edition_number].blank?) then
                result += ". — Вып. #{params[:edition_number]}"
              end

              result += ". — #{params[:release_date]}"

              if !(params[:position].blank?) then
                result += ". — C. #{params[:position]}."
              end

    end
  end

  def internet_resourse

            unless params[:article_title].blank? || params[:url].blank? || params[:accessing_resource].blank?

                  result = String.new


                if !(params[:author].blank?) then

                  authors = params[:author].delete_if{ |e| e.blank? }
                  authors.map! do |author|
                    author = author.split(/[ \.]/).delete_if{ |e| e.blank? }
                    (Array(author[0]) << author[1..-1].map{ |e| e[0] }).flatten
                  end

                      if (authors[0][2] == nil) then
                          authors_q = "#{authors[0][0]}, #{authors[0][1]}."
                          authors_r = "#{authors[0][1]}. #{authors[0][0]}"
                          authors[1..-1].each do |author|
                            if (author[2] == nil) then
                                  authors_r += ", #{author[1]}. #{author[0]}"
                            else
                               authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                            end
                          end
                      end

                    if (authors[0][2] != nil) then
                      authors_q = "#{authors[0][0]}, #{authors[0][1]}. #{authors[0][2]}."
                      authors_r = "#{authors[0][1]}. #{authors[0][2]}. #{authors[0][0]}"
                      authors[1..-1].each do |author|
                          if (author[2] != nil) then
                              authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
                          else
                              authors_r += ", #{author[1]}. #{author[0]}"
                          end
                      end
                    end
                    result += " #{authors_q}"
                end

                result += " #{params[:article_title]} [Электронный ресурс] "

                if !(params[:author].blank?) then
                      result += " / #{authors_r}"
                end

                if !(params[:city].blank?) then
                  result += ". — #{params[:city]}"
                end

                if !(params[:publisher].blank?) then
                  result += " : #{params[:publisher]}"
                end

                if !(params[:year].blank?) then
                  result += ", #{params[:year]}"
                end

                  result += ". — URL: #{params[:url]}"

                  result += " (дата обращения: #{params[:accessing_resource]})."

              end

      end
end
