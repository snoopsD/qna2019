class Link < ApplicationRecord
  URL_REGEXP = /(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?/ix

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URL_REGEXP, message: 'provided invalid' }

  def gist?
    url.include?("gist.github.com")
  end

  def show_gist
    Octokit::Client.new.gist(url.split('/').last).files.map{ |el| {name: el.first, content: el[1].content}}
  end
end
