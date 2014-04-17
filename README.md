## sql-rewriter

A Ruby library for SQL query analysis, rewriting and injection. Currently supports ActiveRecord.

### Features

  * Receive a callback before execution of an SQL query with a parsed AST representing the query
  * Receive a callback after execution of an SQL query

### Usage

**Example ActiveRecord application**

```ruby

config = { adapter: 'sqlite3', database: 'test.sqlite' }

ActiveRecord::Base.establish_connection(config)

class User < ActiveRecord::Base
  
  has_many :problems
  
end

class Problem < ActiveRecord::Base
  
  belongs_to :users
  
end

```

**Example SQLRewriter configuration**

```ruby

SQLRewriter.inject(ActiveRecord) do
  
  before_query do |sql, binds, ast|

    # pre-process SQL query

    # AST will be nil upon parse failure
    ast ? ast.to_sql : sql

  end
  
  after_query do |result|

    # post-process retrieved data

    result

  end
  
end

```

###License

This software is released under the MIT license.