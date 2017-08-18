# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ImageProcessing::Morphology do
  describe '.dilate' do
    context 'valid image' do
      subject(:image) do
        Vips::Image.new_from_array([[3.0, 4.0, 7.0],
                                    [1.0, 4.0, 0.0],
                                    [9.0, 5.0, 2.0]])
      end

      it 'apply dilation' do
        dilation = ImageProcessing::Morphology.dilate(image)
        expect(dilation.to_a).to eq([[[4.0], [7.0], [7.0]],
                                     [[9.0], [9.0], [7.0]],
                                     [[9.0], [9.0], [5.0]]])
      end
    end

    context 'invalid image' do
      subject(:image) { Vips::Image.new_from_file('samples/lena.jpg') }

      it 'raise an ImageProcessingError' do
        expect { ImageProcessing::Morphology.dilate(image) }
          .to raise_error(ImageProcessing::ImageProcessingError)
      end
    end
  end

  describe '.erode' do
    context 'valid image' do
      subject(:image) do
        Vips::Image.new_from_array([[3.0, 4.0, 7.0],
                                    [1.0, 4.0, 0.0],
                                    [9.0, 5.0, 2.0]])
      end

      it 'apply erosion' do
        erosion = ImageProcessing::Morphology.erode(image)
        expect(erosion.to_a).to eq([[[1.0], [0.0], [0.0]],
                                    [[1.0], [0.0], [0.0]],
                                    [[1.0], [0.0], [0.0]]])
      end
    end

    context 'invalid image' do
      subject(:image) { Vips::Image.new_from_file('samples/lena.jpg') }

      it 'raise an ImageProcessingError' do
        expect { ImageProcessing::Morphology.erode(image) }
          .to raise_error(ImageProcessing::ImageProcessingError)
      end
    end
  end

  describe '.opening' do
    subject(:image) do
      Vips::Image.new_from_array([[0.0, 0.0, 0.0],
                                  [0.0, 1.0, 0.0],
                                  [0.0, 0.0, 0.0]])
    end

    it 'opening operator' do
      opening = ImageProcessing::Morphology.opening(image)
      expect(opening.to_a).to eq([[[0.0], [0.0], [0.0]],
                                  [[0.0], [0.0], [0.0]],
                                  [[0.0], [0.0], [0.0]]])
    end
  end

  describe '.closing' do
    subject(:image) do
      Vips::Image.new_from_array([[1.0, 1.0, 1.0],
                                  [1.0, 0.0, 1.0],
                                  [1.0, 1.0, 1.0]])
    end

    it 'closing operator' do
      closing = ImageProcessing::Morphology.closing(image)
      expect(closing.to_a).to eq([[[1.0], [1.0], [1.0]],
                                  [[1.0], [1.0], [1.0]],
                                  [[1.0], [1.0], [1.0]]])
    end
  end

  describe '.gradient' do
    subject(:image) do
      Vips::Image.new_from_array([[0.0, 0.0, 0.0],
                                  [0.0, 1.0, 0.0],
                                  [0.0, 0.0, 0.0]])
    end

    it 'morphological gradient' do
      gradient = ImageProcessing::Morphology.gradient(image)
      expect(gradient.to_a).to eq([[[1.0], [1.0], [1.0]],
                                   [[1.0], [1.0], [1.0]],
                                   [[1.0], [1.0], [1.0]]])
    end
  end
end
