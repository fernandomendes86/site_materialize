# frozen_string_literal: true

class Category < ApplicationRecord
  validates :name, presence: true, length: { minimum: 3, maximum: 25 }
  validates_uniqueness_of :name, case_insensitive: true

  has_many :article_categories
  has_many :articles, through: :article_categories

  paginates_per 5
end
