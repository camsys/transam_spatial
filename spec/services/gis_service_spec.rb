require 'rails_helper'

RSpec.describe GisService, :type => :service do

  class TestPoint
    attr_accessor :x
    attr_accessor :y
  end

  let(:test_gis_service) { GisService.new }
  let(:pt0) { TestPoint.new }
  let(:pt1) { TestPoint.new }

  before(:each) do
    allow_any_instance_of(GisService).to receive(:initialize).and_return(true)

    pt0.x = 1.5
    pt0.y = 2.0

    pt1.x = 6.5
    pt1.y = 14.0
  end

  describe '#calulate_offset_along_line_segment' do
    it 'offset distance cannot be more than distance of line' do
      expect(test_gis_service.calculate_offset_along_line_segment(pt0,pt1,13,20)).to eq([pt1.x,pt1.y])
    end

    it 'offset distance must be positive' do
      expect(test_gis_service.calculate_offset_along_line_segment(pt0,pt1,13,-1)).to eq([pt0.x,pt0.y])
    end

    it 'offset distance equals line segment distance' do
      expect(test_gis_service.calculate_offset_along_line_segment(pt0,pt1,13,13)).to eq([pt1.x,pt1.y])
    end

    it 'if horizontal line' do
      pt1.y = 2.0
      expect(test_gis_service.calculate_offset_along_line_segment(pt0,pt1,5,3)).to eq([pt0.x+3,pt0.y])
    end

    it 'if vertical line' do
      pt1.x = 1.5
      expect(test_gis_service.calculate_offset_along_line_segment(pt0,pt1,12,3)).to eq([pt0.x,pt0.y+3])
    end

    it 'calculates' do
      result = test_gis_service.calculate_offset_along_line_segment(pt0,pt1,13,5)
      expect([result[0].round(4), result[1].round(4)]).to eq([3.4231,6.6154])
    end
  end
end
