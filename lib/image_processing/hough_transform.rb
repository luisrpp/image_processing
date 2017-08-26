# frozen_string_literal: true

require 'matrix'

module ImageProcessing
  # Hough Transform implementation.
  class HoughTransform
    using ImageProcessing::ImageRefinements

    attr_reader :image

    # Generates the Accumulator Matrix.
    class Accumulator
      attr_reader :matrix, :theta_res, :theta_size, :rho_res, :rho_size

      def initialize(image, theta_res, rho_res) # rubocop:disable Metrics/AbcSize
        @theta_res = theta_res
        @rho_res = rho_res
        @theta_size = (2.0 * Math::PI / 2) / theta_res
        @rho_size = 2.0 * (rho_res * Math.sqrt((image.width**2) + (image.height**2))).ceil
        @matrix = Matrix.zero(rho_size, theta_size).to_a
      end

      def write(theta, rho)
        puts "rho=#{rho} rho_size=#{rho_size} rho_index=#{rho_index(rho)} theta=#{theta} theta_index=#{theta_index(theta)}"
        matrix[rho_index(rho)][theta_index(theta)] += 1
      end

      private

      def theta_index(theta)
        (theta / theta_res).round + theta_size / 2
      end

      def rho_index(rho)
        (rho / rho_res).round + rho_size / 2
      end
    end

    def initialize(image)
      validate_image(image)
      @image = image
    end

    def find_lines(options = {}) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      default_options = { theta_res: Math::PI / 180, rho_res: 1.0 }
      options = default_options.merge(options)

      accumulator = Accumulator.new(image, options[:theta_res], options[:rho_res])

      theta_start = -Math::PI / 2
      theta_end = (Math::PI / 2) - options[:theta_res]

      image.non_zero_pixels.each do |pixel|
        (theta_start..theta_end).step(options[:theta_res]).each do |theta|
          rho = pixel[:x] * Math.cos(theta) + pixel[:y] * Math.sin(theta)
          accumulator.write(theta, rho)
        end
      end

      acc_matrix = Vips::Image.new_from_array accumulator.matrix
      puts acc_matrix.max
      acc_matrix = acc_matrix * 255
      puts acc_matrix.max
      acc_matrix.write_to_file('accumulator.png')
    end

    private

    def validate_image(image)
      raise ImageProcessing::ImageProcessingError, 'Use a greyscale image!' unless image.bands == 1
    end
  end
end
