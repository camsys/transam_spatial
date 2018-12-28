require 'rails_helper'

RSpec.describe TransamAssociationLocatable do
  class AssociationLocatableAssociation
    def geometry
      "test geometry"
    end
  end

  class AssociationLocatableClass
    extend TransamAssociationLocatable

    def initialize(params)
      @organization = params[:organization]
    end
  end

  let(:test_association) { AssociationLocatableAssociation.new }
  let(:test_class) { AssociationLocatableClass.new(organization: test_association) }

  # it 'configure_association_locatable' do
  #   TransamAssociationLocatable::ClassMethods.configure_association_locatable( {association_name: "organization", association_geometry_attribute_name: "geometry"} )
  #   expect(test_class._association_name).to eq("organization")
  #   expect(test_class._association_geometry_attribute_name).to eq("geometry")
  # end
end