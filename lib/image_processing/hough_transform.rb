# frozen_string_literal: true

require 'matrix'

module ImageProcessing
  # Hough Transform implementation.
  class HoughTransform
    using ImageProcessing::ImageRefinements

    attr_reader :image

    # Generates the Accumulator Matrix.
    class Accumulator
      attr_reader :accumulator_matrix, :theta_res, :theta_size, :rho_res, :rho_size

      def initialize(image, theta_res, rho_res) # rubocop:disable Metrics/AbcSize
        @theta_res = theta_res
        @rho_res = rho_res
        @theta_size = (2.0 * Math::PI / 2) / theta_res
        @rho_size = 2.0 * (rho_res * Math.sqrt((image.width**2) + (image.height**2))).ceil
        @accumulator_matrix = Matrix.zero(rho_size, theta_size).to_a
      end
    end

    def initialize(image)
      validate_image(image)
      @image = image
    end

    def find_lines(theta_res = Math::PI / 180, rho_res = 1.0)
      accumulator = Accumulator.new(image, theta_res, rho_res)
      accumulator.accumulator_matrix
      # TODO: (-Math::PI/2..Math::PI/2).step(Math::PI/180)...
    end

    private

    def validate_image(image)
      raise ImageProcessing::ImageProcessingError, 'Use a greyscale image!' unless image.bands == 1
    end
  end
end
