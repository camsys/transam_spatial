require 'rails_helper'

RSpec.describe MapsController, :type => :controller do

  let(:test_asset) { create(:buslike_asset) }

  it 'GET index' do

  end

  it 'GET marker', :skip do # route does not match
    get :marker

    expect(assigns(:marker)).to eq("")
  end
end
