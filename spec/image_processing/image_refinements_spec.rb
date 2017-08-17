# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ImageProcessing::ImageRefinements do
  using ImageProcessing::ImageRefinements

  subject(:image) { Vips::Image.new_from_file('samples/lena.jpg') }

  describe '#to_grayscale' do
    it 'Converts the image to grayscale' do
      gray_img = image.to_grayscale

      expect(image.bands).to eq(3)
      expect(gray_img.width).to eq(512)
      expect(gray_img.height).to eq(512)
      expect(gray_img.bands).to eq(1)
    end
  end
end
