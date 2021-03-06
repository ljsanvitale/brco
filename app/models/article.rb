class Article < ApplicationRecord
  belongs_to :author
  has_many :comments
  has_many :taggings
  has_many :tags, through: :taggings
  has_attached_file :image
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  default_scope { order(created_at: :desc) }
  scope :article_list, ->{where("articles.article_type IN (?) AND articles.published=? ", ["news", "notes"],true).order(created_at: :desc)}
  scope :article_reviews, -> { where("articles.article_type=? AND articles.published=? ",  'review',true).order(created_at: :desc) }
  scope :admin_article_reviews, -> { where("articles.article_type=?",  'review').order(created_at: :desc) }
  scope :article_notes, -> { where("articles.article_type=? AND articles.published=? ",  'notes',true).order(created_at: :desc) }
  scope :admin_article_notes, -> { where("articles.article_type=?",  'notes').order(created_at: :desc) }
  scope :article_previews, -> { where("articles.article_type=? AND articles.published=? ",  'preview',true).order(created_at: :desc) }
  scope :admin_article_previews, -> { where("articles.article_type=?",  'preview').order(created_at: :desc) }
  scope :article_news, -> { where("articles.article_type=? AND articles.published=? ",  'news',true).order(created_at: :desc) }
  scope :admin_article_news, -> { where("articles.article_type=?",  'news').order(created_at: :desc) }
  validates :article_slug, uniqueness: true

  def tag_list
    self.tags.collect do |tag|
    tag.name
    end.join(", ")
  end

  def tag_list=(tags_string)
    tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq
    new_or_found_tags = tag_names.collect { |name| Tag.find_or_create_by(name: name) }
    self.tags = new_or_found_tags

  end
  def self.all_except(article)
    where.not(id: article)
  end

  def slug
   title.strip.downcase.gsub(" ", "-")
 end

 def to_param
  "#{article_slug}"
  end

  def next
    if self.article_type=='preview'
      Article.article_previews.reorder(created_at: :asc).where("id > ?", id).limit(1).first
    else
      Article.article_reviews.reorder(created_at: :asc).where("id > ?", id).limit(1).first
    end
  end

  def previous
    if self.article_type=='preview'
      Article.article_previews.where("id < ?", id).limit(1).first
    else
      Article.article_reviews.where("id < ?", id).limit(1).first
    end
  end
end
