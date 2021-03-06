# frozen_string_literal: true

class User < ApplicationRecord
  has_many :articles, dependent: :destroy

  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { minimum: 3, maximum: 20 }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: 105 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password, length: { minimum: 6, maximum: 20 }, on: %i[create update]

  before_save { self.email = email.downcase }

  scope :order_by_name, -> { order(:username) }

  paginates_per 5

  has_secure_password
end
