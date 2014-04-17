module SQLRewriter
  
  require 'sql-parser'
  
  require_relative 'sql-rewriter/hooks'
  require_relative 'sql-rewriter/adapters'
  
  class << self
    attr_accessor :before_hook
    attr_accessor :after_hook
  end
  
  self.before_hook = nil
  self.after_hook = nil
  
  def self.inject(adapter, &block)
    
    if adapter.to_s == 'ActiveRecord'
      SQLRewriter::Adapters::ActiveRecord.inject
    else
      raise 'No adapter for ' + adapter.to_s
    end
    
    instance_eval(&block)
    
  end
  
  
  def self.before_query(&block)
    self.before_hook = block
  end
  
  def self.after_query(&block)
    self.after_hook = block
  end
  
end