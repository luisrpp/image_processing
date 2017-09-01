# frozen_string_literal: true

require 'matrix'

module ImageProcessing
  # Hough Transform implementation.
  class HoughTransform
    using ImageProcessing::ImageRefinements

    attr_reader :image

    # Generates the Accumulator Matrix.
    class Accumulator
      # Accumulator constructor.
      #
      # @param image [Vips::Image] the image
      # @param theta_res [Float] theta resolution
      # @param rho_res [Float] rho resolution
      def initialize(image, theta_res, rho_res)
        @image = image
        @theta_res = theta_res
        @rho_res = 1.0 / rho_res
        @matrix = Matrix.zero(rho_range_size, theta_range_size).to_a
      end

      # Get theta values with precomputed sin and cos.
      #
      # @return [Array<Hash<Symbol, Float>>] theta values.
      def theta_values
        @theta_values ||= theta_range.map do |theta|
          { value: theta, sin: Math.sin(theta), cos: Math.cos(theta) }
        end
      end

      # Writes the theta and rho values to the accumulator matrix.
      #
      # @param theta [Float] theta value
      # @param rho [Float] rho value
      def write(theta, rho)
        rho_index = calculate_index(rho_range_size, @rho_res, rho)
        theta_index = calculate_index(theta_range_size, @theta_res, theta[:value])

        @matrix[rho_index][theta_index] += 1
      end

      # Get all intersections.
      #
      # @param threshold [Integer] threshold for intersections
      #
      # @return [Array<Hash<Symbol, Numeric>>] sorted intersections
      def intersections(threshold = 0)
        values = []

        @matrix.each_with_index do |row, i|
          row.each_with_index do |value, j|
            values << { rho: rho_range[i], theta: theta_values[j][:value] } unless value < threshold
          end
        end

        values.sort { |a, b| b[:value] <=> a[:value] }
      end

      # Maximum value in the accumulator matrix.
      #
      # @return [Integer] the maximum value
      def max_value
        max = 0

        @matrix.each do |row|
          row_max = row.max
          max = row_max if row_max > max
        end

        max
      end

      # Converts the accumulator matrix to image.
      #
      # @return [Vips::Image] image of the accumulator matrix
      def to_image
        matrix_img = Vips::Image.new_from_array @matrix
        matrix_img.scaleimage
      end

      private

      # Generates the theta range.
      def theta_range
        theta_start = -Math::PI / 2
        theta_end = (Math::PI / 2) - @theta_res
        (theta_start..theta_end).step(@theta_res).to_a
      end

      # Theta range size.
      def theta_range_size
        @theta_range_size ||= theta_range.size
      end

      # Generates the rho range.
      def rho_range
        @rho_range ||= lambda do
          diagonal = Math.sqrt((@image.width**2) + (@image.height**2)).ceil
          rho_start = -diagonal
          rho_end = diagonal
          (rho_start..rho_end).step(@rho_res).to_a
        end.call
      end

      # Rho range size.
      def rho_range_size
        @rho_range_size ||= rho_range.size
      end

      # Calculates the index in the accumulator matrix for a given value.
      def calculate_index(range_size, step_size, value)
        (value / step_size + range_size / 2).round
      end
    end

    # Hough transform constructor.
    #
    # @param image [Vips::Image] image to be processed
    def initialize(image)
      validate_image(image)
      @image = image
    end

    # Find lines in the image.
    #
    # @param [Hash] options find lines options.
    # @option options [Float] :theta_res theta resolution
    # @option options [Float] :rho_res rho resolution
    # @option options [Integer] :threshold threshold for intersections in the accumulator matrix
    # @option options [String] :output_matrix image file name to write the accumulator matrix
    def find_lines(options = {})
      default_options = { theta_res: Math::PI / 180, rho_res: 1.0, threshold: 80 }
      options = default_options.merge(options)

      accumulator = Accumulator.new(image, options[:theta_res], options[:rho_res])

      image.non_zero_pixels.each do |pixel|
        accumulator.theta_values.each do |theta|
          rho = pixel[:x] * theta[:cos] + pixel[:y] * theta[:sin]
          accumulator.write(theta, rho)
        end
      end

      accumulator.to_image.write_to_file(options[:output_matrix]) if options[:output_matrix]

      accumulator.intersections(accumulator.max_value * options[:threshold] / 100.0)
    end

    private

    def validate_image(image)
      raise ImageProcessing::ImageProcessingError, 'Use a greyscale image!' unless image.bands == 1
    end
  end
end
