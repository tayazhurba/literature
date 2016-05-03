class AppController < ApplicationController

  def main

  end

def proc
  puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#{params[:author][0][2]}"
  puts params[:author].blank?

  @result = Hash.new
  single_author
  multi_authors
  book_article
  magazines_article
  papers_article
  internet_resourse

  render :result
end

private

  def single_author

    unless params[:title].blank? || params[:author].blank? || params[:city].blank? ||  params[:publisher].blank? || params[:year].blank? || params[:volume].blank?

          @result[:single_author] = Hash.new
          @result[:single_author][:type] = 'Книга'

          @result[:single_author][:fullname] = "#{params[:author].delete_if{ |e| e.blank? }.join(', ').capitalize}"
          @result[:single_author][:fullname] = "#{params[:author].map { |e| e.split } }"

          @result[:single_author][:title] = "#{params[:title]}. — "
          @result[:single_author][:title].chr.capitalize!

          @result[:single_author][:city] = "#{params[:city]}: "
          @result[:single_author][:city].chr.capitalize!

          @result[:single_author][:publisher] = "#{params[:publisher]}, "
          @result[:single_author][:publisher].capitalize!

          @result[:single_author][:year] = "#{params[:year]}. — "

          @result[:single_author][:volume] = "#{params[:volume]} c."

    end

  end

  def multi_authors

        unless params[:title].blank? || params[:author].blank? || params[:city].blank? ||  params[:publisher].blank? || params[:year].blank? || params[:volume].blank?

              # @result[:multi_authors] = Hash.new
              # @result[:multi_authors][:type] = 'Несколько авторов'
              #
              # authors = params[:author].delete_if{ |e| e.blank? }
              # authors.map! do |author|
              #   author = author.split(/[ \.]/).delete_if{ |e| e.blank? }
              #   (Array(author[0]) << author[1..-1].map{ |e| e[0] }).flatten
              # end
              # authors_q = "#{authors[0][0]}, #{authors[0][1]}. #{authors[0][2]}."
              # authors_r = "#{authors[0][1]}. #{authors[0][2]}. #{authors[0][0]}"
              # authors[1..-1].each do |author|
              #   authors_r += ", #{author[1]}. #{author[2]}. #{author[0]}"
              # end
              #
              # p authors
              #
              # @result[:multi_authors][:author] = "#{authors_q}"
              #
              # @result[:multi_authors][:title] = "#{params[:title]}. / "
              # @result[:multi_authors][:title].chr.capitalize!
              #
              # @result[:multi_authors][:authors] = "#{authors_r}."
              #
              # @result[:multi_authors][:city] = ". — #{params[:city]}: "
              # @result[:multi_authors][:city].chr.capitalize!
              #
              # @result[:multi_authors][:publisher] = "#{params[:publisher]}, "
              # @result[:multi_authors][:publisher].capitalize!
              #
              # @result[:multi_authors][:year] = "#{params[:year]}. — "
              #
              # @result[:multi_authors][:volume] = "#{params[:volume]} c."

              @result[:multi_authors] = String.new
              @result[:multi_authors] += "Несколько авторов\n"

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

              @result[:multi_authors] += "#{authors_q}"

              @result[:multi_authors] += "#{params[:title]}. / "

              @result[:multi_authors] += "#{authors_r}."

              @result[:multi_authors] += ". — #{params[:city]}: "

              @result[:multi_authors] += "#{params[:publisher]}, "

              @result[:multi_authors] += "#{params[:year]}. — "

              @result[:multi_authors] += "#{params[:volume]} c."

    end

  end

  def book_article

        unless params[:author_sur].blank? || params[:author_name].blank? || params[:author_last].blank? || params[:article_title].blank? || params[:title].blank? || params[:city].blank? ||  params[:year].blank? || params[:position].blank?

              @result[:book_article] = Hash.new
              @result[:book_article][:type] = 'Статья из книги'

              @result[:book_article][:fullname] = "#{params[:author_sur].capitalize}, #{params[:author_name].capitalize.first}. "
              @result[:book_article][:fullname] << "#{params[:author_last].capitalize.first}." unless params[:author_last].blank?

              @result[:book_article][:article_title] = "#{params[:article_title]} / "
              @result[:book_article][:article_title].chr.capitalize!

              @result[:book_article][:fullname] = "#{params[:author_name].capitalize.first}. "
              @result[:book_article][:fullname] << "#{params[:author_last].capitalize.first}. " unless params[:author_last].blank?
              @result[:book_article][:fullname] << " #{params[:author_sur].capitalize} // "

              @result[:book_article][:title] = "#{params[:title]}. — "
              @result[:book_article][:title].chr.capitalize!

              @result[:book_article][:city] = "#{params[:city]}: "
              @result[:book_article][:city].chr.capitalize!

              @result[:book_article][:year] = "#{params[:year]}. — "

              @result[:book_article][:position] = "C. #{params[:position]}."

    # r[:edition_number] = "#{params[:edition_number]}"

    end
  end

  def magazines_article

        unless params[:author_sur].blank? || params[:author_name].blank? || params[:author_last].blank? || params[:article_title].blank? || params[:title].blank? || params[:number].blank? ||  params[:year].blank? || params[:position].blank?

              @result[:magazines_article] = Hash.new
              @result[:magazines_article][:type] = 'Статья из журнала'

              @result[:magazines_article][:fullname] = "#{params[:author_sur].capitalize}, #{params[:author_name].capitalize.first}. "
              @result[:magazines_article][:fullname] << "#{params[:author_last].capitalize.first}." unless params[:author_last].blank?

              @result[:magazines_article][:article_title] = "#{params[:article_title]} / "
              @result[:magazines_article][:article_title].chr.capitalize!

              @result[:magazines_article][:fullname] = "#{params[:author_name].capitalize.first}. "
              @result[:magazines_article][:fullname] << "#{params[:author_last].capitalize.first}. " unless params[:author_last].blank?
              @result[:magazines_article][:fullname] << " #{params[:author_sur].capitalize} // "

              @result[:magazines_article][:title] = "#{params[:title]}. — "
              @result[:magazines_article][:title].chr.capitalize!

              @result[:magazines_article][:year] = "#{params[:year]}. — "

              @result[:magazines_article][:number] = "№ #{params[:number]}. — "

              @result[:magazines_article][:position] = "C. #{params[:position]}."

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
