module SQLRewriter
  
  module Adapters
    
    class ActiveRecord
      
      # Most of this code is lifted from the Marginalia gem
      def self.inject
      
        if defined? ::ActiveRecord::ConnectionAdapters::Mysql2Adapter
          if ::ActiveRecord::Base.connection.is_a?(
              ::ActiveRecord::ConnectionAdapters::Mysql2Adapter)
            ::ActiveRecord::ConnectionAdapters::Mysql2Adapter.module_eval do
              include SQLRewriter::Adapters::ActiveRecord::Decorator
            end
          end
        end

        if defined? ::ActiveRecord::ConnectionAdapters::MysqlAdapter
          if ::ActiveRecord::Base.connection.is_a?(
              ::ActiveRecord::ConnectionAdapters::MysqlAdapter)
            ::ActiveRecord::ConnectionAdapters::MysqlAdapter.module_eval do
              include SQLRewriter::Adapters::ActiveRecord::Decorator
            end
          end
        end

        # SQL queries made through PostgreSQLAdapter#exec_delete will not be annotated.
        if defined? ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
          if ::ActiveRecord::Base.connection.is_a?(
              ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
            ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.module_eval do
              include SQLRewriter::Adapters::ActiveRecord::Decorator
            end
          end
        end

        if defined? ::ActiveRecord::ConnectionAdapters::SQLite3Adapter
          if ::ActiveRecord::Base.connection.is_a?(
              ::ActiveRecord::ConnectionAdapters::SQLite3Adapter)
            ::ActiveRecord::ConnectionAdapters::SQLite3Adapter.module_eval do
              include SQLRewriter::Adapters::ActiveRecord::Decorator
            end
          end
        end
        
      end
      
      if defined? Rails::Railtie
        require 'rails/railtie'

        class Railtie < Rails::Railtie
        
          initializer 'SQLRewriter.insert' do
            ActiveSupport.on_load :active_record do
              SQLRewriter::ActiveRecord::Decorator.insert_into_active_record
            end
          end
        
        end

      end

      module Decorator
        
        include SQLRewriter::Hooks::AfterQuery
        include SQLRewriter::Hooks::BeforeQuery
        
        def self.included(decorated_class)
 
          decorated_class.class_eval do
            if decorated_class.method_defined?(:execute)
              alias_method :execute_without_sqlr, :execute
              alias_method :execute, :execute_with_sqlr
            end

            is_mysql2 = defined?(ActiveRecord::ConnectionAdapters::Mysql2Adapter) &&
              ActiveRecord::ConnectionAdapters::Mysql2Adapter == decorated_class

            # Dont instrument exec_query on mysql2 and AR 3.2+, as it calls execute internally
            unless is_mysql2 && ActiveRecord::VERSION::STRING > "3.1"
              if decorated_class.method_defined?(:exec_query)
                alias_method :exec_query_without_sqlr, :exec_query
                alias_method :exec_query, :exec_query_with_sqlr
              end
            end
          end
        end

        def execute_with_sqlr(sql, name = nil, binds)
          after_query(execute_without_sqlr(before_query(sql, binds), name))
          
        end

        def exec_query_with_sqlr(sql, name = 'SQL', binds = [])
          after_query(exec_query_without_sqlr(before_query(sql, binds), name, binds))
        end

      end
    
    end
  
  end
  
end
