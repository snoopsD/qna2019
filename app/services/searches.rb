class Services::Searches
  FIND_TYPES = %w[all question answer comment user]

  def self.type_of_select
    FIND_TYPES.each { |type| type }
  end

  def self.find_query(index, query)
    if index != 'all'
      index.classify.constantize.search query.to_s
    else
      ThinkingSphinx.search query.to_s
    end  
  end
end
