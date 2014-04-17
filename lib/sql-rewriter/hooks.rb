module SQLRewriter
  
  module Hooks
    
    module AfterQuery

      def after_query(result)

        SQLRewriter.after_hook.call(result)

      end

    end

    module BeforeQuery

      def before_query(sql, binds)

        begin

          sql_spliced = sql.dup

          # ActiveRecord double quotes everything
          sql_spliced.gsub!(/([^\\])"/) { $1 + '`' }

          sql_spliced.gsub!('?', '`a`')
          
          parser = SQLParser::Parser.new
          ast = parser.scan_str(sql_spliced)

          res = SQLRewriter.before_hook.call(sql, binds, ast)

          res.to_sql

        rescue

          SQLRewriter.before_hook.call(sql, binds, nil)

        end

      end

    end
  
  end
  
end
