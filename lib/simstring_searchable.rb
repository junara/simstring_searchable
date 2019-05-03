# frozen_string_literal: true

require 'simstring_searchable/version'
require 'simstring_pure'

module SimstringSearchable
  extend ActiveSupport::Concern
  class SimstringSearchableError < StandardError
  end

  SIMSTRING_THRESHOLD = 0.5
  SIMSTRING_GRAM = 3
  SIMSTRING_LIMIT = 10
  module ClassMethods
    def create_simstring_index(attribute, gram = SIMSTRING_GRAM)
      remove_simstring_index(attribute)
      ngram_builder = SimString::NGramBuilder.new(gram)
      instance_variable_set(simstring_class_variable_name(attribute), SimString::Database.new(ngram_builder))
      pluck(attribute).each do |str|
        str = yield(str) if block_given?
        instance_variable_get(simstring_class_variable_name(attribute)).add(str)
      end
      simstring_index(attribute)
    end

    def remove_whole_simstring_indexes
      attribute_names.each { |attribute| remove_simstring_index(attribute) }
    end

    def remove_simstring_index(attribute)
      return if simstring_index(attribute).blank?

      remove_instance_variable(simstring_class_variable_name(attribute))
    end

    def simstring_index(attribute)
      instance_variable_get(simstring_class_variable_name(attribute))
    end

    def simstring_ranked_search(attribute, query, threshold: SIMSTRING_THRESHOLD, limit: SIMSTRING_LIMIT)
      check_simstring_index(attribute)
      simstring_matcher(attribute).ranked_search(query, threshold)[0..(limit-1)]
    end

    def simstring_search(attribute, query, threshold: SIMSTRING_THRESHOLD, limit: SIMSTRING_LIMIT)
      simstring_ranked_search(attribute, query, threshold: threshold, limit: limit).map(&:value)
    end

    def simstring_search_result(attribute, query, threshold: SIMSTRING_THRESHOLD, limit: SIMSTRING_LIMIT)
      where(attribute => simstring_search(attribute, query, threshold: threshold, limit: limit))
    end

    def simstring_find_by(attribute, query, threshold: SIMSTRING_THRESHOLD)
      simstring_search_result(attribute, query, threshold: threshold, limit: 1).first.presence || nil
    end

    private

    def check_simstring_index(attribute)
      raise SimstringSearchableError, "#{attribute} has no simstring index. Before use, AR.create_simstring_index(:#{attribute})" if simstring_index(attribute).blank?
    end

    def simstring_matcher(attribute)
      SimString::StringMatcher.new(simstring_index(attribute), SimString::CosineMeasure.new)
    end

    def simstring_class_variable_name(attribute)
      "@simstring_#{attribute}_index"
    end
  end
end
