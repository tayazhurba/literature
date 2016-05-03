class MagazinesArticle

  def initialize
      @author =              true
      @title =               true
      @year =                true
      @publisher =           false
      @volume =              false
      @city =                false
      @edition_number =      false
      @number =              true
      @position =            true
      @article_title =       true
      @url =                 false
      @release_date =        false
      @accessing_resource =  false
    end

    def author
      @author
    end

    def title
      @title
    end

    def year
      @year
    end

    def publisher
      @publisher
    end

    def volume
      @volume
    end

    def city
      @city
    end

    def edition_number
      @edition_number
    end

    def number
      @number
    end

    def position
      @position
    end

    def article_title
      @article_title
    end

    def url
      @url
    end

    def release_date
      @release_date
    end

    def accessing_resource
      @accessing_resource
    end

end
