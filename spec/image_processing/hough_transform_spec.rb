# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ImageProcessing::HoughTransform do
  using ImageProcessing::ImageRefinements

  subject { described_class.new(image) }

  let(:image) do
    Vips::Image.new_from_array [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 255, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 255, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 255, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]
  end

  describe '#find_lines' do
    it 'find lines in an image' do
      lines = subject.find_lines(theta_res: Math::PI / 180, rho_res: 10.0, threshold: 100)

      expect(lines.size).to eq(1)
      expect(lines[0][:rho]).to eq(0.0)
      expect(lines[0][:theta]).to eq(-0.7853981633974483)
    end

    # it do
    #   img = Vips::Image.new_from_file('samples/lena.jpg')
    #   img = img.to_greyscale
    #   img = ImageProcessing::Morphology.gradient(img)
    #   img = img.threshold(img.percent(90))
    #   # img.write_to_file('gradient.jpg')
    #   described_class.new(img).find_lines(theta_res: Math::PI / 540, rho_res: 0.5, threshold: 100,
    #                                       output_matrix: 'acc.png')
    # end
  end
end
