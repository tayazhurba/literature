class Record < ActiveRecord::Base

  enum rec_type: {
    book_1to3:            1,
    book_from4:           2,
    digest:               3,
    tome:                 4,
    tome_single:          5,
    book_article_1to3:    6,
    book_article_from4:   7,
    magazines_article:    8,
    digest_article:       9,
    internet_resourse:    10
  }

end
