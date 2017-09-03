# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ImageProcessing::HoughTransform do
  using ImageProcessing::ImageRefinements

  subject { described_class.new(image) }

  describe '#find_lines' do
    context 'if there are three points on the same diagonal of the image' do
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

      let(:line) do
        [[[255.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
         [[0.0], [255.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
         [[0.0], [0.0], [255.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
         [[0.0], [0.0], [0.0], [255.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
         [[0.0], [0.0], [0.0], [0.0], [255.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
         [[0.0], [0.0], [0.0], [0.0], [0.0], [255.0], [0.0], [0.0], [0.0], [0.0]],
         [[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [255.0], [0.0], [0.0], [0.0]],
         [[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [255.0], [0.0], [0.0]],
         [[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [255.0], [0.0]],
         [[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [255.0]]]
      end

      it 'only one line will be found' do
        lines = subject.find_lines(theta_res: Math::PI / 180, rho_res: 10.0, threshold: 50)

        expect(lines.size).to eq(1)
        expect(lines[0][:rho]).to eq(0.0)
        expect(lines[0][:theta]).to eq(-0.7853981633974483)
        expect(image.draw_lines(255.0, lines).to_a).to eq(line)
      end
    end
  end
end
