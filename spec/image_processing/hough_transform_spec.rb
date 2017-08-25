# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ImageProcessing::HoughTransform do
  using ImageProcessing::ImageRefinements

  subject { described_class.new(grey_image) }

  let(:image) { Vips::Image.new_from_file('samples/lines.png') }
  let(:grey_image) { image.to_greyscale }

  describe '#find_lines' do
    it 'find lines in an image' do
      puts subject.find_lines
    end
  end
end
