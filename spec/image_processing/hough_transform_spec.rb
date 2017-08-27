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
      subject.find_lines(theta_res: Math::PI / 180, rho_res: 10.0)
    end
  end
end
