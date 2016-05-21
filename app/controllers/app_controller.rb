class AppController < ApplicationController

  def main

  end

  def check
    require 'matrix'

    def field_check(p)
      return (params[:author].delete_if{ |e| e.blank? }.size > 0 ? 1 : 0).to_i if p == :author
      return (params[:author].delete_if{ |e| e.blank? }.size > 3 ? 1 : 0).to_i if p == :author_many
      (params[p].blank? ? 0 : 1).to_i
    end

    vectors = [
      Vector[1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], # 1 to 3 autors
      Vector[0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      Vector[0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      Vector[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
    ]

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
    inner_array << field_check(:city)
    inner_array << field_check(:edition_number)
    inner_array << field_check(:number)
    inner_array << field_check(:position)
    inner_array << field_check(:article_title)
    inner_array << field_check(:url)
    inner_array << field_check(:release_date)
    inner_array << field_check(:accessing_resource)

    inner_vector = Vector.elements(inner_array)

    puts '---'
    puts inner_vector
    puts '---'
    puts  vectors.sort_by{ |e| (inner_vector - e).to_a.delete_if{ |x| x != -1 }.size }

    render text: vectors.sort_by{ |e| (inner_vector - e).to_a.delete_if{ |x| x != -1 }.size }

    # render text: inner_vector




  end

  def proc
    puts ""
    puts params[:author].blank?

    @result = Hash.new
    single_author
    multi_authors
    digest
    tome
    book_article
    magazines_article
    papers_article
    internet_resourse

    render :result
  end

private

  def single_author

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

            @result[:single_author] = String.new
            @result[:single_author] += "Книга"

            @result[:single_author] += " #{authors_q} "

            @result[:single_author] += "#{params[:title]}"

            if !(params[:title_info].blank?) then
              @result[:single_author] += " : #{params[:title_info]}"
            end

            @result[:single_author] += " / #{authors_r}"

            if !(params[:editor].blank?) then
                editor = params[:editor].split(/[ \.]/).delete_if{ |e| e.blank? }

                if (editor[2] == nil) then
                  editor_q = "#{editor[1]}. #{editor[0]}"
                else
                  editor_q = "#{editor[1]}. #{editor[2]}. #{editor[0]}"
                end

                @result[:single_author] += " ; ред. #{editor_q}"
            end

            if !(params[:organizations].blank?) then
              @result[:single_author] += " ; #{params[:organizations]}"
            end

            if !(params[:edition_number].blank?) then
              @result[:single_author] += ". — #{params[:edition_number]}"
            end

            @result[:single_author] += ". — #{params[:city]} : "

            @result[:single_author] += "#{params[:publisher]}, "

            @result[:single_author] += "#{params[:year]}. — "

            @result[:single_author] += "#{params[:volume]} c."

          end
    end

  end

  def multi_authors

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

              @result[:multi_authors] = String.new
              @result[:multi_authors] += "Несколько авторов "

              @result[:multi_authors] += "#{params[:title]} "

              if !(params[:title_info].blank?) then
                @result[:multi_authors] += " : #{params[:title_info]}"
              end

              @result[:multi_authors] += " / #{authors_q} [и др.]"

              if !(params[:editor].blank?) then
                  editor = params[:editor].split(/[ \.]/).delete_if{ |e| e.blank? }

                  if (editor[2] == nil) then
                    editor_q = "#{editor[1]}. #{editor[0]}"
                  else
                    editor_q = "#{editor[1]}. #{editor[2]}. #{editor[0]}"
                  end

                  @result[:multi_authors] += " ; ред. #{editor_q}"
              end

              if !(params[:organizations].blank?) then
                @result[:multi_authors] += " ; #{params[:organizations]}"
              end

              if !(params[:edition_number].blank?) then
                @result[:multi_authors] += ". — #{params[:edition_number]}"
              end

              @result[:multi_authors] += ". — #{params[:city]}: "

              @result[:multi_authors] += "#{params[:publisher]}, "

              @result[:multi_authors] += "#{params[:year]}. — "

              @result[:multi_authors] += "#{params[:volume]} c."

            end

    end

  end

  def digest
        unless params[:title].blank? || params[:city].blank? || params[:publisher].blank? ||  params[:year].blank? || params[:volume].blank?

                  @result[:digest] = String.new
                  @result[:digest] += "Сборник статей"

                  @result[:digest] += " #{params[:title]}"

                  if !(params[:title_info].blank?) then
                    @result[:digest] += " : #{params[:title_info]}"
                  end

                  if !(params[:organizations].blank?) then
                    @result[:digest] += " / #{params[:organizations]}"
                  end

                  if !(params[:compiler].blank?) then
                      compiler = params[:compiler].split(/[ \.]/).delete_if{ |e| e.blank? }

                      if (compiler[2] == nil) then
                        compiler_q = "#{compiler[1]}. #{compiler[0]}"
                      else
                        compiler_q = "#{compiler[1]}. #{compiler[2]}. #{compiler[0]}"
                      end

                      @result[:digest] += " ; сост.: #{compiler_q}"
                  end

                  if !(params[:editor].blank?) then
                      editor = params[:editor].split(/[ \.]/).delete_if{ |e| e.blank? }

                      if (editor[2] == nil) then
                        editor_q = "#{editor[1]}. #{editor[0]}"
                      else
                        editor_q = "#{editor[1]}. #{editor[2]}. #{editor[0]}"
                      end

                      @result[:digest] += " ; ред. #{editor_q}"
                  end

                  @result[:digest] += ". — #{params[:city]}"

                  @result[:digest] += " : #{params[:publisher]}"

                  @result[:digest] += ", #{params[:year]}"

                  @result[:digest] += ". — #{params[:volume]} с."

        end
  end

  def tome
      unless params[:title].blank? || params[:volume_tome].blank? || params[:city].blank? ||  params[:publisher].blank? || params[:year].blank?

                  @result[:tome] = String.new
                  @result[:tome] += "Многотомные издания"

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
                      @result[:tome] += " #{authors_q}"
                  end

                  @result[:tome] += " #{params[:title]}"

                  @result[:tome] += " : в #{params[:volume_tome]} т."

                  if !(params[:author].blank?) then
                      @result[:tome] += " / #{authors_r}"
                  end

                  if !(params[:compiler].blank?) then
                      compiler = params[:compiler].split(/[ \.]/).delete_if{ |e| e.blank? }

                      if (compiler[2] == nil) then
                        compiler_q = "#{compiler[1]}. #{compiler[0]}"
                      else
                        compiler_q = "#{compiler[1]}. #{compiler[2]}. #{compiler[0]}"
                      end

                      @result[:tome] += " ; сост.: #{compiler_q}"
                  end

                  if !(params[:editor].blank?) then
                      editor = params[:editor].split(/[ \.]/).delete_if{ |e| e.blank? }

                      if (editor[2] == nil) then
                        editor_q = "#{editor[1]}. #{editor[0]}"
                      else
                        editor_q = "#{editor[1]}. #{editor[2]}. #{editor[0]}"
                      end

                      @result[:tome] += " ; ред. #{editor_q}"
                  end

                  if !(params[:edition_number].blank?) then
                    @result[:tome] += ". — #{params[:edition_number]}-е изд"
                  end

                  @result[:tome] += ". — #{params[:city]}"

                  @result[:tome] += " : #{params[:publisher]}"

                  @result[:tome] += ", #{params[:year]}"

                  @result[:tome] += ". — #{params[:volume_tome]} т."

        # r[:edition_number] = "#{params[:edition_number]}"

        end
      end


  def book_article

        unless params[:author].blank? || params[:article_title].blank? || params[:title].blank? || params[:city].blank? ||  params[:year].blank? || params[:position].blank?

              @result[:book_article] = String.new
              @result[:book_article] += "Статья из книги"

              authors = params[:author].delete_if{ |e| e.blank? }
              authors.map! do |author|
                author = author.split(/[ \.]/).delete_if{ |e| e.blank? }
                (Array(author[0]) << author[1..-1].map{ |e| e[0] }).flatten
              end
              authors_q = "#{authors[0][0]}, #{authors[0][1]}. #{authors[0][2]}."
              authors_r = "#{authors[0][1]}. #{authors[0][2]}. #{authors[0][0]}"
              authors[1..-1].each do |author|
                authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
              end

              p  authors_q
              p  authors_r.size

              @result[:book_article] += " #{authors_q}"

              @result[:book_article] += " #{params[:article_title]} / "
              @result[:book_article].chr.capitalize!

              @result[:multi_authors] += " #{authors_r} // "

              @result[:book_article] += "#{params[:title]}. — "
              @result[:book_article].chr.capitalize!

              @result[:book_article] += "#{params[:city]}, "
              @result[:book_article].chr.capitalize!

              @result[:book_article] += "#{params[:year]}. — "

              @result[:book_article] += "C. #{params[:position]}."

    # r[:edition_number] = "#{params[:edition_number]}"

    end
  end

  def magazines_article

        unless params[:author].blank? || params[:article_title].blank? || params[:title].blank? || params[:number].blank? ||  params[:year].blank? || params[:position].blank?

              @result[:magazines_article] = String.new
              @result[:magazines_article] += "Статья из журнала"

              authors = params[:author].delete_if{ |e| e.blank? }
              authors.map! do |author|
                author = author.split(/[ \.]/).delete_if{ |e| e.blank? }
                (Array(author[0]) << author[1..-1].map{ |e| e[0] }).flatten
              end
              authors_q = "#{authors[0][0]}, #{authors[0][1]}. #{authors[0][2]}."
              authors_r = "#{authors[0][1]}. #{authors[0][2]}. #{authors[0][0]}"
              authors[1..-1].each do |author|
                authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
              end

              @result[:magazines_article] += " #{authors_q} "

              @result[:magazines_article] += "#{params[:article_title]} / "
              @result[:magazines_article].chr.capitalize!

              @result[:magazines_article] += " #{authors_r} // "

              @result[:magazines_article] += "#{params[:title]}. — "
              @result[:magazines_article].chr.capitalize!

              @result[:magazines_article] += "#{params[:year]}. — "

              @result[:magazines_article] += "№ #{params[:number]}. — "

              @result[:magazines_article] += "C. #{params[:position]}."

    # r[:edition_number] = "#{params[:edition_number]}"

    end
  end

  def papers_article

        unless params[:author_sur].blank? || params[:author_name].blank? || params[:author_last].blank? || params[:article_title].blank? || params[:title].blank? || params[:release_date].blank? ||  params[:year].blank? || params[:position].blank?

              @result[:papers_article] = Hash.new

              @result[:papers_article][:type] = 'Статья из газеты'

              @result[:papers_article][:fullname] = "#{params[:author_sur].capitalize}, #{params[:author_name].capitalize.first}. "
              @result[:papers_article][:fullname] << "#{params[:author_last].capitalize.first}." unless params[:author_last].blank?

              @result[:papers_article][:article_title] = "#{params[:article_title]} / "
              @result[:papers_article][:article_title].chr.capitalize!

              @result[:papers_article][:fullname] = "#{params[:author_name].capitalize.first}. "
              @result[:papers_article][:fullname] << "#{params[:author_last].capitalize.first}. " unless params[:author_last].blank?
              @result[:papers_article][:fullname] << " #{params[:author_sur].capitalize} // "

              @result[:papers_article][:title] = "#{params[:title]}. — "
              @result[:papers_article][:title].chr.capitalize!

              @result[:papers_article][:year] = "#{params[:year]}. — "

              @result[:papers_article][:release_date] = "#{params[:release_date]}. — "

              @result[:papers_article][:position] = "C. #{params[:position]}."

        end
  end

  def internet_resourse

            unless params[:url].blank? || params[:accessing_resource].blank?

                  @result[:internet_resourse] = Hash.new

                  @result[:internet_resourse][:type] = 'Интернет - ресурс'

                  @result[:internet_resourse][:url] = "URL: #{params[:url]}"

                  @result[:internet_resourse][:accessing_resource] = " (дата обращения: #{params[:accessing_resource]})."

            end

  end

end
