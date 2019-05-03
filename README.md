# SimstringSearchable

Search ActiveRecord column by simstring.
Simstring is executed by [simstring_pure](https://github.com/davidkellis/simstring) gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simstring_searchable', github: 'junara/simstring_searchable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simstring_searchable

## Usage

* Include SimstringSearchable module to your ActiveRecord model.

```
class YourModel < ApplicationRecord
  include SimstringSearchable # Add this line
```

* Make simstring index

```irb
irb> YourModel.create_simstring_index(:name, gram = 3)
```

* Search with simstring

```irb
irb> YourModel.simstring_search(:name, 'query', threshold: 0.1, limit: 10)
#=> Array of name
```

or 

```irb
irb> YourModel.simstring_ranked_search(:name, 'query', threshold: 0.1, limit: 10)
#=> Array of name and score
```

* Search and get ActiveRecord

```irb
irb> YourModel.simstring_search_result(:name, 'query', threshold: 0.1, limit: 10)
#=> ActiveRecord_Relation
```

* Find ActiveRecord

```irb
irb> YourModel.simstring_find_by(:name, 'query', threshold: 0.1)
#=> YourModel instance like `find_by`
```


* OPTION
* You can make index with modified strings using block.
```
YourModel.create_simstring_index(:name, gram = 3) {|str| str.gsub(/( |　)/, '')} # replace space by ''

```

* To remove index use `remove_simstring_index` method

```
irb> YourModel.remove_simstring_index(:name)

```

or if you erase whole simstring index in your model, use `remove_whole_simstring_indexes`



```
irb> YourModel.remove_whole_simstring_indexes

```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
