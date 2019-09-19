module Workarea
  class Segment
    include ApplicationDocument
    include Commentable
    include Ordering
    include Mongoid::Document::Taggable

    field :name, type: String
    embeds_many :rules, class_name: 'Workarea::Segment::Rules::Base', inverse_of: :segment
    validates :name, presence: true

    def self.find_qualifying(visit)
      all.select { |s| s.qualifies?(visit) }
    end

    def self.applied
      Thread.current[:applied_segments] || Collection.new
    end

    def self.applied=(*segments)
      Thread.current[:applied_segments] = Collection.new(*segments)
    end

    def self.apply(*segments)
      previous = applied

      self.applied = segments
      yield
    ensure
      self.applied = previous
    end

    def qualifies?(visit)
      return false if rules.blank? || visit.blank?
      rules.all? { |r| r.qualifies?(visit) }
    end
  end
end
