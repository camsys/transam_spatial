require 'rails_helper'

RSpec.describe LocationReferenceType, :type => :model do

  let(:test_type) { LocationReferenceType.first }

  it '.to_s' do
    expect(test_type.to_s).to eq(test_type.name)
  end
end
