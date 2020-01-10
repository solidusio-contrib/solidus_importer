# frozen_string_literal: true

module SolidusImporter
  module Importers
    class Orders < Base
      class << self
        def mapping
          @mapping ||= {
            'Name' => :number,
            'Email' => :email,
            'Financial Status' => nil,
            'Fulfillment Status' => nil,
            'Currency' => :currency,
            'Buyer Accepts Marketing' => nil,
            'Cancel Reason' => nil,
            'Cancelled At' => nil,
            'Closed At' => nil,
            'Tags' => nil,
            'Note' => :special_instructions,
            'Phone' => nil,
            'Referring Site' => nil,
            'Processed At' => nil,
            'Source name' => nil,
            'Total weight' => nil,
            'Total Tax' => nil,
            'Shipping Company' => nil,
            'Shipping Name' => nil,
            'Shipping Phone' => nil,
            'Shipping First Name' => nil,
            'Shipping Last Name' => nil,
            'Shipping Address1' => nil,
            'Shipping Address2' => nil,
            'Shipping City' => nil,
            'Shipping Province' => nil,
            'Shipping Province Code' => nil,
            'Shipping Zip' => nil,
            'Shipping Country' => nil,
            'Shipping Country Code' => nil,
            'Billing Company' => nil,
            'Billing Name' => nil,
            'Billing Phone' => nil,
            'Billing First Name' => nil,
            'Billing Last Name' => nil,
            'Billing Address1' => nil,
            'Billing Address2' => nil,
            'Billing City' => nil,
            'Billing Province' => nil,
            'Billing Province Code' => nil,
            'Billing Zip' => nil,
            'Billing Country' => nil,
            'Billing Country Code' => nil,
            'Lineitem name' => nil,
            'Lineitem quantity' => nil,
            'Lineitem price' => nil,
            'Lineitem sku' => nil,
            'Lineitem requires shipping' => nil,
            'Lineitem taxable' => nil,
            'Lineitem fulfillment status' => nil,
            'Tax 1 Title' => nil,
            'Tax 1 Price' => nil,
            'Tax 1 Rate' => nil,
            'Tax 2 Title' => nil,
            'Tax 2 Price' => nil,
            'Tax 2 Rate' => nil,
            'Tax 3 Title' => nil,
            'Tax 3 Price' => nil,
            'Tax 3 Rate' => nil,
            'Transaction amount' => nil,
            'Transaction kind' => nil,
            'Transaction status' => nil,
            'Shipping line code' => nil,
            'Shipping line price' => nil,
            'Shipping line title' => nil,
            'Shipping line carrier identifier' => nil,
            'Shipping Tax Price' => nil,
            'Discount code' => nil,
            'Discount amount' => nil,
            'Discount type' => nil,
            'Metafield Namespace' => nil,
            'Metafield Key' => nil,
            'Metafield Value' => nil,
            'Metafield Value Type' => nil
          }
        end

        def processors_list
          @processors_list ||= ::SolidusImporter::Config.solidus_importer.dig(:orders, :processors) || []
        end
      end
    end
  end
end
