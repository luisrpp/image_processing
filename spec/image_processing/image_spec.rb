# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Vips::Image do
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

  describe '#draw_lines' do
    subject(:image) do
      Vips::Image.new_from_array([[0.0, 0.0, 0.0],
                                  [0.0, 0.0, 0.0],
                                  [0.0, 0.0, 0.0]])
    end

    let(:lines) do
      [{ rho: 0.0, theta: -1.5707963267948966 },
       { rho: -2.0, theta: -1.5707963267948966 }]
    end

    let(:result) do
      [[[255.0], [0.0], [255.0]],
       [[255.0], [0.0], [255.0]],
       [[255.0], [0.0], [255.0]]]
    end

    it 'draw two lines' do
      expect(image.draw_lines(255.0, lines).to_a).to eq(result)
    end
  end
end
