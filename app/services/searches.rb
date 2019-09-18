class Services::Searches
  FIND_TYPES = %w[all question answer comment user]

  def self.type_of_select
    FIND_TYPES.each { |type| type }
  end

  def self.find_query(index, query)
    return nil unless index.in?(self.type_of_select)
    

    if index != 'all'
      index.classify.constantize.search ThinkingSphinx::Query.escape(query.to_s)
    else
      ThinkingSphinx.search ThinkingSphinx::Query.escape(query.to_s)
    end  
  end
end
