# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ImageProcessing::ImageRefinements do
  using ImageProcessing::ImageRefinements

  subject(:image) { Vips::Image.new_from_file('samples/lena.jpg') }

  describe '#to_greyscale' do
    it 'Converts the image to greyscale' do
      grey_img = image.to_greyscale

      expect(image.bands).to eq(3)
      expect(grey_img.width).to eq(512)
      expect(grey_img.height).to eq(512)
      expect(grey_img.bands).to eq(1)
    end
  end

  describe '#non_zero_pixels' do
    subject(:image) do
      Vips::Image.new_from_array([[0.0, 60.0, 70.0],
                                  [100.0, 0.0, 190.0],
                                  [200.0, 220.0, 0.0]])
    end

    it 'get all non zero pixels' do
      pixels = image.non_zero_pixels
      expect(pixels.first[:x]).to eq(0)
      expect(pixels.first[:y]).to eq(1)
      expect(pixels.first[:value]).to eq([60.0])
      expect(pixels.size).to eq(6)
    end
  end

  describe '#threshold' do
    subject(:image) do
      Vips::Image.new_from_array([[50.0, 60.0, 70.0],
                                  [100.0, 150.0, 190.0],
                                  [200.0, 220.0, 255.0]])
    end

    context 'binary threshold' do
      it 'apply threshold' do
        threshold = image.threshold(150)
        expect(threshold.to_a).to eq([[[0.0], [0.0], [0.0]],
                                      [[0.0], [0.0], [255.0]],
                                      [[255.0], [255.0], [255.0]]])
      end
    end
  end
end
