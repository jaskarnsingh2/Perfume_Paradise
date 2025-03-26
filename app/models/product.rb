class Product < ApplicationRecord
    has_rich_text :description
    has_many_attached :images
    belongs_to :category, optional: true
    has_many :cart_items
    attribute :on_sale, :boolean, default: false
    has_many :order_items
    has_many :orders, through: :order_items
  
    # Include PgSearch for full-text search
    include PgSearch::Model
    
    # Define a pg_search_scope to search by name and rich text description
    pg_search_scope :search_by_name_and_description,
      against: :name,
      associated_against: { rich_text_description: :body },
      using: {
        tsearch: { prefix: true } # Enables partial word matching
      }
  
      validates :name, presence: true, uniqueness: true
      validates :description, presence: true, length: { minimum: 10 }
      validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
      validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  end
  